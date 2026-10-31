import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/export.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import '../models/index.dart';
import '../providers/app_provider.dart';

class LMBKHeader {
  static const int legacyFormatVersion = 1;
  static const int formatVersion = 2;
  static const int saltLength = 32;
  static const int ivLength = 12;
  static const int tagLength = 16;
  static const String magic = 'LMBK';

  final int version;
  final Uint8List salt;
  final Uint8List iv;

  LMBKHeader({
    required this.version,
    required this.salt,
    required this.iv,
  });

  Uint8List toBytes() {
    final buffer = BytesBuilder();
    buffer.add(magic.codeUnits);
    buffer.addByte(version);
    buffer.add(salt);
    buffer.add(iv);
    return buffer.toBytes();
  }

  static LMBKHeader? fromBytes(Uint8List bytes) {
    if (bytes.length < headerLength) return null;

    final magicBytes = bytes.sublist(0, 4);
    final magicStr = String.fromCharCodes(magicBytes);
    if (magicStr != magic) return null;

    final version = bytes[4];
    if (version != legacyFormatVersion && version != formatVersion) {
      return null;
    }
    final salt = bytes.sublist(5, 5 + saltLength);
    final iv = bytes.sublist(5 + saltLength, 5 + saltLength + ivLength);

    return LMBKHeader(version: version, salt: salt, iv: iv);
  }

  static int get headerLength => 4 + 1 + saltLength + ivLength;
}

class BackupService {
  static const int pbkdf2Iterations = 200000;
  static const int keyLength = 32;
  static const int maxBackups = 5;
  static const String appDataFolderName = 'appDataFolder';
  static const String googleServerClientId =
      '773939013768-s1f118anigoq5njai293crtfonrjp6g1.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: googleServerClientId,
    scopes: [
      'email',
      'https://www.googleapis.com/auth/drive.appdata',
    ],
  );

  GoogleSignInAccount? _currentUser;
  drive.DriveApi? _driveApi;
  http.BaseClient? _authClient;
  String? _lastSignInError;

  GoogleSignInAccount? get currentUser => _currentUser;
  bool get isSignedIn => _currentUser != null;
  String? get lastSignInError => _lastSignInError;

  Future<bool> signIn() async {
    _lastSignInError = null;
    try {
      final user = await _googleSignIn.signIn();
      if (user == null) {
        _lastSignInError = 'Google sign-in was cancelled.';
        return false;
      }

      final headers = await user.authHeaders;
      final authClient = _GoogleAuthClient(headers);
      final driveApi = drive.DriveApi(authClient);
      _authClient?.close();
      _currentUser = user;
      _authClient = authClient;
      _driveApi = driveApi;
      return true;
    } catch (e) {
      _lastSignInError = _describeSignInError(e);
      _currentUser = null;
      _driveApi = null;
      _authClient?.close();
      _authClient = null;
      return false;
    }
  }

  String _describeSignInError(Object error) {
    final details = error.toString();
    if (RegExp(r'(?:ApiException:\s*|v1:)\s*10(?:\D|$)').hasMatch(details)) {
      return 'Google OAuth error 10: register an Android OAuth client in the '
          'same Google Cloud project for package '
          'com.example.loan_management_app and the signing certificate SHA-1 '
          'used by this build. Keep the Web client ID configured as the '
          'server client ID.';
    }
    return details;
  }

  Future<void> signOut() async {
    _lastSignInError = null;
    try {
      await _googleSignIn.signOut();
    } finally {
      _currentUser = null;
      _driveApi = null;
      _authClient?.close();
      _authClient = null;
    }
  }

  Uint8List _deriveKey(String password, Uint8List salt) {
    final passwordBytes = Uint8List.fromList(utf8.encode(password));
    return _deriveKeyWithPasswordBytes(passwordBytes, salt);
  }

  Uint8List _deriveLegacyKey(String password, Uint8List salt) {
    final passwordBytes = Uint8List.fromList(password.codeUnits);
    return _deriveKeyWithPasswordBytes(passwordBytes, salt, legacy: true);
  }

  Uint8List _deriveKeyWithPasswordBytes(
    Uint8List passwordBytes,
    Uint8List salt, {
    bool legacy = false,
  }) {
    final hmac = HMac(SHA256Digest(), 64);
    hmac.init(KeyParameter(passwordBytes));
    final blockBytes = Uint8List(4)..[3] = 1;
    final firstInput = BytesBuilder()
      ..add(salt)
      ..add(blockBytes);
    var u = Uint8List.fromList(hmac.process(firstInput.toBytes()));
    final derivedKey = Uint8List.fromList(u);

    for (var iteration = 1; iteration < pbkdf2Iterations; iteration++) {
      if (legacy) {
        hmac.init(KeyParameter(u));
        u = Uint8List.fromList(hmac.process(passwordBytes));
      } else {
        hmac.init(KeyParameter(passwordBytes));
        u = Uint8List.fromList(hmac.process(u));
      }
      for (var i = 0; i < derivedKey.length; i++) {
        derivedKey[i] ^= u[i];
      }
    }

    return Uint8List.fromList(derivedKey.sublist(0, keyLength));
  }

  Future<Uint8List> _encryptData(Uint8List data, String password) async {
    final salt = encrypt.IV.fromSecureRandom(LMBKHeader.saltLength).bytes;
    final iv = encrypt.IV.fromSecureRandom(LMBKHeader.ivLength).bytes;
    
    final keyBytes = _deriveKey(password, salt);
    final key = encrypt.Key(keyBytes);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.gcm));
    
    final encrypted = encrypter.encryptBytes(data, iv: encrypt.IV(iv));
    
    final header = LMBKHeader(version: LMBKHeader.formatVersion, salt: salt, iv: iv);
    final headerBytes = header.toBytes();
    
    final result = BytesBuilder();
    result.add(headerBytes);
    result.add(encrypted.bytes);
    return result.toBytes();
  }

  Future<Uint8List?> _decryptData(Uint8List encryptedData, String password) async {
    final header = LMBKHeader.fromBytes(encryptedData);
    if (header == null) return null;

    final encryptedBytes = encryptedData.sublist(LMBKHeader.headerLength);
    if (encryptedBytes.length < LMBKHeader.tagLength) return null;

    final keyBytes = header.version == LMBKHeader.legacyFormatVersion
        ? _deriveLegacyKey(password, header.salt)
        : _deriveKey(password, header.salt);
    final key = encrypt.Key(keyBytes);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.gcm));

    final cipherText = encryptedBytes.sublist(0, encryptedBytes.length - LMBKHeader.tagLength);
    final tag = encryptedBytes.sublist(encryptedBytes.length - LMBKHeader.tagLength);
    
    try {
      final decrypted = encrypter.decryptBytes(
        encrypt.Encrypted(Uint8List.fromList(cipherText + tag)),
        iv: encrypt.IV(header.iv),
      );
      return Uint8List.fromList(decrypted);
    } catch (e) {
      return null;
    }
  }

  Future<bool> restoreFromPackage(AppProvider provider, Uint8List data) async {
    try {
      final jsonString = utf8.decode(data);
      final Map<String, dynamic> backup = jsonDecode(jsonString);
      
      if (backup['version'] != 1) return false;

      await _replaceProviderData(provider, backup);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> restoreBackup(AppProvider provider, Uint8List data) async {
    if (!_isSqliteDatabase(data)) {
      return restoreFromPackage(provider, data);
    }

    try {
      final state = await provider.database.readBackupState(data);
      _validateAppState(state);
      await provider.database.restoreDatabaseFile(data);
      await provider.reloadFromStorage();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> backup(AppProvider provider, String password) async {
    if (_driveApi == null || _currentUser == null) return false;

    try {
      await provider.saveToStorage();
      final databaseFile = await provider.database.exportDatabaseFile();
      final encrypted = await _encryptData(databaseFile, password);
      
      final fileName = 'backup_${DateTime.now().millisecondsSinceEpoch}.lmbk';
      final file = drive.File()
        ..name = fileName
        ..parents = [appDataFolderName]
        ..mimeType = 'application/octet-stream';

      final media = drive.Media(
        Stream.value(encrypted),
        encrypted.length,
      );

      await _driveApi!.files.create(file, uploadMedia: media);
      
      await _cleanupOldBackups();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Uint8List?> restore(String password) async {
    if (_driveApi == null || _currentUser == null) return null;

    try {
      final list = await _driveApi!.files.list(
        q: "name contains '.lmbk' and trashed=false",
        spaces: 'appDataFolder',
        orderBy: 'createdTime desc',
        pageSize: 1,
      );

      if (list.files == null || list.files!.isEmpty) return null;

      final latestBackup = list.files!.first;
      final fileId = latestBackup.id!;

      final media = await _driveApi!.files.get(
        fileId, 
        downloadOptions: drive.DownloadOptions.fullMedia
      ) as drive.Media;
      final bytesBuilder = BytesBuilder();
      await for (final chunk in media.stream) {
        bytesBuilder.add(chunk);
      }
      final bytes = bytesBuilder.takeBytes();
      return await _decryptData(bytes, password);
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> listBackups() async {
    if (_driveApi == null) return [];

    try {
      final list = await _driveApi!.files.list(
        q: "name contains '.lmbk' and trashed=false",
        spaces: 'appDataFolder',
        orderBy: 'createdTime desc',
        pageSize: maxBackups,
      );

      if (list.files == null) return [];

      return list.files!.map((f) => {
        'id': f.id,
        'name': f.name,
        'createdTime': f.createdTime?.toIso8601String(),
        'size': f.size,
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> _cleanupOldBackups() async {
    try {
      final list = await _driveApi!.files.list(
        q: "name contains '.lmbk' and trashed=false",
        spaces: 'appDataFolder',
        orderBy: 'createdTime desc',
      );

      if (list.files != null && list.files!.length > maxBackups) {
        final toDelete = list.files!.skip(maxBackups);
        for (final file in toDelete) {
          await _driveApi!.files.delete(file.id!);
        }
      }
    } catch (e) {
      // Ignore cleanup errors
    }
  }

  bool _isSqliteDatabase(Uint8List bytes) {
    const signature = 'SQLite format 3\u0000';
    if (bytes.length < signature.length) return false;
    return String.fromCharCodes(bytes.sublist(0, signature.length)) ==
        signature;
  }

  Future<void> _replaceProviderData(
    AppProvider provider,
    Map<String, dynamic> data,
  ) async {
    final parsed = _parseAppState(data);
    await provider.replaceAllData(
      lender: parsed.lender,
      customers: parsed.customers,
      loans: parsed.loans,
      emis: parsed.emis,
      documents: parsed.documents,
    );
  }

  void _validateAppState(Map<String, dynamic> data) {
    _parseAppState(data);
  }

  _BackupAppState _parseAppState(Map<String, dynamic> data) {
    final lenderData = data['lender'];
    return _BackupAppState(
      lender: lenderData == null
          ? null
          : Lender.fromJson(Map<String, dynamic>.from(lenderData as Map)),
      customers: _decodeBackupList(data['customers'], Customer.fromJson),
      loans: _decodeBackupList(data['loans'], Loan.fromJson),
      emis: _decodeBackupList(data['emis'], EMI.fromJson),
      documents: _decodeBackupList(
        data['documents'],
        LoanDocument.fromJson,
      ),
    );
  }
}

class _BackupAppState {
  final Lender? lender;
  final List<Customer> customers;
  final List<Loan> loans;
  final List<EMI> emis;
  final List<LoanDocument> documents;

  const _BackupAppState({
    required this.lender,
    required this.customers,
    required this.loans,
    required this.emis,
    required this.documents,
  });
}

List<T> _decodeBackupList<T>(
  dynamic value,
  T Function(Map<String, dynamic>) fromJson,
) {
  if (value == null) return [];
  return (value as List)
      .map((item) => fromJson(Map<String, dynamic>.from(item as Map)))
      .toList();
}

class _GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  _GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }

  @override
  void close() {
    _client.close();
  }

  @override
  Future<http.Response> delete(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _client.delete(url, headers: _mergeHeaders(headers), body: body, encoding: encoding);
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    return _client.get(url, headers: _mergeHeaders(headers));
  }

  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) {
    return _client.head(url, headers: _mergeHeaders(headers));
  }

  @override
  Future<http.Response> patch(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _client.patch(url, headers: _mergeHeaders(headers), body: body, encoding: encoding);
  }

  @override
  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _client.post(url, headers: _mergeHeaders(headers), body: body, encoding: encoding);
  }

  @override
  Future<http.Response> put(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _client.put(url, headers: _mergeHeaders(headers), body: body, encoding: encoding);
  }

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) {
    return _client.read(url, headers: _mergeHeaders(headers));
  }

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) {
    return _client.readBytes(url, headers: _mergeHeaders(headers));
  }

  Map<String, String> _mergeHeaders(Map<String, String>? headers) {
    final merged = Map<String, String>.from(_headers);
    if (headers != null) merged.addAll(headers);
    return merged;
  }
}