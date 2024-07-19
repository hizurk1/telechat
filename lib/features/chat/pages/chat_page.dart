import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:telechat/app/constants/gen/assets.gen.dart';
import 'package:telechat/core/extensions/build_context.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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
          onPressed: () {},
          shape: const CircleBorder(),
          child: SvgPicture.asset(
            Assets.svgs.addChat,
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
