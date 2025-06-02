import 'package:flutter/material.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../models/icon_alignment.dart';

/// Mega Base Button
/// The colors is configured by the theme
/// ButtonThemeData.colorScheme
/// background: Color
/// onBackground: Color
class MegaBaseButton extends StatelessWidget {
  const MegaBaseButton(
    this.label, {
    super.key,
    required this.onButtonPress,
    this.textStyle,
    this.borderRadius,
    this.buttonColor,
    this.loadingColor,
    this.isLoading = false,
    this.buttonHeight,
    this.width,
    this.leftIcon,
    this.rightIcon,
    this.iconAlignment = MegaIconAlignment.center,
    this.border,
    this.paddingLeftIcon,
    this.paddingRightIcon,
    this.isDisable = false,
    this.hasShadow = false,
    this.textColor,
    this.disabledTextColor,
  });
  final VoidCallback onButtonPress;
  final String? label;
  final TextStyle? textStyle;
  final double? borderRadius;
  final Color? buttonColor;
  final Color? loadingColor;
  final bool? isLoading;
  final double? buttonHeight;
  final double? width;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final double? paddingLeftIcon;
  final double? paddingRightIcon;
  final MegaIconAlignment? iconAlignment;
  final BoxBorder? border;
  final bool? isDisable;
  final bool? hasShadow;
  final Color? textColor;
  final Color? disabledTextColor;

  @override
  Widget build(BuildContext context) {
    final btnHeight = buttonHeight ?? context.theme.buttonTheme.height;

    final textWidget = Text(
      label ?? '',
      textAlign: TextAlign.center,
      style: textStyle ??
          TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDisable == true ? disabledTextColor : textColor,
          ),
    );

    Widget makeButton() {
      var children = <Widget>[textWidget];

      if (leftIcon != null) {
        switch (iconAlignment) {
          case MegaIconAlignment.center:
            children = [
              leftIcon!,
              Flexible(
                child: textWidget,
              ),
            ];
            break;
          default:
            children = [
              leftIcon!,
              Expanded(
                child: textWidget,
              ),
              SizedBox(
                width: 0.63 * btnHeight,
              ),
            ];
            break;
        }
      } else if (rightIcon != null) {
        switch (iconAlignment) {
          case MegaIconAlignment.center:
            children = [
              Flexible(
                child: textWidget,
              ),
              rightIcon!,
            ];
            break;
          default:
            children = [
              SizedBox(
                width: 0.63 * btnHeight,
              ),
              Expanded(
                child: textWidget,
              ),
              rightIcon!,
            ];
            break;
        }
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );
    }

    return Container(
      height: btnHeight,
      width: width ?? MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(
            borderRadius ?? 8,
          ),
        ),
        color: _getButtonColor(context),
        border: border,
        boxShadow: hasShadow == true
            ? [
                BoxShadow(
                  color: _getButtonColor(context).withValues(alpha: 0.5),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: InkWell(
        borderRadius: BorderRadius.all(
          Radius.circular(
            borderRadius ?? 8,
          ),
        ),
        onTap: _validOnTap(),
        child: Ink(
          child: Center(
            child: isLoading == true
                ? SizedBox(
                    width: btnHeight / 2,
                    height: btnHeight / 2,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                        loadingColor ?? Colors.white,
                      ),
                      strokeWidth: 2,
                    ),
                  )
                : Visibility(
                    visible: iconAlignment != MegaIconAlignment.center,
                    replacement: makeButton(),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: paddingLeftIcon ?? 12,
                            ),
                            child: leftIcon ?? const SizedBox.shrink(),
                          ),
                        ),
                        Center(child: textWidget),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: paddingRightIcon ?? 12,
                            ),
                            child: rightIcon ?? const SizedBox.shrink(),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  VoidCallback? _validOnTap() {
    if (isDisable == true) {
      return null;
    }
    return isLoading == true ? null : onButtonPress;
  }

  Color _getButtonColor(BuildContext context) {
    final buttonTheme = context.theme.buttonTheme;
    final btnColor = buttonTheme.colorScheme?.surface;
    final btnDisabledColor = buttonTheme.colorScheme?.onSurface;
    if (isDisable == true) {
      return btnDisabledColor ?? context.theme.disabledColor;
    }
    return buttonColor ?? btnColor ?? context.theme.primaryColor;
  }
}
