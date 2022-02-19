import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class FileHandler {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> _localFile(String fileName) async {
    final String path = await _localPath;
    return File('$path/$fileName');
  }

  Future<File> write({required String fileName, required String data}) async {
    final File file = await _localFile(fileName);
    return file.writeAsString(data);
  }

  Future<String> readData({required String fileName}) async {
    try {
      final File file = await _localFile(fileName);

      final String contents = await file.readAsString();

      return contents;
    } catch (e) {
      print(e);
    }

    return '';
  }

  void deleteFile(String fileName) async {
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
