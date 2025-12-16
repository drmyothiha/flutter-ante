// lib/widgets/anaesthesia_tabs/recovery_tab.dart
import 'package:flutter/material.dart';

class RecoveryTab extends StatefulWidget {
  const RecoveryTab({super.key});

  @override
  State<RecoveryTab> createState() => _RecoveryTabState();
}

class _RecoveryTabState extends State<RecoveryTab> {
  bool _extubated = false;
  bool _painControlled = false;
  bool _vitalsStable = false;
  bool _readyForTransfer = false;

  final Map<String, String> _recoveryVitals = {
    'Heart Rate': '82 bpm',
    'Blood Pressure': '118/76 mmHg',
    'SpO₂': '96% on room air',
    'Respiratory Rate': '16/min',
    'Temperature': '36.8°C',
    'Pain Score': '3/10',
  };

  final List<Map<String, dynamic>> _recoveryChecklist = [
    {'item': 'Patient responsive', 'checked': true},
    {'item': 'Airway patent', 'checked': true},
    {'item': 'Breathing spontaneously', 'checked': true},
    {'item': 'Adequate oxygen saturation', 'checked': true},
    {'item': 'Stable hemodynamics', 'checked': true},
    {'item': 'Pain controlled', 'checked': false},
    {'item': 'No nausea/vomiting', 'checked': true},
    {'item': 'Surgical site checked', 'checked': true},
    {'item': 'IV access secure', 'checked': true},
    {'item': 'Discharge orders reviewed', 'checked': false},
  ];

  Widget _buildRecoveryStatus() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.health_and_safety, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Recovery Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildStatusChip('Extubated', _extubated, Icons.air),
                _buildStatusChip('Pain Controlled', _painControlled, Icons.healing),
                _buildStatusChip('Vitals Stable', _vitalsStable, Icons.monitor_heart),
                _buildStatusChip('Ready for Transfer', _readyForTransfer, Icons.transfer_within_a_station),
              ],
            ),
            const SizedBox(height: 16),
            if (_extubated && _painControlled && _vitalsStable && _readyForTransfer)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Patient ready for discharge from recovery',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, bool active, IconData icon) {
    return FilterChip(
      label: Row(
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: active,
      onSelected: (selected) {
        setState(() {
          switch (label) {
            case 'Extubated':
              _extubated = selected;
              break;
            case 'Pain Controlled':
              _painControlled = selected;
              break;
            case 'Vitals Stable':
              _vitalsStable = selected;
              break;
            case 'Ready for Transfer':
              _readyForTransfer = selected;
              break;
          }
        });
      },
      selectedColor: Colors.green[100],
      checkmarkColor: Colors.green,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: active ? Colors.green : Colors.grey[700],
        fontWeight: active ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildVitalSignsCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.monitor_heart, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Recovery Vital Signs',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: _recoveryVitals.entries.map((entry) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          fontSize: 16,
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

  Widget _buildRecoveryChecklist() {
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
                  'Recovery Checklist',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._recoveryChecklist.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Checkbox(
                      value: item['checked'],
                      onChanged: (value) {
                        setState(() {
                          item['checked'] = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        item['item'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: item['checked'] ? Colors.black : Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 16),
            Text(
              'Completed: ${_recoveryChecklist.where((item) => item['checked']).length}/${_recoveryChecklist.length}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationsCard() {
    final medications = [
      {'name': 'Paracetamol', 'dose': '1g', 'route': 'IV', 'time': 'Every 6 hours'},
      {'name': 'Ondansetron', 'dose': '4mg', 'route': 'IV', 'time': 'As needed for nausea'},
      {'name': 'Fentanyl', 'dose': '25mcg', 'route': 'IV', 'time': 'PRN for pain'},
    ];

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.medication, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  'Post-op Medications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...medications.map((med) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.medical_services, color: Colors.purple),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            med['name']!,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${med['dose']} ${med['route']} • ${med['time']}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${med['name']} ${med['dose']} administered'),
                            backgroundColor: Colors.purple,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      ),
                      child: const Text('Give'),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDischargeNotes() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.note, color: Colors.brown),
                SizedBox(width: 8),
                Text(
                  'Discharge Notes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter discharge notes and instructions...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Discharge notes saved'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              icon: const Icon(Icons.save),
              label: const Text('Save Notes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
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
          _buildRecoveryStatus(),
          const SizedBox(height: 16),
          _buildVitalSignsCard(),
          const SizedBox(height: 16),
          _buildRecoveryChecklist(),
          const SizedBox(height: 16),
          _buildMedicationsCard(),
          const SizedBox(height: 16),
          _buildDischargeNotes(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}