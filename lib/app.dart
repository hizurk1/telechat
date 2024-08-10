import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/routes/app_routes.dart';
import 'package:telechat/app/themes/themes.dart';
import 'package:telechat/app/widgets/error_page.dart';
import 'package:telechat/features/authentication/controllers/auth_controller.dart';
import 'package:telechat/features/home/pages/home_page.dart';
import 'package:telechat/features/intro/pages/intro_page.dart';
import 'package:telechat/shared/providers/user_data_provider.dart';

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
          home: ref.watch(getUserDataProvider).when(
                skipLoadingOnRefresh: false,
                data: (user) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ref.read(userDataProvider.notifier).update((_) => user);
                  });
                  return user != null ? const HomePage() : const IntroPage();
                },
                error: (_, __) => ErrorPage(
                  message: "Unable to load your information.",
                  onRetry: () => ref.refresh(getUserDataProvider.future),
                ),
                loading: () => const Scaffold(),
              ),
        );
      },
    );
  }
}
