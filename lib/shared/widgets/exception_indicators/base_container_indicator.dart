import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../../models/models.dart';
import '../../utils/mega_base_images.dart';
import '../mega_base_button.dart';

class BaseContainerIndicator extends StatelessWidget {
  const BaseContainerIndicator({
    required this.title,
    required this.message,
    this.assetName,
    this.onTryAgain,
    this.isShowIcon = true,
    this.customIcon,
    super.key,
    this.iconColor,
  });

  final String title;
  final String message;
  final String? assetName;
  final VoidCallback? onTryAgain;
  final bool isShowIcon;
  final Widget? customIcon;
  final Color? iconColor;

  String _getIconByTheme(BuildContext context) {
    if (assetName != null) {
      return assetName!;
    }
    final isDark = context.theme.brightness == Brightness.dark;
    return isDark ? MegaBaseImages.icAlertDark : MegaBaseImages.icAlert;
  }

  Color _getBackgroundColor(BuildContext context) {
    if (iconColor != null) {
      return iconColor!.withValues(alpha: 0.1);
    }
    final isDark = context.theme.brightness == Brightness.dark;
    return isDark ? const Color(0xFF676666) : const Color(0xFFF3F7FF);
  }

  Color _getIconColor(BuildContext context) {
    if (iconColor != null) {
      return iconColor!;
    }
    final isDark = context.theme.brightness == Brightness.dark;
    return isDark ? const Color(0xFFB9B9B9) : const Color(0xFF1F64E7);
  }

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _makeIcon(context),
              const SizedBox(height: 34),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (message != null)
                const SizedBox(
                  height: 16,
                ),
              if (message != null)
                Text(
                  message,
                  textAlign: TextAlign.center,
                ),
              if (onTryAgain != null) const Spacer(),
              if (onTryAgain != null)
                MegaBaseButton(
                  'Tentar novamente',
                  buttonHeight: 50,
                  textStyle: context.theme.textTheme.labelLarge,
                  onButtonPress: onTryAgain!,
                  leftIcon: const Icon(
                    Icons.refresh,
                  ),
                  iconAlignment: MegaIconAlignment.left,
                ),
            ],
          ),
        ),
      );

  Widget _makeIcon(BuildContext context) {
    if (!isShowIcon) {
      return const SizedBox.shrink();
    }
    if (customIcon != null) {
      return customIcon!;
    }
    return Container(
      height: 100,
      width: 100,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(70),
      ),
      child: SvgPicture.asset(
        _getIconByTheme(context),
        package: 'mega_commons',
        colorFilter: ColorFilter.mode(
          _getIconColor(context),
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
