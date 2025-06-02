// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddressAdapter extends TypeAdapter<Address> {
  @override
  final int typeId = 102;

  @override
  Address read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Address(
      cityId: fields[0] as String?,
      cityName: fields[1] as String?,
      complement: fields[2] as String?,
      name: fields[3] as String?,
      neighborhood: fields[4] as String?,
      number: fields[5] as String?,
      stateId: fields[6] as String?,
      stateName: fields[7] as String?,
      stateUf: fields[8] as String?,
      streetAddress: fields[9] as String?,
      zipCode: fields[10] as String?,
      ibge: fields[11] as String?,
      gia: fields[12] as String?,
      isDefault: fields[13] as bool?,
      created: fields[17] as int?,
      dataBlocked: fields[15] as int?,
      disabled: fields[16] as int?,
      id: fields[18] as String?,
      referencePoint: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Address obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.cityId)
      ..writeByte(1)
      ..write(obj.cityName)
      ..writeByte(2)
      ..write(obj.complement)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.neighborhood)
      ..writeByte(5)
      ..write(obj.number)
      ..writeByte(6)
      ..write(obj.stateId)
      ..writeByte(7)
      ..write(obj.stateName)
      ..writeByte(8)
      ..write(obj.stateUf)
      ..writeByte(9)
      ..write(obj.streetAddress)
      ..writeByte(10)
      ..write(obj.zipCode)
      ..writeByte(11)
      ..write(obj.ibge)
      ..writeByte(12)
      ..write(obj.gia)
      ..writeByte(13)
      ..write(obj.isDefault)
      ..writeByte(14)
      ..write(obj.referencePoint)
      ..writeByte(15)
      ..write(obj.dataBlocked)
      ..writeByte(16)
      ..write(obj.disabled)
      ..writeByte(17)
      ..write(obj.created)
      ..writeByte(18)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      cityId: json['cityId'] as String?,
      cityName: json['cityName'] as String?,
      complement: json['complement'] as String?,
      name: json['name'] as String?,
      neighborhood: json['neighborhood'] as String?,
      number: json['number'] as String?,
      stateId: json['stateId'] as String?,
      stateName: json['stateName'] as String?,
      stateUf: json['stateUf'] as String?,
      streetAddress: json['streetAddress'] as String?,
      zipCode: json['zipCode'] as String?,
      ibge: json['ibge'] as String?,
      gia: json['gia'] as String?,
      isDefault: json['isDefault'] as bool?,
      created: (json['created'] as num?)?.toInt(),
      dataBlocked: (json['dataBlocked'] as num?)?.toInt(),
      disabled: (json['disabled'] as num?)?.toInt(),
      id: json['id'] as String?,
      referencePoint: json['referencePoint'] as String?,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      if (instance.cityId case final value?) 'cityId': value,
      if (instance.cityName case final value?) 'cityName': value,
      if (instance.complement case final value?) 'complement': value,
      if (instance.name case final value?) 'name': value,
      if (instance.neighborhood case final value?) 'neighborhood': value,
      if (instance.number case final value?) 'number': value,
      if (instance.stateId case final value?) 'stateId': value,
      if (instance.stateName case final value?) 'stateName': value,
      if (instance.stateUf case final value?) 'stateUf': value,
      if (instance.streetAddress case final value?) 'streetAddress': value,
      if (instance.zipCode case final value?) 'zipCode': value,
      if (instance.ibge case final value?) 'ibge': value,
      if (instance.gia case final value?) 'gia': value,
      if (instance.isDefault case final value?) 'isDefault': value,
      if (instance.referencePoint case final value?) 'referencePoint': value,
      if (instance.dataBlocked case final value?) 'dataBlocked': value,
      if (instance.disabled case final value?) 'disabled': value,
      if (instance.created case final value?) 'created': value,
      if (instance.id case final value?) 'id': value,
    };
