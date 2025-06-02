import 'package:flutter/cupertino.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../../utils/mega_base_images.dart';
import 'base_container_indicator.dart';

class GenericErrorIndicator extends StatelessWidget {
  const GenericErrorIndicator({
    super.key,
    required this.onTryAgain,
    this.isError = false,
  });

  final VoidCallback onTryAgain;
  final bool isError;

  String _getIconByTheme(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    if (!isError) {
      return isDark ? MegaBaseImages.icAlertDark : MegaBaseImages.icAlert;
    }
    return isDark ? MegaBaseImages.icErrorDark : MegaBaseImages.icError;
  }

  @override
  Widget build(BuildContext context) => BaseContainerIndicator(
        title: 'Algo deu errado',
        message: 'O aplicativo encontrou um erro desconhecido. \n '
            'Por favor, tente novamente mais tarde.',
        assetName: _getIconByTheme(context),
        onTryAgain: onTryAgain,
      );
}
