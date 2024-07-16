import 'package:flutter/material.dart';

import '../utils/util_function.dart';

class UnfocusArea extends StatelessWidget {
  const UnfocusArea({
    super.key,
    required this.child,
    this.color,
  });

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => UtilsFunction.unfocusTextField(),
      child: Container(
        color: color ?? Colors.transparent,
        child: child,
      ),
    );
  }
}
