import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/constants/gen/assets.gen.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/widgets/error_page.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/app/widgets/no_border_text_field.dart';
import 'package:telechat/app/widgets/unfocus.dart';
import 'package:telechat/core/extensions/build_context.dart';
import 'package:telechat/features/contact/controllers/contact_controller.dart';
import 'package:telechat/features/contact/controllers/contact_state.dart';
import 'package:telechat/features/contact/pages/add_contact_page.dart';
import 'package:telechat/features/contact/widgets/contact_item_with_avatar.dart';
import 'package:telechat/features/contact/widgets/empty_contact.dart';
import 'package:telechat/features/contact/widgets/loading_contact.dart';

class SelectContactPage extends ConsumerStatefulWidget {
  static const String route = "/select-contact";
  const SelectContactPage({super.key});

  @override
  ConsumerState<SelectContactPage> createState() => _SelectContactPageState();
}

class _SelectContactPageState extends ConsumerState<SelectContactPage> {
  final searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  final visibleFab = ValueNotifier(true);
  final visibleSearchBar = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(() {
        if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
          if (visibleFab.value) visibleFab.value = false;
        } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
          if (!visibleFab.value) visibleFab.value = true;
        }
      });

      ref.read(contactControllerProvider.notifier).fetchContacts();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(contactControllerProvider);
    return UnfocusArea(
      onUnfocus: () => visibleSearchBar.value = false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.white),
          title: ValueListenableBuilder(
            valueListenable: visibleSearchBar,
            child: NoBorderTextField(
              controller: searchController,
              focusNode: _focusNode,
              onChanged: (text) => ref
                  .read(contactControllerProvider.notifier)
                  .searchForYourContactsByNameOrPhone(keyword: text.trim()),
              onSubmitted: (text) => ref
                  .read(contactControllerProvider.notifier)
                  .searchForYourContactsByNameOrPhone(keyword: text.trim()),
              hintText: "Search by name or phone",
            ),
            builder: (context, bool isShowSearch, child) {
              return isShowSearch
                  ? child!
                  : Text("Select contact", style: AppTextStyle.bodyL.white);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: ValueListenableBuilder(
                valueListenable: visibleSearchBar,
                child: IconButton(
                  onPressed: () {
                    searchController.clear();
                    ref
                        .read(contactControllerProvider.notifier)
                        .searchForYourContactsByNameOrPhone(keyword: "");
                  },
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  tooltip: "Clear",
                ),
                builder: (context, bool isShowSearch, child) {
                  return isShowSearch
                      ? child!
                      : IconButton(
                          onPressed: () {
                            visibleSearchBar.value = true;
                            _focusNode.requestFocus();
                          },
                          icon: const Icon(Icons.search_rounded, color: Colors.white),
                          tooltip: "Search",
                        );
                },
              ),
            ),
          ],
        ),
        body: switch (state.status) {
          ContactStatus.loading => const LoadingContactWidget(),
          ContactStatus.success => state.searchList.isEmpty
              ? const EmptyContactWidget()
              : ListView.separated(
                  itemCount: state.searchList.length,
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  separatorBuilder: (context, index) => const Gap(1),
                  itemBuilder: (context, index) {
                    final contact = state.searchList[index];
                    return ContactItemWidget(
                      onTap: () {
                        debugPrint(contact.name);
                      },
                      name: contact.name,
                      subText: contact.phoneNumber,
                      imageUrl: contact.profileImage,
                    );
                  },
                ),
          ContactStatus.error => ErrorPage(
              onRetry: () => ref.read(contactControllerProvider.notifier).fetchContacts(),
            )
        },
        floatingActionButton: ValueListenableBuilder(
          valueListenable: visibleFab,
          child: FloatingActionButton(
            onPressed: () async {
              final onBackResult =
                  await Navigator.pushNamed(context, AddContactPage.route) as bool?;
              if (onBackResult != null && onBackResult) {
                ref.read(contactControllerProvider.notifier).fetchContacts();
              }
            },
            shape: const CircleBorder(),
            backgroundColor: AppColors.primary,
            child: Assets.svgs.addPerson.svg(
              height: 25.r,
              width: 25.r,
              colorFilter: context.colorFilterBg,
            ),
          ),
          builder: (context, isVisibleFab, child) {
            return AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInBack,
              offset: isVisibleFab ? const Offset(0, 0) : const Offset(0, 2),
              child: child,
            );
          },
        ),
      ),
    );
  }
}
