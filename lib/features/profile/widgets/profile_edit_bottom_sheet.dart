import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/themes.dart';
import 'package:telechat/app/utils/navigator.dart';
import 'package:telechat/app/utils/util_function.dart';
import 'package:telechat/app/widgets/cached_network_image.dart';
import 'package:telechat/app/widgets/widgets.dart';
import 'package:telechat/core/extensions/build_context.dart';
import 'package:telechat/core/extensions/date_time.dart';
import 'package:telechat/features/profile/controllers/profile_controller.dart';
import 'package:telechat/shared/models/user_model.dart';

class ProfileEditBottomSheet extends StatefulWidget {
  final UserModel user;
  const ProfileEditBottomSheet({
    super.key,
    required this.user,
  });

  void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: this,
      ),
    );
  }

  @override
  State<ProfileEditBottomSheet> createState() => _ProfileEditBottomSheetState();
}

class _ProfileEditBottomSheetState extends State<ProfileEditBottomSheet> {
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  File? image;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
    _dobController.text = widget.user.dateOfBirth?.ddMMyyyy ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UnfocusArea(
      child: Container(
        width: context.screenWidth,
        padding: EdgeInsets.all(5.r),
        decoration: BoxDecoration(
          color: AppColors.cardMessage,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
                Text(
                  "Edit profile",
                  style: AppTextStyle.bodyL.medium.white,
                  textAlign: TextAlign.center,
                ),
                Consumer(
                  builder: (context, ref, child) {
                    return IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        AppNavigator.showLoading(
                          task: ref.read(profileControllerProvider).updateUserProfile(
                                name: _nameController.text.trim(),
                                dateOfBirth: _dobController.text,
                                profileImg: image,
                              ),
                        );
                      },
                      icon: const Icon(Icons.check),
                    );
                  },
                )
              ],
            ),
            const Gap.medium(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        image == null
                            ? CachedNetworkImageCustom.avatar(
                                imageUrl: widget.user.profileImage,
                                size: 64,
                              )
                            : SizedBox.square(
                                dimension: 64.r,
                                child: ClipOval(
                                  child: Image.file(
                                    image!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                        Positioned(
                          bottom: -16.r,
                          right: -16.r,
                          child: IconButton(
                            onPressed: () async {
                              final pickedImage = await UtilsFunction.pickImageFromGallery();
                              if (pickedImage != null) {
                                setState(() => image = pickedImage);
                              }
                            },
                            icon: const Icon(Icons.camera_alt),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Gap.extra(),
                  TextField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      label: Text(
                        "Name",
                        style: AppTextStyle.bodyS.sub.medium,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                  const Gap.large(),
                  TextField(
                    controller: _dobController,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: widget.user.dateOfBirth ?? DateTime.now(),
                        currentDate: DateTime.now(),
                        firstDate: DateTime(1930),
                        lastDate: DateTime(2030),
                      );
                      if (date != null) {
                        _dobController.text = date.ddMMyyyy;
                      }
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      label: Text(
                        "Date of birth",
                        style: AppTextStyle.bodyS.sub.medium,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                  const Gap.large(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
