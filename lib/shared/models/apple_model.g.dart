// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apple_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppleModelAdapter extends TypeAdapter<AppleModel> {
  @override
  final int typeId = 105;

  @override
  AppleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppleModel(
      givenName: fields[0] as String,
      userIdentifier: fields[1] as String,
      email: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AppleModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.givenName)
      ..writeByte(1)
      ..write(obj.userIdentifier)
      ..writeByte(2)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
