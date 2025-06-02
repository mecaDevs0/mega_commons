// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bank _$BankFromJson(Map<String, dynamic> json) => Bank(
      code: json['code'] as String?,
      name: json['name'] as String?,
      id: json['id'] as String?,
      accountMask: json['accountMask'] as String?,
      agencyMask: json['agencyMask'] as String?,
    );

Map<String, dynamic> _$BankToJson(Bank instance) => <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'accountMask': instance.accountMask,
      'agencyMask': instance.agencyMask,
      'id': instance.id,
    };
