import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

class MegaFormatter {
  MegaFormatter._();
  static DateFormat get dateFormat => DateFormat('dd/MM/yyyy');

  static String formatDateTodayType({
    required int timeStampDate,
    DateFormat? format,
    DateFormat? todayFormat,
    DateFormat? yesterdayFormat,
  }) {
    final date = DateTime.fromMillisecondsSinceEpoch(timeStampDate * 1000);
    final now = DateTime.now();
    final DateTime yesterday = now.subtract(const Duration(days: 1));
    if (now.day == date.day &&
        now.month == date.month &&
        now.year == date.year) {
      return todayFormat != null ? todayFormat.format(date) : 'Hoje';
    }
    if (yesterday.day == date.day &&
        yesterday.month == date.month &&
        yesterday.year == date.year) {
      return yesterdayFormat != null ? yesterdayFormat.format(date) : 'Ontem';
    }
    return format != null
        ? format.format(date)
        : DateFormat('dd/MM/yyyy').format(date);
  }
}
