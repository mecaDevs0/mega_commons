import 'package:flutter/material.dart' hide IconAlignment;
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

class MegaAppleButton extends StatelessWidget {
  const MegaAppleButton({
    super.key,
    required this.onPressed,
    this.text = 'Entrar com Apple ID',
    this.height = 44,
    this.style = SignInWithAppleButtonStyle.black,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.iconAlignment = IconAlignment.center,
  });

  final VoidCallback onPressed;
  final String? text;
  final double? height;
  final SignInWithAppleButtonStyle? style;
  final BorderRadius? borderRadius;
  final IconAlignment? iconAlignment;

  @override
  Widget build(BuildContext context) {
    return SignInWithAppleButton(
      onPressed: onPressed,
      text: text!,
      height: height!,
      style: style!,
      borderRadius: borderRadius!,
      iconAlignment: iconAlignment!,
    );
  }
}
