// lib/widgets/anaesthesia_tabs/preop_tab.dart
import 'package:flutter/material.dart';

class PreopTab extends StatefulWidget {
  const PreopTab({super.key});

  @override
  State<PreopTab> createState() => _PreopTabState();
}

class _PreopTabState extends State<PreopTab> {
  final Map<String, bool> _checklistItems = {
    'Patient Identification Verified': false,
    'Surgical Consent Signed': false,
    'Allergies Confirmed': false,
    'NPO Status Confirmed (>8 hours)': false,
    'IV Access Established': false,
    'Baseline Vital Signs Recorded': false,
    'Medical History Reviewed': false,
    'Lab Results Reviewed': false,
    'Blood Cross-matched': false,
    'Premedication Given': false,
  };

  final Map<String, String> _patientInfo = {
    'ASA Status': 'ASA II',
    'Mallampati Score': 'Class II',
    'Airway Assessment': 'Normal',
    'Cardiac History': 'Hypertension controlled',
    'Respiratory History': 'No issues',
    'Renal Function': 'Normal',
    'Liver Function': 'Normal',
    'Fasting Status': '8 hours',
    'Allergies': 'Penicillin, Sulfa',
    'Medications': 'Metformin, Lisinopril',
  };

  Widget _buildChecklistCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.checklist, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Pre-operative Checklist',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._checklistItems.entries.map((entry) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Checkbox(
                      value: entry.value,
                      onChanged: (value) {
                        setState(() {
                          _checklistItems[entry.key] = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: entry.value ? Colors.black : Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Completed: ${_checklistItems.values.where((v) => v).length}/${_checklistItems.length}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      for (var key in _checklistItems.keys) {
                        _checklistItems[key] = true;
                      }
                    });
                  },
                  child: const Text('Mark All Complete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientInfoCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.person, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Patient Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: _patientInfo.entries.map((entry) {
                return Container(
                  width: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entry.value,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssessmentCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.assessment, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Anaesthesia Assessment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Risk Assessment:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Patient is ASA II with controlled hypertension. Good candidate for general anesthesia.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              'Planned Anaesthesia:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              '• General anesthesia with endotracheal intubation\n'
              '• Standard ASA monitoring plus BIS\n'
              '• Propofol induction, Sevoflurane maintenance\n'
              '• Fentanyl for analgesia\n'
              '• Rocuronium for muscle relaxation',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildChecklistCard(),
          const SizedBox(height: 16),
          _buildPatientInfoCard(),
          const SizedBox(height: 16),
          _buildAssessmentCard(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}