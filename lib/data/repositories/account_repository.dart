import 'dart:convert';

import 'package:boilerplate_flutter/data/api/user_api.dart';
import 'package:boilerplate_flutter/data/models/user_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountRepository {
  AccountRepository() {
    _getToken().then((value) => tokenSubject.add(value));
    _getUser().then((value) => userSubject.add(value));
  }

  BehaviorSubject<String> tokenSubject = BehaviorSubject();
  BehaviorSubject<UserModel> userSubject = BehaviorSubject();

  String get token => tokenSubject.value;
  UserModel get currentUser => userSubject.value;

  Future<Exception> login({String email, String password}) async {
    try {
      var loginResponse = await UserApi.login(email, password);
      if (loginResponse != null) {
        await createSession(loginResponse.token, loginResponse.user);
        return null;
      }
    } catch (error) {
      return Exception(error.toString().replaceAll('Exception:', ''));
    }

    return Exception('Something went wrong');
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<UserModel> _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJsonString = prefs.getString('user');
    if (userJsonString?.isNotEmpty == true) {
      return UserModel.fromJSON(jsonDecode(userJsonString));
    }
    return null;
  }

  Future<void> createSession(String token, UserModel user) async {
    updateToken(token);
    updateUser(user);
  }

  Future<void> updateToken(String token) async {
    tokenSubject.add(token);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> updateUser(UserModel user) async {
    userSubject.add(user);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', user.jsonString);
  }

  Future logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    userSubject.add(null);
    tokenSubject.add(null);
  }
}
