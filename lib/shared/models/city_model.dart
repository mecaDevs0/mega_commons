import 'package:json_annotation/json_annotation.dart';

part 'city_model.g.dart';

@JsonSerializable()
class CityModel {
  CityModel({this.name, this.stateName, this.stateId, this.id});

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);

  String? name;
  String? stateName;
  String? stateId;
  String? id;

  Map<String, dynamic> toJson() => _$CityModelToJson(this);
}
