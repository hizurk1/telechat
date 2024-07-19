import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/routes/app_routes.dart';
import 'package:telechat/app/themes/themes.dart';
import 'package:telechat/features/authentication/controllers/auth_controller.dart';
import 'package:telechat/features/authentication/pages/fill_user_info_page.dart';
import 'package:telechat/features/intro/pages/intro_page.dart';

import 'app/utils/navigator.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(393, 827),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.appTheme,
          onGenerateRoute: AppRoutes.generateRoutes,
          navigatorKey: AppNavigator.navigatorKey,
          home: ref.watch(authControllerProvider).currentUser != null
              ? const FillUserInfoPage()
              : const IntroPage(),
        );
      },
    );
  }
}
