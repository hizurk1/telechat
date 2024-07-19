import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/constants/app_const.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/widgets/error_page.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/app/widgets/loading_indicator.dart';
import 'package:telechat/app/widgets/no_border_text_field.dart';
import 'package:telechat/app/widgets/unfocus.dart';
import 'package:telechat/features/authentication/controllers/auth_controller.dart';
import 'package:telechat/features/contact/widgets/contact_item_with_avatar.dart';
import 'package:telechat/features/contact/widgets/empty_contact.dart';

class SelectContactPage extends ConsumerStatefulWidget {
  static const String route = "/select-contact";
  const SelectContactPage({super.key});

  @override
  ConsumerState<SelectContactPage> createState() => _SelectContactPageState();
}

class _SelectContactPageState extends ConsumerState<SelectContactPage> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UnfocusArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.white),
          title: NoBorderTextField(
            controller: searchController,
            hintText: "Search for your contacts",
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
        body: ref.watch(userDataProvider).when(
              data: (user) {
                if (user == null) {
                  return ErrorPage(onRetry: () => ref.refresh(userDataProvider.future));
                } else {
                  if (user.contactIds.isNotEmpty) {
                    return const EmptyContactWidget();
                  } else {
                    return ListView.separated(
                      itemCount: 10,
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      separatorBuilder: (context, index) => const Gap(1),
                      itemBuilder: (context, index) {
                        return ContactItemWithAvatarWidget(
                          onTap: () {},
                          imageUrl: index % 3 == 0 ? AppConst.defaultUserProfilePicUrl : null,
                          name: "Nick",
                          subText: index % 4 == 0 ? "KK" : "",
                        );
                      },
                    );
                  }
                }
              },
              error: (_, __) => ErrorPage(onRetry: () => ref.refresh(userDataProvider.future)),
              loading: () => const LoadingIndicatorPage(),
            ),
      ),
    );
  }
}
