// lib/models/active_patient_model.dart
import 'package:hive/hive.dart';

part 'active_patient_model.g.dart';

@HiveType(typeId: 0)
class ActivePatient {
  @HiveField(0)
  final String patientId;

  @HiveField(1)
  final Map<String, dynamic> patientData;

  @HiveField(2)
  final DateTime activatedAt;

  @HiveField(3)
  final bool isSynced;

  @HiveField(4)
  DateTime? surgeryStartedAt; // NEW: Track when surgery started

  @HiveField(5)
  bool surgeryInProgress; // NEW: Track if surgery is in progress

  @HiveField(6)
  String? anaesthesiologist; // NEW: Who started the anaesthesia

  ActivePatient({
    required this.patientId,
    required this.patientData,
    required this.activatedAt,
    required this.isSynced,
    this.surgeryStartedAt,
    this.surgeryInProgress = false,
    this.anaesthesiologist,
  });

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'patientData': patientData,
      'activatedAt': activatedAt.toIso8601String(),
      'isSynced': isSynced,
      'surgeryStartedAt': surgeryStartedAt?.toIso8601String(),
      'surgeryInProgress': surgeryInProgress,
      'anaesthesiologist': anaesthesiologist,
    };
  }
}
