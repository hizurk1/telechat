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
import 'package:telechat/features/chat/widgets/chat_list/chat_list_group_item.dart';
import 'package:telechat/features/chat/widgets/chat_list/chat_list_loading_contact_item.dart';
import 'package:telechat/features/chat/widgets/chat_list/chat_list_no_contact.dart';
import 'package:telechat/features/contact/pages/select_contact_page.dart';
import 'package:telechat/features/group/controllers/group_controller.dart';
import 'package:telechat/features/group/models/group_model.dart';
import 'package:telechat/shared/controllers/user_controller.dart';

class ChatListPage extends ConsumerStatefulWidget {
  const ChatListPage({super.key});

  @override
  ConsumerState<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends ConsumerState<ChatListPage> with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  final visibleFab = ValueNotifier(true);
  final chatCounter = ValueNotifier<List<int>>([-1, -1]);

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
    visibleFab.dispose();
    chatCounter.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final uid = ref.read(userControllerProvider).currentUser!.uid;
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              StreamBuilder<List<ChatContactModel>>(
                stream: ref.watch(chatControllerProvider).getListOfChatContacts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverToBoxAdapter(
                      child: ChatListLoadingContactItemWidget(),
                    );
                  }
                  final List<ChatContactModel>? listOfContacts = snapshot.data;
                  if (listOfContacts == null) {
                    return const SliverToBoxAdapter(child: SizedBox());
                  }
                  final contacts = listOfContacts.where((e) {
                    return e.createdUserId == uid || e.lastSenderId.isNotEmpty;
                  }).toList();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    chatCounter.value = [contacts.length, chatCounter.value[1]];
                  });
                  if (contacts.isEmpty) {
                    return const SliverToBoxAdapter(child: SizedBox());
                  }
                  return SliverList.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      return ChatListContactItemWidget(
                        chatContact: contacts[index],
                      );
                    },
                  );
                },
              ),
              StreamBuilder<List<GroupModel>>(
                stream: ref.watch(groupControllerProvider).getListOfGroupChats(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverToBoxAdapter(
                      child: SizedBox(),
                    );
                  }
                  final List<GroupModel>? listOfGroups = snapshot.data;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    chatCounter.value = [chatCounter.value[0], (listOfGroups?.length ?? 0)];
                  });
                  return listOfGroups.isNullOrEmpty
                      ? const SliverToBoxAdapter(child: SizedBox())
                      : SliverList.builder(
                          itemCount: listOfGroups!.length,
                          itemBuilder: (context, index) {
                            return ChatListGroupItemWidget(
                              groupModel: listOfGroups[index],
                            );
                          },
                        );
                },
              ),
            ],
          ),
          ValueListenableBuilder<List<int>>(
            valueListenable: chatCounter,
            child: const ChatListNoContactWidget(),
            builder: (context, value, child) {
              if (value.every((e) => e == 0)) {
                return child!;
              }
              return const SizedBox();
            },
          ),
        ],
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
