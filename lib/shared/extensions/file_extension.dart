import 'dart:io';

extension FileExtension on File? {
  /// Verifica se o arquivo é nulo ou vazio
  /// Retorna true se o arquivo for nulo ou vazio
  bool get isNullOrEmpty {
    return this == null || this?.path.isEmpty == true;
  }

  /// Verifica se o arquivo não é nulo ou vazio
  /// Retorna true se o arquivo não for nulo ou vazio
  bool get isNotNullOrEmpty {
    return this != null && this!.path.isNotEmpty;
  }

  /// Retorna o nome do arquivo a partir do File
  String get fileName {
    if (this == null) {
      return 'Arquivo';
    }
    if (this!.path.isEmpty) {
      return 'Arquivo';
    }
    return this!.path.split('/').last;
  }
}
