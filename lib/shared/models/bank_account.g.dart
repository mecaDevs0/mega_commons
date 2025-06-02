// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankAccount _$BankAccountFromJson(Map<String, dynamic> json) => BankAccount(
      accountableName: json['accountableName'] as String?,
      accountableCpf: json['accountableCpf'] as String?,
      bankAccount: json['bankAccount'] as String?,
      bankAgency: json['bankAgency'] as String?,
      bank: json['bank'] as String?,
      bankName: json['bankName'] as String?,
      typeAccount: (json['typeAccount'] as num?)?.toInt(),
      personType: (json['personType'] as num?)?.toInt() ?? 1,
      bankCnpj: json['bankCnpj'] as String?,
      dataBankStatus: (json['dataBankStatus'] as num?)?.toInt() ?? 0,
      id: json['id'] as String?,
      hasDataBank: json['hasDataBank'] as bool?,
    );

Map<String, dynamic> _$BankAccountToJson(BankAccount instance) =>
    <String, dynamic>{
      'accountableName': instance.accountableName,
      'accountableCpf': instance.accountableCpf,
      'bankAccount': instance.bankAccount,
      'bankAgency': instance.bankAgency,
      'bank': instance.bank,
      'bankName': instance.bankName,
      'typeAccount': instance.typeAccount,
      'personType': instance.personType,
      if (instance.bankCnpj case final value?) 'bankCnpj': value,
      if (instance.dataBankStatus case final value?) 'dataBankStatus': value,
      if (instance.id case final value?) 'id': value,
      if (instance.hasDataBank case final value?) 'hasDataBank': value,
    };
