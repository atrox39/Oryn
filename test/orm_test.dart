import 'package:oryn/src/orm/core/annotations.dart';
import 'package:oryn/src/orm/sqlite/sqlite_schema_generator.dart';
import 'package:oryn/src/orm/sqlite/sqlite_connection.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';

// Sample Model Definition
@Entity(tableName: 'test_users')
class User {
  @PrimaryKey()
  @AutoIncrement()
  @Column(name: 'user_id')
  int? id;

  @Column()
  String? username;

  @Column()
  String? emailAddress; // Will be converted to email_address

  @Column()
  bool? isActive;

  @Column()
  double? balance;
  
  @Column()
  DateTime? createdAt;

  // Non-column field
  String? temporaryInfo;

  User({this.id, this.username, this.emailAddress, this.isActive, this.balance, this.createdAt});
}

@Entity() // No table name, should use class name
class Product {
  @PrimaryKey()
  @Column(name: 'product_sku')
  String? sku;

  @Column()
  String? name;

  @Column()
  int? stockCount;

  Product({this.sku, this.name, this.stockCount});
}

@Entity()
class EmptyEntity {}

@Entity()
class BadKeyEntity {
  @PrimaryKey()
  @AutoIncrement()
  @Column()
  String? id;
}

void main() {
  group('SqliteSchemaGenerator', () {
    final generator = SqliteSchemaGenerator();

    test('generates CREATE TABLE SQL for User model', () {
      final sql = generator.generateCreateTableSql(User);
      // Normalize whitespace for comparison
      final expectedSql = '''
        CREATE TABLE IF NOT EXISTS test_users (user_id INTEGER PRIMARY KEY AUTOINCREMENT, 
          username TEXT, 
          email_address TEXT, 
          is_active INTEGER, 
          balance REAL, 
          created_at TEXT
        );
      '''.replaceAll(RegExp(r'\s+'), ' ').trim();
      //The generator actually produces '...TEXT);' not '...TEXT );'
      //Let's adjust the expectation or the generator. For now, adjust expectation.
      expect(sql.replaceAll(RegExp(r'\s+'), ' ').trim(), expectedSql.replaceAll(' )', ')'));
    });

    test('generates CREATE TABLE SQL for Product model (auto table name)', () {
      final sql = generator.generateCreateTableSql(Product);
      final expectedSql = '''
        CREATE TABLE IF NOT EXISTS product (product_sku TEXT PRIMARY KEY, 
          name TEXT, 
          stock_count INTEGER
        );
      '''.replaceAll(RegExp(r'\s+'), ' ').trim();
      expect(sql.replaceAll(RegExp(r'\s+'), ' ').trim(), expectedSql.replaceAll(' )', ')'));
    });

    test('throws error for class not annotated with @Entity', () {
      expect(() => generator.generateCreateTableSql(String), throwsArgumentError);
    });

    test('throws error for entity with no @Column fields', () {
      expect(() => generator.generateCreateTableSql(EmptyEntity), throwsArgumentError);
    });
    
    test('throws error for AUTOINCREMENT on non-INTEGER type', () {
      expect(() => generator.generateCreateTableSql(BadKeyEntity), throwsArgumentError);
    });
  });

  group('SqliteConnection', () {
    final dbPath = 'test_orm_connection.db';
    // Ensure a clean state by deleting the test DB if it exists from a previous run
    // This is typically done in setUp or tearDownAll, but for simplicity here:
    // File(dbPath).deleteSync(); // Requires dart:io, ensure test environment allows this or use specific test setup.

    test('can open and close an in-memory database', () {
      final connection = SqliteConnection(':memory:');
      expect(() => connection.db, throwsStateError); // Check db access before open
      connection.open();
      expect(connection.db, isA<Database>());
      // Ensure it's usable by executing a simple query
      connection.db.execute('CREATE TABLE test_table (id INTEGER);');
      connection.db.execute('INSERT INTO test_table (id) VALUES (1);');
      final resultSet = connection.db.select('SELECT * FROM test_table');
      expect(resultSet.length, 1);
      expect(resultSet.first['id'], 1);
      
      connection.close();
      expect(() => connection.db, throwsStateError); // Check db access after close
    });

    // Test with a file-based database if preferred, ensuring cleanup
    // For now, in-memory is simpler for unit tests.
  });
}
