import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

extension DoubleExtension on double {
  String moneyFormat() {
    final valueFormatted =
        NumberFormat.simpleCurrency(locale: 'pt_BR', name: '').format(this);
    return 'R\$$valueFormatted';
  }

  String moneyFormatWithoutSymbol(String currencyCode) {
    String valueFormatted = '';
    if (currencyCode == 'BRL') {
      valueFormatted =
          NumberFormat.simpleCurrency(locale: 'pt_BR', name: '').format(this);
    } else {
      valueFormatted =
          NumberFormat.simpleCurrency(locale: 'en_US', name: '').format(this);
    }

    return valueFormatted;
  }

  String removeUnnecessaryZeros() {
    final regex = RegExp(r'([.]*0)(?!.*\d)');
    return this.toString().replaceAll(regex, '');
  }

  String toKilometer(double value) {
    final valueFormatted = NumberFormat.decimalPattern('pt_BR')
        .format(double.parse(value.toStringAsFixed(1)));
    return '$valueFormatted km';
  }
  
}
