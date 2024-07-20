import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/constants/gen/assets.gen.dart';
import 'package:telechat/app/themes/themes.dart';
import 'package:telechat/app/widgets/gap.dart';

class InitContactSearchWidget extends StatelessWidget {
  const InitContactSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.jsons.notFound.lottie(
              height: 200.r,
              width: 200.r,
            ),
            Text(
              "Enter contact's name \nor phone to search",
              style: AppTextStyle.bodyM.sub,
              textAlign: TextAlign.center,
            ),
            const Gap.extra(),
          ],
        ),
      ),
    );
  }
}
