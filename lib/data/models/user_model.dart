import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({this.id, this.email, this.username}) : assert(id != null);

  final int id;
  final String email;
  final String username;

  @override
  List<Object> get props => [id, email, username];

  static UserModel fromJSON(Map json) {
    try {
      int id = json['id'];
      String email = json['email'];
      String username = json['username'];
      return UserModel(id: id, email: email, username: username);
    } catch (error) {
      throw Exception(
          'Failed to parse user object from $json\n${error.toString()}');
    }
  }

  String get jsonString => jsonEncode({
        "id": id,
        "email": email,
        "username": username,
      });
}
