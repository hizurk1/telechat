import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/core/extensions/date_time.dart';
import 'package:telechat/shared/models/user_model.dart';

class ProfileSliverInfo extends StatelessWidget {
  const ProfileSliverInfo({
    super.key,
    required this.user,
  });

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Text(
                "Info",
                style: AppTextStyle.bodyM.primary.medium,
              ),
            ),
            ListTile(
              title: Text(
                user?.phoneNumber ?? '---',
                style: AppTextStyle.bodyS.white,
              ),
              subtitle: Text(
                "Phone",
                style: AppTextStyle.caption.sub,
              ),
            ),
            ListTile(
              title: Text(
                user?.dateOfBirth?.ddMMyyyy ?? '---',
                style: AppTextStyle.bodyS.white,
              ),
              subtitle: Text(
                "Date of birth",
                style: AppTextStyle.caption.sub,
              ),
            ),
            ListTile(
              title: Text(
                user?.createdDate.ddMMyyyy ?? '---',
                style: AppTextStyle.bodyS.white,
              ),
              subtitle: Text(
                "Created date",
                style: AppTextStyle.caption.sub,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
