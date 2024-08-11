import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/widgets/error_page.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/app/widgets/loading_indicator.dart';
import 'package:telechat/features/group/controllers/new_group_controller.dart';
import 'package:telechat/features/group/controllers/new_group_state.dart';
import 'package:telechat/features/group/widgets/new_group/new_group_contact_item.dart';

class NewGroupContactListViewWidget extends ConsumerStatefulWidget {
  const NewGroupContactListViewWidget({super.key});

  @override
  ConsumerState<NewGroupContactListViewWidget> createState() =>
      _NewGroupContactListViewWidgetState();
}

class _NewGroupContactListViewWidgetState extends ConsumerState<NewGroupContactListViewWidget> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(newGroupControllerProvider.notifier).fetchContacts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(newGroupControllerProvider.notifier);
    final state = ref.watch(newGroupControllerProvider);
    return Column(
      children: [
        TextField(
          controller: _searchController,
          style: AppTextStyle.bodyM.white,
          onChanged: (text) => controller.onSearchContacts(text),
          decoration: InputDecoration(
            // icon: const Icon(Icons.search, color: AppColors.iconGrey),
            hintText: "Search your contacts",
            hintStyle: AppTextStyle.bodyM.sub,
            suffixIcon: GestureDetector(
              onTap: () {
                _searchController.clear();
                controller.onSearchContacts("");
              },
              child: const Icon(Icons.close_rounded),
            ),
          ),
        ),
        const Gap.large(),
        Expanded(
          child: switch (state.status) {
            NewGroupStatus.initial || NewGroupStatus.loading => const LoadingIndicatorPage(),
            NewGroupStatus.error => ErrorPage(
                onRetry: () => controller.fetchContacts(),
              ),
            NewGroupStatus.success => ListView.separated(
                itemCount: state.searchContacts.length,
                padding: const EdgeInsets.symmetric(vertical: 1),
                separatorBuilder: (context, index) => const Gap(1),
                itemBuilder: (context, index) {
                  final contact = state.searchContacts[index];
                  final isSelected = state.selectedContacts.contains(contact);
                  return NewGroupContactItemWidget(
                    onTap: () => controller.onSelectContact(contact),
                    name: contact.name,
                    subText: contact.phoneNumber,
                    imageUrl: contact.profileImage,
                    isSelected: isSelected,
                  );
                },
              ),
          },
        ),
      ],
    );
  }
}
