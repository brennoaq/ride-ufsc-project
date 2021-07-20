import 'dart:convert';

import 'package:boilerplate_flutter/data/models/carro/carro.dart';
import 'package:boilerplate_flutter/data/models/user/user_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountRepository {
  AccountRepository() {
    _getToken().then((value) => _tokenSubject.add(value));
    _getUser().then((value) => _userSubject.add(value));
  }

  BehaviorSubject<String?> _tokenSubject = BehaviorSubject();
  BehaviorSubject<UserModel?> _userSubject = BehaviorSubject();

  String? get token => _tokenSubject.value;

  UserModel? get currentUser => _userSubject.value;

  Stream<String?> get tokenStream async* {
    yield* _tokenSubject.stream;
  }

  Stream<UserModel?> get userModelStream async* {
    yield* _userSubject.stream;
  }

  Future<Exception?> login(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      //TODO implements request for get user in fireStore
      // await createSession(userCredential.credential.token.toString(), userCredential.user);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (error) {
      return Exception(error.toString().replaceAll('Exception:', ''));
    }

    return Exception('Something went wrong');
  }

  Future<Exception?> register({
    required String email,
    required String password,
    required String name,
    required bool isMotorista,
    required Carro? carro,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await updateUser(UserModel(
            uid: userCredential.user!.uid,
            idUFSC: userCredential.user!.email!,
            name: name,
            isMotorista: isMotorista,
            carro: carro));
      }
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (error) {
      return Exception(error.toString().replaceAll('Exception:', ''));
    }
    return Exception('Something went wrong');
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<UserModel?> _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJsonString = prefs.getString('user');
    if (userJsonString?.isNotEmpty == true) {
      return UserModel.fromJson(jsonDecode(userJsonString!));
    }
    return null;
  }

  Future<void> createSession(String token, UserModel user) async {
    updateToken(token);
    updateUser(user);
  }

  Future<void> updateToken(String? token) async {
    _tokenSubject.add(token);
    final prefs = await SharedPreferences.getInstance();
    if (token != null) {
      await prefs.setString('token', token);
    } else {
      await prefs.remove('token');
    }
  }

  Future<void> updateUser(UserModel? user) async {
    _userSubject.add(user);
    final prefs = await SharedPreferences.getInstance();
    if (user != null) {
      await prefs.setString('user', json.encode(user.toJson()));
    } else {
      await prefs.remove('user');
    }
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    _userSubject.add(null);
    _tokenSubject.add(null);
  }
}
