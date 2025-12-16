// lib/screens/anaesthesia/anaesthesia_management_screen.dart
import 'package:flutter/material.dart';

class AnaesthesiaManagementScreen extends StatefulWidget {
  final Map<String, dynamic>? patientData;

  const AnaesthesiaManagementScreen({super.key, this.patientData});

  @override
  State<AnaesthesiaManagementScreen> createState() =>
      _AnaesthesiaManagementScreenState();
}

class _AnaesthesiaManagementScreenState
    extends State<AnaesthesiaManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const List<Tab> _tabs = [
    Tab(text: 'PreOP'),
    Tab(text: 'Induction'),
    Tab(text: 'Timeline'),
    Tab(text: 'Recovery'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  Widget _buildPatientHeader() {
    if (widget.patientData == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        color: Colors.grey[100],
        child: const Row(
          children: [
            Icon(Icons.person, color: Colors.grey),
            SizedBox(width: 12),
            Text('No patient selected'),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue[50],
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue,
            child: Text(
              widget.patientData!['patientName']?.substring(0, 1) ?? 'P',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.patientData!['patientName'] ?? 'Unknown',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Procedure: ${widget.patientData!['procedureCode'] ?? 'N/A'}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Activate patient
            },
            child: const Text('Activate'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          // PreOP Tab
          Container(
            padding: const EdgeInsets.all(16),
            child: const Column(
              children: [
                Text('Pre-operative Assessment'),
                // Add your PreOP content here
              ],
            ),
          ),

          // Induction Tab
          Container(
            padding: const EdgeInsets.all(16),
            child: const Column(
              children: [
                Text('Induction Management'),
                // Add your Induction content here
              ],
            ),
          ),

          // Timeline Tab
          Container(
            padding: const EdgeInsets.all(16),
            child: const Column(
              children: [
                Text('Intraoperative Timeline'),
                // Add your Timeline content here
              ],
            ),
          ),

          // Recovery Tab
          Container(
            padding: const EdgeInsets.all(16),
            child: const Column(
              children: [
                Text('Recovery Management'),
                // Add your Recovery content here
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //_buildPatientHeader(),
        TabBar(
          controller: _tabController,
          tabs: _tabs,
          labelColor: Colors.blue,
          indicatorColor: Colors.blue,
          isScrollable: true,
        ),
        _buildTabContent(),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
