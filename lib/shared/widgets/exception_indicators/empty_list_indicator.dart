import 'package:flutter/cupertino.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../../utils/mega_base_images.dart';
import 'base_container_indicator.dart';

class EmptyListIndicator extends StatelessWidget {
  const EmptyListIndicator({
    super.key,
    this.title,
    this.message,
    this.isShowIcon = true,
    this.iconColor,
  });

  final String? title;
  final String? message;
  final bool isShowIcon;
  final Color? iconColor;

  String _getIconByTheme(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return isDark ? MegaBaseImages.icEmptyListDark : MegaBaseImages.icEmptyList;
  }

  @override
  Widget build(BuildContext context) => BaseContainerIndicator(
        title: title ?? 'Lista vazia',
        message: message ?? 'Não foi possível encontrar nenhum item.',
        isShowIcon: isShowIcon,
        assetName: _getIconByTheme(context),
        iconColor: iconColor,
      );
}
