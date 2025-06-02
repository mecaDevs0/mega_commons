import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class MegaNotification {

  MegaNotification({
    this.title,
    this.content,
    this.image,
    this.dateRead,
    this.dataBlocked,
    this.disabled,
    this.created,
    this.id,
    this.referenceActionId,
    this.typeNotification,
  });

  factory MegaNotification.fromJson(Map<String, dynamic> json) {
    return _$MegaNotificationFromJson(json);
  }
  String? title;
  String? content;
  String? image;
  int? dateRead;
  int? dataBlocked;
  int? disabled;
  int? created;
  String? id;
  String? referenceActionId;
  int? typeNotification;

  Map<String, dynamic> toJson() => _$MegaNotificationToJson(this);
}
