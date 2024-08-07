import 'package:flutter/material.dart';

import '../../app/themes/app_color.dart';

extension BuildContextExtension on BuildContext {
  /// Get screen size of current context
  Size get screenSize => MediaQuery.of(this).size;

  /// Get screen width of current context
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get screen height of current context
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Get padding top of current context
  double get paddingTop => MediaQuery.of(this).padding.top;

  /// Get padding bottom of current context
  double get paddingBottom => MediaQuery.of(this).padding.bottom;

  /// Get screen ratio of current context, for different devices
  int get gridRatio => MediaQuery.of(this).size.width > 900
      ? 3
      : MediaQuery.of(this).size.width > 600
          ? 2
          : 1;

  /// Get text theme of current context
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Get theme of current context
  ThemeData get theme => Theme.of(this);

  /// Get brightness of current context
  Brightness get brightness => Theme.of(this).brightness;

  ColorFilter get colorFilterBg => const ColorFilter.mode(AppColors.background, BlendMode.srcIn);
  
  ColorFilter colorFilter(Color color) => ColorFilter.mode(color, BlendMode.srcIn);

  /// To show date picker.
  ///
  /// * initDate: When the date picker is first displayed, if [initialDate] is not null, it will show the month of [initialDate], with [initialDate] selected. Otherwise it will show the [currentDate]'s month.
  /// * lastDate: the last date that the user could select from the date picker.
  Future<DateTime?> showDatePickerPopup({
    DateTime? initDate,
    DateTime? lastDate,
    Locale? locale,
  }) async {
    final now = DateTime.now();
    return await showDatePicker(
      context: this,
      initialDate: initDate ?? now,
      firstDate: DateTime(now.year - 100),
      lastDate: lastDate ?? now,
      currentDate: now,
    );
  }

  /// To show modal bottom sheet with template.
  ///
  /// **Highly recommended** the widget is passed on `child` should use with [BottomSheetCustom].
  /// * `isScrollControlled`: the user is allowed to scroll or not.
  /// * `useSafeArea`: turn on the safe area for bottom sheet.
  Future<T?> showBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = true,
    bool useSafeArea = true,
  }) {
    return showModalBottomSheet<T?>(
      context: this,
      elevation: 0,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
      backgroundColor: Colors.transparent,
      builder: (context) => child,
    );
  }
}
