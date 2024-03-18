// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AreaTypeAdapter extends TypeAdapter<AreaType> {
  @override
  final int typeId = 11;

  @override
  AreaType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AreaType(
      id: fields[0] as String,
      title: fields[1] as String,
      layerUrl: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AreaType obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.layerUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AreaTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}