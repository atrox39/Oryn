import 'database_service.dart';

abstract class OrynRepository<T> {
  final String tableName;
  final T Function(Map<String, dynamic>) fromMap;

  OrynRepository({required this.tableName, required this.fromMap});

  Future<T?> create(T data) async {
    final id = await DatabaseService.driver.insert(tableName, data as Map<String, dynamic>);
    return find(id.toString());
  }

  Future<bool> delete(int id) async {
    final result = await DatabaseService.driver.delete(tableName, 'id = ?', [id]);
    return result > 0;
  }

  Future<T?> find(String id) async {
    final results = await DatabaseService.driver.query(
      'SELECT * FROM $tableName WHERE id = ?',
      [id],
    );
    if (results.isEmpty) return null;
    return fromMap(results.first);
  }

  Future<List<T>> all() async {
    final results = await DatabaseService.driver.query('SELECT * FROM $tableName');
    return results.map(fromMap).toList();
  }

  Future<List<T>> where(String field, dynamic value) async {
    final results = await DatabaseService.driver.query(
      'SELECT * FROM $tableName WHERE $field = ?',
      [value],
    );
    return results.map(fromMap).toList();
  }
}
