import 'package:flutter/material.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../../utils/mega_base_images.dart';
import 'base_container_indicator.dart';

class EmptyCreditCards extends StatelessWidget {
  const EmptyCreditCards({super.key});

  String _getIconByTheme(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return isDark
        ? MegaBaseImages.icNoCreditCardDark
        : MegaBaseImages.icNoCreditCard;
  }

  @override
  Widget build(BuildContext context) => BaseContainerIndicator(
        title: 'Cartão de crédito',
        message: 'Nenhum cartão de crédito encontrado.',
        assetName: _getIconByTheme(context),
      );
}
