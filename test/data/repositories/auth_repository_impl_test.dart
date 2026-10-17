import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:loan_management_app/core/error/failures.dart';
import 'package:loan_management_app/core/utils/pbkdf2.dart';
import 'package:loan_management_app/core/utils/validators.dart';
import 'package:loan_management_app/data/local/prefs_storage.dart';
import 'package:loan_management_app/data/repositories/auth_repository_impl.dart';
import 'package:loan_management_app/domain/entities/auth_attempt.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeSecureStorage secure;
  late PrefsStorage prefs;
  late DateTime clock;
  late AuthRepositoryImpl repo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = PrefsStorage(await SharedPreferences.getInstance());
    secure = FakeSecureStorage();
    clock = DateTime.utc(2026, 10, 17, 12);
    repo = AuthRepositoryImpl(
      secureStorage: secure,
      prefsStorage: prefs,
      now: () => clock,
      iterations: 2,
      // Run the hash synchronously; the isolate is not needed in tests.
      derive: (mpin, salt, iterations) async => Uint8List.fromList(
        pbkdf2HmacSha256(password: mpin, salt: salt, iterations: iterations),
      ),
    );
  });

  Future<void> wrong(int times, {String mpin = '9999'}) async {
    for (var i = 0; i < times; i++) {
      await repo.verifyMpin(mpin);
    }
  }

  group('setMpin', () {
    test('stores a salted hash, never the MPIN', () async {
      expect((await repo.hasMpin()).valueOrNull, isFalse);

      final result = await repo.setMpin('1234');

      expect(result.isSuccess, isTrue);
      expect((await repo.hasMpin()).valueOrNull, isTrue);
      expect((await repo.mpinLength()).valueOrNull, 4);
      final credentials = secure.credentials!;
      expect(credentials.salt.length, 16);
      expect(credentials.hash, isNot('1234'.codeUnits));
      expect(credentials.hash.length, 32);
    });

    test('uses a fresh random salt each time', () async {
      await repo.setMpin('1234');
      final first = secure.credentials!.salt;
      await repo.setMpin('1234');
      expect(secure.credentials!.salt, isNot(first));
    });

    test('rejects anything but 4 or 6 digits', () async {
      for (final bad in ['', '123', '12345', '1234567', 'abcd', '12 4']) {
        final result = await repo.setMpin(bad);
        expect(
          result.failureOrNull,
          const ValidationFailure(ValidationError.mpinInvalid),
          reason: 'for "$bad"',
        );
      }
      expect((await repo.hasMpin()).valueOrNull, isFalse);
    });

    test('accepts 6 digits and remembers the length', () async {
      await repo.setMpin('123456');
      expect((await repo.mpinLength()).valueOrNull, 6);
    });

    test('resets failed attempts and lockout', () async {
      await repo.setMpin('1234');
      await wrong(5);
      expect(secure.lockoutUntil, isNotNull);

      await repo.setMpin('4321');

      expect(secure.failedAttempts, 0);
      expect(secure.lockoutUntil, isNull);
    });
  });

  group('verifyMpin', () {
    setUp(() => repo.setMpin('1234'));

    test('accepts the right MPIN', () async {
      final attempt = (await repo.verifyMpin('1234')).valueOrNull!;
      expect(attempt.success, isTrue);
    });

    test('counts down remaining attempts on wrong MPINs', () async {
      final remaining = <int>[];
      for (var i = 0; i < 4; i++) {
        remaining.add(
          (await repo.verifyMpin('0000')).valueOrNull!.remainingAttempts,
        );
      }
      expect(remaining, [4, 3, 2, 1]);
    });

    test('locks out for 30 seconds after 5 wrong attempts', () async {
      await wrong(4);
      final fifth = (await repo.verifyMpin('9999')).valueOrNull!;

      expect(fifth.success, isFalse);
      expect(fifth.failedAttempts, 5);
      expect(fifth.lockedUntil, clock.add(const Duration(seconds: 30)));
      expect(
        (await repo.getLockoutUntil()).valueOrNull,
        clock.add(const Duration(seconds: 30)),
      );
    });

    test('refuses even the right MPIN while locked out', () async {
      await wrong(5);
      clock = clock.add(const Duration(seconds: 10));

      final attempt = (await repo.verifyMpin('1234')).valueOrNull!;

      expect(attempt.success, isFalse);
      expect(attempt.lockedUntil, isNotNull);
      // A locked attempt must not push the counter further.
      expect(secure.failedAttempts, 5);
    });

    test('accepts the right MPIN after the lockout ends', () async {
      await wrong(5);
      clock = clock.add(const Duration(seconds: 31));

      expect((await repo.getLockoutUntil()).valueOrNull, isNull);
      final attempt = (await repo.verifyMpin('1234')).valueOrNull!;
      expect(attempt.success, isTrue);
      expect(secure.failedAttempts, 0);
    });

    test('doubles the lockout on the next round of failures', () async {
      await wrong(5);
      clock = clock.add(const Duration(seconds: 31));
      await wrong(4);
      final tenth = (await repo.verifyMpin('9999')).valueOrNull!;

      expect(tenth.failedAttempts, 10);
      expect(tenth.lockedUntil, clock.add(const Duration(seconds: 60)));
    });

    test('caps the lockout at one hour', () async {
      late AuthAttempt last;
      // Each round is 5 wrong tries, which starts a longer lockout. The
      // clock jumps past the previous lockout before each round.
      for (var round = 0; round < 12; round++) {
        clock = clock.add(const Duration(hours: 2));
        for (var i = 0; i < 5; i++) {
          last = (await repo.verifyMpin('9999')).valueOrNull!;
        }
      }
      expect(last.lockedUntil, clock.add(const Duration(hours: 1)));
    });

    test('a correct MPIN resets the failure count', () async {
      await wrong(3);
      await repo.verifyMpin('1234');
      await wrong(4);

      final attempt = (await repo.verifyMpin('9999')).valueOrNull!;
      expect(attempt.failedAttempts, 5);
      // Only 5 in total since the reset, so this is the first lockout.
      expect(attempt.lockedUntil, clock.add(const Duration(seconds: 30)));
    });
  });

  group('verifyMpin without an MPIN', () {
    test('fails with a not-found failure', () async {
      final result = await repo.verifyMpin('1234');
      expect(result.failureOrNull, isA<NotFoundFailure>());
    });
  });

  group('biometric flag', () {
    test('defaults to off and can be switched', () async {
      expect(await repo.isBiometricEnabled(), isFalse);
      await repo.setBiometricEnabled(enabled: true);
      expect(await repo.isBiometricEnabled(), isTrue);
      await repo.setBiometricEnabled(enabled: false);
      expect(await repo.isBiometricEnabled(), isFalse);
    });
  });
}
