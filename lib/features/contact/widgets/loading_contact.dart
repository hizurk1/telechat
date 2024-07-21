import 'package:flutter/material.dart';
import 'package:telechat/app/widgets/faded_list.dart';
import 'package:telechat/app/widgets/skeleton.dart';

class LoadingContactWidget extends StatelessWidget {
  const LoadingContactWidget({
    super.key,
    this.showAvatar = true,
  });

  final bool showAvatar;

  @override
  Widget build(BuildContext context) {
    return FadedListWidget(
      child: Column(
        children: List.generate(
          7,
          (_) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                if (showAvatar) ...[
                  const Skeleton(size: 42, borderRadius: 42),
                  const SizedBox(width: 14),
                ] else ...[
                  const SizedBox(height: 42),
                ],
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Skeleton(height: 15, width: 120),
                    SizedBox(height: 6),
                    Skeleton(height: 10, width: 80),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
