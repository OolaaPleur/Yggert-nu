import 'dart:io';

import 'package:archive/archive.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// Operations with files.
class IOOperations {
  /// Unzipping archive
  static void unzipFile(String zipFilePath, String destinationDir) {
    final bytes = File(zipFilePath).readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      final fileName = file.name;

      if (file.isFile) {
        final data = file.content as List<int>;
        File('$destinationDir/$fileName')
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory('$destinationDir/$fileName').create(recursive: true);
      }
    }
  }

  /// Deleting file.
  static Future<void> deleteFile(String fileName) async {
    final log = Logger('deleteFile');
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final filePath = '${appDocumentsDirectory.path}/$fileName';

    try {
      final file = File(filePath);
      if (file.existsSync()) {
        await file.delete();
        log.info('File deleted: $filePath');
      } else {
        log.warning('File not found: $filePath');
      }
    } catch (e) {
      log.warning('Error deleting file: $e');
    }
  }

  /// Checks GTFS file existence.
  static Future<bool> checkFileExistence(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePathTest = '${directory.path}/gtfs/$filename';

    if (File(filePathTest).existsSync()) {
      return true;
    }
    return false;
  }
  /// Opens required file.
  static Future<String> openFile (String fileName) async {
    final log = Logger('openFile');
    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final file = File('${documentsDirectory.path}/gtfs/$fileName');
      return file.readAsString();
    } catch (e) {
      log.severe(e);
      throw FileSystemException('Failed to read file: $fileName');
    }
  }
  /// Checks existence of database with provided [databaseName].
  static Future<bool> databaseExists(String databaseName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, '$databaseName.db');
    return File(path).existsSync();
  }
}
