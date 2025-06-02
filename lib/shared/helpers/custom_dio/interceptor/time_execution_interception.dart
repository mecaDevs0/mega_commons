import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../../../../mega_commons.dart';

class TimeExecutionInterception extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final DateTime timer = DateTime.now();
    options.extra['start_time'] = timer.toIso8601String();
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final start = DateTime.parse(response.requestOptions.extra['start_time']);
    final totalExecution = DateTime.now().difference(start);
    MegaLogger.info('${totalExecution.inMilliseconds} in milliseconds');
    response.data['execution_time'] = totalExecution.inMilliseconds;
    handler.next(response);
  }
}
