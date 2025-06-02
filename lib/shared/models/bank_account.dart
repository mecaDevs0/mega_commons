import 'package:json_annotation/json_annotation.dart';

part 'bank_account.g.dart';

@JsonSerializable()
class BankAccount {
  BankAccount({
    this.accountableName,
    this.accountableCpf,
    this.bankAccount,
    this.bankAgency,
    this.bank,
    this.bankName,
    this.typeAccount,
    this.personType = 1,
    this.bankCnpj,
    this.dataBankStatus,
    this.id,
    this.hasDataBank,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) =>
      _$BankAccountFromJson(json);
  final String? accountableName;
  final String? accountableCpf;
  final String? bankAccount;
  final String? bankAgency;
  final String? bank;
  final String? bankName;
  final int? typeAccount;
  final int? personType;
  @JsonKey(includeIfNull: false)
  final String? bankCnpj;
  @JsonKey(defaultValue: 0, includeIfNull: false)
  final int? dataBankStatus;
  @JsonKey(includeIfNull: false)
  final String? id;
  @JsonKey(includeIfNull: false)
  final bool? hasDataBank;

  Map<String, dynamic> toJson() => _$BankAccountToJson(this);
}
