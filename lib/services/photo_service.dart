import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Picks a photo and copies it into the app documents directory, so it
/// survives the gallery or camera cache being cleared.
class PhotoService {
  PhotoService([ImagePicker? picker]) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// Returns the stored file path, or null if the user cancelled.
  Future<String?> pickAndStore() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (picked == null) {
      return null;
    }
    final documents = await getApplicationDocumentsDirectory();
    final folder = Directory(p.join(documents.path, 'photos'));
    await folder.create(recursive: true);
    final extension = p.extension(picked.path);
    final target = p.join(folder.path, '${const Uuid().v4()}$extension');
    await File(picked.path).copy(target);
    return target;
  }
}
