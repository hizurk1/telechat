import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/constants/gen/assets.gen.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/core/extensions/build_context.dart';
import 'package:telechat/core/extensions/list.dart';
import 'package:telechat/features/chat/controllers/chat_controller.dart';
import 'package:telechat/features/chat/models/chat_contact_model.dart';
import 'package:telechat/features/chat/widgets/chat_list/chat_list_contact_item.dart';
import 'package:telechat/features/chat/widgets/chat_list/chat_list_loading_contact_item.dart';
import 'package:telechat/features/chat/widgets/chat_list/chat_list_no_contact.dart';
import 'package:telechat/features/contact/pages/select_contact_page.dart';

class ChatListPage extends ConsumerStatefulWidget {
  const ChatListPage({super.key});

  @override
  ConsumerState<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends ConsumerState<ChatListPage> {
  final _scrollController = ScrollController();
  final visibleFab = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (visibleFab.value) visibleFab.value = false;
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (!visibleFab.value) visibleFab.value = true;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<ChatContactModel>>(
        stream: ref.watch(chatControllerProvider).getListOfChatContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ChatListLoadingContactItemWidget();
          }
          final List<ChatContactModel>? listOfContacts = snapshot.data;
          return listOfContacts.isNullOrEmpty
              ? const ChatListNoContactWidget()
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: listOfContacts!.length,
                  itemBuilder: (context, index) {
                    return ChatListContactItemWidget(
                      chatContact: listOfContacts[index],
                    );
                  },
                );
        },
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: visibleFab,
        child: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, SelectContactPage.route),
          shape: const CircleBorder(),
          backgroundColor: AppColors.primary,
          child: Assets.svgs.addChat.svg(
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
    );
  }
}
