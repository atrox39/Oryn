import 'dart:mirrors';
import '../core/annotations.dart';
import '../core/utils.dart';

class SqliteSchemaGenerator {
  String generateCreateTableSql(Type modelType) {
    final classMirror = reflectClass(modelType);
    if (!classMirror.metadata.any((m) => m.reflectee is Entity)) {
      throw ArgumentError('Class $modelType is not annotated with @Entity');
    }
    final entityAnnotation = classMirror.metadata.firstWhere((m) => m.reflectee is Entity).reflectee as Entity;
    final tableName = entityAnnotation.tableName ?? _camelToSnakeCase(symbolToString(classMirror.simpleName));
    final columns = <String>[];
    final primaryKeys = <String>[];
    classMirror.declarations.forEach((symbol, declMirror) {
      if (declMirror is VariableMirror && declMirror.metadata.any((m) => m.reflectee is Column)) {
        final columnAnnotation = declMirror.metadata.firstWhere((m) => m.reflectee is Column).reflectee as Column;
        final columnName = columnAnnotation.name ?? _camelToSnakeCase(symbolToString(declMirror.simpleName));
        String columnType = _getSqliteType(declMirror.type);
        String columnDefinition = '$columnName $columnType';
        bool isPrimaryKey = declMirror.metadata.any((m) => m.reflectee is PrimaryKey);
        bool isAutoIncrement = declMirror.metadata.any((m) => m.reflectee is AutoIncrement);
        if (isPrimaryKey) {
          columnDefinition += ' PRIMARY KEY';
          if (isAutoIncrement) {
            if (columnType != 'INTEGER') {
              throw ArgumentError('AutoIncrement can only be used with INTEGER columns');
            }
            columnDefinition += ' AUTOINCREMENT';
          }
          primaryKeys.add(columnName);
        }
        columns.add(columnDefinition);
      }
    });
    if (columns.isEmpty) {
      throw ArgumentError('Class $modelType has no columns defined with @Column');
    }
    return 'CREATE TABLE IF NOT EXISTS $tableName (${columns.join(', ')});';
  }

  String _getSqliteType(TypeMirror typeMirror) {
    if (typeMirror.isAssignableTo(reflectType(String))) {
      return 'TEXT';
    }
    if (typeMirror.isAssignableTo(reflectType(int))) {
      return 'INTEGER';
    }
    if (typeMirror.isAssignableTo(reflectType(double))) {
      return 'REAL';
    }
    if (typeMirror.isAssignableTo(reflectType(bool))) {
      return 'INTEGER';
    }
    if (typeMirror.isAssignableTo(reflectType(DateTime))) {
      return 'TEXT';
    }
    if (typeMirror.isAssignableTo(reflectType(List))) {
      return 'BLOB';
    }
    throw ArgumentError('Unsupported Dart type: ${typeMirror.reflectedType}');
  }

  String _camelToSnakeCase(String camelCase) {
    final exp = RegExp('(?<=[a-z])[A-Z]');
    return camelCase.replaceAllMapped(exp, (match) => '_${match.group(0)}').toLowerCase();
  }
}
