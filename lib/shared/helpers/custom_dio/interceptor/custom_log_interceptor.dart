// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

class CustomLogInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!kIsWeb) {
      final Map<String, String> headeRUserAgentData = {};
      final UserAgentData uaData = await userAgentData();
      final name = removeDiacritics(uaData.brand);
      final headerUserAgent =
          '$name (${uaData.platform} ${uaData.platformVersion}; ${uaData.model}; ${uaData.device}; ${uaData.architecture})';
      headeRUserAgentData['User-Agent'] =
          '$headerUserAgent full-version ${uaData.package.appVersion}/${uaData.package.buildNumber}';
      options.headers.addAll(headeRUserAgentData);
    }
    if (!kReleaseMode) {
      _printRequest(options, Level.info);
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (!kReleaseMode) {
      _printResponse(response, Level.info);
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.cancel) {
      return super.onError(err, handler);
    }

    if (!kReleaseMode) {
      _printErrorResponse(err, Level.error);
    }
    super.onError(err, handler);
  }

  void _printRequest(RequestOptions options, Level level) {
    final uri = options.uri;
    final method = options.method;
    print('');
    final icon = makeLogIcon(level);
    _printByLevel(level, log: '$icon Request ║ $method ');
    _printByLevel(level, log: uri.toString());
    _printByLevel(level, log: '${options.headers}');
    if (options.data is FormData) {
      _printByLevel(level, log: 'FormData');
    } else {
      _printByLevel(
        level,
        log: jsonEncode(options.data ?? '{data: NO BODY DATA}'),
      );
    }

    _printLine(level, '╚');
    print('');
  }

  void _printResponse(Response response, Level level) {
    final uri = response.requestOptions.uri;
    final method = response.requestOptions.method;
    print('');
    final icon = makeLogIcon(level);
    _printByLevel(
      level,
      log:
          '$icon Response ║ $method ║ Status: ${response.statusCode} ${response.statusMessage}',
    );
    _printByLevel(level, log: uri.toString());
    _printByLevel(
      level,
      log: jsonEncode(response.data ?? '{message: NO BODY DATA}'),
    );
    _printLine(level, '╚');
    print('');
  }

  void _printErrorResponse(DioException err, Level level) {
    final icon = makeLogIcon(level);
    final uri = err.response?.requestOptions.uri;
    if (err.type != DioExceptionType.unknown) {
      print('');
      _printByLevel(
        level,
        log:
            '$icon DioError ░ Status: ${err.response?.statusCode} ${err.response?.statusMessage}',
      );
      _printByLevel(level, log: uri.toString());
      if (err.response != null && err.response?.data != null) {
        _printByLevel(level, log: '🧨 ${err.type.toString()}');
        _printByLevel(level, log: err.response!.data.toString());
      }
      _printLine(level, '╚');
      print('');
    } else {
      _printByLevel(level, log: 'DioError ░ ${err.type}');
      _printByLevel(level, log: err.message ?? '🚦');
    }
  }

  AnsiColor makeColor(Level level) {
    switch (level) {
      case Level.info:
        return const AnsiColor.fg(34);
      case Level.warning:
        return const AnsiColor.fg(208);
      case Level.error:
        return const AnsiColor.fg(196);
      case Level.debug:
        return const AnsiColor.fg(111);
      default:
        return const AnsiColor.none();
    }
  }

  String makeLogIcon(Level level) {
    switch (level) {
      case Level.info:
        return '✅ ';
      case Level.warning:
        return '🚧 ';
      case Level.error:
        return '❌ ';
      case Level.debug:
        return '🐛 ';
      default:
        return '💬 ';
    }
  }

  void _printByLevel(Level level, {required String log}) {
    if (!kIsWeb && Platform.isIOS) {
      print(log);
    } else {
      print('${makeColor(level)}$log');
    }
  }

  void _printLine(Level level, [String pre = '', String suf = '╝']) =>
      _printByLevel(level, log: '$pre${'═' * 100}$suf');
}
