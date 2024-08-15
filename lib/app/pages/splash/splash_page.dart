import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:telechat/app/constants/gen/assets.gen.dart';
import 'package:telechat/app/pages/home/home_page.dart';
import 'package:telechat/app/pages/intro/intro_page.dart';
import 'package:telechat/app/utils/shared_preferences.dart';
import 'package:telechat/core/extensions/build_context.dart';
import 'package:telechat/features/authentication/pages/sign_in_page.dart';
import 'package:telechat/shared/controllers/user_controller.dart';

class SplashPage extends ConsumerStatefulWidget {
  static const String route = "/splash";
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () {
        if (SharedPrefs.getAsFirstEnterIntroPage) {
          Navigator.pushReplacementNamed(context, IntroPage.route);
          return;
        }

        if (ref.read(userControllerProvider).currentUser == null) {
          Navigator.pushReplacementNamed(context, SignInPage.route);
          return;
        }

        Navigator.pushReplacementNamed(context, HomePage.route);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LottieBuilder.asset(
          Assets.jsons.message.path,
          width: context.screenWidth / 2,
          fit: BoxFit.fitWidth,
          repeat: false,
        ),
      ),
    );
  }
}
