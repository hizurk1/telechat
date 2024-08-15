import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/widgets/cached_network_image.dart';
import 'package:telechat/shared/controllers/user_controller.dart';
import 'package:telechat/shared/models/user_model.dart';

class HomeMenuDrawerHeaderWidget extends StatelessWidget {
  const HomeMenuDrawerHeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer(
          builder: (context, ref, child) {
            return StreamBuilder<UserModel?>(
              stream: ref.watch(userControllerProvider).getUserDataAsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                }
                final user = snapshot.data;
                return Theme(
                  data: Theme.of(context).copyWith(
                    dividerTheme: const DividerThemeData(color: Colors.transparent),
                  ),
                  child: UserAccountsDrawerHeader(
                    currentAccountPicture: CachedNetworkImageCustom.avatar(
                      imageUrl: user?.profileImage ?? '',
                      size: 54,
                    ),
                    accountName: Text(
                      user?.name ?? '---',
                      style: AppTextStyle.bodyM.white.medium,
                    ),
                    accountEmail: Text(
                      user?.phoneNumber ?? '',
                      style: AppTextStyle.caption.sub,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.card,
                    ),
                  ),
                );
              },
            );
          },
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.light_mode,
                color: AppColors.white,
                size: 24.r,
              ),
            ),
          ),
        )
      ],
    );
  }
}
