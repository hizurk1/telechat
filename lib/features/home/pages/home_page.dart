import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/features/call/controllers/call_controller.dart';
import 'package:telechat/features/call/pages/call_pickup_page.dart';
import 'package:telechat/features/chat/pages/chat_list_page.dart';
import 'package:telechat/features/story/pages/story_page.dart';
import 'package:telechat/shared/controllers/user_controller.dart';

class HomePage extends ConsumerStatefulWidget {
  static const String route = "/home";
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint("AppLifecycleState=${state.name}");

    if (state == AppLifecycleState.paused) {
      ref.read(userControllerProvider).updateUserOnlineStatus(false);
    } else if (state == AppLifecycleState.resumed) {
      ref.read(userControllerProvider).updateUserOnlineStatus(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              leading: const Icon(Icons.menu, color: Colors.white),
              title: Text("Telechat", style: AppTextStyle.titleS.white.bold),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 3),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search_rounded, color: Colors.white),
                  ),
                )
              ],
              bottom: TabBar(
                labelStyle: AppTextStyle.bodyM.white.medium,
                unselectedLabelStyle: AppTextStyle.bodyM.sub.medium,
                indicatorColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 1,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: "Chats"),
                  Tab(text: "Stories"),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                ChatListPage(),
                StoryPage(),
              ],
            ),
          ),
        ),
        StreamBuilder(
          stream: ref.watch(callControllerProvider).getCallAsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final call = snapshot.data!;
              if (!call.hasDialled) {
                return CallPickupPage(call: call);
              }
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
