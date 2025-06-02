import 'dart:io';

import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../../../../mega_commons.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.routeLogin,
    required this.baseUrl,
    required this.dio,
    this.pathRefreshToken,
    this.isAnonymous = false,
    this.routeHome,
  });

  final Box accessTokenBox = MegaDataCache.box<AuthToken>();
  final Box isLogged = MegaDataCache.box<bool>();

  final String baseUrl;
  late AuthToken? accessTokenData;
  final Dio dio;
  final String routeLogin;
  final String? routeHome;
  final String? pathRefreshToken;
  final bool isAnonymous;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    accessTokenData = AuthToken.fromCache();
    if (accessTokenData != null &&
        accessTokenData?.accessToken?.isNotEmpty == true) {
      options.headers['Authorization'] =
          'Bearer ${accessTokenData!.accessToken}';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == HttpStatus.unauthorized ||
        err.response?.statusCode == HttpStatus.forbidden) {
      getNewToken(err, handler);
    } else {
      return handler.next(err);
    }
  }

  Future<void> getNewToken(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    accessTokenData = AuthToken.fromCache();
    if (accessTokenData?.refreshToken == null) {
      await _reAuthenticate(error, handler);
      return error.response?.data;
    }
    try {
      final response = await RestClientDio.noAuth(baseUrl).post(
        pathRefreshToken ?? 'api/v1/Profile/Token',
        data: {'refreshToken': '${accessTokenData?.refreshToken}'},
      );
      await _saveNewTokenRequestAgain(response, error, handler);
    } on MegaResponse catch (_) {
      await _reAuthenticate(error, handler);
      return error.response?.data;
    }
  }

  Future<void> _saveNewTokenRequestAgain(
    MegaResponse response,
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final newAuthToken = AuthToken.fromJson(response.data);
    await _setNewTokenInLocalStorage(newAuthToken);
    await _requestAgainLastApiCall(error, handler);
  }

  Future<void> _navigateToLogin() async {
    if (isAnonymous) {
      await _getAnonymousToken();
      Get.offAllNamed(routeHome ?? '/core');
    } else {
      Get.offAllNamed(routeLogin);
    }
  }

  Future<void> _getAnonymousToken() async {
    final response = await RestClientDio(baseUrl).get(
      'api/v1/Profile/GetAnonymousAccess',
    );
    final newAuthToken = AuthToken.fromJson(response.data);
    await _setNewTokenInLocalStorage(newAuthToken);
    await isLogged.put(
      'isLogged',
      false,
    );
  }

  Future<void> _setNewTokenInLocalStorage(AuthToken authToken) async {
    await accessTokenBox.put(
      AuthToken.cacheBoxKey,
      authToken,
    );
  }

  Future<void> _reAuthenticate(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final profileToken = ProfileToken.fromCache();
    if (profileToken != null) {
      await _requestLogin(error, handler);
      return;
    }
    await _validRouting();
  }

  Future<void> _validRouting() async {
    final routing = Get.routing;
    if (routing.current != routeLogin) {
      await AuthToken.remove();
      await _navigateToLogin();
    }
  }

  Future<void> _requestLogin(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final profileToken = ProfileToken.fromCache();
    final data = {};
    if (profileToken!.email != null && profileToken.password != null) {
      data['email'] = profileToken.email;
      data['password'] = profileToken.password;
    } else if (profileToken.typeProvider != null &&
        profileToken.providerId != null) {
      data['typeProvider'] = profileToken.typeProvider;
      data['providerId'] = profileToken.providerId;
    }
    try {
      final response = await RestClientDio.noAuth(baseUrl).post(
        pathRefreshToken ?? 'api/v1/Profile/Token',
        data: data,
      );
      await _saveNewTokenRequestAgain(response, error, handler);
    } on Exception {
      MegaSnackbar.showErroSnackBar(
        'Erro ao tentar se autenticar novamente.',
      );
      await _validRouting();
    }
  }

  Future<void> _requestAgainLastApiCall(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final RequestOptions options = error.requestOptions;
      final response = await dio.request(
        options.path,
        options: Options(
          method: options.method,
        ),
        data: options.data,
        queryParameters: options.queryParameters,
        onReceiveProgress: options.onReceiveProgress,
        onSendProgress: options.onSendProgress,
        cancelToken: options.cancelToken,
      );
      handler.resolve(response);
    } catch (e) {
      MegaLogger.error(e.toString());
    }
  }
}
