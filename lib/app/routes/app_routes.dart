import 'package:flutter/material.dart';
import 'package:telechat/features/authentication/pages/fill_user_info_page.dart';
import 'package:telechat/features/authentication/pages/sign_in_page.dart';
import 'package:telechat/features/authentication/pages/verify_opt_page.dart';
import 'package:telechat/features/intro/pages/intro_page.dart';

class AppRoutes {
  AppRoutes._();

  static Route<dynamic> generateRoutes(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      case IntroPage.route:
        return _SlidePageRoute(page: const IntroPage());

      case SignInPage.route:
        return _SlidePageRoute(page: const SignInPage());

      case VerifyOTPPage.route:
        final verificationId = args?["verificationId"] as String?;
        final phoneNumber = args?["phoneNumber"] as String?;
        return _SlidePageRoute(
          page: VerifyOTPPage(
            verificationId: verificationId ?? '',
            phoneNumber: phoneNumber ?? '',
          ),
        );

      case FillUserInfoPage.route:
        return _SlidePageRoute(page: const FillUserInfoPage());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: Center(
          child: Text("Page not found!"),
        ),
      );
    });
  }
}

class _SlidePageRoute extends PageRouteBuilder {
  final Widget page;
  _SlidePageRoute({
    required this.page,
  }) : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
