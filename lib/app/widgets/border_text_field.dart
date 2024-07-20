import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:telechat/app/themes/themes.dart';

class BorderTextField extends StatelessWidget {
  BorderTextField({
    super.key,
    this.controller,
    this.icon,
    this.hintColor,
    this.hintText = '',
    this.enable = true,
    this.borderColor,
    this.maxLength,
    this.maxLines = 1,
    this.inputType = TextInputType.text,
    this.isPasswordField = false,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.onChanged,
    this.prefix,
    this.onTap,
    this.textStyle,
  });

  final TextEditingController? controller;
  final Color? borderColor;
  final String? icon;
  final String hintText;
  final Color? hintColor;
  final TextInputType inputType;
  final bool isPasswordField;
  final TextCapitalization textCapitalization;
  final int? maxLength;
  final int maxLines;
  final bool autofocus;
  final Widget? prefix;
  final TextStyle? textStyle;
  final void Function(String)? onChanged;

  /// If this value is set to `false`, the user can't type in this text field
  /// and an [InkWell] widget with [onTap] function will be available.
  final bool enable;
  final VoidCallback? onTap;

  final ValueNotifier<bool> eyeState = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: maxLines > 1 ? 10.w : 0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? Colors.grey,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: ValueListenableBuilder(
          valueListenable: eyeState,
          builder: (context, value, _) {
            return TextField(
              controller: controller,
              onChanged: onChanged,
              autofocus: autofocus,
              maxLines: maxLines,
              maxLength: maxLength ?? 50,
              enabled: enable,
              textCapitalization: textCapitalization,
              style: textStyle ?? AppTextStyle.bodyS,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                icon: icon != null
                    ? SvgPicture.asset(
                        icon!,
                        height: 25.r,
                        width: 25.r,
                        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                      )
                    : null,
                hintText: hintText,
                hintStyle: AppTextStyle.bodyS,
                counterText: '',
                prefixIcon: prefix,
                suffixIcon: isPasswordField
                    ? GestureDetector(
                        onTap: () => eyeState.value = !eyeState.value,
                        child: Opacity(
                          opacity: .5,
                          child: SvgPicture.asset(
                            'assets/svgs/eye_${value ? 'open' : 'close'}.svg',
                            fit: BoxFit.scaleDown,
                            height: 25.r,
                            width: 25.r,
                          ),
                        ),
                      )
                    : null,
              ),
              obscureText: isPasswordField ? !value : false,
              keyboardType: inputType,
              cursorWidth: 2,
              cursorColor: AppColors.primary,
              textAlignVertical: isPasswordField ? TextAlignVertical.center : TextAlignVertical.top,
            );
          }),
    );
    return enable
        ? child
        : InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10.r),
            child: child,
          );
  }
}
