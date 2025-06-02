import 'package:flutter/material.dart';

import 'inherited_widget/inherited_calendar_theme.dart';
import 'mega_date_picker.dart';

class BottomAction extends StatelessWidget {
  const BottomAction({
    super.key,
    required this.widget,
    required this.selectedDate,
  });

  final MegaDatePicker widget;
  final DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final theme = InheritedCalendarTheme.of(context).theme;
    return Padding(
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
                widget.onCancelClick();
                Navigator.pop(context);
              },
              child: SizedBox(
                height: 48,
                child: Center(
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: theme.cancelLabelColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: theme.buttonColor ?? Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
              ),
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(24),
                ),
                highlightColor: Colors.transparent,
                onTap: () {
                  if (selectedDate != null) {
                    widget.onSelectDate(selectedDate!);
                    Navigator.pop(context);
                  }
                },
                child: const Center(
                  child: Text(
                    'OK',
                    style: TextStyle(
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
    );
  }
}
