import 'dart:async';

import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

class DioConnectivityRequestRetries {
  DioConnectivityRequestRetries({
    required this.dio,
    required this.connectivity,
  });

  final Dio dio;

  final InternetConnectionChecker connectivity;

  Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async {
    late StreamSubscription<InternetConnectionStatus> streamSubscription;
    final responseCompleter = Completer<Response>();
    streamSubscription = InternetConnectionChecker().onStatusChange.listen(
      (connectivityResult) {
        if (connectivityResult == InternetConnectionStatus.connected) {
          streamSubscription.cancel();

          responseCompleter.complete(
            dio.request(
              requestOptions.path,
              cancelToken: requestOptions.cancelToken,
              data: requestOptions.data,
              onReceiveProgress: requestOptions.onReceiveProgress,
              onSendProgress: requestOptions.onSendProgress,
              queryParameters: requestOptions.queryParameters,
              options: Options(
                method: requestOptions.method,
                sendTimeout: requestOptions.sendTimeout,
                receiveTimeout: requestOptions.receiveTimeout,
                extra: requestOptions.extra,
                headers: requestOptions.headers,
                responseType: requestOptions.responseType,
                contentType: requestOptions.contentType,
                validateStatus: requestOptions.validateStatus,
                receiveDataWhenStatusError:
                    requestOptions.receiveDataWhenStatusError,
                followRedirects: requestOptions.followRedirects,
                maxRedirects: requestOptions.maxRedirects,
                requestEncoder: requestOptions.requestEncoder,
                responseDecoder: requestOptions.responseDecoder,
                listFormat: requestOptions.listFormat,
              ),
            ),
          );
        }
      },
    );

    return responseCompleter.future;
  }
}
