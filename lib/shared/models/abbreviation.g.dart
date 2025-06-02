// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abbreviation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AbbreviationAdapter extends TypeAdapter<Abbreviation> {
  @override
  final int typeId = 104;

  @override
  Abbreviation read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Abbreviation.custom;
      case 1:
        return Abbreviation.development;
      case 2:
        return Abbreviation.homolog;
      case 3:
        return Abbreviation.production;
      default:
        return Abbreviation.custom;
    }
  }

  @override
  void write(BinaryWriter writer, Abbreviation obj) {
    switch (obj) {
      case Abbreviation.custom:
        writer.writeByte(0);
        break;
      case Abbreviation.development:
        writer.writeByte(1);
        break;
      case Abbreviation.homolog:
        writer.writeByte(2);
        break;
      case Abbreviation.production:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AbbreviationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
