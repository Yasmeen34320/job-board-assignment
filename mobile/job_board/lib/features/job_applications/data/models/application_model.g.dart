// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApplicationModelAdapter extends TypeAdapter<ApplicationModel> {
  @override
  final int typeId = 2;

  @override
  ApplicationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApplicationModel(
      id: fields[0] as String,
      jobId: fields[1] as String,
      userId: fields[2] as String,
      resumePath: fields[3] as String,
      coverLetter: fields[4] as String,
      status: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ApplicationModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.jobId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.resumePath)
      ..writeByte(4)
      ..write(obj.coverLetter)
      ..writeByte(5)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
