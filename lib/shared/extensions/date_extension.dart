import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

extension DateExtension on DateTime {
  String toddMMyyyy() {
    final formatLocale = DateFormat('dd/MM/yyyy');
    return formatLocale.format(this);
  }

  String toddMMyyHHmmss() {
    final formatLocale = DateFormat('dd_MM_yyyyHHmmss');
    return formatLocale.format(this);
  }

  String toddMMyy() {
    final formatLocale = DateFormat('dd/MM/yy');
    return formatLocale.format(this);
  }

  bool isToday() {
    final now = DateTime.now();
    return now.year == year && now.month == month && now.day == day;
  }

  String toHHmm() {
    final formatLocale = DateFormat('HH:mm');
    return formatLocale.format(this);
  }

  String toMMMMyyyy() {
    final formatLocale = DateFormat('MMMM yyyy');
    return formatLocale.format(this).capitalize ?? formatLocale.format(this);
  }

  int formatFirstDay() {
    return DateTime(year, month, 1).millisecondsSinceEpoch ~/ 1000;
  }

  int formatLastDay() {
    return DateTime(year, month + 1, 0).millisecondsSinceEpoch ~/ 1000;
  }

  int formatFirstHour() {
    return DateTime(year, month, day, 0, 0, 0).millisecondsSinceEpoch ~/ 1000;
  }

  int formatLastHour() {
    return DateTime(year, month, day, 23, 59, 59).millisecondsSinceEpoch ~/
        1000;
  }

  String formateTimeZone() {
    final timeZone = timeZoneOffset.inHours;
    return timeZone > 0 ? 'UTC+$timeZone' : 'UTC$timeZone';
  }

  int toTimestamp() {
    return millisecondsSinceEpoch ~/ 1000;
  }

  String toCompleteDate() {
    final formatLocale = DateFormat("EEEE, d 'de' MMMM 'de' y", 'pt_BR');
    return formatLocale.format(this);
  }

  bool isSameDay(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  String? get toMMyyyy {
    final formatLocale = DateFormat('MM/yyyy');
    return formatLocale.format(this);
  }

  String get toWeekDayAbbr {
    final formatLocale = DateFormat('E', 'pt_BR');
    final weekDay = formatLocale.format(this).replaceAll('.', '');
    return weekDay.capitalize ?? weekDay;
  }
}
