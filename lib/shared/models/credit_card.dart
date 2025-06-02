import 'package:json_annotation/json_annotation.dart';

part 'credit_card.g.dart';

@JsonSerializable()
class CreditCard {

  CreditCard({
    this.name,
    this.number,
    this.expMonth,
    this.expYear,
    this.cvv,
    this.flag,
    this.brand,
    this.id,
  });

  factory CreditCard.fromJson(Map<String, dynamic> json) =>
      _$CreditCardFromJson(json);
  String? name;
  String? number;
  int? expMonth;
  int? expYear;
  String? cvv;
  @JsonKey(includeIfNull: false)
  String? flag;
  @JsonKey(includeIfNull: false)
  String? brand;
  @JsonKey(includeIfNull: false)
  String? id;

  Map<String, dynamic> toJson() => _$CreditCardToJson(this);
}
