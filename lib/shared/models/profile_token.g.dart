// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_token.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileTokenAdapter extends TypeAdapter<ProfileToken> {
  @override
  final int typeId = 103;

  @override
  ProfileToken read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileToken(
      fullName: fields[0] as String?,
      email: fields[1] as String?,
      password: fields[2] as String?,
      refreshToken: fields[3] as String?,
      providerId: fields[4] as String?,
      typeProvider: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileToken obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.fullName)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.refreshToken)
      ..writeByte(4)
      ..write(obj.providerId)
      ..writeByte(5)
      ..write(obj.typeProvider);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileTokenAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileToken _$ProfileTokenFromJson(Map<String, dynamic> json) => ProfileToken(
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      refreshToken: json['refreshToken'] as String?,
      providerId: json['providerId'] as String?,
      typeProvider: (json['typeProvider'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProfileTokenToJson(ProfileToken instance) =>
    <String, dynamic>{
      if (instance.fullName case final value?) 'fullName': value,
      if (instance.email case final value?) 'email': value,
      if (instance.password case final value?) 'password': value,
      if (instance.refreshToken case final value?) 'refreshToken': value,
      if (instance.providerId case final value?) 'providerId': value,
      if (instance.typeProvider case final value?) 'typeProvider': value,
    };
