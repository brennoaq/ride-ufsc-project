import 'package:boilerplate_flutter/config/app_routes.dart';
import 'package:boilerplate_flutter/config/theme.dart';
import 'package:boilerplate_flutter/data/repositories/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await launcher(accountRepository);
  Intl.defaultLocale = 'pt_BR';
  runApp(
    Phoenix(
      child: App(),
    ),
  );
}

AccountRepository accountRepository = AccountRepository();
String route;

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
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
  final token = prefs.getString('token');

  if (token != null) {
    route = '/core';
  } else {
    route = '/login';
  }
}

extension ObjectExt<T> on T {
  R let<R>(R Function(T that) op) => op(this);
}
