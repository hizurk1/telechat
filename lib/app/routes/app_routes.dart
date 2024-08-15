// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/constants/gen/assets.gen.dart';
import 'package:telechat/app/pages/home/home_page.dart';
import 'package:telechat/app/pages/intro/intro_page.dart';
import 'package:telechat/app/pages/splash/splash_page.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/features/authentication/pages/fill_user_info_page.dart';
import 'package:telechat/features/authentication/pages/sign_in_page.dart';
import 'package:telechat/features/authentication/pages/verify_opt_page.dart';
import 'package:telechat/features/call/pages/call_page.dart';
import 'package:telechat/features/chat/pages/chat_page.dart';
import 'package:telechat/features/contact/pages/add_contact_page.dart';
import 'package:telechat/features/contact/pages/select_contact_page.dart';
import 'package:telechat/features/group/pages/new_group_page.dart';

class AppRoutes {
  AppRoutes._();

  static Route<dynamic> generateRoutes(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      case SplashPage.route:
        return _SlidePageRoute(page: const SplashPage());

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
        return _SlidePageRoute(page: const SelectContactPage());

      case AddContactPage.route:
        return _SlidePageRoute(page: const AddContactPage());

      case ChatPage.route:
        return _SlidePageRoute(
          page: ChatPage(
            chatId: args!['chatId'],
            memberIds: args['memberIds'],
            groupName: args['groupName'],
          ),
        );

      case NewGroupPage.route:
        return _SlidePageRoute(
          page: const NewGroupPage(),
        );

      case CallPage.route:
        return _SlidePageRoute(
          page: CallPage(
            channelId: args?["channelId"],
            callModel: args?["callModel"],
            isGroup: args?["isGroup"],
          ),
        );

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
        appBar: AppBar(
          surfaceTintColor: AppColors.background,
          backgroundColor: AppColors.background,
          iconTheme: const IconThemeData(color: AppColors.white),
          elevation: 0,
          automaticallyImplyLeading: true,
        ),
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
                const Gap(40),
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
