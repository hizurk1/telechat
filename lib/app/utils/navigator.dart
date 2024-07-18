import 'package:flutter/material.dart';
import 'package:telechat/app/themes/themes.dart';

enum SnackbarType {
  info(Colors.white),
  success(Colors.green),
  error(Colors.red);

  final Color color;
  const SnackbarType(this.color);
}

class AppNavigator {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get currentContext => navigatorKey.currentContext;

  static popDialog() => Navigator.of(currentContext!).pop();

  static Future<T?> pushNamed<T>(String route, {Object? arguments}) =>
      Navigator.of(currentContext!).pushNamed(route, arguments: arguments);

  static Future<T?> pushReplacementNamed<T>(String route, {Object? arguments}) =>
      Navigator.of(currentContext!).pushReplacementNamed(route, arguments: arguments);

  static Future<T?> pushNamedAndRemoveUntil<T>(String route, {Object? arguments}) =>
      Navigator.of(currentContext!)
          .pushNamedAndRemoveUntil(route, arguments: arguments, (_) => false);

  static showMessage(
    String message, {
    SnackbarType type = SnackbarType.info,
  }) {
    ScaffoldMessenger.of(currentContext!).showSnackBar(
      SnackBar(
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        behavior: SnackBarBehavior.floating,
        backgroundColor: type.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Text(
          message,
          style: AppTextStyle.bodyS,
        ),
      ),
    );
  }
}
