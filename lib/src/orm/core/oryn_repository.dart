import 'database_service.dart';
import 'oryn_model.dart';

abstract class OrynRepository<T extends OrynModel> {
  final String tableName;
  final T Function(Map<String, dynamic>) fromMap;

  OrynRepository({required this.tableName, required this.fromMap});

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
