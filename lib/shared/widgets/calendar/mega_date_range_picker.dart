import 'package:flutter/material.dart';

import 'calendar_theme.dart';
import 'inherited_widget/inherited_calendar_theme.dart';
import 'mega_range_calendar.dart';

class MegaDateRangePicker extends StatefulWidget {
  const MegaDateRangePicker({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    required this.onApplyClick,
    this.barrierDismissible = true,
    required this.minimumDate,
    required this.maximumDate,
    required this.onCancelClick,
    this.labelCancel = 'Limpar Filtro',
    this.labelConfirm = 'Filtrar',
    this.radiusConfirmButton,
  });
  final DateTime minimumDate;
  final DateTime maximumDate;
  final bool barrierDismissible;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(DateTime, DateTime?) onApplyClick;
  final Function() onCancelClick;
  final String labelCancel;
  final String labelConfirm;
  final double? radiusConfirmButton;

  @override
  CustomDateRangePickerState createState() => CustomDateRangePickerState();
}

class CustomDateRangePickerState extends State<MegaDateRangePicker>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  DateTime? startDate;

  DateTime? endDate;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    startDate = widget.initialStartDate;
    endDate = widget.initialEndDate;
    animationController?.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = InheritedCalendarTheme.of(context).theme;
    return Center(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            if (widget.barrierDismissible) {
              Navigator.pop(context);
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.backgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                ),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  onTap: () {},
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
                      MegaRangeCalendar(
                        minimumDate: widget.minimumDate,
                        maximumDate: widget.maximumDate,
                        initialEndDate: widget.initialEndDate,
                        initialStartDate: widget.initialStartDate,
                        startEndDateChange:
                            (DateTime startDateData, DateTime? endDateData) {
                          setState(() {
                            startDate = startDateData;
                            endDate = endDateData;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 16,
                          top: 8,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  try {
                                    widget.onCancelClick();
                                    Navigator.pop(context);
                                  } catch (_) {}
                                },
                                child: SizedBox(
                                  height: 48,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Center(
                                      child: Text(
                                        widget.labelCancel,
                                        style: TextStyle(
                                          color: theme.cancelLabelColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  widget.onApplyClick(startDate!, endDate);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 55,
                                  decoration: BoxDecoration(
                                    color: theme.buttonColor ??
                                        Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        widget.radiusConfirmButton ?? 30,
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.labelConfirm,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showMegaDateRangePicker(
  BuildContext context, {
  required bool dismissible,
  required DateTime minimumDate,
  required DateTime maximumDate,
  DateTime? startDate,
  DateTime? endDate,
  required Function(DateTime startDate, DateTime? endDate) onApplyClick,
  required Function() onCancelClick,
  double? radiusConfirmButton,
  CalendarTheme? theme,
}) {
  FocusScope.of(context).requestFocus(FocusNode());
  showDialog(
    context: context,
    builder: (BuildContext context) => InheritedCalendarTheme(
      theme: theme ?? const BaseTheme(),
      child: MegaDateRangePicker(
        barrierDismissible: true,
        minimumDate: minimumDate,
        maximumDate: maximumDate,
        initialStartDate: startDate,
        initialEndDate: endDate,
        onApplyClick: onApplyClick,
        onCancelClick: onCancelClick,
        radiusConfirmButton: radiusConfirmButton,
      ),
    ),
  );
}
