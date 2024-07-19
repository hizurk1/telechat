import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/constants/gen/assets.gen.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/widgets/gap.dart';

class EmptyContactWidget extends StatelessWidget {
  const EmptyContactWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.jsons.empty.lottie(
            height: 200.r,
            width: 200.r,
          ),
          Text(
            "No contacts",
            style: AppTextStyle.bodyM.white,
          ),
          const Gap(30),
        ],
      ),
    );
  }
}
