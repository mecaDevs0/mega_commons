import 'package:flutter/material.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../../../mega_commons.dart';
import 'inherited_widget/inherited_calendar_theme.dart';
import 'inherited_widget/maximum_date.dart';
import 'inherited_widget/minimum_date.dart';
import 'week_day_row.dart';

class MegaCalendar extends StatefulWidget {
  const MegaCalendar({
    super.key,
    this.selectedDate,
    this.onDateSelected,
    this.disabledWeekDays = const [],
    this.dotsWeekDays = const [],
    this.dotDates = const [],
    this.onChangeMonth,
  });
  final DateTime? selectedDate;
  final Function(DateTime)? onDateSelected;
  final List<int> disabledWeekDays;
  final List<int> dotsWeekDays;
  final List<DateTime> dotDates;
  final Function(DateTime date)? onChangeMonth;

  @override
  CustomCalendarState createState() => CustomCalendarState();
}

class CustomCalendarState extends State<MegaCalendar> {
  List<DateTime> dateList = <DateTime>[];
  DateTime currentMonthDate = DateTime.now();
  DateTime? startDate;
  List<DateTime> dotsDates = <DateTime>[];

  final now = DateTime.now();

  @override
  void initState() {
    dotsDates = widget.dotDates;

    if (widget.dotDates.isEmpty) {
      dotsDates = <DateTime>[].obs;
    }

    if (widget.selectedDate != null) {
      startDate = widget.selectedDate;
      currentMonthDate = DateTime(
        widget.selectedDate!.year,
        widget.selectedDate!.month,
        15,
      );
    }

    setListOfDate(currentMonthDate);

    super.initState();
  }

  DateTime _stripTime(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool isDisabledDay(DateTime date) {
    final minDate = MinimumDate.of(context).minimumDate;
    final maxDate = MaximumDate.of(context).maximumDate;
    final weekdayIsDisabled = widget.disabledWeekDays.contains(date.weekday);

    final isBeforeMin =
        minDate != null && _stripTime(date).isBefore(_stripTime(minDate));
    final isAfterMax =
        maxDate != null && _stripTime(date).isAfter(_stripTime(maxDate));

    return weekdayIsDisabled || isBeforeMin || isAfterMax;
  }

  void setListOfDate(DateTime monthDate) {
    dateList.clear();

    final lastDayPrevMonth = DateTime(monthDate.year, monthDate.month, 0);
    final int leadingDays = lastDayPrevMonth.weekday % 7;

    for (int i = leadingDays - 1; i >= 0; i--) {
      dateList.add(lastDayPrevMonth.subtract(Duration(days: i)));
    }

    final int remainingDays = 42 - dateList.length;
    for (int i = 1; i <= remainingDays; i++) {
      dateList.add(lastDayPrevMonth.add(Duration(days: i)));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minimumDate = MinimumDate.of(context).minimumDate;
    final maximumDate = MaximumDate.of(context).maximumDate;
    final theme = InheritedCalendarTheme.of(context).theme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4),
          child: Row(
            children: [
              SizedBox(
                height: 38,
                width: 38,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (minimumDate != null &&
                          currentMonthDate.month == minimumDate.month &&
                          currentMonthDate.year == minimumDate.year) {
                        return;
                      }
                      setState(() {
                        currentMonthDate = DateTime(
                          currentMonthDate.year,
                          currentMonthDate.month,
                          0,
                        );
                        setListOfDate(currentMonthDate);
                      });
                      widget.onChangeMonth?.call(currentMonthDate);
                    },
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: theme.secondaryColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    currentMonthDate.toMMMMyyyy(),
                    style: TextStyle(
                      color: theme.secondaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 38,
                  width: 38,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (maximumDate != null &&
                            currentMonthDate.month == maximumDate.month &&
                            currentMonthDate.year == maximumDate.year) {
                          return;
                        }
                        setState(() {
                          currentMonthDate = DateTime(
                            currentMonthDate.year,
                            currentMonthDate.month + 2,
                            0,
                          );
                          setListOfDate(currentMonthDate);
                        });
                        widget.onChangeMonth?.call(currentMonthDate);
                      },
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: theme.secondaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ).shade,
        WeekDayRow(dateList: dateList).shade,
        Padding(
          padding: const EdgeInsets.only(right: 8, left: 8),
          child: Column(
            children: getDaysNoUI(),
          ),
        ),
      ],
    );
  }

  List<Widget> getDaysNoUI() {
    final List<Widget> noList = <Widget>[];
    final minimumDate = MinimumDate.of(context).minimumDate;
    final maximumDate = MaximumDate.of(context).maximumDate;
    final selectedColor =
        InheritedCalendarTheme.of(context).theme.selectedDayBackground;
    int count = 0;
    for (int i = 0; i < dateList.length / 7; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < 7; i++) {
        final DateTime date = dateList[count];
        listUI.add(
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: [
                  InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                    onTap: () {
                      if (widget.disabledWeekDays != null &&
                          widget.disabledWeekDays.contains(date.weekday)) {
                        return;
                      }
                      if (currentMonthDate.month <= date.month) {
                        if (minimumDate != null && maximumDate != null) {
                          final DateTime newMinimumDate = DateTime(
                            minimumDate.year,
                            minimumDate.month,
                            minimumDate.day - 1,
                          );
                          final DateTime newMaximumDate = DateTime(
                            maximumDate.year,
                            maximumDate.month,
                            maximumDate.day + 1,
                          );
                          if (date.isAfter(newMinimumDate) &&
                              date.isBefore(newMaximumDate)) {
                            onDateClick(date);
                          }
                        } else if (minimumDate != null) {
                          final DateTime newMinimumDate = DateTime(
                            minimumDate.year,
                            minimumDate.month,
                            minimumDate.day - 1,
                          );
                          if (date.isAfter(newMinimumDate)) {
                            onDateClick(date);
                          }
                        } else if (maximumDate != null) {
                          final DateTime newMaximumDate = DateTime(
                            maximumDate.year,
                            maximumDate.month,
                            maximumDate.day + 1,
                          );
                          if (date.isBefore(newMaximumDate)) {
                            onDateClick(date);
                          }
                        } else {
                          onDateClick(date);
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSameDay(date)
                              ? selectedColor ?? Theme.of(context).primaryColor
                              : Colors.transparent,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(32.0)),
                          boxShadow: isSameDay(date)
                              ? <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.6),
                                    blurRadius: 4,
                                    offset: Offset.zero,
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            '${date.day}',
                            style: TextStyle(
                              color: _getColor(date, minimumDate),
                              fontSize: MediaQuery.of(context).size.width > 360
                                  ? 18
                                  : 16,
                              fontWeight: _getFontWeight(date),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!isDisabledDay(date))
                    Obx(
                      () => Positioned(
                        bottom: 9,
                        right: 0,
                        left: 0,
                        child: Container(
                          height: 6,
                          width: 6,
                          decoration: BoxDecoration(
                            color: _getDotColor(date),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                ],
              ).leaf,
            ),
          ),
        );
        count += 1;
      }
      noList.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: listUI,
        ),
      );
    }
    return noList;
  }

  Color _getDotColor(DateTime date) {
    final dotColor = InheritedCalendarTheme.of(context).theme.dotColor;
    final calendarTheme = InheritedCalendarTheme.of(context).theme;
    final selectedColor = calendarTheme.selectedDayBackground;

    if (dotsDates.any((dotDate) => dotDate.isSameDay(date))) {
      return dotColor;
    }

    if (widget.dotsWeekDays.contains(date.weekday)) {
      return dotColor;
    }

    if (date.isSameDay(now)) {
      return selectedColor ?? Theme.of(context).primaryColor;
    }

    return Colors.transparent;
  }

  Color _getColor(DateTime date, DateTime? minimumDate) {
    final theme = InheritedCalendarTheme.of(context).theme;
    final disabledColor =
        theme.disabledDayTextColor ?? Colors.grey.withValues(alpha: 0.5);
    final selectedColor = theme.selectedDayTextColor;
    final normalColor = theme.dayColor;
    final fallbackDisabledColor =
        theme.disabledDayTextColor ?? Colors.grey.withValues(alpha: 0.6);

    final maxDate = MaximumDate.of(context).maximumDate;
    final isBeforeMin =
        minimumDate != null && date.isBefore(_stripTime(minimumDate));
    final isAfterMax = maxDate != null && date.isAfter(_stripTime(maxDate));

    if (widget.disabledWeekDays.contains(date.weekday)) {
      return disabledColor;
    }
    if (isBeforeMin || isAfterMax) {
      return disabledColor;
    }
    if (isSameDay(date)) {
      return selectedColor;
    }
    if (currentMonthDate.month == date.month) {
      return normalColor;
    }

    return fallbackDisabledColor;
  }

  FontWeight _getFontWeight(DateTime date) {
    if (isSameDay(date)) {
      return FontWeight.bold;
    }
    if (currentMonthDate.month == date.month) {
      return FontWeight.w700;
    }

    return FontWeight.normal;
  }

  bool isSameDay(DateTime date) {
    return startDate?.isSameDay(date) ?? false;
  }

  void onDateClick(DateTime date) {
    startDate = date;
    setState(() {
      widget.onDateSelected!(startDate!);
    });
  }
}
