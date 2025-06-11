import 'package:oryn/orm.dart';

@Entity(tableName: 'tb_users')
class User {
  @PrimaryKey()
  @AutoIncrement()
  @Column()
  int? id;
  @Column()
  String? name;
  @Column()
  String? email;
  @Column()
  String? password;

  User({
    this.id,
    this.name,
    this.email,
    this.password,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  } 
}
