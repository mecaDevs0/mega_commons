import 'package:flutter/cupertino.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../../utils/mega_base_images.dart';
import 'base_container_indicator.dart';

class NoConnectionIndicator extends StatelessWidget {
  const NoConnectionIndicator({
    super.key,
    required this.onTryAgain,
  });

  final VoidCallback onTryAgain;

  String _getIconByTheme(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return isDark ? MegaBaseImages.icNoWifiDark : MegaBaseImages.icNoWifi;
  }

  @override
  Widget build(BuildContext context) => BaseContainerIndicator(
        title: 'Sem conexão',
        message:
            'Por favor, verifique a conexão com a Internet e tente novamente.',
        assetName: _getIconByTheme(context),
        onTryAgain: onTryAgain,
      );
}
