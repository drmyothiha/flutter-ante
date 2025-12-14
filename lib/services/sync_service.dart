// lib/services/sync_service.dart
import 'dart:convert';
import 'package:my_app/models/active_patient_model.dart';
import 'package:my_app/services/local_storage_service.dart';
import 'package:my_app/services/api_service.dart';

class SyncService {
  final ApiService _apiService = ApiService();
  
  Future<void> saveAndSyncPatientData({
    required ActivePatient patient,
    required Map<String, dynamic> medicalData,
  }) async {
    // 1. Prepare complete patient data
    final completeData = {
      'patient': patient.patientData,
      'medicalRecords': medicalData,
      'syncedAt': DateTime.now().toIso8601String(),
    };
    
    // 2. Save locally first (already done when you fill forms)
    
    // 3. Try to sync with server
    try {
      // For now, simulate API call
      // Replace with actual API call
      print('Sending data to server: $completeData');
      
      // Simulate API response
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock successful response
      final response = {
        'success': true,
        'id': 'server-${DateTime.now().millisecondsSinceEpoch}',
        'message': 'Data saved successfully',
      };
      
      if (response['success'] == true) {
        // Mark as synced
        print('Data synced successfully: ${response['id']}');
        
        // In real implementation, update local storage with server ID
        // and mark all records as synced
        
        // For now, just show success
        return;
      } else {
        throw Exception('Server returned error: ${response['message']}');
      }
    } catch (e) {
      print('Sync failed, data saved locally: $e');
      // Data remains in local storage for later sync
      rethrow;
    }
  }
  
  // Sync unsynced records in background
  Future<void> syncUnsyncedRecords() async {
    final unsyncedRecords = LocalStorageService.getUnsyncedRecords();
    
    if (unsyncedRecords.isEmpty) return;
    
    try {
      // Simulate batch sync
      print('Syncing ${unsyncedRecords.length} unsynced records');
      
      // For each unsynced record, try to sync
      for (var record in unsyncedRecords) {
        try {
          // Simulate API call
          await Future.delayed(const Duration(milliseconds: 100));
          
          // Mock success
          final serverId = 'server-${DateTime.now().millisecondsSinceEpoch}';
          
          await LocalStorageService.markRecordAsSynced(
            patientId: record['patientId']?.toString() ?? '',
            recordType: record['recordType']?.toString() ?? '',
            serverId: serverId,
          );
        } catch (e) {
          print('Failed to sync record: $e');
          // Continue with other records
        }
      }
      
      print('Background sync completed');
    } catch (e) {
      print('Background sync failed: $e');
    }
  }
  
  // Check if there are unsynced records
  Future<bool> hasUnsyncedData() async {
    final unsyncedRecords = LocalStorageService.getUnsyncedRecords();
    return unsyncedRecords.isNotEmpty;
  }
}