import 'package:flutter/material.dart';

import 'mega_base_button.dart';

class MegaGoogleButton extends StatelessWidget {
  const MegaGoogleButton({
    super.key,
    this.text = 'Entrar com Google',
    required this.onPressed,
    this.buttonColor = Colors.blue,
    this.height = 44,
    this.textStyle,
    this.border,
  });

  final String text;
  final VoidCallback onPressed;
  final Color? buttonColor;
  final double? height;
  final TextStyle? textStyle;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return MegaBaseButton(
      text,
      onButtonPress: onPressed,
      buttonHeight: height,
      textStyle: textStyle,
      buttonColor: buttonColor,
      border: border,
      leftIcon: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Image.asset(
          'assets/google_logo.png',
          package: 'mega_commons',
          height: height! / 2,
        ),
      ),
    );
  }
}
