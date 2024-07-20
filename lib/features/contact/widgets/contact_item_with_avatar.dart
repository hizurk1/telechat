import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/widgets/cached_network_image.dart';

class ContactItemWidget extends StatelessWidget {
  const ContactItemWidget({
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
      tileColor: AppColors.card,
      minTileHeight: 58.h,
      leading: imageUrl != null
          ? CachedNetworkImageCustom.avatar(
              imageUrl: imageUrl!,
              size: 42,
              loadingIndicatorSize: 0,
            )
          : null,
      title: Text(
        name,
        style: AppTextStyle.bodyM.white.medium,
      ),
      subtitle: subText.isNotEmpty
          ? Text(
              subText,
              style: AppTextStyle.labelM.dark.medium,
            )
          : null,
    );
  }
}
