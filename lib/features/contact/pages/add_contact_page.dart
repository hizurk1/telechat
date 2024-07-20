import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/widgets/error_page.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/app/widgets/no_border_text_field.dart';
import 'package:telechat/app/widgets/unfocus.dart';
import 'package:telechat/core/extensions/string.dart';
import 'package:telechat/features/contact/controllers/search_contact_controller.dart';
import 'package:telechat/features/contact/controllers/search_contact_state.dart';
import 'package:telechat/features/contact/widgets/contact_item_with_avatar.dart';
import 'package:telechat/features/contact/widgets/empty_contact.dart';
import 'package:telechat/features/contact/widgets/init_contact_search.dart';
import 'package:telechat/features/contact/widgets/loading_contact.dart';

class AddContactPage extends ConsumerStatefulWidget {
  static const String route = "/add-contact";
  const AddContactPage({super.key});

  @override
  ConsumerState<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends ConsumerState<AddContactPage> {
  final searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void onSearchContacts(String text) {
    if (ref.read(searchContactControllerProvider).isLoading) return;

    if (text.trim().isEmpty) {
      ref.read(searchContactControllerProvider.notifier).clearSearchField();
    } else {
      ref.read(searchContactControllerProvider.notifier).globalContactSearchByKeyword(
            keyword: text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchContactControllerProvider);
    return UnfocusArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.white),
          title: NoBorderTextField(
            controller: searchController,
            onSubmitted: onSearchContacts,
            autofocus: true,
            hintText: "Global search",
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: IconButton(
                onPressed: () => onSearchContacts(searchController.text),
                icon: const Icon(Icons.search_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
        body: switch (state.status) {
          SearchContactStatus.initial => const InitContactSearchWidget(),
          SearchContactStatus.loading => const LoadingContactWidget(showAvatar: false),
          SearchContactStatus.error => const ErrorPage(),
          SearchContactStatus.success => state.contactList.isEmpty
              ? const EmptyContactWidget()
              : ListView.separated(
                  itemCount: state.contactList.length,
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  separatorBuilder: (context, index) => const Gap(1),
                  itemBuilder: (context, index) {
                    final contact = state.contactList[index];
                    return ContactItemWidget(
                      onTap: () {
                        ref.read(searchContactControllerProvider.notifier).addContactForUser(
                              contactUid: contact.uid,
                              contactName: contact.name,
                            );
                      },
                      name: contact.name,
                      subText: searchController.text.trim().isNumeric ? contact.phoneNumber : '',
                    );
                  },
                ),
        },
      ),
    );
  }
}
