import 'dart:convert';

import 'package:boilerplate_flutter/config/settings.dart';
import 'package:boilerplate_flutter/data/models/user_model.dart';
import 'package:boilerplate_flutter/util/api/login_api.dart';
import 'package:boilerplate_flutter/util/validator/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountRepository {
  Future<UserModel> getUser(String email, String password) async {
    var snapshot = await fetchLogin(email, password);
    if (Validator.isNull(snapshot) && snapshot.isNotEmpty) {
      UserModel user = UserModel(
          username: snapshot.username, email: snapshot.email, id: snapshot.id);
      return user;
    }
    return null;
  }

  Future<void> saveUserCache(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'user',
        jsonEncode({
          "id": user.id,
          "email": user.email,
          "username": user.username,
        }));
    Settings.user = user;
  }

  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove('user');
  }
}
