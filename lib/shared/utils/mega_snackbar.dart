import 'package:flutter/material.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

class MegaSnackbar {
  MegaSnackbar._();

  static void showErroSnackBar(
    String message, {
    String? title,
    Color? backgroundColor,
    Widget? iconError,
    Duration? duration,
  }) {
    Get.snackbar(
      title ?? '',
      message,
      titleText: title != null ? null : Container(),
      colorText: Colors.white,
      backgroundColor:
          backgroundColor ?? Get.theme.colorScheme.error.withValues(alpha: 0.7),
      icon: iconError,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  static void showSuccessSnackBar(
    String message, {
    String? title,
    Color? backgroundColor,
    Color? textColor,
  }) {
    Get.snackbar(
      title ?? '',
      message,
      titleText: title != null ? null : Container(),
      colorText: textColor ?? Colors.white,
      backgroundColor: backgroundColor ?? const Color(0xFF5CB85C),
    );
  }

  static void showToast(String message) {
    Get.snackbar(
      '',
      message,
      titleText: const SizedBox.shrink(),
      backgroundColor: Colors.black.withValues(alpha: 0.8),
      barBlur: 10,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
