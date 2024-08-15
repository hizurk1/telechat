import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/widgets/loading_indicator.dart';

class CachedNetworkImageCustom extends StatelessWidget {
  final String imageUrl;
  final double borderRadius;
  final double? height;
  final double? width;
  final double? size;
  final double? loadingIndicatorSize;

  const CachedNetworkImageCustom({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.size,
    this.loadingIndicatorSize,
    this.borderRadius = 8.0,
  });

  const CachedNetworkImageCustom.avatar({
    super.key,
    required this.imageUrl,
    required this.size,
    this.loadingIndicatorSize,
    this.height,
    this.width,
    this.borderRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        borderRadius > 0 ? borderRadius : (size ?? 1000),
      ),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: size?.r ?? height,
        width: size?.r ?? width,
        fit: BoxFit.cover,
        placeholder: (_, __) => Container(
          height: size?.r ?? height,
          width: size?.r ?? width,
          color: AppColors.buttonGrey,
          child: LoadingIndicatorWidget(
            size: loadingIndicatorSize ?? 20,
            lineWidth: 1,
            color: AppColors.card,
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: size?.r ?? height,
          width: size?.r ?? width,
          color: AppColors.buttonGrey,
          child: LoadingIndicatorWidget(
            size: loadingIndicatorSize ?? 20,
            lineWidth: 1,
            color: AppColors.card,
          ),
        ),
      ),
    );
  }
}
