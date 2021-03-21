part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class Idle extends LoginState {
  const Idle(
      {@required this.emailFieldState,
      @required this.passwordFieldState,
      @required this.isLoginButtonEnabled,
      this.nextRoute});
  final FieldState emailFieldState;
  final FieldState passwordFieldState;
  final bool isLoginButtonEnabled;
  final String nextRoute;

  @override
  List<Object> get props =>
      [emailFieldState, passwordFieldState, isLoginButtonEnabled, nextRoute];
}

class Loading extends LoginState {
  @override
  List<Object> get props => [];
}
