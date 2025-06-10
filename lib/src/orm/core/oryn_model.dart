import 'database_service.dart';

abstract class OrynModel {
  String? id;

  OrynModel({ this.id });

  String get tableName => runtimeType.toString().toLowerCase();

  Map<String, dynamic> toMap();

  Future<void> save() async {
    final map = toMap();
    if (id == null) {
      id = (await DatabaseService.driver.insert(tableName, map)).toString();
    } else {
      await DatabaseService.driver.update(
        tableName,
        map,
        'id = ?',
        [id],
      );
    }
  }

  Future<void> delete() async {
    if (id != null) return;
    await DatabaseService.driver.delete(
      tableName,
      'id = ?',
      [id],
    );
  }
}
