import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/themes/app_text_theme.dart';
import 'package:telechat/app/widgets/cached_network_image.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/features/call/controllers/call_controller.dart';
import 'package:telechat/features/call/models/call_model.dart';
import 'package:telechat/features/call/pages/call_page.dart';

class CallPickupPage extends ConsumerWidget {
  final CallModel call;
  const CallPickupPage({
    super.key,
    required this.call,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Incoming call",
                style: AppTextStyle.headingS.medium.white,
                textAlign: TextAlign.center,
              ),
            ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CachedNetworkImageCustom.avatar(
                    imageUrl: call.callerAvatar,
                    size: 150,
                  ),
                  const Gap.extra(),
                  Center(
                    child: Text(
                      call.callerName,
                      style: AppTextStyle.titleL.medium.white,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton.filled(
                  onPressed: () => ref.read(callControllerProvider).endCall(
                        callerId: call.callerId,
                        chatId: call.callerId,
                        memberIds: call.receiverIds,
                        timeCalledInSec: 0,
                        isGroupCall: call.isGroup,
                      ),
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.redAccent),
                  ),
                  padding: EdgeInsets.all(12.r),
                  icon: Icon(
                    Icons.call_end,
                    color: AppColors.white,
                    size: 40.r,
                  ),
                ),
                IconButton.filled(
                  onPressed: () => Navigator.pushNamed(context, CallPage.route, arguments: {
                    "channelId": call.callId,
                    "callModel": call,
                    "isGroup": call.isGroup,
                  }),
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.green),
                  ),
                  padding: EdgeInsets.all(12.r),
                  icon: Icon(
                    Icons.call,
                    color: AppColors.white,
                    size: 40.r,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
