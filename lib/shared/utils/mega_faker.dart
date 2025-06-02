import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

class MegaFaker {
  MegaFaker._();

  /// Gera um CNPJ fictício e insere no [TextEditingController] informado.
  ///
  /// Este método só executa em modo de desenvolvimento (`kDebugMode == true`),
  /// evitando que dados fictícios sejam usados em produção.
  ///
  /// Exemplo de uso:
  /// ```dart
  /// final controller = TextEditingController();
  /// MegaFaker.generateCNPJ(controller);
  /// print(controller.text); // 12.345.678/0001-95
  /// ```
  ///
  /// [controller] - O controller de texto onde o CNPJ gerado será inserido.
  static void generateCNPJ(TextEditingController controller) {
    if (kDebugMode) {
      controller.text = UtilBrasilFields.gerarCNPJ();
    }
  }

  /// Gera um CPF fictício e insere no [TextEditingController] informado.
  ///
  /// Este método só executa em modo de desenvolvimento (`kDebugMode == true`),
  /// evitando que dados fictícios sejam usados em produção.
  ///
  /// Exemplo de uso:
  /// ```dart
  /// final controller = TextEditingController();
  /// MegaFaker.generateCPF(controller);
  /// print(controller.text); // 123.456.789-09
  /// ```
  ///
  /// [controller] - O controller de texto onde o CPF gerado será inserido.
  static void generateCPF(TextEditingController controller) {
    if (kDebugMode) {
      controller.text = UtilBrasilFields.gerarCPF();
    }
  }
}
