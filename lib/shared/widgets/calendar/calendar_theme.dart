import 'package:flutter/material.dart';

@immutable
abstract class CalendarTheme {
  const CalendarTheme({
    this.backgroundColor = Colors.white,
    this.titleModalColor = Colors.black,
    this.dotColor = Colors.black,
    this.cancelLabelColor = Colors.black,
    this.secondaryColor = Colors.black,
    this.selectedDayTextColor = Colors.white,
    this.dayColor = Colors.black,
    this.buttonColor,
    this.disabledDayTextColor,
    this.selectedDayBackground,
  });

  final Color backgroundColor;
  final Color titleModalColor;
  final Color dotColor;
  final Color cancelLabelColor;
  final Color secondaryColor;
  final Color selectedDayTextColor;
  final Color dayColor;
  final Color? buttonColor;
  final Color? disabledDayTextColor;
  final Color? selectedDayBackground;
}

@immutable
class BaseTheme extends CalendarTheme {
  const BaseTheme();
}
