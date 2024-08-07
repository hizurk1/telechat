import 'package:flutter/material.dart';
import 'package:telechat/app/widgets/faded_list.dart';
import 'package:telechat/app/widgets/skeleton.dart';

class ChatListLoadingContactItemWidget extends StatelessWidget {
  const ChatListLoadingContactItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadedListWidget(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          5,
          (_) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Skeleton.circle(size: 52),
                SizedBox(width: 14),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Skeleton(height: 12, width: 110),
                    SizedBox(height: 8),
                    Skeleton(height: 10, width: 80),
                  ],
                ),
                Spacer(),
                Skeleton(height: 12, width: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
