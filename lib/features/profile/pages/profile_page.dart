import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/app/widgets/loading_indicator.dart';
import 'package:telechat/features/profile/widgets/profile_sliver_header.dart';
import 'package:telechat/features/profile/widgets/profile_sliver_info.dart';
import 'package:telechat/shared/controllers/user_controller.dart';

class ProfilePage extends ConsumerWidget {
  static const String route = "/profile";
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: StreamBuilder(
        stream: ref.watch(userControllerProvider).getUserDataAsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicatorPage();
          }
          final user = snapshot.data;
          return CustomScrollView(
            slivers: [
              ProfileSliverHeader(user: user),
              ProfileSliverInfo(user: user),
            ],
          );
        },
      ),
    );
  }
}
