import 'package:flutter/material.dart';

class MinimumDate extends InheritedWidget {

  const MinimumDate({
    super.key,
    required this.minimumDate,
    required super.child,
  });
  final DateTime minimumDate;

  static MinimumDate of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MinimumDate>()!;
  }

  @override
  bool updateShouldNotify(MinimumDate oldWidget) {
    return minimumDate != oldWidget.minimumDate;
  }
}
