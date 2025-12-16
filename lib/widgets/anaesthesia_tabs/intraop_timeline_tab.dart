// lib/widgets/anaesthesia_tabs/intraop_timeline_tab.dart
import 'package:flutter/material.dart';

class IntraopTimelineTab extends StatefulWidget {
  const IntraopTimelineTab({super.key});

  @override
  State<IntraopTimelineTab> createState() => _IntraopTimelineTabState();
}

class _IntraopTimelineTabState extends State<IntraopTimelineTab> {
  final List<Map<String, dynamic>> _timelineEvents = [
    {
      'time': '10:00',
      'title': 'Pre-oxygenation',
      'type': 'anaesthesia',
      'completed': true,
    },
    {
      'time': '10:03',
      'title': 'Induction started',
      'type': 'anaesthesia',
      'completed': true,
    },
    {
      'time': '10:05',
      'title': 'Intubation',
      'type': 'anaesthesia',
      'completed': true,
    },
    {
      'time': '10:10',
      'title': 'Surgical time-out',
      'type': 'surgery',
      'completed': true,
    },
    {
      'time': '10:15',
      'title': 'Incision',
      'type': 'surgery',
      'completed': true,
    },
    {
      'time': '10:30',
      'title': 'Paracetamol 1g IV',
      'type': 'medication',
      'completed': true,
    },
    {
      'time': '10:45',
      'title': 'Blood loss 150ml',
      'type': 'monitoring',
      'completed': true,
    },
    {
      'time': '11:00',
      'title': 'Current Time',
      'type': 'current',
      'completed': false,
    },
    {
      'time': '11:30',
      'title': 'Surgical closure',
      'type': 'surgery',
      'completed': false,
    },
    {
      'time': '11:45',
      'title': 'Emergence',
      'type': 'anaesthesia',
      'completed': false,
    },
  ];

  Color _getEventColor(String type) {
    switch (type) {
      case 'anaesthesia':
        return Colors.blue;
      case 'surgery':
        return Colors.green;
      case 'medication':
        return Colors.purple;
      case 'monitoring':
        return Colors.orange;
      case 'current':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getEventIcon(String type) {
    switch (type) {
      case 'anaesthesia':
        return Icons.medical_services;
      case 'surgery':
        return Icons.cut;
      case 'medication':
        return Icons.medication;
      case 'monitoring':
        return Icons.monitor_heart;
      case 'current':
        return Icons.access_time;
      default:
        return Icons.event;
    }
  }

  Widget _buildTimelineEvent(Map<String, dynamic> event, int index) {
    final isCompleted = event['completed'] as bool;
    final isCurrent = event['type'] == 'current';
    final eventColor = _getEventColor(event['type']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time column
          SizedBox(
            width: 60,
            child: Text(
              event['time'] as String,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isCurrent ? Colors.red : Colors.black,
              ),
            ),
          ),
          
          // Timeline connector
          Column(
            children: [
              Container(
                width: 2,
                height: 20,
                color: isCompleted ? eventColor : Colors.grey[300],
              ),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: isCurrent ? Colors.red : (isCompleted ? eventColor : Colors.white),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCurrent ? Colors.red : (isCompleted ? eventColor : Colors.grey[300]!),
                    width: isCurrent ? 3 : 2,
                  ),
                ),
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        size: 10,
                        color: Colors.white,
                      )
                    : null,
              ),
              if (index < _timelineEvents.length - 1)
                Container(
                  width: 2,
                  height: 20,
                  color: isCompleted ? eventColor : Colors.grey[300],
                ),
            ],
          ),
          
          // Event details
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCurrent 
                    ? Colors.red[50] 
                    : (isCompleted ? eventColor.withOpacity(0.1) : Colors.grey[50]),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isCurrent 
                      ? Colors.red[200]! 
                      : (isCompleted ? eventColor.withOpacity(0.3) : Colors.grey[300]!),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getEventIcon(event['type']),
                    size: 18,
                    color: isCurrent ? Colors.red : eventColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['title'] as String,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isCurrent ? Colors.red : eventColor,
                          ),
                        ),
                        if (isCurrent)
                          const SizedBox(height: 4),
                        if (isCurrent)
                          const Text(
                            'Currently in progress',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (isCurrent)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          event['completed'] = true;
                          final now = DateTime.now();
                          final hour = now.hour;
                          final minute = now.minute.toString().padLeft(2, '0');
                          final currentTime = '$hour:$minute';
                          
                          _timelineEvents.insert(index + 1, {
                            'time': currentTime,
                            'title': 'Current Time',
                            'type': 'current',
                            'completed': false,
                          });
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      ),
                      child: const Text('Complete'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalSignsChart() {
    return Card(
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
                  'Vital Signs Trend',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Column(
                children: [
                  // Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildLegendItem('HR', Colors.red),
                      _buildLegendItem('BP', Colors.blue),
                      _buildLegendItem('SpO₂', Colors.green),
                      _buildLegendItem('ETCO₂', Colors.purple),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Chart placeholder
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.show_chart, size: 48, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              'Real-time monitoring chart',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
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

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    // Define quick actions with proper typing
    final List<Map<String, dynamic>> quickActions = [
      {'icon': Icons.add_alert, 'label': 'Add Alert', 'color': Colors.orange},
      {'icon': Icons.medication, 'label': 'Give Drug', 'color': Colors.purple},
      {'icon': Icons.water_drop, 'label': 'IV Fluids', 'color': Colors.blue},
      {'icon': Icons.note_add, 'label': 'Add Note', 'color': Colors.green},
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
                Icon(Icons.flash_on, color: Colors.amber),
                SizedBox(width: 8),
                Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: quickActions.map((action) {
                final color = action['color'] as Color;
                final icon = action['icon'] as IconData;
                final label = action['label'] as String;
                
                return Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: color.withOpacity(0.3)),
                      ),
                      child: IconButton(
                        icon: Icon(icon, color: color),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$label action triggered'),
                              backgroundColor: color,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimplePlaceholder() {
    return Card(
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
                  'Intraoperative Timeline',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Column(
                children: [
                  Icon(Icons.timeline, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Intraoperative Timeline',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Real-time surgical timeline with events and monitoring',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Add Alert'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  },
                  child: const Text('Add Alert'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Add Medication'),
                        backgroundColor: Colors.purple,
                      ),
                    );
                  },
                  child: const Text('Add Medication'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Add Note'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text('Add Note'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalSignsPlaceholder() {
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
                  'Vital Signs Monitor',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.monitor_heart, size: 48, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      'Heart Rate: 78 bpm',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Blood Pressure: 120/80 mmHg',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'SpO₂: 98%',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
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
          // Simple placeholder version - uncomment this for basic version
          // _buildSimplePlaceholder(),
          
          // Or use the full version below:
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
                        'Intraoperative Timeline',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ..._timelineEvents.asMap().entries.map((entry) {
                    return _buildTimelineEvent(entry.value, entry.key);
                  }).toList(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildVitalSignsChart(),
          const SizedBox(height: 16),
          _buildQuickActions(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}