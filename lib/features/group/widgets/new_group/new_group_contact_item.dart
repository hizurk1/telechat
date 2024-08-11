import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/widgets/cached_network_image.dart';

class NewGroupContactItemWidget extends StatelessWidget {
  const NewGroupContactItemWidget({
    super.key,
    required this.onTap,
    required this.name,
    required this.subText,
    this.imageUrl,
    this.isSelected = false,
  });

  final VoidCallback onTap;
  final String? imageUrl;
  final String name;
  final String subText;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      splashColor: AppColors.buttonGrey,
      hoverColor: AppColors.buttonGrey,
      tileColor: AppColors.card,
      minTileHeight: 58.h,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
        side: isSelected
            ? const BorderSide(
                color: AppColors.primary,
                width: 0.5,
              )
            : BorderSide.none,
      ),
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
      trailing: isSelected
          ? const Icon(
              Icons.check_circle_outline,
              color: AppColors.primary,
            )
          : null,
    );
  }
}
