import 'package:flutter/material.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/features/chat/pages/chat_list_page.dart';

class HomePage extends StatelessWidget {
  static const String route = "/home";
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
        body: TabBarView(
          children: [
            const ChatListPage(),
            Container(),
          ],
        ),
      ),
    );
  }
}
