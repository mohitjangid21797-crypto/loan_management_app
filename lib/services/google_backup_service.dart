import 'dart:convert';
import 'dart:typed_data';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import '../providers/app_provider.dart';

class GoogleDriveService {
  static final GoogleDriveService _instance = GoogleDriveService._internal();
  factory GoogleDriveService() => _instance;
  GoogleDriveService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/drive.file',
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

  Future<String?> _getOrCreateBackupFolder() async {
    if (_driveApi == null) return null;

    const folderName = 'LoanManagementApp_Backup';
    final query = "name='$folderName' and mimeType='application/vnd.google-apps.folder' and trashed=false";

    try {
      final list = await _driveApi!.files.list(q: query, spaces: 'drive');
      if (list.files != null && list.files!.isNotEmpty) {
        return list.files!.first.id;
      }

      final folder = drive.File()
        ..name = folderName
        ..mimeType = 'application/vnd.google-apps.folder';
      final created = await _driveApi!.files.create(folder);
      return created.id;
    } catch (e) {
      return null;
    }
  }

  Future<bool> backupData(AppProvider provider) async {
    if (_driveApi == null || _currentUser == null) return false;

    try {
      final folderId = await _getOrCreateBackupFolder();
      if (folderId == null) return false;

      final backupData = {
        'lender': provider.lender?.toJson(),
        'customers': provider.customers.map((c) => c.toJson()).toList(),
        'loans': provider.loans.map((l) => l.toJson()).toList(),
        'emis': provider.emis.map((e) => e.toJson()).toList(),
        'documents': provider.documents.map((d) => d.toJson()).toList(),
        'backupDate': DateTime.now().toIso8601String(),
        'version': '1.0',
      };

      final jsonString = jsonEncode(backupData);
      final bytes = utf8.encode(jsonString);

      final fileName = 'loan_backup_${DateTime.now().millisecondsSinceEpoch}.json';
      final file = drive.File()
        ..name = fileName
        ..parents = [folderId];

      final media = drive.Media(
        Stream.value(bytes),
        bytes.length,
      );

      await _driveApi!.files.create(file, uploadMedia: media);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> restoreData() async {
    if (_driveApi == null || _currentUser == null) return null;

    try {
      final folderId = await _getOrCreateBackupFolder();
      if (folderId == null) return null;

      final query = "'$folderId' in parents and name contains 'loan_backup_' and trashed=false";
      final list = await _driveApi!.files.list(
        q: query,
        spaces: 'drive',
        orderBy: 'createdTime desc',
        pageSize: 1,
      );

      if (list.files == null || list.files!.isEmpty) return null;

      final latestBackup = list.files!.first;
      final fileId = latestBackup.id!;

      final media = await _driveApi!.files.get(fileId, downloadOptions: drive.DownloadOptions.fullMedia) as http.StreamedResponse;
      final bytes = await media.stream.toBytes();
      final jsonString = utf8.decode(bytes);
      return jsonDecode(jsonString);
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> listBackups() async {
    if (_driveApi == null) return [];

    try {
      final folderId = await _getOrCreateBackupFolder();
      if (folderId == null) return [];

      final query = "'$folderId' in parents and name contains 'loan_backup_' and trashed=false";
      final list = await _driveApi!.files.list(
        q: query,
        spaces: 'drive',
        orderBy: 'createdTime desc',
        pageSize: 10,
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

  // Delegate all methods to the inner client
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