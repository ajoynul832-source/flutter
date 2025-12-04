import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import '../models/file_model.dart';

class FileService extends ChangeNotifier {
  List<LocalFile> _files = [];
  bool _isLoading = false;

  List<LocalFile> get files => _files;
  bool get isLoading => _isLoading;

  FileService() {
    refreshFiles();
  }

  /// 1. Load files from the App's Document Directory
  Future<void> refreshFiles() async {
    _isLoading = true;
    notifyListeners();

    try {
      final directory = await getApplicationDocumentsDirectory();
      final List<FileSystemEntity> entities = directory.listSync();

      _files = entities.whereType<File>().map((file) {
        final stat = file.statSync();
        final name = p.basename(file.path);
        return LocalFile(
          name: name,
          path: file.path,
          sizeBytes: stat.size,
          date: stat.modified,
          type: _determineType(name),
        );
      }).toList();
      
      // Sort by newest first
      _files.sort((a, b) => b.date.compareTo(a.date));
      
    } catch (e) {
      debugPrint("Error loading files: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// 2. Import a file from the device (Gallery/Downloads)
  Future<void> pickAndImportFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      File originalFile = File(result.files.single.path!);
      
      // Copy to our app's local storage so we keep it persistently
      final appDir = await getApplicationDocumentsDirectory();
      final String newPath = p.join(appDir.path, result.files.single.name);
      
      await originalFile.copy(newPath);
      await refreshFiles(); // Reload list
    }
  }

  /// 3. Open a file
  Future<void> openFile(String path) async {
    await OpenFile.open(path);
  }

  /// Helper: Determine file type based on extension
  FileType _determineType(String path) {
    final mimeType = lookupMimeType(path);
    if (mimeType == null) return FileType.other;
    
    if (mimeType.startsWith('image/')) return FileType.image;
    if (mimeType.startsWith('video/')) return FileType.video;
    if (mimeType.startsWith('audio/')) return FileType.audio;
    if (mimeType.contains('pdf') || mimeType.contains('word') || mimeType.contains('text')) return FileType.document;
    if (mimeType.contains('zip') || mimeType.contains('tar')) return FileType.archive;
    
    return FileType.other;
  }
}