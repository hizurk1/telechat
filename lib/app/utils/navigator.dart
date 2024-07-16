import 'package:flutter/material.dart';

class AppNavigator {
  static final navigationKey = GlobalKey<NavigatorState>();

  static BuildContext? get currentContext => navigationKey.currentContext;

  static popDialog() => Navigator.of(currentContext!).pop();

  static Future<T?> pushNamed<T>(String route, {Object? arguments}) =>
      Navigator.of(currentContext!).pushNamed(route, arguments: arguments);

  static Future<T?> pushReplacementNamed<T>(String route,
          {Object? arguments}) =>
      Navigator.of(currentContext!)
          .pushReplacementNamed(route, arguments: arguments);

  static Future<T?> pushNamedAndRemoveUntil<T>(String route,
          {Object? arguments}) =>
      Navigator.of(currentContext!)
          .pushNamedAndRemoveUntil(route, arguments: arguments, (_) => false);

  static showMessage(String message) {
    ScaffoldMessenger.of(currentContext!).showSnackBar(
      SnackBar(
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Text(message),
      ),
    );
  }
}
