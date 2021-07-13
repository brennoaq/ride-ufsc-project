import 'package:boilerplate_flutter/main.dart';
import 'package:boilerplate_flutter/modules/core/core_screen.dart';
import 'package:boilerplate_flutter/modules/login/login_screen.dart';
import 'package:flutter/material.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class AppRoutes {
  static const String login = '/login';
  static const String appRestart = '/appRestart';
  static const String core = '/core';

  static Map<String, WidgetBuilder> defaultBuilder = <String, WidgetBuilder>{};

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
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (context) {
            return LoginScreen(
              routeObserver: routeObserver,
              accountRepository: accountRepository,
            );
          },
        );
      case AppRoutes.appRestart:
        return PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => LoginScreen(
            routeObserver: routeObserver,
            accountRepository: accountRepository,
          ),
          transitionDuration: Duration(seconds: 0),
        );

      default:
        return MaterialPageRoute(
            builder: defaultBuilder[settings.name]!, settings: settings);
    }
  }
}
