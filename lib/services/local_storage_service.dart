// lib/services/local_storage_service.dart
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:my_app/models/active_patient_model.dart';

class LocalStorageService {
  static const String _activePatientsBox = 'active_patients';
  static const String _medicalRecordsBox = 'medical_records';
  static const String _settingsBox = 'settings';

  static Future<void> init() async {
    // Initialize Hive with path
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ActivePatientAdapter());
    }

    // Get documents directory
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    // Open boxes
    await Hive.openBox<ActivePatient>(_activePatientsBox);
    await Hive.openBox(_medicalRecordsBox);
    await Hive.openBox(_settingsBox);
  }

  // Get current active patient
  static ActivePatient? getActivePatient() {
    final box = Hive.box<ActivePatient>(_activePatientsBox);
    final activePatients = box.values.toList();

    // Sort by activation time, get most recent
    activePatients.sort((a, b) => b.activatedAt.compareTo(a.activatedAt));

    return activePatients.isNotEmpty ? activePatients.first : null;
  }

  // Set patient as active
  static Future<void> setPatientAsActive(
    Map<String, dynamic> patientJson,
  ) async {
    try {
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(ActivePatientAdapter());
      }

      // Ensure box is open
      if (!Hive.isBoxOpen(_activePatientsBox)) {
        await Hive.openBox<ActivePatient>(_activePatientsBox);
      }

      final box = Hive.box<ActivePatient>(_activePatientsBox);
      final rawId = patientJson['id'];
      final patientId =
          rawId?.toString() ??
          'unknown-${DateTime.now().millisecondsSinceEpoch}';

      final activePatient = ActivePatient(
        patientId: patientId,
        patientData: patientJson,
        activatedAt: DateTime.now(),
        isSynced: false,
      );

      await box.put(patientId, activePatient);
    } catch (e) {
      // Don't block navigation for storage issues; log and continue
      // ignore: avoid_print
      print('Warning: Failed to set patient as active: $e');
    }
  }

  // Store medical record data for active patient
  static Future<void> saveMedicalRecord({
    required String patientId,
    required String recordType, // 'preop', 'intraop', 'postop', 'checklist'
    required Map<String, dynamic> data,
    bool isSynced = false,
  }) async {
    final box = Hive.box(_medicalRecordsBox);
    final key = '$patientId-$recordType';

    final recordData = {
      'patientId': patientId,
      'recordType': recordType,
      'data': data,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'isSynced': isSynced,
    };

    await box.put(key, jsonEncode(recordData));
  }

  // Get medical record for patient
  static Map<String, dynamic>? getMedicalRecord({
    required String patientId,
    required String recordType,
  }) {
    final box = Hive.box(_medicalRecordsBox);
    final key = '$patientId-$recordType';
    final recordJson = box.get(key);

    if (recordJson != null) {
      try {
        return jsonDecode(recordJson.toString());
      } catch (e) {
        print('Error decoding JSON for key $key: $e');
        return null;
      }
    }

    return null;
  }

  // Get all unsynced records
  static List<Map<String, dynamic>> getUnsyncedRecords() {
    final box = Hive.box(_medicalRecordsBox);
    final records = <Map<String, dynamic>>[];

    for (var value in box.values) {
      final record = jsonDecode(value);
      if (record['isSynced'] == false) {
        records.add(record);
      }
    }

    return records;
  }

  // Mark record as synced
  static Future<void> markRecordAsSynced({
    required String patientId,
    required String recordType,
    required String serverId,
  }) async {
    final box = Hive.box(_medicalRecordsBox);
    final key = '$patientId-$recordType';
    final recordJson = box.get(key);

    if (recordJson != null) {
      final record = jsonDecode(recordJson);
      record['isSynced'] = true;
      record['serverId'] = serverId;
      record['updatedAt'] = DateTime.now().toIso8601String();

      await box.put(key, jsonEncode(record));
    }
  }

  // Get all active patients (history)
  static List<ActivePatient> getActivePatientHistory() {
    final box = Hive.box<ActivePatient>(_activePatientsBox);
    final patients = box.values.toList();

    // Sort by activation time (newest first)
    patients.sort((a, b) => b.activatedAt.compareTo(a.activatedAt));

    return patients;
  }

  // Remove patient from active list
  static Future<void> removeActivePatient(String patientId) async {
    final box = Hive.box<ActivePatient>(_activePatientsBox);
    await box.delete(patientId);
  }

  // Clear all data (for testing/debugging)
  static Future<void> clearAllData() async {
    await Hive.box<ActivePatient>(_activePatientsBox).clear();
    await Hive.box(_medicalRecordsBox).clear();
  }

  // Export all data for backup
  static Future<String> exportAllData() async {
    final activePatientsBox = Hive.box<ActivePatient>(_activePatientsBox);
    final medicalRecordsBox = Hive.box(_medicalRecordsBox);

    final exportData = {
      'activePatients': activePatientsBox.values
          .map((p) => p.toJson())
          .toList(),
      'medicalRecords': medicalRecordsBox.values
          .map((v) => jsonDecode(v))
          .toList(),
      'exportedAt': DateTime.now().toIso8601String(),
    };

    return jsonEncode(exportData);
  }

  // Close Hive
  static Future<void> close() async {
    await Hive.close();
  }
}
