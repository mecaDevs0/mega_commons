import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class MegaWeekCalendar extends StatefulWidget {
  const MegaWeekCalendar({
    super.key,
    this.selectedDate,
    this.onDateSelected,
    required this.minimumDate,
    this.maximumDate,
    this.selectedColor,
    this.textSelectedColor,
    this.onMonthChange,
  });
  final DateTime minimumDate;
  final DateTime? maximumDate;
  final DateTime? selectedDate;
  final Function(DateTime)? onDateSelected;
  final Color? selectedColor;
  final Color? textSelectedColor;
  final Function(DateTime)? onMonthChange;

  @override
  CustomWeekCalendarState createState() => CustomWeekCalendarState();
}

class CustomWeekCalendarState extends State<MegaWeekCalendar> {
  List<DateTime> dateList = <DateTime>[];
  DateTime currentMonthDate = DateTime.now();
  DateTime? startDate;
  int weekIndex = 0;
  final PageController pageViewController = PageController();

  @override
  void initState() {
    setListOfDate(currentMonthDate);
    if (widget.selectedDate != null) {
      startDate = widget.selectedDate;
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
                      final newDate = DateTime(
                        currentMonthDate.year,
                        currentMonthDate.month,
                        0,
                      );
                      if (widget.minimumDate.isAfter(newDate)) {
                        return;
                      }
                      setState(() {
                        currentMonthDate = newDate;
                        setListOfDate(currentMonthDate);
                      });
                      if (widget.onMonthChange != null) {
                        widget.onMonthChange!(currentMonthDate);
                      }
                    },
                    child: const Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    DateFormat('MMMM yyyy', 'pt-BR').format(currentMonthDate),
                    style: const TextStyle(
                      color: Colors.black,
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
                        if (widget.onMonthChange != null) {
                          widget.onMonthChange!(currentMonthDate);
                        }
                      },
                      child: const Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black,
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
          child: SizedBox(
            height: 50,
            child: PageView(
              controller: pageViewController,
              scrollDirection: Axis.horizontal,
              children: getDaysNoUIPageView(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> getDaysNameUI() {
    final List<Widget> listUI = <Widget>[];
    for (int i = 0; i < 7; i++) {
      listUI.add(
        Expanded(
          child: Center(
            child: Text(
              toBeginningOfSentenceCase(
                DateFormat('EEEE', 'pt-BR').format(dateList[i]).substring(0, 3),
              )!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black.withValues(alpha: 0.4),
              ),
            ),
          ),
        ),
      );
    }
    return listUI;
  }

  List<Widget> getDaysNoUIPageView() {
    final List<List<DateTime>> dateListChunks = chunk(dateList, 7);
    weekIndex = _getTodayIndex(dateListChunks);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      pageViewController.animateToPage(
        weekIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    });
    final List<Widget> noList = <Widget>[];
    int count = 0;
    for (int i = 0; i < dateList.length / 7; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < 7; i++) {
        final DateTime date = dateList[count];
        listUI.add(
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                onTap: () {
                  if (widget.minimumDate != null &&
                      widget.maximumDate != null) {
                    final DateTime newMinimumDate = DateTime(
                      widget.minimumDate.year,
                      widget.minimumDate.month,
                      widget.minimumDate.day - 1,
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
                      widget.minimumDate.year,
                      widget.minimumDate.month,
                      widget.minimumDate.day - 1,
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
                child: Center(
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: getIsSelectedDate(date)
                          ? widget.selectedColor ??
                              Theme.of(context).primaryColor
                          : Colors.transparent,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(32.0)),
                    ),
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          color: _getColor(date),
                          fontSize:
                              MediaQuery.of(context).size.width > 360 ? 18 : 16,
                        ),
                      ),
                    ),
                  ),
                ),
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

  List<List<DateTime>> chunk(List<DateTime> list, int chunkSize) {
    final List<List<DateTime>> chunks = [];
    final int len = list.length;
    for (var i = 0; i < len; i += chunkSize) {
      final int size = i + chunkSize;
      chunks.add(list.sublist(i, size > len ? len : size));
    }
    return chunks;
  }

  bool getIsSelectedDate(DateTime date) {
    if (startDate != null &&
        startDate!.day == date.day &&
        startDate!.month == date.month &&
        startDate!.year == date.year) {
      return true;
    } else {
      return false;
    }
  }

  void onDateClick(DateTime date) {
    startDate = date;
    setState(() {
      try {
        widget.onDateSelected!(startDate!);
      } catch (_) {}
    });
  }

  int _getTodayIndex(List<List<DateTime>> dateListChunks) {
    int index = 0;
    final now = startDate ?? DateTime.now();
    for (final element in dateListChunks) {
      final hasItem = element.any(
        (element) => element.day == now.day && element.month == now.month,
      );
      index = hasItem ? dateListChunks.indexOf(element) : 0;
      if (hasItem) {
        break;
      }
    }
    return index;
  }

  Color _getColor(DateTime date) {
    final diffDays = widget.minimumDate.difference(date).inDays;
    if (getIsSelectedDate(date)) {
      return widget.textSelectedColor ?? Colors.black;
    }
    if (widget.minimumDate.isAfter(date) && diffDays > 0) {
      return Colors.grey.withValues(alpha: 0.6);
    }
    return Colors.black;
  }
}
