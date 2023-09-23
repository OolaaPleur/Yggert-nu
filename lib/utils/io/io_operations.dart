import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
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
  static Future<void> deleteFile(String fileOrPath) async {
    final log = Logger('deleteFile');
    final path = await IOOperations.getAppDirForPlatform();
    final filePath = '$path/$fileOrPath';

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
    final path = await IOOperations.getAppDirForPlatform();
    final filePathTest = '$path/gtfs/$filename';

    if (File(filePathTest).existsSync()) {
      return true;
    }
    return false;
  }
  /// Opens required file.
  static Future<String> openFile (String fileName) async {
    final log = Logger('openFile');
    try {
      final path = await IOOperations.getAppDirForPlatform();
      final file = File('$path/gtfs/$fileName');
      return file.readAsString();
    } catch (e) {
      log.severe(e);
      throw FileSystemException('Failed to read file: $fileName');
    }
  }
  /// Checks existence of database with provided [databaseName].
  static Future<bool> databaseExists(String databaseName) async {
    final dbPath = await IOOperations.getDbDirForPlatform();
    final path = join(dbPath, '$databaseName.db');
    return File(path).existsSync();
  }

  /// Delete a database if it exists
  static Future<void> deleteDatabaseIfExists(String dbPath) async {
    if (File(dbPath).existsSync()) {
      await deleteDatabase(dbPath);
    }
  }

  /// Get platform-specific application directory.
  static Future<String> getAppDirForPlatform () async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } else if (kIsWeb) {
      return '';
    }
    return '';
  }
  /// Get platform-specific database directory.
  static Future<String> getDbDirForPlatform () async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final path = await getDatabasesPath();
      return path;
    } else if (kIsWeb) {
      return '';
    }
    return '';
  }
}
