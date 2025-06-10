import 'database_driver.dart';

class DatabaseService {
  static late DatabaseDriver _driver;
  static void use(DatabaseDriver driver) {
    _driver = driver;
    _driver.open();
  }
  static DatabaseDriver get driver => _driver;
}
