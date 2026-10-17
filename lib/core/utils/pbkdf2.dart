import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// PBKDF2 with HMAC-SHA256 (RFC 8018), in pure Dart.
///
/// This is CPU heavy at high iteration counts; call it from an isolate.
Uint8List pbkdf2HmacSha256({
  required List<int> password,
  required List<int> salt,
  required int iterations,
  int keyLength = 32,
}) {
  const hashLength = 32;
  final hmac = Hmac(sha256, password);
  final blockCount = (keyLength + hashLength - 1) ~/ hashLength;
  final output = BytesBuilder();

  for (var block = 1; block <= blockCount; block++) {
    final index = ByteData(4)..setUint32(0, block);
    var u = hmac.convert([...salt, ...index.buffer.asUint8List()]).bytes;
    final t = List<int>.of(u);
    for (var i = 1; i < iterations; i++) {
      u = hmac.convert(u).bytes;
      for (var k = 0; k < t.length; k++) {
        t[k] ^= u[k];
      }
    }
    output.add(t);
  }
  return Uint8List.fromList(output.toBytes().sublist(0, keyLength));
}

/// Compares two byte lists in time that does not depend on where they differ.
bool constantTimeEquals(List<int> a, List<int> b) {
  if (a.length != b.length) {
    return false;
  }
  var diff = 0;
  for (var i = 0; i < a.length; i++) {
    diff |= a[i] ^ b[i];
  }
  return diff == 0;
}
