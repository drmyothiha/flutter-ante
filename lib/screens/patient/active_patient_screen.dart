// lib/screens/active_patient_screen.dart
import 'package:flutter/material.dart';
import 'package:my_app/models/active_patient_model.dart';
import 'package:my_app/services/local_storage_service.dart';
import 'package:my_app/services/sync_service.dart';

class ActivePatientScreen extends StatefulWidget {
  final Map<String, dynamic> patientData;
  
  const ActivePatientScreen({super.key, required this.patientData});

  @override
  State<ActivePatientScreen> createState() => _ActivePatientScreenState();
}

class _ActivePatientScreenState extends State<ActivePatientScreen> {
  late ActivePatient _activePatient;
  final SyncService _syncService = SyncService();
  
  // Form controllers
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, dynamic> _medicalData = {
    'preop': {},
    'intraop': {},
    'postop': {},
    'checklists': {},
  };

  @override
  void initState() {
    super.initState();
    
    // Create ActivePatient from data
    _activePatient = ActivePatient(
      patientId: widget.patientData['id']?.toString() ?? 'unknown',
      patientData: widget.patientData,
      activatedAt: DateTime.now(),
      isSynced: false,
    );
    
    // Load existing medical data
    _loadExistingData();
  }

  void _loadExistingData() {
    // Load pre-existing medical records for this patient
    final recordTypes = ['preop', 'intraop', 'postop'];
    
    for (var type in recordTypes) {
      final record = LocalStorageService.getMedicalRecord(
        patientId: _activePatient.patientId,
        recordType: type,
      );
      
      if (record != null) {
        _medicalData[type] = record['data'] ?? {};
      }
    }
  }

  void _saveMedicalRecord(String recordType) {
    final data = _medicalData[recordType];
    
    if (data != null && data.isNotEmpty) {
      LocalStorageService.saveMedicalRecord(
        patientId: _activePatient.patientId,
        recordType: recordType,
        data: data,
      );
    }
  }

  Future<void> _syncToServer() async {
    try {
      // Create a medical record map to pass to sync service
      final medicalRecords = {
        'preop': _medicalData['preop'],
        'intraop': _medicalData['intraop'],
        'postop': _medicalData['postop'],
        'checklists': _medicalData['checklists'],
      };
      
      await _syncService.saveAndSyncPatientData(
        patient: _activePatient,
        medicalData: medicalRecords,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data saved and synced successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Save failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildPatientHeader() {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _activePatient.patientName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Patient ID: ${_activePatient.patientId}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                Chip(
                  label: Text(
                    _activePatient.statusText,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: _activePatient.statusColor,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 20,
              runSpacing: 10,
              children: [
                _buildInfoItem('👨‍⚕️ Doctor', _activePatient.doctorName),
                _buildInfoItem('🏥 Location', _activePatient.location ?? 'N/A'),
                _buildInfoItem('📅 Date', _activePatient.formattedDate),
                _buildInfoItem('⏰ Time', _activePatient.formattedTime),
                _buildInfoItem('🩺 Diagnosis', _activePatient.diagnosis),
                _buildInfoItem('🔧 Procedure', _activePatient.procedureCode),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.grey),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _syncToServer,
                    icon: const Icon(Icons.save),
                    label: const Text('Save & Sync to Server'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    // Export patient data
                    _exportPatientData();
                  },
                  icon: const Icon(Icons.download),
                  tooltip: 'Export Data',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalSection(String title, String recordType) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        initiallyExpanded: recordType == 'preop',
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildMedicalForm(recordType, title),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalForm(String recordType, String sectionTitle) {
    // Define form fields based on record type
    final fields = _getFieldsForRecordType(recordType);
    
    return Column(
      children: [
        ...fields.map((field) {
          final fieldKey = field['key'] ?? 'unknown';
          final fieldLabel = field['label'] ?? 'Unknown Field';
          final currentValue = _medicalData[recordType][fieldKey] ?? '';
          
          final controller = _controllers[fieldKey] ??= TextEditingController(
            text: currentValue.toString(),
          );
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: fieldLabel,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                _medicalData[recordType][fieldKey] = value;
              },
            ),
          );
        }).toList(),
        
        const SizedBox(height: 16),
        
        ElevatedButton(
          onPressed: () {
            _saveMedicalRecord(recordType);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$sectionTitle saved locally'),
                backgroundColor: Colors.blue,
              ),
            );
          },
          child: const Text('Save Locally'),
        ),
      ],
    );
  }

  List<Map<String, String>> _getFieldsForRecordType(String recordType) {
    switch (recordType) {
      case 'preop':
        return [
          {'key': 'bp', 'label': 'Blood Pressure'},
          {'key': 'hr', 'label': 'Heart Rate'},
          {'key': 'temp', 'label': 'Temperature'},
          {'key': 'spo2', 'label': 'SpO₂'},
          {'key': 'allergies', 'label': 'Allergies'},
          {'key': 'medications', 'label': 'Current Medications'},
          {'key': 'notes', 'label': 'Pre-op Notes'},
        ];
      case 'intraop':
        return [
          {'key': 'anesthesia_type', 'label': 'Anesthesia Type'},
          {'key': 'medications_administered', 'label': 'Medications Administered'},
          {'key': 'vitals_monitoring', 'label': 'Vitals Monitoring'},
          {'key': 'events', 'label': 'Significant Events'},
          {'key': 'fluids', 'label': 'IV Fluids'},
          {'key': 'blood_loss', 'label': 'Estimated Blood Loss'},
          {'key': 'urine_output', 'label': 'Urine Output'},
        ];
      case 'postop':
        return [
          {'key': 'recovery_time', 'label': 'Recovery Time'},
          {'key': 'pain_score', 'label': 'Pain Score (0-10)'},
          {'key': 'complications', 'label': 'Complications'},
          {'key': 'disposition', 'label': 'Disposition'},
          {'key': 'instructions', 'label': 'Post-op Instructions'},
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Patient'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Show patient history
              _showPatientHistory();
            },
            tooltip: 'Patient History',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPatientHeader(),
            
            // Medical Sections
            _buildMedicalSection('Pre-operative Assessment', 'preop'),
            _buildMedicalSection('Intra-operative Record', 'intraop'),
            _buildMedicalSection('Post-operative Record', 'postop'),
            
            // Checklists Section
            _buildChecklistsSection(),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistsSection() {
    final checklists = [
      {'title': 'WHO Surgical Safety', 'key': 'who'},
      {'title': 'Anesthesia Machine Check', 'key': 'machine'},
      {'title': 'Medication Verification', 'key': 'meds'},
      {'title': 'Patient Identification', 'key': 'patient_id'},
    ];
    
    return Card(
      margin: const EdgeInsets.all(8),
      child: ExpansionTile(
        title: const Text(
          'Safety Checklists',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: checklists.map((checklist) {
                final key = checklist['key'] ?? 'unknown';
                final checklistTitle = checklist['title'] ?? 'Unknown Checklist';
                final isChecked = _medicalData['checklists'][key] ?? false;
                
                return CheckboxListTile(
                  title: Text(checklistTitle),
                  value: isChecked as bool,
                  onChanged: (value) {
                    setState(() {
                      _medicalData['checklists'][key] = value;
                      // Auto-save checklists
                      LocalStorageService.saveMedicalRecord(
                        patientId: _activePatient.patientId,
                        recordType: 'checklist-$key',
                        data: {'checked': value, 'timestamp': DateTime.now()},
                      );
                    });
                  },
                  secondary: Icon(
                    isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: isChecked ? Colors.green : Colors.grey,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showPatientHistory() {
    final history = LocalStorageService.getActivePatientHistory();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recently Active Patients'),
        content: SizedBox(
          width: double.maxFinite,
          child: history.isEmpty
              ? const Center(child: Text('No patient history found'))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final patient = history[index];
                    return ListTile(
                      title: Text(patient.patientName),
                      subtitle: Text(patient.formattedDate),
                      trailing: patient.patientId == _activePatient.patientId
                          ? const Chip(
                              label: Text('Current'),
                              backgroundColor: Colors.blue,
                              labelStyle: TextStyle(color: Colors.white),
                            )
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        // Switch to this patient
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActivePatientScreen(
                              patientData: patient.patientData,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportPatientData() async {
    try {
      final exportData = {
        'patient': _activePatient.toJson(),
        'medicalRecords': _medicalData,
        'exportedAt': DateTime.now().toIso8601String(),
      };
      
      // You can implement export functionality here
      // For example, save to file, share, etc.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Patient data prepared for export'),
          backgroundColor: Colors.blue,
        ),
      );
      
      print('Export Data: $exportData');
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}