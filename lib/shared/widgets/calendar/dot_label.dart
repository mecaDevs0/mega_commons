import 'package:flutter/material.dart';

import 'inherited_widget/inherited_calendar_theme.dart';

class DotLabel extends StatelessWidget {
  const DotLabel({
    super.key,
    this.dotsWeekDays = const [],
    this.dotsWeekLabel = '',
  });

  final List<int> dotsWeekDays;
  final String dotsWeekLabel;

  @override
  Widget build(BuildContext context) {
    if (dotsWeekDays.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = InheritedCalendarTheme.of(context).theme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: theme.dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Text(dotsWeekLabel),
            ],
          ),
        ],
      ),
    );
  }
}
