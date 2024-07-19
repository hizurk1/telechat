import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/constants/app_const.dart';
import 'package:telechat/app/constants/gen/assets.gen.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/utils/util_function.dart';
import 'package:telechat/app/widgets/border_text_field.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/app/widgets/loading_indicator.dart';
import 'package:telechat/app/widgets/primary_button.dart';
import 'package:telechat/features/authentication/controllers/auth_controller.dart';
import 'package:telechat/features/authentication/widgets/auth_body_frame_widget.dart';

class FillUserInfoPage extends ConsumerStatefulWidget {
  static const String route = "/fill-user-info";
  const FillUserInfoPage({super.key});

  @override
  ConsumerState<FillUserInfoPage> createState() => _FillUserInfoPageState();
}

class _FillUserInfoPageState extends ConsumerState<FillUserInfoPage> {
  final nameController = TextEditingController();
  final confirmNotifier = ValueNotifier<bool>(false);
  File? image;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> onSelectImage() async {
    final pickedImg = await UtilsFunction.pickImageFromGallery();
    setState(() {
      image = pickedImg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthBodyFrameWidget(
      title: "One last step",
      body: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: SizedBox.square(
                  dimension: 100.r,
                  child: image == null
                      ? Image.network(AppConst.defaultUserProfilePicUrl)
                      : Image.file(image!),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => onSelectImage(),
                  child: Assets.svgs.addImage.svg(
                    height: 25.r,
                    width: 25.r,
                  ),
                ),
              ),
            ],
          ),
          const Gap.extra(),
          BorderTextField(
            controller: nameController,
            hintText: "Enter your name",
            inputType: TextInputType.name,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 1,
            maxLength: 20,
          ),
        ],
      ),
      bottom: PrimaryButton(
        onPressed: () async {
          if (!confirmNotifier.value) {
            confirmNotifier.value = true;
            await ref.read(authControllerProvider).saveUserDataToDB(
                  name: nameController.text.trim(),
                  profileImg: image,
                );
            confirmNotifier.value = false;
          }
        },
        child: ValueListenableBuilder(
          valueListenable: confirmNotifier,
          builder: (context, confiming, _) {
            return confiming
                ? const LoadingIndicatorWidget(color: AppColors.background)
                : Text(
                    "Confirm",
                    style: AppTextStyle.bodyS.bg,
                  );
          },
        ),
      ),
    );
  }
}
