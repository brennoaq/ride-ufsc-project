part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class OnFormChanged extends LoginEvent {
  const OnFormChanged() : super();
}

class OnLoginButtonClicked extends LoginEvent {
  OnLoginButtonClicked();
}

class OnForgotPasswordClicked extends LoginEvent {
  OnForgotPasswordClicked();
}

class OnLoginSuccess extends LoginEvent {
  OnLoginSuccess();
}

class OnLoginFail extends LoginEvent {
  OnLoginFail(this.error);
  final Exception error;

  @override
  List<Object> get props => [error];
}
