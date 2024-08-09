import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/themes.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/app/widgets/no_border_text_field.dart';
import 'package:telechat/core/extensions/build_context.dart';
import 'package:telechat/shared/enums/message_enum.dart';

class ChatBoardSendMediaDialog extends StatefulWidget {
  final File media;
  final MessageEnum type;
  final void Function(String) onSend;
  const ChatBoardSendMediaDialog({
    super.key,
    required this.media,
    required this.type,
    required this.onSend,
  });

  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => this,
    );
  }

  @override
  State<ChatBoardSendMediaDialog> createState() => _ChatBoardSendMediaDialogState();
}

class _ChatBoardSendMediaDialogState extends State<ChatBoardSendMediaDialog> {
  String captionMessage = "";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      backgroundColor: AppColors.card,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.r).copyWith(bottom: 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Send ${widget.type == MessageEnum.image ? "an image" : "a video"}",
                    style: AppTextStyle.bodyM.medium.white,
                  ),
                  Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.white,
                    size: 24.r,
                  ),
                ],
              ),
              const Gap.medium(),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Center(
                  child: widget.type == MessageEnum.image
                      ? Image.file(
                          widget.media,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 140.h,
                          width: context.screenWidth,
                          decoration: BoxDecoration(
                            color: AppColors.buttonGrey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.play_circle_filled_rounded,
                              color: AppColors.iconGrey,
                              size: 40.r,
                            ),
                          ),
                        ),
                ),
              ),
              const Gap.medium(),
              NoBorderTextField(
                onChanged: (text) => setState(() => captionMessage = text),
                // borderColor: AppColors.buttonGrey.withOpacity(0.75),
                // hintColor: AppColors.textGrey,
                hintText: "Enter caption",
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: AppTextStyle.bodyS.primary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      widget.onSend(captionMessage.trim());
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Send",
                      style: AppTextStyle.bodyS.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
