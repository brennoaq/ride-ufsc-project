import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:boilerplate_flutter/config/app_routes.dart';
import 'package:boilerplate_flutter/data/models/field_state.dart';
import 'package:boilerplate_flutter/data/models/user/user_model.dart';
import 'package:boilerplate_flutter/data/repositories/account_repository.dart';
import 'package:boilerplate_flutter/util/validator/validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc(this.accountRepository) : super(Loading()) {
    add(OnFormChanged());
  }

  UserModel? userModel;
  final AccountRepository accountRepository;

  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    yield _mapEventToState(event);
  }

  RegisterState _mapEventToState(RegisterEvent event) {
    if (event is OnFormChanged) {
      return _mapOnFormChangedToState(event);
    } else if (event is OnRegisterButtonClicked) {
      return _mapOnLoginButtonClickedToState(event);
    } else if (event is OnRegisterSuccess) {
      return _mapOnLoginSuccessToState(event);
    } else if (event is OnRegisterFail) {
      return _mapOnLoginFailedToState(event);
    } else if (event is OnRegisterClicked) {
      return _mapOnRegisterClickedState();
    }
    return state;
  }

  RegisterState _mapOnFormChangedToState(RegisterEvent event) {
    RegisterState currentState = state;
    if (currentState is IdleRegister ||
        currentState is Loading ||
        currentState is Error) {
      return _getIdleState(null);
    }
    return currentState;
  }

  RegisterState _mapOnLoginButtonClickedToState(RegisterEvent event) {
    //TODO implement register request
    // accountRepository
    //     .register(
    //         email: _emailEditingController.text,
    //         password: _passwordEditingController.text,
    //         name: null,
    //         isMotorista: null,
    //         carro: null)
    //     .then((error) {
    //   if (error != null) {
    //     add(OnRegisterFail(error));
    //   } else {
    //     add(OnRegisterSuccess());
    //   }
    // });
    return Loading();
  }

  RegisterState _mapOnLoginSuccessToState(RegisterEvent event) {
    return _getIdleState(AppRoutes.core);
  }

  RegisterState _mapOnLoginFailedToState(OnRegisterFail event) {
    return Error(error: event.error);
  }

  RegisterState _mapOnRegisterClickedState() {
    return _getIdleState(AppRoutes.register);
  }

  RegisterState _getIdleState(String? nextRoute) {
    bool isValidEmail = _emailEditingController.text.isValidEmailUFSC();
    bool isValidPassword =
        Validator.isValidPassword(_passwordEditingController.text);

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

    return IdleRegister(
        emailFieldState: emailFieldState,
        passwordFieldState: passwordFieldState,
        isLoginButtonEnabled: isValidPassword && isValidEmail,
        nextRoute: nextRoute);
  }

  @override
  Future<void> close() {
    // listeners.forEach((element) {
    //   element.cancel();
    // });
    return super.close();
  }
}
