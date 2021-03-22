import 'package:boilerplate_flutter/data/models/email.dart';
import 'package:boilerplate_flutter/data/models/password.dart';

class Validator {
  static final regexEmail = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  static final regexPassword =
  RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  static bool isNull(dynamic obj) {
    return obj == null;
  }

  static bool isFilledString(String obj) {
    return obj != null && obj.isNotEmpty;
  }

  static bool validatePasswordApp(String password) {
    if (password.isNotEmpty) return true;
    return false;
  }

  static EmailValidationError validateEmail(String email) {
    return (!regexEmail.hasMatch(email.trim()))
        ? null
        : EmailValidationError.invalid;
  }

  static PasswordValidationError validatePassword(String password) {
    return (!regexPassword.hasMatch(password.trim()))
        ? null
        : PasswordValidationError.invalid;
  }
}
