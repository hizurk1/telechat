import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/widgets/cached_network_image.dart';
import 'package:telechat/core/extensions/build_context.dart';
import 'package:telechat/features/profile/widgets/profile_edit_bottom_sheet.dart';
import 'package:telechat/shared/models/user_model.dart';

class ProfileSliverHeader extends StatelessWidget {
  const ProfileSliverHeader({
    super.key,
    required this.user,
  });

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    final avatarHeight = context.screenHeight * 0.35;
    return SliverPersistentHeader(
      floating: true,
      pinned: true,
      delegate: _CustomSliverAppBarDelegate(
        expandedHeight: avatarHeight,
        user: user,
      ),
    );
  }
}

class _CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final UserModel? user;

  _CustomSliverAppBarDelegate({
    required this.expandedHeight,
    required this.user,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final buttonSize = 60.r;
    final topPosition = expandedHeight - shrinkOffset - buttonSize / 2;
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        Opacity(
          opacity: shrinkOffset < expandedHeight * 0.65 ? (1 - shrinkOffset / expandedHeight) : 0,
          child: Stack(
            children: [
              CachedNetworkImageCustom(
                imageUrl: user?.profileImage ?? '',
                height: expandedHeight,
                width: context.screenWidth,
              ),
              Container(
                height: expandedHeight,
                width: context.screenWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.65),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.all(20.r),
                  child: Text(
                    user?.name ?? '---',
                    style: AppTextStyle.titleL.white.medium,
                  ),
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ],
          ),
        ),
        Opacity(
          opacity: shrinkOffset > expandedHeight * 0.65 ? shrinkOffset / expandedHeight : 0,
          child: AppBar(
            automaticallyImplyLeading: true,
            iconTheme: const IconThemeData(color: AppColors.white),
            backgroundColor: AppColors.card,
            title: Text(
              user?.name ?? '---',
              style: AppTextStyle.bodyL.white.medium,
              textAlign: TextAlign.start,
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.edit, color: AppColors.white, size: 22.r),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: topPosition,
          right: 20.w,
          child: Opacity(
            opacity: shrinkOffset < expandedHeight * 0.65 ? 1 : 0,
            child: SizedBox.square(
              dimension: buttonSize,
              child: IconButton.filled(
                onPressed: () {
                  if (user != null) {
                    ProfileEditBottomSheet(
                      user: user!,
                    ).show(context);
                  }
                },
                icon: const Icon(
                  Icons.edit,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 30;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
