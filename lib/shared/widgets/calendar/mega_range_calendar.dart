import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'inherited_widget/inherited_calendar_theme.dart';

class MegaRangeCalendar extends StatefulWidget {
  const MegaRangeCalendar({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    this.startEndDateChange,
    this.minimumDate,
    this.maximumDate,
  });
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(DateTime, DateTime?)? startEndDateChange;

  @override
  CustomRangeCalendarState createState() => CustomRangeCalendarState();
}

class CustomRangeCalendarState extends State<MegaRangeCalendar> {
  List<DateTime> dateList = <DateTime>[];

  DateTime currentMonthDate = DateTime.now();

  DateTime? startDate;

  DateTime? endDate;

  @override
  void initState() {
    setListOfDate(currentMonthDate);
    if (widget.initialStartDate != null) {
      startDate = widget.initialStartDate;
    }
    if (widget.initialEndDate != null) {
      endDate = widget.initialEndDate;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setListOfDate(DateTime monthDate) {
    dateList.clear();
    final DateTime newDate = DateTime(monthDate.year, monthDate.month, 0);
    int previousMothDay = 0;
    if (newDate.weekday < 7) {
      previousMothDay = newDate.weekday;
      for (int i = 1; i <= previousMothDay; i++) {
        dateList.add(newDate.subtract(Duration(days: previousMothDay - i)));
      }
    }
    for (int i = 0; i < (42 - previousMothDay); i++) {
      dateList.add(newDate.add(Duration(days: i + 1)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = InheritedCalendarTheme.of(context).theme;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4),
          child: Row(
            children: <Widget>[
              SizedBox(
                height: 38,
                width: 38,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        currentMonthDate = DateTime(
                          currentMonthDate.year,
                          currentMonthDate.month,
                          0,
                        );
                        setListOfDate(currentMonthDate);
                      });
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
                    DateFormat('MMMM yyyy', 'pt-BR').format(currentMonthDate),
                    style: TextStyle(
                      color: theme.secondaryColor,
                      fontSize: 16,
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
                        setState(() {
                          currentMonthDate = DateTime(
                            currentMonthDate.year,
                            currentMonthDate.month + 2,
                            0,
                          );
                          setListOfDate(currentMonthDate);
                        });
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
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
          child: Row(
            children: getDaysNameUI(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8, left: 8),
          child: Column(
            children: getDaysNoUI(),
          ),
        ),
      ],
    );
  }

  List<Widget> getDaysNameUI() {
    final List<Widget> listUI = <Widget>[];
    final theme = InheritedCalendarTheme.of(context).theme;
    for (int i = 0; i < 7; i++) {
      listUI.add(
        Expanded(
          child: Center(
            child: Text(
              DateFormat('E', 'pt-BR').format(dateList[i])[0].toUpperCase(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: theme.secondaryColor,
              ),
            ),
          ),
        ),
      );
    }
    return listUI;
  }

  List<Widget> getDaysNoUI() {
    final List<Widget> noList = <Widget>[];
    int count = 0;
    final theme = InheritedCalendarTheme.of(context).theme;
    final rangeColor = theme.selectedDayBackground;
    for (int i = 0; i < dateList.length / 7; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < 7; i++) {
        final DateTime date = dateList[count];
        listUI.add(
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 3, bottom: 3),
                    child: Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 2,
                          bottom: 2,
                          left: isStartDateRadius(date) ? 4 : 0,
                          right: isEndDateRadius(date) ? 4 : 0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: startDate != null && endDate != null
                                ? getIsItStartAndEndDate(date) ||
                                        getIsInRange(date)
                                    ? rangeColor
                                    : Colors.transparent
                                : Colors.transparent,
                            borderRadius: BorderRadius.only(
                              bottomLeft: isStartDateRadius(date)
                                  ? const Radius.circular(24)
                                  : Radius.zero,
                              topLeft: isStartDateRadius(date)
                                  ? const Radius.circular(24)
                                  : Radius.zero,
                              topRight: isEndDateRadius(date)
                                  ? const Radius.circular(24)
                                  : Radius.zero,
                              bottomRight: isEndDateRadius(date)
                                  ? const Radius.circular(24)
                                  : Radius.zero,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(32.0)),
                      onTap: () {
                        if (widget.minimumDate != null &&
                            widget.maximumDate != null) {
                          final DateTime newMinimumDate = DateTime(
                            widget.minimumDate!.year,
                            widget.minimumDate!.month,
                            widget.minimumDate!.day - 1,
                          );
                          final DateTime newMaximumDate = DateTime(
                            widget.maximumDate!.year,
                            widget.maximumDate!.month,
                            widget.maximumDate!.day + 1,
                          );
                          if (date.isAfter(newMinimumDate) &&
                              date.isBefore(newMaximumDate)) {
                            onDateClick(date);
                          }
                        } else if (widget.minimumDate != null) {
                          final DateTime newMinimumDate = DateTime(
                            widget.minimumDate!.year,
                            widget.minimumDate!.month,
                            widget.minimumDate!.day - 1,
                          );
                          if (date.isAfter(newMinimumDate)) {
                            onDateClick(date);
                          }
                        } else if (widget.maximumDate != null) {
                          final DateTime newMaximumDate = DateTime(
                            widget.maximumDate!.year,
                            widget.maximumDate!.month,
                            widget.maximumDate!.day + 1,
                          );
                          if (date.isBefore(newMaximumDate)) {
                            onDateClick(date);
                          }
                        } else {
                          onDateClick(date);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          decoration: BoxDecoration(
                            color: getIsItStartAndEndDate(date)
                                ? rangeColor
                                : Colors.transparent,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(32.0)),
                            boxShadow: getIsItStartAndEndDate(date)
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
                                color: _getColor(date),
                                fontSize:
                                    MediaQuery.of(context).size.width > 360
                                        ? 18
                                        : 16,
                                fontWeight: _getFontWeight(date),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 9,
                    right: 0,
                    left: 0,
                    child: Container(
                      height: 6,
                      width: 6,
                      decoration: BoxDecoration(
                        color: DateTime.now().day == date.day &&
                                DateTime.now().month == date.month &&
                                DateTime.now().year == date.year
                            ? getIsInRange(date)
                                ? Colors.white
                                : rangeColor
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
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

  Color _getColor(DateTime date) {
    final theme = InheritedCalendarTheme.of(context).theme;
    final textDisabledColor = theme.disabledDayTextColor;
    if (getIsItStartAndEndDate(date) || getIsInRange(date)) {
      return theme.selectedDayTextColor;
    }
    if (currentMonthDate.month == date.month) {
      return theme.secondaryColor;
    }
    if (currentMonthDate.isBefore(date)) {
      return textDisabledColor ?? const Color(0x66000000);
    }
    if (currentMonthDate.isAfter(date)) {
      return textDisabledColor ?? const Color(0x66000000);
    }
    return Colors.grey.withValues(alpha: 0.6);
  }

  FontWeight _getFontWeight(DateTime date) {
    if (getIsItStartAndEndDate(date)) {
      return FontWeight.bold;
    }
    if (currentMonthDate.month == date.month) {
      return FontWeight.w700;
    }
    if (currentMonthDate.isBefore(date)) {
      return FontWeight.normal;
    }
    if (currentMonthDate.isAfter(date)) {
      return FontWeight.normal;
    }
    return FontWeight.normal;
  }

  bool getIsInRange(DateTime date) {
    if (startDate != null && endDate != null) {
      if (date.isAfter(startDate!) && date.isBefore(endDate!)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool getIsItStartAndEndDate(DateTime date) {
    if (startDate != null &&
        startDate!.day == date.day &&
        startDate!.month == date.month &&
        startDate!.year == date.year) {
      return true;
    } else if (endDate != null &&
        endDate!.day == date.day &&
        endDate!.month == date.month &&
        endDate!.year == date.year) {
      return true;
    } else {
      return false;
    }
  }

  bool hasInRange(DateTime date) {
    if (startDate != null && endDate != null) {
      if (date.isAfter(startDate!) && date.isBefore(endDate!)) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  bool isStartDateRadius(DateTime date) {
    if (startDate != null &&
        startDate!.day == date.day &&
        startDate!.month == date.month) {
      return true;
    } else if (date.weekday == 1) {
      return true;
    } else {
      return false;
    }
  }

  bool isEndDateRadius(DateTime date) {
    if (endDate != null &&
        endDate!.day == date.day &&
        endDate!.month == date.month) {
      return true;
    } else if (date.weekday == 7) {
      return true;
    } else {
      return false;
    }
  }

  void onDateClick(DateTime date) {
    if (startDate == null) {
      startDate = date;
    } else if (startDate != date && endDate == null) {
      endDate = date;
    } else if (startDate!.day == date.day && startDate!.month == date.month) {
      startDate = null;
    } else if (endDate!.day == date.day && endDate!.month == date.month) {
      endDate = null;
    }
    if (startDate == null && endDate != null) {
      startDate = endDate;
      endDate = null;
    }
    if (startDate != null && endDate != null) {
      if (!endDate!.isAfter(startDate!)) {
        final DateTime d = startDate!;
        startDate = endDate;
        endDate = d;
      }
      if (date.isBefore(startDate!)) {
        startDate = date;
      }
      if (date.isAfter(endDate!)) {
        endDate = date;
      }
    }
    setState(() {
      try {
        widget.startEndDateChange!(startDate!, endDate);
      } catch (_) {}
    });
  }
}
