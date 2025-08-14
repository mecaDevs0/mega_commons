import 'dart:developer' as console;
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

class RetryInterceptor extends Interceptor {
  static const int _maxRetries = 2;
  static const Duration _retryDelay = Duration(seconds: 2);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Verificar se é um erro que pode ser retry (502, 503, 504)
    final shouldRetry = err.response?.statusCode == 502 ||
        err.response?.statusCode == 503 ||
        err.response?.statusCode == 504;

    if (shouldRetry && _canRetry(err.requestOptions)) {
      console.log('🔄 Tentando retry para erro ${err.response?.statusCode}', 
          name: 'RetryInterceptor');
      
      // Aguardar um pouco antes de tentar novamente
      await Future.delayed(_retryDelay);
      
      try {
        // Fazer nova tentativa
        final response = await _retryRequest(err.requestOptions);
        console.log('✅ Retry bem-sucedido', name: 'RetryInterceptor');
        handler.resolve(response);
        return;
      } catch (retryError) {
        console.log('❌ Retry falhou: $retryError', name: 'RetryInterceptor');
        handler.next(err);
        return;
      }
    }

    // Se não deve fazer retry, passar o erro normalmente
    handler.next(err);
  }

  bool _canRetry(RequestOptions requestOptions) {
    // Verificar se já não excedeu o número máximo de tentativas
    final retryCount = requestOptions.extra['retryCount'] ?? 0;
    return retryCount < _maxRetries;
  }

  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    // Incrementar contador de tentativas
    final retryCount = (requestOptions.extra['retryCount'] ?? 0) + 1;
    requestOptions.extra['retryCount'] = retryCount;

    console.log('🔄 Tentativa $retryCount de $_maxRetries', name: 'RetryInterceptor');

    // Criar nova instância do Dio para fazer a requisição
    final dio = Dio();
    
    // Configurar timeout menor para retry
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);

    return await dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
      ),
    );
  }
}
