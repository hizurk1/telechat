import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/app_color.dart';
import 'package:telechat/app/themes/app_text_theme.dart';

import '../../../core/extensions/build_context.dart';
import '../../../core/extensions/string.dart';
import '../gap.dart';
import '../unfocus.dart';

class DynamicBottomSheetCustom extends StatelessWidget {
  const DynamicBottomSheetCustom({
    super.key,
    this.children = const [],
    this.child,
    this.showDragHandle = false,
    this.backgroundColor,
    this.padding,
    this.textTitle,
    this.textAction,
    this.onAction,
    this.showAction = true,
    this.dismissable = true,
  });

  /// Allow the user to dismiss the bottom sheet.
  final bool dismissable;

  /// Show action button.
  final bool showAction;

  /// Show drag handle. Best practice is only show if [textTitle] is `null`.
  final bool showDragHandle;

  /// Text in title of bottom sheet. If it sets to `null`, the bottom sheet
  /// title will be hidden.
  final String? textTitle;

  /// The body of bottom sheet. Excludes bottom sheet title.
  final List<Widget> children;

  /// The body of bottom sheet if children is empty. Excludes bottom sheet title.
  /// If you want to put `Column` inside this child, the mainAxisSize should be set to min.
  final Widget? child;

  /// Text for action button on the right.
  final String? textAction;

  /// Action button callback.
  final VoidCallback? onAction;

  /// Apply padding for bottom sheet title.
  final EdgeInsetsGeometry? padding;

  /// Color for background of bottom sheet, excludes title bar.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          if (dismissable) {
            Navigator.of(context).maybePop();
          }
        },
        child: Container(
          color: Colors.transparent,
        ),
      ),
      bottomSheet: Container(
        width: context.screenWidth,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.background,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.r),
          ),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin:
                  EdgeInsets.only(top: textTitle.isNotNullOrEmpty ? kToolbarHeight + 20.h : 30.h),
              padding: padding,
              child: SingleChildScrollView(
                child: UnfocusArea(
                  child: child ??
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: children,
                      ),
                ),
              ),
            ),
            Container(
              color: Colors.transparent,
              child: _buildTitle(context),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return textTitle.isNotNullOrEmpty
        ? _buildTitleBar(context)
        : showDragHandle
            ? Container(
                padding: EdgeInsets.only(top: 5.h),
                child: _buildDragHandle(context),
              )
            : const SizedBox();
  }

  Widget _buildDragHandle(BuildContext context) {
    return Container(
      height: 4.h,
      width: 34.w,
      margin: EdgeInsets.only(top: 10.h, bottom: 5.h),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildTitleBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade800,
            offset: const Offset(0, 0.5),
            blurRadius: 1,
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //* Handler
            _buildDragHandle(context),
            //* Title
            Row(
              children: [
                CloseButton(
                  style: ButtonStyle(iconSize: WidgetStateProperty.all(24.dm)),
                ),
                const Gap(5),
                Expanded(
                  child: Center(
                    child: Text(
                      textTitle ?? '',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.bodyL,
                    ),
                  ),
                ),
                showAction
                    ? TextButton(
                        onPressed: onAction,
                        child: Text(
                          textAction ?? "Save",
                          textAlign: TextAlign.center,
                          style: AppTextStyle.bodyM,
                        ),
                      )
                    : SizedBox(width: 50.w),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
