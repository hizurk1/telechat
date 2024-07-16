import 'package:flutter/material.dart';
import 'package:telechat/features/intro/pages/intro_page.dart';

class AppRoutes {
  AppRoutes._();

  static Route<dynamic> generateRoutes(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case IntroPage.route:
        return _SlidePageRoute(page: const IntroPage());

      default:
        args;
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
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
