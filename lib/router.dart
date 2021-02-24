import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';

class AppRouter {
  static const String loginRoute = "/login";
  static const String homeRoute = "/home";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name) {
      case loginRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Login()
        );

      case homeRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Home()
        );

      default:
        return null;
    }
  }
}