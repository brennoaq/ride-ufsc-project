import 'package:boilerplate_flutter/data/repositories/account_repository.dart';
import 'package:boilerplate_flutter/modules/core/core_screen.dart';
import 'package:boilerplate_flutter/modules/login/login_screen.dart';
import 'package:flutter/material.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
AccountRepository accountRepository = AccountRepository();

class AppRoutes {
  static const String login = '/login';
  static const String core = '/core';

  static Map<String, WidgetBuilder> defaultBuilder = <String, WidgetBuilder>{
    login: (BuildContext context) => LoginScreen(),
  };

  static Route<dynamic> routeFactory(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.core:
        return MaterialPageRoute(
          builder: (context) {
            return CoreScreen(
              routeObserver: routeObserver,
              accountRepository: accountRepository,
            );
          },
        );
      default:
        return MaterialPageRoute(builder: defaultBuilder[settings.name]);
    }
  }
}
