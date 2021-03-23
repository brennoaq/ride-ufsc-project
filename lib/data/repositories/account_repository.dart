import 'package:boilerplate_flutter/data/models/user_model.dart';
import 'package:boilerplate_flutter/util/api/user_api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountRepository {
  AccountRepository() {
    _getToken().then((value) => tokenSubject.add(value));
  }

  BehaviorSubject<String> tokenSubject = BehaviorSubject();

  String get token => tokenSubject.value;

  Future<Exception> login({String email, String password}) async {
    var loginResponse = await UserApi.login(email, password);
    if (loginResponse != null) {
      try {
        await createSession(loginResponse.token, loginResponse.user);
      } catch (error) {
        return Exception(error.toString());
      }

      return null;
    }
    return Exception('Something went wrong');
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> createSession(String token, UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    updateUser(user);
  }

  Future<void> updateUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', user.jsonString);
  }

  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove('user');
  }
}
