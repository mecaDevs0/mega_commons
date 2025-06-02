import 'dart:io';

import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../dio_connectivity_request_retries.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor {
  RetryOnConnectionChangeInterceptor({
    required this.requestRetries,
  });

  final DioConnectivityRequestRetries requestRetries;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_shouldRetry(err)) {
      try {
        requestRetries.scheduleRequestRetry(err.requestOptions);
      } catch (e) {
        super.onError(err, handler);
      }
    } else {
      super.onError(err, handler);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.error != null && err.error is SocketException;
  }
}
