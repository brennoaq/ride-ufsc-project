part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();
}

class IdleRegister extends RegisterState {
  const IdleRegister({
    required this.emailFieldState,
    required this.passwordFieldState,
    required this.isLoginButtonEnabled,
    this.nonFieldError,
    this.nextRoute,
  });

  final FieldState emailFieldState;
  final FieldState passwordFieldState;
  final bool isLoginButtonEnabled;
  final String? nonFieldError;
  final String? nextRoute;

  @override
  List<Object?> get props => [
        emailFieldState,
        passwordFieldState,
        isLoginButtonEnabled,
        nonFieldError,
        nextRoute
      ];
}

class Error extends RegisterState {
  const Error({
    this.error,
  });

  final Exception? error;

  @override
  List<Object?> get props => [error];
}

class Loading extends RegisterState {
  @override
  List<Object> get props => [];
}
