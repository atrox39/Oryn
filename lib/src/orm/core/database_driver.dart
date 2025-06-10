abstract class DatabaseDriver {
  void open();
  void close();
  Future<void> execute(String sql);
  Future<List<Map<String, dynamic>>> query(String sql, [List<dynamic> params]);
  Future<int> insert(String table, Map<String, dynamic> values);
  Future<int> update(String table, Map<String, dynamic> values, String whereClause, List<dynamic> whereArgs);
  Future<int> delete(String table, String whereClause, List<dynamic> whereArgs);
}
