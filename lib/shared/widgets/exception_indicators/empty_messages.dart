import 'package:flutter/material.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../../utils/mega_base_images.dart';
import 'base_container_indicator.dart';

class EmptyMessages extends StatelessWidget {
  const EmptyMessages({super.key});

  String _getIconByTheme(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return isDark ? MegaBaseImages.icNoMessageDark : MegaBaseImages.icNoMessage;
  }

  @override
  Widget build(BuildContext context) => BaseContainerIndicator(
        title: 'Mensagens',
        message: 'Nenhuma mensagem encontrada.',
        assetName: _getIconByTheme(context),
      );
}
