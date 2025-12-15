// lib/screens/patient/patient_medical_history_screen.dart
import 'package:flutter/material.dart';

class PatientMedicalHistoryScreen extends StatefulWidget {
  final Map<String, dynamic> patientData;
  final VoidCallback? onBack;

  const PatientMedicalHistoryScreen({
    super.key,
    required this.patientData,
    this.onBack,
  });

  @override
  State<PatientMedicalHistoryScreen> createState() =>
      _PatientMedicalHistoryScreenState();
}

class _PatientMedicalHistoryScreenState
    extends State<PatientMedicalHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove AppBar since MainLayoutScreen already has one
      body: Column(
        children: [
          // Patient header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    if (widget.onBack != null) {
                      widget.onBack!();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                const SizedBox(width: 16),
                CircleAvatar(child: Text(widget.patientData['patientName'][0])),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.patientData['patientName'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ID: ${widget.patientData['id']}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Medical history content here
                  _buildInfoCard(
                    'Procedure',
                    widget.patientData['procedureCode'],
                  ),
                  _buildInfoCard('Diagnosis', widget.patientData['diagnosis']),
                  _buildInfoCard('Doctor', widget.patientData['doctorName']),
                  _buildInfoCard('Date', widget.patientData['appointmentDate']),
                  _buildInfoCard('Time', widget.patientData['appointmentTime']),
                  // Add more medical history sections...
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
