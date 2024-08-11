import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/configs/remote_config.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/utils/debouncer.dart';
import 'package:telechat/app/widgets/cached_network_image.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/app/widgets/no_border_text_field.dart';
import 'package:telechat/core/extensions/build_context.dart';
import 'package:telechat/features/group/controllers/new_group_controller.dart';

class NewGroupHeaderWidget extends StatefulWidget {
  const NewGroupHeaderWidget({super.key});

  @override
  State<NewGroupHeaderWidget> createState() => _NewGroupHeaderWidgetState();
}

class _NewGroupHeaderWidgetState extends State<NewGroupHeaderWidget> {
  final _groupNameController = TextEditingController();
  final _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    _groupNameController.text = "My group";
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: context.screenWidth,
        padding: EdgeInsets.symmetric(vertical: 12.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: AppColors.card,
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: const Icon(Icons.arrow_back_rounded, color: AppColors.iconGrey),
            ),
            Consumer(
              builder: (context, ref, child) {
                final image = ref.watch(newGroupControllerProvider).image;
                return GestureDetector(
                  onTap: () => ref.read(newGroupControllerProvider.notifier).onSelectImage(),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: SizedBox.square(
                          dimension: 40.r,
                          child: image == null
                              ? CachedNetworkImageCustom.avatar(
                                  imageUrl: RemoteConfig.defaultUserProfilePicUrl,
                                  size: 100,
                                )
                              : Image.file(image),
                        ),
                      ),
                      Positioned(
                        bottom: -3,
                        right: -3,
                        child: Icon(
                          Icons.edit,
                          color: AppColors.white,
                          size: 20.r,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Gap.large(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer(
                    builder: (context, ref, child) {
                      return NoBorderTextField(
                        controller: _groupNameController,
                        hintText: "Group name",
                        autofocus: true,
                        onChanged: (text) {
                          _debouncer.run(() {
                            ref.read(newGroupControllerProvider.notifier).onChangedGroupName(text);
                          });
                        },
                        onTap: () {
                          _groupNameController.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: _groupNameController.text.length,
                          );
                        },
                      );
                    },
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      final numberOfContacts =
                          ref.watch(newGroupControllerProvider).selectedContacts.length;
                      return Text(
                        "$numberOfContacts members",
                        style: AppTextStyle.labelL.sub,
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
