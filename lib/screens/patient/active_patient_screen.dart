// Simple active patient screen
import 'package:flutter/material.dart';
import 'package:my_app/services/local_storage_service.dart';
import 'package:my_app/models/active_patient_model.dart';

class ActivePatientScreen extends StatefulWidget {
  const ActivePatientScreen({super.key});

  @override
  State<ActivePatientScreen> createState() => _ActivePatientScreenState();
}

class _ActivePatientScreenState extends State<ActivePatientScreen> {
  ActivePatient? _activePatient;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadActivePatient();
  }

  void _loadActivePatient() {
    final patient = LocalStorageService.getActivePatient();
    setState(() {
      _activePatient = patient;
      _isLoading = false;
    });
  }

  Widget _buildNoPatientScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.person_outline,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Active Patient',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please select a patient from OT List',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back to OT List'),
          ),
        ],
      ),
    );
  }

  Widget _buildActivePatientScreen() {
    final patientData = _activePatient!.patientData;
    
    return Column(
      children: [
        // Simple Header
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue[50],
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  patientData['patientName']?.substring(0, 1) ?? 'P',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientData['patientName'] ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ID: ${patientData['id'] ?? 'N/A'}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Basic Info Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Patient Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow('Doctor', patientData['doctorName']),
                        _buildInfoRow('Procedure', patientData['procedureCode']),
                        _buildInfoRow('Status', patientData['status']),
                        _buildInfoRow('Date', patientData['formattedDate']),
                        _buildInfoRow('Time', patientData['formattedTime']),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // View Medical History
                      },
                      child: const Text('Medical History'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Anaesthesia Management
                      },
                      child: const Text('Anaesthesia'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? 'N/A',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_activePatient == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Active Patient')),
        body: _buildNoPatientScreen(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Patient'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadActivePatient,
          ),
        ],
      ),
      body: _buildActivePatientScreen(),
    );
  }
}