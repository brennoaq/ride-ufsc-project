import 'package:boilerplate_flutter/config/app_routes.dart';
import 'package:boilerplate_flutter/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  Intl.defaultLocale = 'pt_BR';
  runApp(App());
}

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
        initialRoute: '/login',
        onGenerateRoute: (settings) {
          return AppRoutes.routeFactory(settings);
        },
        navigatorObservers: [routeObserver],
      ),
    );
  }
}

extension ObjectExt<T> on T {
  R let<R>(R Function(T that) op) => op(this);
}
