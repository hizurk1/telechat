import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:telechat/app/constants/gen/assets.gen.dart';
import 'package:telechat/app/themes/themes.dart';
import 'package:telechat/app/widgets/widgets.dart';

class IntroPage extends StatelessWidget {
  static const String route = "/intro";

  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            children: [
              Text(
                "Welcome to Telechat",
                style: AppTextStyle.headingL,
                textAlign: TextAlign.center,
              ),
              const Gap.medium(),
              Expanded(
                child: SvgPicture.asset(
                  Assets.svgs.intro,
                  width: 300.r,
                  height: 300.r,
                ),
              ),
              const Gap.medium(),
              Text(
                "Read our Privacy Policy and tap \"Agree and continue\" to accept the Terms of Service.",
                style: AppTextStyle.bodyS.dark,
                textAlign: TextAlign.center,
              ),
              const Gap.medium(),
              PrimaryButton.text(
                onPressed: () {},
                text: "Agree and continue",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
