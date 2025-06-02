import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

enum AppLogLevel { debug, info, warning, error, success, log, banner }

class MegaLogger {
  MegaLogger._();

  static const _levelColors = {
    AppLogLevel.debug: '\x1b[38;5;135m',
    AppLogLevel.info: '\x1b[38;5;33m',
    AppLogLevel.warning: '\x1b[38;5;214m',
    AppLogLevel.error: '\x1b[38;5;196m',
    AppLogLevel.success: '\x1b[38;5;82m',
    AppLogLevel.log: '\x1b[38;5;245m',
    AppLogLevel.banner: '\x1B[38;5;205m',
  };

  static const _levelIcons = {
    AppLogLevel.debug: '🐛',
    AppLogLevel.info: '💡',
    AppLogLevel.warning: '⚠️',
    AppLogLevel.error: '🔥',
    AppLogLevel.success: '✅',
    AppLogLevel.log: '📝',
    AppLogLevel.banner: '📢',
  };

  static void _print(AppLogLevel level, String message, {String? tag}) {
    if (kReleaseMode) {
      return;
    }

    final color = _levelColors[level]!;
    final icon = _levelIcons[level]!;
    final tagPart = tag != null ? '[$tag] ' : '';
    debugPrint('$color$icon $tagPart$message\x1b[0m');
  }

  static void info(String message) => _print(AppLogLevel.info, message);
  static void success(String message) => _print(AppLogLevel.success, message);
  static void warning(String message) => _print(AppLogLevel.warning, message);
  static void error(String message) => _print(AppLogLevel.error, message);
  static void debug(String message) => _print(AppLogLevel.debug, message);
  static void log(String tag, String message) =>
      _print(AppLogLevel.log, message, tag: tag);

  static void banner(String message, {String? icon}) {
    if (kReleaseMode) {
      return;
    }

    final color = _levelColors[AppLogLevel.banner];
    icon ??= _levelIcons[AppLogLevel.banner];

    final totalWidth = (message.length + 5).clamp(1, 80);
    final line = '╴' * totalWidth;
    final logger = Logger();
    logger.i('Mensagem colorida');

    debugPrint('$color╭$line╮\x1b[0m');
    debugPrint('$color│ $icon $message │\x1b[0m');
    debugPrint('$color╰$line╯\x1b[0m');
  }
}
