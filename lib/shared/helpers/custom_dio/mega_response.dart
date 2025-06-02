import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

part 'mega_response.g.dart';

@JsonSerializable()
class MegaResponse implements Exception {
  MegaResponse({
    this.data,
    this.erro,
    this.errors,
    this.message,
    this.statusCode,
  });

  factory MegaResponse.fromJson(Map<String, dynamic> json) =>
      _$MegaResponseFromJson(json);

  MegaResponse.fromDioError(DioException e) {
    if (e.requestOptions.extra['noConnection'] == true) {
      message = 'Sem conexão com a internet.';
      return;
    }
    if (e.response != null &&
        e.response!.data != null &&
        e.response!.data is Map) {
      final dynamic json = e.response!.data;
      data = json['data'];
      erro = json['erro'] as bool;
      errors = json['errors'];
      message = json['message'] as String;
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      errors = e.error;
      message = 'Tempo de conexão expirado.';
    } else if (e.error is SocketException) {
      errors = e.error;
      message = 'Sem conexão com a internet.';
    } else {
      errors = e.error;
      message =
          'Ocorreu um erro durante o processamento da sua requisição. Por favor, tente novamente mais tarde.';
    }

    statusCode = e.response?.statusCode ?? HttpStatus.badRequest;
  }

  dynamic data;
  bool? erro;
  dynamic errors;
  String? message;
  int? statusCode;

  Map<String, dynamic> toJson() => _$MegaResponseToJson(this);
}
