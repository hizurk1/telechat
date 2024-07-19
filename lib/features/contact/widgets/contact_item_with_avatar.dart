import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/themes/app_text_theme.dart';

class ContactItemWithAvatarWidget extends StatelessWidget {
  const ContactItemWithAvatarWidget({
    super.key,
    required this.onTap,
    required this.name,
    required this.subText,
    this.imageUrl,
  });

  final VoidCallback onTap;
  final String? imageUrl;
  final String name;
  final String subText;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      splashColor: AppColors.buttonGrey,
      hoverColor: AppColors.buttonGrey,
      tileColor: AppColors.appBarBg,
      minTileHeight: 58.h,
      leading: imageUrl != null
          ? Image.network(
              imageUrl!,
              height: 42.r,
              width: 42.r,
            )
          : null,
      title: Text(
        name,
        style: AppTextStyle.bodyM.white.medium,
      ),
      subtitle: subText.isNotEmpty
          ? Text(
              name,
              style: AppTextStyle.labelM.dark.medium,
            )
          : null,
    );
  }
}
