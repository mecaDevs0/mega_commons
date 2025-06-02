// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'environment_url.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EnvironmentUrlAdapter extends TypeAdapter<EnvironmentUrl> {
  @override
  final int typeId = 101;

  @override
  EnvironmentUrl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EnvironmentUrl(
      abbreviation: fields[0] as Abbreviation,
      name: fields[1] as String,
      url: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EnvironmentUrl obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.abbreviation)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnvironmentUrlAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
