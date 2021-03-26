import 'package:boilerplate_flutter/data/models/user_model.dart';
import 'package:equatable/equatable.dart';

class LoginResponse extends Equatable {
  const LoginResponse({this.token, this.user});

  final String token;
  final UserModel user;

  @override
  List<Object> get props => [token, user];

  static LoginResponse fromJSON(Map json) {
    String token = json['key'];
    UserModel user = UserModel.fromJSON(json['user']);
    return LoginResponse(token: token, user: user);
  }
}
