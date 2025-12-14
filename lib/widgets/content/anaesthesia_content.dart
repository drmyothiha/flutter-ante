import 'package:flutter/material.dart';

class AnaesthesiaContent extends StatelessWidget {
  const AnaesthesiaContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> vitalSignsData = [
      {'parameter': 'ECG(II)', 'values': List.filled(10, 'RSR')},
      {
        'parameter': 'SBP',
        'values': [
          '187',
          '173',
          '165',
          '155',
          '121',
          '114',
          '122',
          '132',
          '137',
          '139',
        ],
      },
      {
        'parameter': 'DBP',
        'values': ['76', '72', '76', '73', '62', '57', '65', '68', '71', '69'],
      },
      {
        'parameter': 'HR',
        'values': ['83', '82', '75', '74', '75', '73', '65', '64', '64', '63'],
      },
      {'parameter': 'SPO2', 'values': List.filled(37, '100')},
      {'parameter': 'ETCO2', 'values': List.filled(37, '')},
      {'parameter': 'CVP', 'values': List.filled(37, '')},
      {
        'parameter': 'BIS',
        'values': ['50', '44', '', '', '', '', '7', '', '', '8'],
      },
      {
        'parameter': 'PR',
        'values': ['12', '11', '', '', '', '', '12', '', '', ''],
      },
      {
        'parameter': 'Body Temp',
        'values': ['35.8', '', '', '', '', '', '', '', '', ''],
      },
    ];

    final timeColumns = [
      '07',
      '00',
      '05',
      '10',
      '15',
      '20',
      '25',
      '30',
      '35',
      '40',
      '45',
      '50',
      '55',
      '08',
      '00',
      '05',
      '10',
      '15',
      '20',
      '25',
      '30',
      '35',
      '40',
      '45',
      '50',
    ];

    return Column(
      children: [
        _buildTableHeader(
          'Vital Signs Timeline',
          'Scroll right to view extended monitoring',
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                const DataColumn(label: SizedBox()),
                const DataColumn(label: Text('Progress\nParameters')),
                const DataColumn(label: Text('Total Unit')),
                ...timeColumns.map((time) => DataColumn(label: Text(time))),
              ],
              rows: vitalSignsData.asMap().entries.map((entry) {
                int index = entry.key;
                var row = entry.value;
                return DataRow(
                  cells: [
                    if (index == 0)
                      const DataCell(
                        SizedBox(height: 40, child: Center(child: Text('V/S'))),
                      )
                    else
                      const DataCell(SizedBox()),
                    DataCell(Text(row['parameter'] as String)),
                    const DataCell(Text('')),
                    ...((row['values'] as List)
                        .take(timeColumns.length)
                        .map<DataCell>(
                          (value) => DataCell(Text(value.toString())),
                        )),
                    ...List.generate(
                      ((timeColumns.length - (row['values'] as List).length) > 0
                          ? timeColumns.length - (row['values'] as List).length
                          : 0),
                      (i) => const DataCell(Text('')),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF5F7FA), Color(0xFFE4E7EB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}