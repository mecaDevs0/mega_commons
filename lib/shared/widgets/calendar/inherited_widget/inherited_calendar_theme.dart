import 'package:flutter/widgets.dart';

import '../calendar_theme.dart';

class InheritedCalendarTheme extends InheritedWidget {
  const InheritedCalendarTheme({
    super.key,
    required this.theme,
    required super.child,
  });

  final CalendarTheme theme;

  static InheritedCalendarTheme of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedCalendarTheme>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      theme.hashCode != oldWidget.hashCode;
}
