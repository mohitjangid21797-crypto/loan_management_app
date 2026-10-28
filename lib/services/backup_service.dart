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
  static const int formatVersion = 1;
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
    if (bytes.length < 4 + 1 + saltLength + ivLength) return null;
    
    final magicBytes = bytes.sublist(0, 4);
    final magicStr = String.fromCharCodes(magicBytes);
    if (magicStr != magic) return null;

    final version = bytes[4];
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

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/drive.appdata',
    ],
  );

  GoogleSignInAccount? _currentUser;
  drive.DriveApi? _driveApi;
  http.BaseClient? _authClient;

  GoogleSignInAccount? get currentUser => _currentUser;
  bool get isSignedIn => _currentUser != null;

  Future<bool> signIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();
      if (_currentUser == null) return false;

      final headers = await _currentUser!.authHeaders;
      _authClient = _GoogleAuthClient(headers);
      _driveApi = drive.DriveApi(_authClient!);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _currentUser = null;
    _driveApi = null;
    _authClient?.close();
    _authClient = null;
  }

  Uint8List _deriveKey(String password, Uint8List salt) {
    final hmac = HMac(SHA256Digest(), 64);
    final key = Uint8List(keyLength);
    
    var block = 1;
    var offset = 0;
    
    while (offset < keyLength) {
      final blockBytes = Uint8List(4)
        ..[0] = (block >> 24) & 0xFF
        ..[1] = (block >> 16) & 0xFF
        ..[2] = (block >> 8) & 0xFF
        ..[3] = block & 0xFF;
      
      final data = BytesBuilder()
        ..add(salt)
        ..add(blockBytes)
        ..toBytes();
      
      hmac.init(KeyParameter(Uint8List.fromList(password.codeUnits)));
      final u = hmac.process(data.toBytes());
      
      var t = Uint8List.fromList(u);
      
      for (var i = 1; i < pbkdf2Iterations; i++) {
        hmac.init(KeyParameter(t));
        final u2 = hmac.process(Uint8List.fromList(password.codeUnits));
        for (var j = 0; j < u2.length; j++) {
          t[j] ^= u2[j];
        }
      }
      
      final remaining = keyLength - offset;
      final copyLen = remaining < 32 ? remaining : 32;
      key.setRange(offset, offset + copyLen, t);
      offset += copyLen;
      block++;
    }
    
    return key;
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

    final keyBytes = _deriveKey(password, header.salt);
    final key = encrypt.Key(keyBytes);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.gcm));
    
    final encryptedBytes = encryptedData.sublist(LMBKHeader.headerLength);
    if (encryptedBytes.length < LMBKHeader.tagLength) return null;
    
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

  Future<Uint8List> _createBackupPackage(AppProvider provider) async {
    final backupData = {
      'version': 1,
      'timestamp': DateTime.now().toIso8601String(),
      'lender': provider.lender?.toJson(),
      'customers': provider.customers.map((c) => c.toJson()).toList(),
      'loans': provider.loans.map((l) => l.toJson()).toList(),
      'emis': provider.emis.map((e) => e.toJson()).toList(),
      'documents': provider.documents.map((d) => d.toJson()).toList(),
    };
    
    final jsonString = jsonEncode(backupData);
    return utf8.encode(jsonString);
  }

  Future<bool> restoreFromPackage(AppProvider provider, Uint8List data) async {
    try {
      final jsonString = utf8.decode(data);
      final Map<String, dynamic> backup = jsonDecode(jsonString);
      
      if (backup['version'] != 1) return false;
      
      if (backup['lender'] != null) {
        await provider.updateLender(Lender.fromJson(backup['lender']));
      }

      if (backup['customers'] != null) {
        for (final c in backup['customers']) {
          await provider.addCustomer(Customer.fromJson(c));
        }
      }

      if (backup['loans'] != null) {
        for (final l in backup['loans']) {
          await provider.addLoan(Loan.fromJson(l));
        }
      }

      if (backup['emis'] != null) {
        for (final e in backup['emis']) {
          provider.emis.add(EMI.fromJson(e));
        }
      }

      if (backup['documents'] != null) {
        for (final d in backup['documents']) {
          provider.documents.add(LoanDocument.fromJson(d));
        }
      }
      
      await provider.saveToStorage();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> _getAppDataFolderId() async {
    if (_driveApi == null) return null;

    try {
      final list = await _driveApi!.files.list(
        q: "mimeType='application/vnd.google-apps.folder' and name='$appDataFolderName' and trashed=false",
        spaces: 'appDataFolder',
      );
      
      if (list.files != null && list.files!.isNotEmpty) {
        return list.files!.first.id;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> backup(AppProvider provider, String password) async {
    if (_driveApi == null || _currentUser == null) return false;

    try {
      final folderId = await _getAppDataFolderId();
      if (folderId == null) return false;

      final package = await _createBackupPackage(provider);
      final encrypted = await _encryptData(package, password);
      
      final fileName = 'backup_${DateTime.now().millisecondsSinceEpoch}.lmbk';
      final file = drive.File()
        ..name = fileName
        ..parents = [folderId]
        ..mimeType = 'application/octet-stream';

      final media = drive.Media(
        Stream.value(encrypted),
        encrypted.length,
      );

      await _driveApi!.files.create(file, uploadMedia: media);
      
      await _cleanupOldBackups(folderId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Uint8List?> restore(String password) async {
    if (_driveApi == null || _currentUser == null) return null;

    try {
      final folderId = await _getAppDataFolderId();
      if (folderId == null) return null;

      final list = await _driveApi!.files.list(
        q: "'$folderId' in parents and name contains '.lmbk' and trashed=false",
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
      ) as http.StreamedResponse;
      
      final bytes = await media.stream.toBytes();
      return await _decryptData(bytes, password);
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> listBackups() async {
    if (_driveApi == null) return [];

    try {
      final folderId = await _getAppDataFolderId();
      if (folderId == null) return [];

      final list = await _driveApi!.files.list(
        q: "'$folderId' in parents and name contains '.lmbk' and trashed=false",
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

  Future<void> _cleanupOldBackups(String folderId) async {
    try {
      final list = await _driveApi!.files.list(
        q: "'$folderId' in parents and name contains '.lmbk' and trashed=false",
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