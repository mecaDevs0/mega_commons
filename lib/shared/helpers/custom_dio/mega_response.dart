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
    
    // Log detalhado do erro para debug
    print('🔍 Erro Dio detectado: ${e.type}');
    print('📊 Status Code: ${e.response?.statusCode}');
    print('🔗 URL: ${e.requestOptions.uri}');
    print('💬 Mensagem: ${e.message}');
    
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
      message = 'Tempo de conexão expirado. Verifique sua conexão com a internet.';
    } else if (e.error is SocketException) {
      errors = e.error;
      message = 'Sem conexão com a internet. Verifique sua rede e tente novamente.';
    } else if (e.type == DioExceptionType.connectionError) {
      errors = e.error;
      message = 'Erro de conexão com o servidor. Verifique sua internet e tente novamente.';
    } else if (e.response?.statusCode == 502) {
      errors = e.error;
      message = 'Servidor temporariamente indisponível. Tente novamente em alguns minutos.';
    } else if (e.response?.statusCode == 503) {
      errors = e.error;
      message = 'Serviço temporariamente indisponível. Tente novamente em alguns minutos.';
    } else if (e.response?.statusCode == 504) {
      errors = e.error;
      message = 'Tempo limite do servidor. Tente novamente em alguns minutos.';
    } else if (e.response?.statusCode == 400) {
      // Tratamento específico para erro 400 com timeout do MongoDB
      final errorData = e.response?.data;
      if (errorData != null && errorData is Map<String, dynamic>) {
        final messageEx = errorData['messageEx'] as String?;
        if (messageEx?.contains('timeout') == true || 
            messageEx?.contains('MongoDB') == true ||
            messageEx?.contains('CompositeServerSelector') == true) {
          errors = e.error;
          message = 'Servidor temporariamente sobrecarregado. Tente novamente em alguns minutos.';
        } else {
          errors = e.error;
          message = 'Dados inválidos. Verifique as informações enviadas.';
        }
      } else {
        errors = e.error;
        message = 'Dados inválidos. Verifique as informações enviadas.';
      }
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
