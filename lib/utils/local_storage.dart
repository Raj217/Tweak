/// Handles all the functions related to local storage

import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class FileHandler {
  Future<String> get _localPath async {
    /// Returns the local path of the directory of the app
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> _localFile(String fileName) async {
    /// Returns the file stored locally
    final String path = await _localPath;
    return File('$path/$fileName');
  }

  Future<File> write({required String fileName, required String data}) async {
    /// Writes data in the file locally
    final File file = await _localFile(fileName);
    return file.writeAsString(data);
  }

  Future<String> readData({required String fileName}) async {
    /// Read the data stored locally
    try {
      final File file = await _localFile(fileName);

      final String contents = await file.readAsString();

      return contents;
    } catch (e) {
      print('while reading: $e');
    }

    return '';
  }

  void deleteFile(String fileName) async {
    /// Delete the file locally
    try {
      if (await fileExists(fileName: fileName)) {
        final File file = await _localFile(fileName);

        file.delete();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> fileExists({required String fileName}) async {
    String path = await _localPath;
    bool fileDoesExists = await File('$path/$fileName').exists();
    return fileDoesExists;
  }
}
