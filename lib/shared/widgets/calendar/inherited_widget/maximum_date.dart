import 'package:flutter/material.dart';

class MaximumDate extends InheritedWidget {

  const MaximumDate({
    super.key,
    required this.maximumDate,
    required super.child,
  });
  final DateTime maximumDate;

  static MaximumDate of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MaximumDate>()!;
  }

  @override
  bool updateShouldNotify(MaximumDate oldWidget) {
    return maximumDate != oldWidget.maximumDate;
  }
}
