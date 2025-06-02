import 'package:flutter/material.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

class Validators {
  Validators._();

  static FormFieldValidator compare(
    TextEditingController? valueEC,
    String message,
  ) {
    return (value) {
      final valueCompare = valueEC?.text ?? '';
      if (value == null || (value != null && value != valueCompare)) {
        return message;
      }
      return null;
    };
  }

  static FormFieldValidator requiredEmpty(String message) {
    return (value) {
      if (value == null ||
          (value != null && (value as String).trim().isEmpty)) {
        return message;
      }
      return null;
    };
  }

  static FormFieldValidator requiredIf(bool isValidField) {
    return (value) {
      if (value == null || (value != null && isValidField)) {
        return null;
      }
      return 'Campo obrigatório';
    };
  }

  static FormFieldValidator emailUpperCamelCase(
    TextEditingController? valueEC,
    String message,
  ) {
    Validatorless.email('Email inválido');
    return (v) {
      final emailToMatch = v?.toLowerCase() ?? '';
      if (v?.isEmpty ?? true) {
        return null;
      }
      final emailRegex = RegExp(
        r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?",
      );
      if (emailRegex.hasMatch(emailToMatch)) {
        return null;
      }
      return message;
    };
  }

  static FormFieldValidator phone(String message) {
    return (value) {
      if (value == null || (value != null && value.length < 14)) {
        return message;
      }
      return null;
    };
  }
}
