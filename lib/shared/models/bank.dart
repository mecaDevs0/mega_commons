import 'package:json_annotation/json_annotation.dart';

part 'bank.g.dart';

@JsonSerializable()
class Bank {

  Bank({this.code, this.name, this.id, this.accountMask, this.agencyMask});

  factory Bank.fromJson(Map<String, dynamic> json) => _$BankFromJson(json);
  String? code;
  String? name;
  String? accountMask;
  String? agencyMask;
  String? id;

  Map<String, dynamic> toJson() => _$BankToJson(this);
}
