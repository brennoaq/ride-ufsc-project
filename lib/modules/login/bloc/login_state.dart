part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
  });

  final Email email;
  final Password password;
  final FormzStatus status;

  @override
  List<Object> get props => [email, password, status];

  LoginState copyWith({
    Email email,
    Password password,
    FormzStatus status,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }
}

class Idle extends LoginState {
  const Idle({
    this.emailFieldState,
    this.passwordFieldState,
    this.isLoginButtonEnabled,
    this.nextRoute,
  });

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
