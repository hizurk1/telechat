import 'package:flutter/material.dart';

class UtilsFunction {
  static void unfocusTextField([void Function()? task]) {
    FocusManager.instance.primaryFocus?.unfocus();
    task?.call();
  }
}
