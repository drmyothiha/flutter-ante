// lib/widgets/anaesthesia_tabs/induction_tab.dart
import 'package:flutter/material.dart';

class InductionTab extends StatefulWidget {
  const InductionTab({super.key});

  @override
  State<InductionTab> createState() => _InductionTabState();
}

class _InductionTabState extends State<InductionTab> {
  final List<Map<String, dynamic>> _inductionSteps = [
    {
      'title': 'Pre-oxygenation',
      'status': 'completed',
      'time': '10:00 AM',
      'details': '100% O2 via face mask for 3 minutes'
    },
    {
      'title': 'Premedication',
      'status': 'completed',
      'time': '10:03 AM',
      'details': 'Midazolam 2mg IV given'
    },
    {
      'title': 'Induction Agents',
      'status': 'in-progress',
      'time': '10:05 AM',
      'details': 'Propofol 150mg + Fentanyl 100mcg'
    },
    {
      'title': 'Muscle Relaxant',
      'status': 'pending',
      'time': '',
      'details': 'Rocuronium 50mg (planned)'
    },
    {
      'title': 'Intubation',
      'status': 'pending',
      'time': '',
      'details': 'ET tube #7.5 with stylet'
    },
    {
      'title': 'Confirmation',
      'status': 'pending',
      'time': '',
      'details': 'Check ETCO2 and bilateral breath sounds'
    },
  ];

  Widget _buildInductionStep(Map<String, dynamic> step, int index) {
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.pending;
    
    switch (step['status']) {
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'in-progress':
        statusColor = Colors.orange;
        statusIcon = Icons.play_circle;
        break;
      case 'pending':
        statusColor = Colors.grey;
        statusIcon = Icons.pending;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: statusColor),
            ),
            child: Center(
              child: Text(
                (index + 1).toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(statusIcon, size: 16, color: statusColor),
                      const SizedBox(width: 8),
                      Text(
                        step['title'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                      const Spacer(),
                      if (step['time'].isNotEmpty)
                        Text(
                          step['time'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    step['details'],
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  if (step['status'] == 'in-progress' || step['status'] == 'pending')
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (step['status'] == 'pending') {
                            step['status'] = 'in-progress';
                            step['time'] = '${DateTime.now().hour}:${DateTime.now().minute} AM';
                          } else if (step['status'] == 'in-progress') {
                            step['status'] = 'completed';
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: statusColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      ),
                      child: Text(
                        step['status'] == 'in-progress' ? 'Mark Complete' : 'Start',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrugAdministration() {
    final List<Map<String, dynamic>> drugs = [
      {'name': 'Propofol', 'dose': '150mg', 'given': true, 'time': '10:05 AM'},
      {'name': 'Fentanyl', 'dose': '100mcg', 'given': true, 'time': '10:05 AM'},
      {'name': 'Rocuronium', 'dose': '50mg', 'given': false, 'time': ''},
      {'name': 'Sevoflurane', 'dose': '2%', 'given': false, 'time': ''},
      {'name': 'Ondansetron', 'dose': '4mg', 'given': false, 'time': ''},
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
                  'Drug Administration',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...drugs.map((drug) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: drug['given'] ? Colors.green[50] : Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: drug['given'] ? Colors.green[200]! : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: drug['given'],
                      onChanged: (value) {
                        setState(() {
                          drug['given'] = value ?? false;
                          if (value == true) {
                            drug['time'] = '${DateTime.now().hour}:${DateTime.now().minute} AM';
                          }
                        });
                      },
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            drug['name'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Dose: ${drug['dose']}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    if (drug['given'] && drug['time'].isNotEmpty)
                      Text(
                        drug['time'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
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

  Widget _buildVitalSigns() {
    final vitals = [
      {'name': 'Heart Rate', 'value': '78', 'unit': 'bpm', 'trend': 'stable'},
      {'name': 'Blood Pressure', 'value': '120/80', 'unit': 'mmHg', 'trend': 'stable'},
      {'name': 'SpO₂', 'value': '98', 'unit': '%', 'trend': 'good'},
      {'name': 'ETCO₂', 'value': '--', 'unit': 'mmHg', 'trend': 'waiting'},
      {'name': 'BIS', 'value': '--', 'unit': '', 'trend': 'waiting'},
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
                Icon(Icons.monitor_heart, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Vital Signs',
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
              childAspectRatio: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: vitals.map((vital) {
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
                        vital['name']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            vital['value']!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (vital['unit']!.isNotEmpty)
                            Text(
                              ' ${vital['unit']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                        ],
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.timeline, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Induction Timeline',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ..._inductionSteps.asMap().entries.map((entry) {
                    return _buildInductionStep(entry.value, entry.key);
                  }).toList(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildDrugAdministration(),
          const SizedBox(height: 16),
          _buildVitalSigns(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}