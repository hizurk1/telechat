import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/features/authentication/controllers/auth_controller.dart';
import 'package:telechat/features/contact/pages/add_contact_page.dart';
import 'package:telechat/features/group/pages/new_group_page.dart';
import 'package:telechat/features/profile/pages/profile_page.dart';

import 'home_menu_drawer_header.dart';

class HomeMenuDrawerWidget extends StatelessWidget {
  const HomeMenuDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.cardMessage,
      shape: const RoundedRectangleBorder(),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const HomeMenuDrawerHeaderWidget(),
          _MenuListTile(
            onTap: () => Navigator.pushNamed(context, ProfilePage.route),
            title: "My profile",
            iconData: Icons.person_outline,
          ),
          _MenuListTile(
            onTap: () => Navigator.pushNamed(context, AddContactPage.route),
            title: "New contact",
            iconData: Icons.add_ic_call_outlined,
          ),
          _MenuListTile(
            onTap: () => Navigator.pushNamed(context, NewGroupPage.route),
            title: "New group",
            iconData: Icons.group_add_outlined,
          ),
          _MenuListTile(
            onTap: () {},
            title: "Settings",
            iconData: Icons.settings_outlined,
          ),
          Consumer(
            builder: (context, ref, child) {
              return _MenuListTile(
                onTap: () => ref.read(authControllerProvider).signOut(),
                title: "Sign out",
                iconData: Icons.logout_rounded,
              );
            },
          )
        ],
      ),
    );
  }
}

class _MenuListTile extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final IconData iconData;
  const _MenuListTile({
    required this.onTap,
    required this.title,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: AppColors.cardMessage,
      leading: Icon(iconData, color: AppColors.iconGrey, size: 24.r),
      minLeadingWidth: 36.w,
      title: Text(
        title,
        style: AppTextStyle.bodyS.white,
        textAlign: TextAlign.start,
      ),
    );
  }
}
