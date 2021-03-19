import 'dart:convert';

import 'package:boilerplate_flutter/config/app_routes.dart';
import 'package:boilerplate_flutter/config/theme.dart';
import 'package:boilerplate_flutter/data/models/user_model.dart';
import 'package:boilerplate_flutter/data/repositories/account_repository.dart';
import 'package:boilerplate_flutter/util/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  Intl.defaultLocale = 'pt_BR';
  runApp(App());
}

AccountRepository accountRepository = AccountRepository();
String route;

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    launcher(accountRepository);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark),
      child: MaterialApp(
        title: 'BoilerPlate',
        debugShowCheckedModeBanner: false,
        theme: appThemeData,
        home: Container(),
        initialRoute: route,
        onGenerateRoute: (settings) {
          return AppRoutes.routeFactory(settings);
        },
        navigatorObservers: [routeObserver],
      ),
    );
  }
}

Future launcher(AccountRepository accountRepository) async {
  final prefs = await SharedPreferences.getInstance();
  final result = prefs.getString('user');

  if (result != null) {
    var resultInCache = jsonDecode(result);
    if (!Validator.isNull(resultInCache['id']) &&
        resultInCache.toString().isNotEmpty) {
      try {
        var user = UserModel(
          id: resultInCache['id'],
          email: resultInCache['email'],
          username: resultInCache['username'],
        );
        await accountRepository.saveUserCache(user);
      } catch (e) {
        route = '/login';
      }
    } else {
      route = '/login';
    }
    route = '/core';
  } else {
    route = '/login';
  }
}

extension ObjectExt<T> on T {
  R let<R>(R Function(T that) op) => op(this);
}
