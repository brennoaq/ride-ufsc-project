import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:boilerplate_flutter/config/app_routes.dart';
import 'package:boilerplate_flutter/data/models/field_state.dart';
import 'package:boilerplate_flutter/data/models/user/user_model.dart';
import 'package:boilerplate_flutter/data/repositories/account_repository.dart';
import 'package:boilerplate_flutter/util/validator/validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this.accountRepository) : super(Loading()) {
    add(OnFormChanged());
  }

  UserModel? userModel;
  final AccountRepository accountRepository;

  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    yield _mapEventToState(event);
  }

  LoginState _mapEventToState(LoginEvent event) {
    if (event is OnFormChanged) {
      return _mapOnFormChangedToState(event);
    } else if (event is OnLoginButtonClicked) {
      return _mapOnLoginButtonClickedToState(event);
    } else if (event is OnLoginSuccess) {
      return _mapOnLoginSuccessToState(event);
    } else if (event is OnLoginFail) {
      return _mapOnLoginFailedToState(event);
    } else if (event is OnForgotPasswordClicked) {
      //TODO implement real event treatment
      return state;
    }
    return state;
  }

  LoginState _mapOnFormChangedToState(LoginEvent event) {
    LoginState currentState = state;
    if (currentState is Idle ||
        currentState is Loading ||
        currentState is Error) {
      return _getIdleState(null);
    }
    return currentState;
  }

  LoginState _mapOnLoginButtonClickedToState(LoginEvent event) {
    accountRepository
        .login(
            email: _emailEditingController.text,
            password: _passwordEditingController.text)
        .then((error) {
      if (error != null) {
        add(OnLoginFail(error));
      } else {
        add(OnLoginSuccess());
      }
    });
    return Loading();
  }

  LoginState _mapOnLoginSuccessToState(LoginEvent event) {
    return _getIdleState(AppRoutes.core);
  }

  LoginState _mapOnLoginFailedToState(OnLoginFail event) {
    return Error(error: event.error);
  }

  LoginState _getIdleState(String? nextRoute) {
    bool isValidEmail = _emailEditingController.text.isValidEmail();
    bool isValidPassword = _passwordEditingController.text.isValidPassword();

    String? emailError = _emailEditingController.text.isEmpty
        ? null
        : (isValidEmail ? null : "Invalid email");
    String? passwordError = _passwordEditingController.text.isEmpty
        ? null
        : (isValidPassword ? null : "Passwords must have at least 8 chars");

    FieldState emailFieldState =
        FieldState(controller: _emailEditingController, error: emailError);
    FieldState passwordFieldState = FieldState(
        controller: _passwordEditingController, error: passwordError);

    return Idle(
        emailFieldState: emailFieldState,
        passwordFieldState: passwordFieldState,
        isLoginButtonEnabled: isValidPassword && isValidEmail,
        nextRoute: nextRoute);
  }
}
