import 'package:flutter/material.dart';

import '../../../mega_commons.dart';
import 'inherited_widget/inherited_calendar_theme.dart';

class WeekDayRow extends StatelessWidget {
  const WeekDayRow({super.key, required this.dateList});

  final List<DateTime> dateList;

  @override
  Widget build(BuildContext context) {
    final theme = InheritedCalendarTheme.of(context).theme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Row(
        children: List.generate(7, (i) {
          return Expanded(
            child: Center(
              child: Text(
                dateList[i].toWeekDayAbbr,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: theme.secondaryColor,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
