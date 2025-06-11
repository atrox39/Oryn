import 'package:oryn/orm.dart';

@Entity()
class User extends OrynModel<int> {
  @PrimaryKey()
  @AutoIncrement()
  @Column()
  @override
  set id(int? value) => super.id;

  @Column()
  late String name; // Quitar `final`

  User({int? id, required this.name}) : super(id: id);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id ?? 0,
      'name': name,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      name: map['name'],
    );
  }
}
