import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

extension StringExtension on String? {
  String toddMMyyyy() {
    if (this == null) {
      return '';
    }
    final date = DateFormat('dd/MM/yyyy').parse(this!);

    final formatLocale = DateFormat('MMMM yyyy');
    final result =
        formatLocale.format(DateTime.utc(date.year, date.month, 1, 0, 0));
    return result.capitalize!;
  }

  DateTime get toDateTime {
    if (this == null) {
      return DateTime.now();
    }
    return DateFormat('dd/MM/yyyy HH:mm:ss', 'pt_BR').parse(this!);
  }

  int? get toTimeStamp {
    if (this == null) {
      return null;
    }
    return DateFormat('dd/MM/yyyy').parse(this!).millisecondsSinceEpoch ~/ 1000;
  }

  bool isAfterToday() {
    if (this == null) {
      return false;
    }
    final date = DateFormat('dd/MM/yyyy').parse(this!);
    if (date.isAfter(DateTime.now())) {
      return true;
    }
    return false;
  }

  bool isDate() {
    if (this == null) {
      return false;
    }
    try {
      DateFormat('dd/MM/yyyy').parseStrict(this!);
      return true;
    } on FormatException {
      return false;
    }
  }

  /// Verifica se a String é nula ou vazia
  /// Retorna true se a String for nula ou vazia
  bool get isNullOrEmpty {
    return this == null || this?.isEmpty == true;
  }

  /// Verifica se a String não é nula ou vazia
  /// Retorna true se a String não for nula ou vazia
  bool get isNotNullOrEmpty {
    return this != null && this!.isNotEmpty;
  }

  /// Verifica se a String é um arquivo
  /// Retorna true se a String for um arquivo
  bool get isFile {
    final value = this;
    if (value == null || value.isEmpty) {
      return false;
    }

    return value.startsWith('/') ||
        value.startsWith('file://') ||
        value.startsWith('content://');
  }

  /// Converte uma string vazia para null.
  /// Retorna null se a string for vazia ou nula
  String? get emptyToNull {
    if (this?.isEmpty ?? true) {
      return null;
    }
    return this;
  }

  /// Retorna o nome do arquivo a partir do caminho completo
  String get fileName {
    if (this == null) {
      return 'Arquivo';
    }
    return this!.split('/').last;
  }
}
