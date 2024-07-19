import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/constants/gen/assets.gen.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/features/authentication/pages/fill_user_info_page.dart';
import 'package:telechat/features/authentication/pages/sign_in_page.dart';
import 'package:telechat/features/authentication/pages/verify_opt_page.dart';
import 'package:telechat/features/contact/pages/add_contact_page.dart';
import 'package:telechat/features/contact/pages/select_contact_page.dart';
import 'package:telechat/features/home/pages/home_page.dart';
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

      case HomePage.route:
        return _SlidePageRoute(page: const HomePage());

      case SelectContactPage.route:
        return _defaultPageRoute(page: const SelectContactPage());

      case AddContactPage.route:
        return _defaultPageRoute(page: const AddContactPage());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _defaultPageRoute({required Widget page}) {
    return MaterialPageRoute(builder: (_) => page);
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.jsons.catError.lottie(
                  height: 200.r,
                  width: 200.r,
                ),
                Text(
                  "Page not found!",
                  style: AppTextStyle.bodyL.white,
                ),
              ],
            ),
          ),
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

class FabZoomPageRoute extends PageRouteBuilder {
  final Widget page;
  final Offset fabPosition;
  final Size fabSize;

  FabZoomPageRoute({
    required this.page,
    required this.fabPosition,
    required this.fabSize,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
            );

            return Transform(
              transform: Matrix4.identity()
                ..translate(
                  fabPosition.dx + (fabSize.width / 2),
                  fabPosition.dy + (fabSize.height / 2),
                )
                ..scale(scaleAnimation.value)
                ..translate(
                  -(fabPosition.dx + (fabSize.width / 2)),
                  -(fabPosition.dy + (fabSize.height / 2)),
                ),
              alignment: Alignment.center,
              child: child,
            );
          },
        );
}
