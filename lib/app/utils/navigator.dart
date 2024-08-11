import 'package:flutter/material.dart';
import 'package:telechat/app/themes/themes.dart';
import 'package:telechat/app/widgets/loading_indicator.dart';

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

  static void pop<T extends Object?>([T? result]) => Navigator.of(currentContext!).pop<T>(result);

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
          style: AppTextStyle.bodyS.bg,
        ),
      ),
    );
  }

  /// Show simple loading
  ///
  /// If [task] is return bool value, onFinish will be called if value is `true`
  static Future showLoading({
    double size = 30,
    required Future? task,
    Function()? onFinish,
    Function()? onFailed,
  }) async {
    showDialog(
      context: currentContext!,
      barrierDismissible: false,
      builder: (context) => Center(
        child: LoadingIndicatorWidget(
          size: size,
          color: AppColors.primary,
        ),
      ),
    );
    if (task != null) {
      await task.then((value) async {
        Navigator.of(currentContext!).pop();
        if (value is bool && value) {
          onFinish?.call();
        } else if (value is bool && !value) {
          onFailed?.call();
        } else if (value is! bool) {
          onFinish?.call();
        }
      });
    } else {
      Navigator.of(currentContext!).pop();
    }
  }
}
