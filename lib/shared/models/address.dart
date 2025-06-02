import 'package:json_annotation/json_annotation.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../data/mega_data_cache.dart';

part 'address.g.dart';

@JsonSerializable(includeIfNull: false)
@HiveType(typeId: 102)
class Address {

  Address({
    this.cityId,
    this.cityName,
    this.complement,
    this.name,
    this.neighborhood,
    this.number,
    this.stateId,
    this.stateName,
    this.stateUf,
    this.streetAddress,
    this.zipCode,
    this.ibge,
    this.gia,
    this.isDefault,
    this.created,
    this.dataBlocked,
    this.disabled,
    this.id,
    this.referencePoint,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
  static const String addressBoxKey = 'address';

  @HiveField(0)
  String? cityId;
  @HiveField(1)
  String? cityName;
  @HiveField(2)
  String? complement;
  @HiveField(3)
  String? name;
  @HiveField(4)
  String? neighborhood;
  @HiveField(5)
  String? number;
  @HiveField(6)
  String? stateId;
  @HiveField(7)
  String? stateName;
  @HiveField(8)
  String? stateUf;
  @HiveField(9)
  String? streetAddress;
  @HiveField(10)
  String? zipCode;
  @HiveField(11)
  String? ibge;
  @HiveField(12)
  String? gia;
  @HiveField(13)
  bool? isDefault;
  @HiveField(14)
  String? referencePoint;
  @HiveField(15)
  int? dataBlocked;
  @HiveField(16)
  int? disabled;
  @HiveField(17)
  int? created;
  @HiveField(18)
  String? id;

  Map<String, dynamic> toJson() => _$AddressToJson(this);

  String get formattedAddress {
    return '$streetAddress, $number';
  }

  String get formattedAddressWithState {
    return '$streetAddress, $number, $cityName - $stateUf';
  }

  static Box<Address> get deliveryBox => MegaDataCache.box<Address>();

  static Address? fromCache() {
    return deliveryBox.get(addressBoxKey);
  }

  static void saveToCache(Address deliveryAddress) {
    deliveryBox.put(addressBoxKey, deliveryAddress);
  }
}
