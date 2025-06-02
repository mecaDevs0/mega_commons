import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

extension IntExtension on int {
  String toddMMyyyy() {
    final formatLocale = DateFormat('dd/MM/yyyy', 'pt_BR');
    return formatLocale
        .format(DateTime.fromMillisecondsSinceEpoch(this * 1000));
  }

  String toddMMyy() {
    final formatLocale = DateFormat('dd/MM/yy', 'pt_BR');
    return formatLocale
        .format(DateTime.fromMillisecondsSinceEpoch(this * 1000));
  }

  String toddOfMMMMyyyy() {
    final formatLocale = DateFormat("dd 'de' MMMM, yyyy", 'pt_BR');
    return formatLocale
        .format(DateTime.fromMillisecondsSinceEpoch(this * 1000));
  }

  String toddMMyyyyasHHmm() {
    final formatLocale = DateFormat("dd/MM/yyyy 'as' HH:mm", 'pt_BR');
    return formatLocale
        .format(DateTime.fromMillisecondsSinceEpoch(this * 1000));
  }

  String toddMMyyyyHHmm() {
    final formatLocale = DateFormat('dd/MM/yyyy HH:mm', 'pt_BR');
    return formatLocale
        .format(DateTime.fromMillisecondsSinceEpoch(this * 1000));
  }

  String toddMMyyyyHHmmss() {
    final formatLocale = DateFormat('dd/MM/yyyy HH:mm:ss', 'pt_BR');
    return formatLocale
        .format(DateTime.fromMillisecondsSinceEpoch(this * 1000));
  }

  String toHHmm() {
    final formatLocale = DateFormat('HH:mm');
    return formatLocale
        .format(DateTime.fromMillisecondsSinceEpoch(this * 1000));
  }

  bool isSameDate() {
    final now = DateTime.now();
    final dateTime = DateTime.fromMillisecondsSinceEpoch(this * 1000);
    return now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day;
  }

  bool isTodayOrAfter() {
    final now = DateTime.now();
    final dateTime = DateTime.fromMillisecondsSinceEpoch(this * 1000);
    final difference = now.difference(dateTime);
    return difference.inDays >= 0;
  }

  String getTimeAgo() {
    final now = DateTime.now();
    final dateTime = DateTime.fromMillisecondsSinceEpoch(this * 1000);
    final difference = now.difference(dateTime);
    if (difference.inDays > 1) {
      return '${difference.inDays} dias atrás';
    }
    if (difference.inDays == 1) {
      return 'Ontem';
    }
    if (difference.inDays == 0) {
      return toHHmm();
    }
    return '${difference.inHours} horas atrás';
  }

  DateTime toDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(this * 1000);
  }
}
