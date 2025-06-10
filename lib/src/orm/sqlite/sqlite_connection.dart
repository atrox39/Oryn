import 'package:sqlite3/sqlite3.dart';
import '../core/database_driver.dart';

class SqliteConnection implements DatabaseDriver {
  final String databasePath;
  Database? _db;

  SqliteConnection(this.databasePath);

  Database get db {
    if (_db == null) {
      throw StateError('Database connection is not open. Call open() first.');
    }
    return _db!;
  }

  @override
  void open() {
    _db ??= sqlite3.open(databasePath);
  }

  @override
  void close() {
    _db?.dispose();
    _db = null;
  }

  @override
  Future<void> execute(String sql) async {
    db.execute(sql);
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> values) async {
    final keys = values.keys.join(', ');
    final placeholders = List.filled(values.length, '?').join(', ');
    final sql = 'INSERT INTO $table ($keys) VALUES ($placeholders)';
    db.execute(sql, values.values.toList());
    return db.lastInsertRowId;
  }

  @override
  Future<int> update(
    String table,
    Map<String, dynamic> values,
    String whereClause,
    List<dynamic> whereArgs,
  ) async {
    final setClause = values.keys.map((k) => '$k = ?').join(', ');
    final sql = 'UPDATE $table SET $setClause WHERE $whereClause';
    final params = [...values.values, ...whereArgs];
    db.execute(sql, params);
    return db.getUpdatedRows();
  }

  @override
  Future<int> delete(
    String table,
    String whereClause,
    List<dynamic> whereArgs,
  ) async {
    final sql = 'DELETE FROM $table WHERE $whereClause';
    db.execute(sql, whereArgs);
    return db.getUpdatedRows();
  }

  @override
  Future<List<Map<String, dynamic>>> query(
    String sql, [
    List<dynamic> params = const [],
  ]) async {
    final result = db.select(sql, params);
    return result.map((row) => Map<String, dynamic>.from(row)).toList();
  }
}
