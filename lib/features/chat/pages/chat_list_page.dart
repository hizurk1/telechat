import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/constants/gen/assets.gen.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/core/extensions/build_context.dart';
import 'package:telechat/features/contact/pages/select_contact_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
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
      body: ListView.builder(
        controller: _scrollController,
        itemCount: 100,
        itemBuilder: (context, index) {
          return Text("$index");
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
