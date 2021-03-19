import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({this.id, this.email, this.username}) : assert(id != null);

 final String id;
 final String email;
 final String username;

  @override
  List<Object> get props => [id, email, username];
}
