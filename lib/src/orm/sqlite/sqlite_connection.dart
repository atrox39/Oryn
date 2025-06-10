import 'package:sqlite3/sqlite3.dart';

class SqliteConnection {
  final String databasePath;
  Database? _db;

  Database get db {
    if (_db == null) {
      throw StateError('Database connection is not open. Call open() first.');
    }
    return _db!;
  }

  SqliteConnection(this.databasePath);

  void open() {
    if (_db != null) {
      return;
    }
    _db = sqlite3.open(databasePath);
  }

  void close() {
    if (_db != null) {
      _db?.dispose();
      _db = null;
    }
  }
}
