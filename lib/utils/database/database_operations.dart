import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Class, where happens all database-related operations.
// TODO(oolaa): ADD SEARCH OPERATIONS HERE.
class DatabaseOperations {

  /// Open database by [databaseName].
  static Future<Database> openAppDatabase(String databaseName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, '$databaseName.db');
    return openDatabase(path, version: 1);
  }

  /// Create [database], providing [tableName] and required [tableFields].
  static Future<void> createTable(Database database, String tableName, String tableFields) async {
    return database.execute('CREATE TABLE $tableName($tableFields)');
  }
  /// Insert in specific [database] into specific [tableName] required
  /// info ([dataList]), we do in 25000 at a time, so device would not be
  /// lagging a lot.
  static Future<void> insertDataBatch(Database database, String tableName, List<Map<String, dynamic>> dataList) async {
    final log = Logger('insertDataBatch');
    var batch = database.batch();
    for (var i = 0; i < dataList.length; i++) {
      batch.insert(tableName, dataList[i]);

      if (i % 25000 == 0) {
        await batch.commit(noResult: true);
        batch = database.batch();
      }
      if (i % 250000 == 0) {
        log.info(i.toString());
      }

    }
    await batch.commit(noResult: true);
  }
  /// Close specified [database].
  static Future<void> closeDatabase(Database database) async {
    await database.close();
  }
}
