import 'package:flutter/material.dart';
import 'package:telechat/app/routes/app_routes.dart';
import 'package:telechat/app/themes/themes.dart';
import 'package:telechat/features/intro/pages/intro_page.dart';

import 'app/utils/navigator.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      initialRoute: IntroPage.route,
      onGenerateRoute: AppRoutes.generateRoutes,
      navigatorKey: AppNavigator.navigatorKey,
    );
  }
}
