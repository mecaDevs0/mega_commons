// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MegaNotification _$MegaNotificationFromJson(Map<String, dynamic> json) =>
    MegaNotification(
      title: json['title'] as String?,
      content: json['content'] as String?,
      image: json['image'] as String?,
      dateRead: (json['dateRead'] as num?)?.toInt(),
      dataBlocked: (json['dataBlocked'] as num?)?.toInt(),
      disabled: (json['disabled'] as num?)?.toInt(),
      created: (json['created'] as num?)?.toInt(),
      id: json['id'] as String?,
      referenceActionId: json['referenceActionId'] as String?,
      typeNotification: (json['typeNotification'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MegaNotificationToJson(MegaNotification instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'image': instance.image,
      'dateRead': instance.dateRead,
      'dataBlocked': instance.dataBlocked,
      'disabled': instance.disabled,
      'created': instance.created,
      'id': instance.id,
      'referenceActionId': instance.referenceActionId,
      'typeNotification': instance.typeNotification,
    };
