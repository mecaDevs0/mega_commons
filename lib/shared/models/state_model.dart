import 'package:json_annotation/json_annotation.dart';

part 'state_model.g.dart';

@JsonSerializable()
class StateModel {
  StateModel({this.name, this.uf, this.id});

  factory StateModel.fromJson(Map<String, dynamic> json) =>
      _$StateModelFromJson(json);

  String? name;
  String? uf;
  String? id;

  Map<String, dynamic> toJson() => _$StateModelToJson(this);
}
