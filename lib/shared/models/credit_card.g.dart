// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCard _$CreditCardFromJson(Map<String, dynamic> json) => CreditCard(
      name: json['name'] as String?,
      number: json['number'] as String?,
      expMonth: (json['expMonth'] as num?)?.toInt(),
      expYear: (json['expYear'] as num?)?.toInt(),
      cvv: json['cvv'] as String?,
      flag: json['flag'] as String?,
      brand: json['brand'] as String?,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$CreditCardToJson(CreditCard instance) =>
    <String, dynamic>{
      'name': instance.name,
      'number': instance.number,
      'expMonth': instance.expMonth,
      'expYear': instance.expYear,
      'cvv': instance.cvv,
      if (instance.flag case final value?) 'flag': value,
      if (instance.brand case final value?) 'brand': value,
      if (instance.id case final value?) 'id': value,
    };
