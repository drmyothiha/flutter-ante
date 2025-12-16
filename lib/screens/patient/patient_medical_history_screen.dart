// lib/screens/patient/patient_medical_history_screen.dart
import 'package:flutter/material.dart';

class PatientMedicalHistoryScreen extends StatelessWidget {
  final Map<String, dynamic>? patientData;

  const PatientMedicalHistoryScreen({
    super.key,
    this.patientData,
  });

  @override
  Widget build(BuildContext context) {
    if (patientData == null) {
      return const Center(
        child: Text('No patient data available'),
      );
    }

    return Scaffold(
      // NO AppBar here - we're inside main content area
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient header (compact version)
            // Container(
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: Colors.blue[50],
            //     borderRadius: BorderRadius.circular(8),
            //     border: Border.all(color: Colors.blue[100]!),
            //   ),
            //   child: Row(
            //     children: [
            //       CircleAvatar(
            //         radius: 24,
            //         backgroundColor: Colors.blue,
            //         child: Text(
            //           patientData!['patientName']?.substring(0, 1) ?? 'P',
            //           style: const TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.bold,
            //             color: Colors.white,
            //           ),
            //         ),
            //       ),
            //       const SizedBox(width: 16),
            //       Expanded(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //               patientData!['patientName'] ?? 'Unknown Patient',
            //               style: const TextStyle(
            //                 fontSize: 18,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //             Text(
            //               'ID: ${patientData!['id'] ?? 'N/A'}',
            //               style: const TextStyle(color: Colors.grey),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            
            // const SizedBox(height: 16),
            
            // Medical history content
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Medical History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Add your medical history content here
                    _buildInfoRow('Procedure', patientData!['procedureCode']),
                    _buildInfoRow('Doctor', patientData!['doctorName']),
                    _buildInfoRow('Date', patientData!['formattedDate']),
                    _buildInfoRow('Time', patientData!['formattedTime']),
                    _buildInfoRow('Status', patientData!['status']),
                  ],
                ),
              ),
            ),
            
            // Add more sections as needed...
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
}