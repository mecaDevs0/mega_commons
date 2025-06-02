import 'package:flutter/services.dart';

class MegaDataBankInputFormatter extends TextInputFormatter {
  MegaDataBankInputFormatter({required this.mask});

  final String mask;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length > mask.length) {
      return oldValue;
    }

    final formattedValue = StringBuffer();
    final quantityDigits = mask.split('-').last.length;
    final emptyNewString = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final indexSubsStr = emptyNewString.length - 1;

    if (indexSubsStr >= quantityDigits + 1) {
      final lastDigits = quantityDigits - 1;
      final leftString = emptyNewString.substring(0, indexSubsStr - lastDigits);
      final rightString = emptyNewString.substring(indexSubsStr - lastDigits);
      formattedValue.write('$leftString-$rightString');
    } else {
      formattedValue.write(emptyNewString);
    }

    return TextEditingValue(
      text: formattedValue.toString(),
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}
