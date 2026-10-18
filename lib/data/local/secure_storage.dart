import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loan_management_app/core/constants/storage_keys.dart';

/// MPIN credentials: random salt and derived hash.
typedef MpinCredentials = ({Uint8List salt, Uint8List hash});

/// Typed wrapper around the platform keystore for MPIN-related secrets.
class SecureStorage {
  const SecureStorage([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<void> saveMpinCredentials({
    required List<int> salt,
    required List<int> hash,
    required int length,
  }) async {
    await _storage.write(key: StorageKeys.mpinSalt, value: base64Encode(salt));
    await _storage.write(key: StorageKeys.mpinHash, value: base64Encode(hash));
    await _storage.write(key: StorageKeys.mpinLength, value: '$length');
  }

  Future<MpinCredentials?> readMpinCredentials() async {
    final salt = await _storage.read(key: StorageKeys.mpinSalt);
    final hash = await _storage.read(key: StorageKeys.mpinHash);
    if (salt == null || hash == null) {
      return null;
    }
    return (salt: base64Decode(salt), hash: base64Decode(hash));
  }

  Future<int?> readMpinLength() async {
    final value = await _storage.read(key: StorageKeys.mpinLength);
    return value == null ? null : int.tryParse(value);
  }

  Future<int> readFailedAttempts() async {
    final value = await _storage.read(key: StorageKeys.failedAttempts);
    return int.tryParse(value ?? '') ?? 0;
  }

  Future<void> writeFailedAttempts(int count) {
    return _storage.write(key: StorageKeys.failedAttempts, value: '$count');
  }

  Future<DateTime?> readLockoutUntil() async {
    final value = await _storage.read(key: StorageKeys.lockoutUntil);
    final millis = int.tryParse(value ?? '');
    return millis == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true);
  }

  Future<void> writeLockoutUntil(DateTime? until) {
    if (until == null) {
      return _storage.delete(key: StorageKeys.lockoutUntil);
    }
    return _storage.write(
      key: StorageKeys.lockoutUntil,
      value: '${until.millisecondsSinceEpoch}',
    );
  }
}
