import 'package:flutter/material.dart';

import 'bottom_action.dart';
import 'calendar_theme.dart';
import 'dot_label.dart';
import 'inherited_widget/inherited_calendar_theme.dart';
import 'inherited_widget/inherited_widget.dart';
import 'mega_calendar.dart';

class MegaDatePicker extends StatefulWidget {
  const MegaDatePicker({
    super.key,
    this.selectedDate,
    required this.onSelectDate,
    required this.onCancelClick,
    this.disabledWeekDays = const [],
    this.dotsWeekDays = const [],
    this.dotsWeekLabel = '',
    this.dotDates = const [],
    this.onChangeMonth,
  });
  final DateTime? selectedDate;
  final Function(DateTime) onSelectDate;
  final Function() onCancelClick;
  final List<int> disabledWeekDays;
  final List<int> dotsWeekDays;
  final String dotsWeekLabel;
  final List<DateTime> dotDates;
  final Function(DateTime date)? onChangeMonth;

  @override
  CustomDatePickerState createState() => CustomDatePickerState();
}

class CustomDatePickerState extends State<MegaDatePicker> {
  DateTime? selectedDate;

  @override
  void initState() {
    selectedDate = widget.selectedDate;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = InheritedCalendarTheme.of(context).theme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            decoration: BoxDecoration(
              color: theme.backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  offset: const Offset(4, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    top: 20,
                    right: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Data',
                        style: TextStyle(
                          color: theme.titleModalColor,
                          fontSize: 18,
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                ),
                MegaCalendar(
                  selectedDate: widget.selectedDate,
                  onDateSelected: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                  disabledWeekDays: widget.disabledWeekDays,
                  dotsWeekDays: widget.dotsWeekDays,
                  dotDates: widget.dotDates,
                  onChangeMonth: (date) {
                    widget.onChangeMonth?.call(date);
                  },
                ),
                DotLabel(
                  dotsWeekDays: widget.dotsWeekDays,
                  dotsWeekLabel: widget.dotsWeekLabel,
                ),
                const SizedBox(height: 10),
                BottomAction(widget: widget, selectedDate: selectedDate),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showMegaDatePicker(
  BuildContext context, {
  required DateTime minimumDate,
  required DateTime maximumDate,
  DateTime? selectedDate,
  DateTime? endDate,
  required Function(DateTime startDate) onSelectDate,
  required Function() onCancelClick,
  List<int> disabledWeekDays = const [],
  List<int> dotsWeekDays = const [],
  String dotsWeekLabel = '',
  CalendarTheme? theme,
  List<DateTime> dotDates = const [],
  Function(DateTime date)? onChangeMonth,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) => InheritedCalendarTheme(
      theme: theme ?? const BaseTheme(),
      child: MinimumDate(
        minimumDate: minimumDate,
        child: MaximumDate(
          maximumDate: maximumDate,
          child: MegaDatePicker(
            selectedDate: selectedDate,
            onSelectDate: onSelectDate,
            onCancelClick: onCancelClick,
            disabledWeekDays: disabledWeekDays,
            dotsWeekDays: dotsWeekDays,
            dotsWeekLabel: dotsWeekLabel,
            dotDates: dotDates,
            onChangeMonth: (date) {
              onChangeMonth?.call(date);
            },
          ),
        ),
      ),
    ),
  );
}
