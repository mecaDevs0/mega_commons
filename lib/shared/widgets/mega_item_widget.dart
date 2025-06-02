import 'package:flutter/material.dart';

class MegaItemWidget<T> extends StatelessWidget {
  const MegaItemWidget({
    super.key,
    this.child = const SizedBox.shrink(),
    required this.value,
    this.enabled = true,
    this.itemLabel,
    this.color,
    this.textColor,
  });

  final Widget? child;
  final T value;
  final bool enabled;
  final String? itemLabel;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return itemLabel != null
        ? Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            margin: const EdgeInsets.symmetric(vertical: 4),
            width: double.maxFinite,
            color: color ?? Colors.transparent,
            child: Text(
              itemLabel!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: textColor,
              ),
            ),
          )
        : child!;
  }
}
