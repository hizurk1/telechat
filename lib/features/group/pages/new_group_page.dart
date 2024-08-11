import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/utils/navigator.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/app/widgets/unfocus.dart';
import 'package:telechat/features/group/controllers/group_controller.dart';
import 'package:telechat/features/group/controllers/new_group_controller.dart';
import 'package:telechat/features/group/widgets/new_group/new_group_contact_list_view.dart';
import 'package:telechat/features/group/widgets/new_group/new_group_header.dart';

class NewGroupPage extends StatelessWidget {
  static const String route = "/new-group";
  const NewGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UnfocusArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: AppColors.white),
          title: Text("Create a new group", style: AppTextStyle.bodyL.white),
          actions: [
            Consumer(
              builder: (context, ref, child) {
                return Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: IconButton(
                    onPressed: () {
                      AppNavigator.showLoading(
                        task: ref.read(groupControllerProvider).createNewGroup(
                              groupName: ref.read(newGroupControllerProvider).groupName,
                              groupAvatar: ref.read(newGroupControllerProvider).image,
                              groupMembers: ref.read(newGroupControllerProvider).selectedContacts,
                            ),
                        onFinish: () => Navigator.pop(context),
                      );
                    },
                    icon: const Icon(Icons.check, color: Colors.white),
                    tooltip: "Done",
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap.extra(),
              NewGroupHeaderWidget(),
              Gap.large(),
              Expanded(
                child: NewGroupContactListViewWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
