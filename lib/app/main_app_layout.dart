// lib/app/main_app_layout.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_app/widgets/bottom_panel/bottom_panel.dart';
import 'package:my_app/widgets/header/app_header.dart';
import 'package:my_app/screens/patient/ot_list_screen.dart';
import 'package:my_app/app/app_routes.dart';

class MainAppLayout extends StatefulWidget {
  const MainAppLayout({super.key});

  @override
  State<MainAppLayout> createState() => _MainAppLayoutState();
}

class _MainAppLayoutState extends State<MainAppLayout> {
  String _currentScreen = AppRoutes.otList;
  String _screenTitle = 'OT List';
  DateTime _currentTime = DateTime.now();
  String _currentPatientName = 'No Patient Selected';
  String _currentSurgeonName = 'No Surgeon';

  // Timer to update time
  late Timer _timer;

  final Map<String, Widget> _screenMap = {};

  @override
  void initState() {
    super.initState();
    _initializeScreenMap();
    
    // Update time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  void _initializeScreenMap() {
    _screenMap[AppRoutes.otList] = OtListScreen(
      onPatientSelect: _handlePatientSelect,
    );
    // Initialize other screens here as you create them
  }

  void _handlePatientSelect(Map<String, dynamic> patientData) {
    setState(() {
      _currentPatientName = patientData['patientName'] ?? 'Unknown Patient';
      _currentSurgeonName = patientData['doctorName'] ?? 'Unknown Surgeon';
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${patientData['patientName']} selected as active patient'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  void _handleMenuSelect(String route) {
    setState(() {
      _currentScreen = route;
      _screenTitle = _getScreenTitle(route);
    });
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    print('Notification tapped: ${notification['title']}');
    // Show notification details
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification['title']),
        content: Text(notification['message']),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleSettingsAction(String action) {
    print('Settings action: $action');
    // Handle settings actions
  }

  String _getScreenTitle(String route) {
    final titleMap = {
      AppRoutes.otList: 'OT List',
      AppRoutes.otInformation: 'OT Information',
      AppRoutes.handOutForm: 'Hand Out Form',
      AppRoutes.preopAssessment: 'Preoperative Assessment',
      AppRoutes.induction: 'Induction',
      AppRoutes.maintenance: 'Maintenance',
      AppRoutes.monitoring: 'Monitoring',
      AppRoutes.recovery: 'Recovery',
      AppRoutes.surgeryNotes: 'Surgery Notes',
      AppRoutes.treatments: 'Treatments',
      AppRoutes.whoChecklist: 'WHO Checklist',
      AppRoutes.drugsList: 'Drugs List',
      AppRoutes.settings: 'Settings',
      AppRoutes.profile: 'Profile',
      AppRoutes.display: 'Display Settings',
      AppRoutes.shortcuts: 'Keyboard Shortcuts',
      AppRoutes.about: 'About',
      AppRoutes.logout: 'Logout',
    };
    
    return titleMap[route] ?? 'Unknown Screen';
  }

  Widget _getCurrentScreen() {
    final screen = _screenMap[_currentScreen];
    
    if (screen == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              'Under Construction',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Screen "$_screenTitle" is coming soon!',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    
    return screen;
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // App Header (Static - includes Menu Bar + Toolbar)
          AppHeader(
            onMenuSelect: _handleMenuSelect,
            currentTime: _formatTime(_currentTime),
            patientName: _currentPatientName,
            surgeonName: _currentSurgeonName,
          ),
          
          // Main Content Area (Dynamic)
          Expanded(
            child: Container(
              color: Colors.grey[50],
              child: _getCurrentScreen(),
            ),
          ),
          
          // Status Bar (Static)
          StatusBar(
            currentScreen: _screenTitle,
            lastUpdated: DateTime.now(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}