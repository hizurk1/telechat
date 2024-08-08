import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/themes.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/app/widgets/no_border_text_field.dart';

class ChatBoardSendImageDialog extends StatefulWidget {
  final File image;
  final void Function(String) onSend;
  const ChatBoardSendImageDialog({
    super.key,
    required this.image,
    required this.onSend,
  });

  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => this,
    );
  }

  @override
  State<ChatBoardSendImageDialog> createState() => _ChatBoardSendImageDialogState();
}

class _ChatBoardSendImageDialogState extends State<ChatBoardSendImageDialog> {
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
                    "Send an image",
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
                  child: Image.file(
                    widget.image,
                    fit: BoxFit.cover,
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
