import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:boilerplate_flutter/config/app_routes.dart';
import 'package:boilerplate_flutter/data/models/field_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(Loading()) {
    add(OnFormChanged());
  }

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
      //TODO implement real event treatment
      return state;
    } else if (event is OnLoginSuccess) {
      return _mapOnLoginSuccessToState(event);
    } else if (event is OnLoginFail) {
      //TODO implement real event treatment
      return state;
    } else if (event is OnForgotPasswordClicked) {
      //TODO implement real event treatment
      return state;
    }
    return state;
  }

  LoginState _mapOnFormChangedToState(LoginEvent event) {
    LoginState currentState = state;
    if (currentState is Idle || currentState is Loading) {
      return _getIdleState(null);
    }
    return currentState;
  }

  LoginState _mapOnLoginSuccessToState(LoginEvent event) {
    return _getIdleState(AppRoutes.core);
  }

  LoginState _getIdleState(String nextRoute) {
    String email = _emailEditingController.text;
    bool isValidEmail = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    bool isValidPassword = _passwordEditingController.text.length > 8;

    String emailError = _emailEditingController.text.isEmpty
        ? null
        : (isValidEmail ? null : "Invalid email");
    String passwordError = _passwordEditingController.text.isEmpty
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
