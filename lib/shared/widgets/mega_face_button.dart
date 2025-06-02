import 'package:flutter/material.dart';

import 'mega_base_button.dart';

class MegaFaceButton extends StatelessWidget {
  const MegaFaceButton({
    super.key,
    this.text = 'Entrar com Facebook',
    required this.onPressed,
    this.buttonColor,
    this.height = 44,
    this.textStyle,
  });

  final String text;
  final VoidCallback onPressed;
  final Color? buttonColor;
  final double? height;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return MegaBaseButton(
      text,
      onButtonPress: onPressed,
      buttonHeight: height,
      textStyle: textStyle,
      buttonColor: buttonColor ?? const Color(0xFF4267B2),
      leftIcon: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Image.asset(
          'assets/facebook_icon.png',
          package: 'mega_commons',
          height: height! / 2,
        ),
      ),
    );
  }
}
