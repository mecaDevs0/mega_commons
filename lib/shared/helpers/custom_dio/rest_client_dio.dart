import 'dart:io';

import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../../../mega_commons.dart';
import 'interceptor/firebase_performance_interceptor.dart';
import 'retry_interceptor.dart';

class RestClientDio implements ICustomDio {
  RestClientDio(
    String baseUrl, {
    String roteLogin = '/login',
    String? pathRefreshToken,
    bool? isAnonymous,
    String? routeHome,
    Interceptor? customInterceptor,
  }) {
    _setup(
      baseUrl: baseUrl,
      isAuthRequest: true,
      roteLogin: roteLogin,
      pathRefreshToken: pathRefreshToken,
      isAnonymous: isAnonymous ?? false,
      routeHome: routeHome,
      customInterceptor: customInterceptor,
    );
  }

  @Deprecated('Use RestClientDio.noAuth instead')
  RestClientDio.noAuth(
    String baseUrl, {
    String? pathRefreshToken,
  }) {
    _setup(
      baseUrl: baseUrl,
      pathRefreshToken: pathRefreshToken,
    );
  }

  late Dio _dio;

  void _setup({
    required String baseUrl,
    bool isAuthRequest = false,
    String? roteLogin,
    String? pathRefreshToken,
    bool isAnonymous = false,
    String? routeHome,
    Interceptor? customInterceptor,
  }) {
    final BaseOptions baseOptions = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
    );
    _dio = Dio(baseOptions);
    _dio.interceptors.add(FirebasePerformanceInterceptor());
    _dio.interceptors.add(
      AuthInterceptor(
        baseUrl: baseUrl,
        dio: _dio,
        routeLogin: roteLogin ?? '/login',
        pathRefreshToken: pathRefreshToken,
        isAnonymous: isAnonymous,
        routeHome: routeHome,
      ),
    );
    _dio.interceptors.add(CustomLogInterceptor());
    _dio.interceptors.add(RetryInterceptor());
    if (customInterceptor != null) {
      _dio.interceptors.add(customInterceptor);
    }
    if (AliceAdapter.hasInstance()) {
      _dio.interceptors.add(AliceAdapter.alice.getDioInterceptor());
    }
    // _dio.interceptors.add(RetryOnConnectionChangeInterceptor(
    //   requestRetries: DioConnectivityRequestRetries(
    //     dio: _dio,
    //     connectivity: InternetConnectionChecker(),
    //   ),
    // ));
  }

  @override
  Future<MegaResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response<dynamic> response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return MegaResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 401) {
        rethrow;
      }
      throw MegaResponse.fromDioError(e);
    }
  }

  @override
  Future<MegaResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response<dynamic> response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return MegaResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 401) {
        rethrow;
      }
      throw MegaResponse.fromDioError(e);
    }
  }

  @override
  Future<MegaResponse> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      final Response<dynamic> response = await _dio.delete(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      );
      return MegaResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 401) {
        rethrow;
      }
      throw MegaResponse.fromDioError(e);
    }
  }

  @override
  Future<MegaResponse> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response<dynamic> response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return MegaResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 401) {
        rethrow;
      }
      throw MegaResponse.fromDioError(e);
    }
  }

  Future<MegaFile> uploadFile({
    required File file,
    bool returnWithUrl = false,
    bool checkLength = true,
  }) async {
    try {
      _getFileSizeInMB(file);
      final String fileName = file.path.split('/').last;
      final String? mime = lookupMimeType(file.path);
      final FormData formData = FormData.fromMap(
        {
          'file': await MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType:
                MediaType(mime!.split('/').first, mime.split('/').last),
          ),
          'returnWithUrl': returnWithUrl,
          'checkLength': checkLength,
        },
      );

      final response = await _dio.post(
        'api/v1/File/Upload',
        data: formData,
      );
      final data = MegaResponse.fromJson(response.data);
      return MegaFile.fromJson(data.data);
    } on DioException catch (e) {
      throw MegaResponse.fromDioError(e);
    }
  }

  Future<MegaFile> uploadFiles({
    required List<File> files,
    bool returnWithUrl = false,
    bool checkLength = true,
  }) async {
    final List<MultipartFile> multiPartFiles = [];
    try {
      for (final file in files) {
        _getFileSizeInMB(file);
        final String fileName = file.path.split('/').last;
        final String? mime = lookupMimeType(file.path);
        multiPartFiles.add(
          await MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType:
                MediaType(mime!.split('/').first, mime.split('/').last),
          ),
        );
      }

      final FormData formData = FormData.fromMap(
        {
          'files': multiPartFiles,
          'returnWithUrl': returnWithUrl,
          'checkLength': checkLength,
        },
      );

      final response = await _dio.post(
        'api/v1/File/Uploads',
        data: formData,
      );
      final data = MegaResponse.fromJson(response.data);
      return MegaFile.fromJson(data.data);
    } on DioException catch (e) {
      throw MegaResponse.fromDioError(e);
    }
  }

  @override
  Future<MegaResponse> getBankSlip({
    String? baseUrl,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    final dio = Dio(BaseOptions(baseUrl: baseUrl!));
    dio.interceptors.add(TimeExecutionInterception());
    dio.interceptors.add(CustomLogInterceptor());
    dio.interceptors.add(FirebasePerformanceInterceptor());
    try {
      final Response<dynamic> response = await dio.get(
        '',
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return MegaResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 401) {
        rethrow;
      }
      throw MegaResponse.fromDioError(e);
    }
  }

  @override
  Future getCustom(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response<dynamic> response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 401) {
        rethrow;
      }
      throw MegaResponse.fromDioError(e);
    }
  }

  void _getFileSizeInMB(File file) {
    final bytes = file.lengthSync();
    final mb = bytes / (1024 * 1024);
    MegaLogger.banner('File size: ${mb.toStringAsFixed(2)} MB', icon: '📂');
  }
}
