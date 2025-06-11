import 'package:oryn/orm.dart';
import '../model/user_model.dart';

class UserRepository extends OrynRepository<User> {
  UserRepository() : super(tableName: 'users', fromMap: User.fromMap);
}
