// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_patient_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivePatientAdapter extends TypeAdapter<ActivePatient> {
  @override
  final int typeId = 0;

  @override
  ActivePatient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivePatient(
      patientId: fields[0] as String,
      patientData: (fields[1] as Map).cast<String, dynamic>(),
      activatedAt: fields[2] as DateTime,
      isSynced: fields[3] as bool,
      serverId: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ActivePatient obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.patientId)
      ..writeByte(1)
      ..write(obj.patientData)
      ..writeByte(2)
      ..write(obj.activatedAt)
      ..writeByte(3)
      ..write(obj.isSynced)
      ..writeByte(4)
      ..write(obj.serverId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivePatientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
