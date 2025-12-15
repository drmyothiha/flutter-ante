// lib/models/active_patient_model.dart
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'active_patient_model.g.dart';

@HiveType(typeId: 0)
class ActivePatient {
  @HiveField(0)
  final String patientId;

  @HiveField(1)
  final Map<String, dynamic> patientData; // Complete JSON from API

  @HiveField(2)
  final DateTime activatedAt;

  @HiveField(3)
  final bool isSynced;

  @HiveField(4)
  final String? serverId;

  ActivePatient({
    required this.patientId,
    required this.patientData,
    required this.activatedAt,
    this.isSynced = false,
    this.serverId,
  });

  // Helper getters for quick access to common fields
  String get patientName => patientData['patientName']?.toString() ?? 'Unknown';
  String get doctorName => patientData['doctorName']?.toString() ?? 'Unknown';
  String get diagnosis => patientData['diagnosis']?.toString() ?? 'N/A';
  String get procedureCode => patientData['procedureCode']?.toString() ?? 'N/A';

  String? get location {
    final participants = patientData['participants'] as List?;
    if (participants != null) {
      for (var participant in participants) {
        if (participant is Map &&
            participant['actor'] is Map &&
            (participant['actor']['reference'] as String?)?.contains(
                  'Location',
                ) ==
                true) {
          return participant['actor']['display']?.toString();
        }
      }
    }
    return null;
  }

  DateTime? get startTime {
    final start = patientData['start'];
    if (start != null) {
      try {
        return DateTime.parse(start.toString());
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  DateTime? get endTime {
    final end = patientData['end'];
    if (end != null) {
      try {
        return DateTime.parse(end.toString());
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Format time for display
  String get formattedTime {
    if (startTime == null || endTime == null) return 'N/A';

    final start = startTime!;
    final end = endTime!;

    return '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')} - '
        '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
  }

  String get formattedDate {
    if (startTime == null) return 'N/A';
    final date = startTime!;
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Get status color
  Color get statusColor {
    final status = patientData['status']?.toString().toLowerCase() ?? '';
    switch (status) {
      case 'booked':
        return Colors.blue;
      case 'in-progress':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Get status text
  String get statusText {
    final status = patientData['status']?.toString() ?? 'Unknown';
    return status;
  }

  // Convert to JSON for storage/sync
  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'patientData': patientData,
      'activatedAt': activatedAt.toIso8601String(),
      'isSynced': isSynced,
      'serverId': serverId,
    };
  }

  // Factory method from JSON
  factory ActivePatient.fromJson(Map<String, dynamic> json) {
    return ActivePatient(
      patientId: json['patientId'] as String,
      patientData: Map<String, dynamic>.from(json['patientData']),
      activatedAt:
          DateTime.tryParse(json['activatedAt']?.toString() ?? '') ??
          DateTime.now(),
      isSynced: json['isSynced'] as bool,
      serverId: json['serverId'] as String?,
    );
  }
}
