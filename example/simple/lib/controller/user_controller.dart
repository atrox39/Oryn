import 'dart:async';

import 'package:oryn/oryn.dart';
import 'package:simple/repository/user_repository.dart';

class UserController extends Controller {
  final userRepository = UserRepository();
  UserController(App app) : super(app);

  String string = '';

  @override
  FutureOr index(Req req, Res res) async {
    final user = await userRepository.find('1');
    await res.json(user!.toMap());
  }

  @override
  FutureOr view(Req req, Res res) async {
    await res.send('User Detail');
  }

  @override
  FutureOr create(Req req, Res res) async {
    await res.send('Create User');
  }

  @override
  FutureOr edit(Req req, Res res) async {
    await res.send('Edit User');
  }

  @override
  FutureOr delete(Req req, Res res) async {
    await res.send('Delete User');
  }

  @override
  FutureOr deleteAll(Req req, Res res) async {
    await res.send('Delete All Users');
  }

  FutureOr vip(Req req, Res res) async {
    await res.send('List of VIP Users');
  }
}
