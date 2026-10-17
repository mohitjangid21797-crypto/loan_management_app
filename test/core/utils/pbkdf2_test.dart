import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:loan_management_app/core/utils/pbkdf2.dart';

String _hex(List<int> bytes) {
  return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}

void main() {
  group('pbkdf2HmacSha256', () {
    // Well-known PBKDF2-HMAC-SHA256 vectors for "password" / "salt".
    test('1 iteration', () {
      final key = pbkdf2HmacSha256(
        password: utf8.encode('password'),
        salt: utf8.encode('salt'),
        iterations: 1,
      );
      expect(
        _hex(key),
        '120fb6cffcf8b32c43e7225256c4f837a86548c92ccc35480805987cb70be17b',
      );
    });

    test('2 iterations', () {
      final key = pbkdf2HmacSha256(
        password: utf8.encode('password'),
        salt: utf8.encode('salt'),
        iterations: 2,
      );
      expect(
        _hex(key),
        'ae4d0c95af6b46d32d0adff928f06dd02a303f8ef3c251dfd6e2d85a95474c43',
      );
    });

    test('4096 iterations', () {
      final key = pbkdf2HmacSha256(
        password: utf8.encode('password'),
        salt: utf8.encode('salt'),
        iterations: 4096,
      );
      expect(
        _hex(key),
        'c5e478d59288c841aa530db6845c4c8d962893a001ce4e11a4963873aa98134a',
      );
    });

    test('honours keyLength across several blocks', () {
      final key = pbkdf2HmacSha256(
        password: utf8.encode('password'),
        salt: utf8.encode('salt'),
        iterations: 1,
        keyLength: 70,
      );
      expect(key.length, 70);
      expect(
        _hex(key.sublist(0, 32)),
        '120fb6cffcf8b32c43e7225256c4f837a86548c92ccc35480805987cb70be17b',
      );
    });
  });

  group('constantTimeEquals', () {
    test('compares contents and length', () {
      expect(constantTimeEquals([1, 2, 3], [1, 2, 3]), isTrue);
      expect(constantTimeEquals([1, 2, 3], [1, 2, 4]), isFalse);
      expect(constantTimeEquals([1, 2], [1, 2, 3]), isFalse);
      expect(constantTimeEquals([], []), isTrue);
    });
  });
}
