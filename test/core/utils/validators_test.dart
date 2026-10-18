import 'package:flutter_test/flutter_test.dart';
import 'package:loan_management_app/core/utils/validators.dart';

void main() {
  group('Validators.name', () {
    test('rejects null, empty and blank', () {
      expect(Validators.name(null), ValidationError.nameRequired);
      expect(Validators.name(''), ValidationError.nameRequired);
      expect(Validators.name('   '), ValidationError.nameRequired);
    });

    test('accepts a real name', () {
      expect(Validators.name('Ramesh Kumar'), isNull);
    });
  });

  group('Validators.mobile', () {
    test('accepts 10-digit numbers starting 6-9', () {
      expect(Validators.mobile('9876543210'), isNull);
      expect(Validators.mobile('6000000000'), isNull);
      expect(Validators.mobile(' 9876543210 '), isNull);
    });

    test('rejects wrong length, prefix or characters', () {
      expect(Validators.mobile(null), ValidationError.mobileInvalid);
      expect(Validators.mobile(''), ValidationError.mobileInvalid);
      expect(Validators.mobile('987654321'), ValidationError.mobileInvalid);
      expect(Validators.mobile('98765432101'), ValidationError.mobileInvalid);
      expect(Validators.mobile('5876543210'), ValidationError.mobileInvalid);
      expect(Validators.mobile('98765abcde'), ValidationError.mobileInvalid);
    });
  });

  group('Validators.amountPaise', () {
    test('requires a positive amount', () {
      expect(Validators.amountPaise(1), isNull);
      expect(Validators.amountPaise(0), ValidationError.amountInvalid);
      expect(Validators.amountPaise(-5), ValidationError.amountInvalid);
      expect(Validators.amountPaise(null), ValidationError.amountInvalid);
    });
  });

  group('Validators.ratePercent', () {
    test('accepts 0 to 100 inclusive', () {
      expect(Validators.ratePercent(0), isNull);
      expect(Validators.ratePercent(12.5), isNull);
      expect(Validators.ratePercent(100), isNull);
    });

    test('rejects out of range, NaN and null', () {
      expect(Validators.ratePercent(-0.1), ValidationError.rateInvalid);
      expect(Validators.ratePercent(100.1), ValidationError.rateInvalid);
      expect(Validators.ratePercent(double.nan), ValidationError.rateInvalid);
      expect(Validators.ratePercent(null), ValidationError.rateInvalid);
    });
  });

  group('Validators.mpin', () {
    test('accepts exactly 4 or 6 digits', () {
      expect(Validators.mpin('1234'), isNull);
      expect(Validators.mpin('123456'), isNull);
      expect(Validators.mpin('0000'), isNull);
    });

    test('rejects other lengths, letters and blanks', () {
      for (final bad in [null, '', '123', '12345', '1234567', 'abcd', '12 4']) {
        expect(
          Validators.mpin(bad),
          ValidationError.mpinInvalid,
          reason: '$bad',
        );
      }
    });
  });

  group('Validators.tenureMonths', () {
    test('accepts 1 to 600 inclusive', () {
      expect(Validators.tenureMonths(1), isNull);
      expect(Validators.tenureMonths(600), isNull);
    });

    test('rejects out of range and null', () {
      expect(Validators.tenureMonths(0), ValidationError.tenureInvalid);
      expect(Validators.tenureMonths(601), ValidationError.tenureInvalid);
      expect(Validators.tenureMonths(null), ValidationError.tenureInvalid);
    });
  });
}
