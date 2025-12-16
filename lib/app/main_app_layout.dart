// lib/app/main_app_layout.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_app/widgets/bottom_panel/bottom_panel.dart';
import 'package:my_app/widgets/header/app_header.dart';
import 'package:my_app/screens/patient/ot_list_screen.dart';
import 'package:my_app/screens/patient/patient_medical_history_screen.dart';
import 'package:my_app/screens/anaesthesia/anaesthesia_management_screen.dart';
import 'package:my_app/app/app_routes.dart';
import 'package:my_app/services/local_storage_service.dart';
import 'package:my_app/services/auth_service.dart'; // Add this import

class MainAppLayout extends StatefulWidget {
  final VoidCallback? onLogout;

  const MainAppLayout({super.key, this.onLogout});

  @override
  State<MainAppLayout> createState() => _MainAppLayoutState();
}

class _MainAppLayoutState extends State<MainAppLayout> {
  String _currentScreen = AppRoutes.otList;
  String _screenTitle = 'OT List';
  DateTime _currentTime = DateTime.now();
  String _currentPatientName = 'No Patient Selected';
  String _currentSurgeonName = 'No Surgeon';
  bool _showActivePatient = false;

  // User info variables - ADD THESE
  String _currentUserName = 'Loading...';
  String _currentUserRole = 'user';
  String _currentUserDepartment = '';
  Color _currentUserRoleColor = Colors.grey;
  IconData _currentUserRoleIcon = Icons.person;

  // Track navigation stack for back button
  final List<Map<String, dynamic>> _screenStack = [];

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadUserInfo(); // ADD THIS
    _loadActivePatient();
    _startTimer();

    // Initialize with OT List as first screen
    _screenStack.add({
      'route': AppRoutes.otList,
      'title': 'OT List',
      'data': null,
    });
  }

  // ADD THIS METHOD
  void _loadUserInfo() async {
    final user = await AuthService.getCurrentUser();
    if (user != null) {
      setState(() {
        _currentUserName = user.name;
        _currentUserRole = user.role;
        _currentUserDepartment = user.department ?? '';
        _currentUserRoleColor = AuthService.getRoleColor(user.role);
        _currentUserRoleIcon = AuthService.getRoleIcon(user.role);
      });
    }
  }

  void _handlePatientAction(
    Map<String, dynamic> patientData,
    String actionType,
  ) {
    setState(() {
      _screenStack.add({
        'route': actionType, // 'medical-history' or 'anaesthesia-management'
        'title': actionType == 'medical-history'
            ? 'Medical History'
            : 'Anaesthesia Management',
        'data': patientData,
      });
      _currentScreen = actionType;
      _screenTitle = actionType == 'medical-history'
          ? 'Medical History'
          : 'Anaesthesia Management';

      // Update toolbar with patient info
      _currentPatientName = patientData['patientName'] ?? 'Viewing Patient';
      _currentSurgeonName = patientData['doctorName'] ?? 'Unknown Surgeon';
      _showActivePatient = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${actionType == 'medical-history' ? 'Viewing' : 'Managing'} ${patientData['patientName']}',
        ),
        backgroundColor: actionType == 'medical-history'
            ? Colors.blue
            : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  void _loadActivePatient() async {
    final activePatient = LocalStorageService.getActivePatient();
    if (activePatient != null) {
      setState(() {
        _currentPatientName =
            activePatient.patientData['patientName'] ?? 'Active Patient';
        _currentSurgeonName =
            activePatient.patientData['doctorName'] ?? 'Surgeon';
        _showActivePatient = true;
      });
    }
  }

  void _navigateToScreen({
    required String route,
    required String title,
    Map<String, dynamic>? data,
  }) {
    setState(() {
      _screenStack.add({'route': route, 'title': title, 'data': data});
      _currentScreen = route;
      _screenTitle = title;

      // Update toolbar with patient info
      if (data != null) {
        _currentPatientName = data['patientName'] ?? 'Viewing Patient';
        _currentSurgeonName = data['doctorName'] ?? 'Unknown Surgeon';
        _showActivePatient = false;
      }
    });
  }

  void _handleBackNavigation() {
    if (_screenStack.length > 1) {
      setState(() {
        // Remove current screen
        _screenStack.removeLast();

        // Get previous screen
        final previousScreen = _screenStack.last;
        _currentScreen = previousScreen['route'];
        _screenTitle = previousScreen['title'];

        // Reset toolbar if going back to OT List
        if (_currentScreen == AppRoutes.otList) {
          _loadActivePatient(); // Reload active patient
        }
      });
    } else {
      // If only OT List remains, ask to exit app
      _showExitConfirmation();
    }
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Application?'),
        content: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelect(String route) {
    // Special handling for logout
    if (route == AppRoutes.logout) {
      _handleLogout();
      return;
    }

    setState(() {
      // Clear stack and navigate to selected menu item
      _screenStack.clear();
      _screenStack.add({
        'route': route,
        'title': _getScreenTitle(route),
        'data': null,
      });
      _currentScreen = route;
      _screenTitle = _getScreenTitle(route);

      // Reset toolbar for menu navigation
      if (route != AppRoutes.otList) {
        _currentPatientName = 'No Patient Selected';
        _currentSurgeonName = 'No Surgeon';
        _showActivePatient = false;
      } else {
        _loadActivePatient();
      }
    });
  }

  // ADD THIS METHOD
  void _handleLogout() {
    if (widget.onLogout != null) {
      widget.onLogout!();
    }
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
      'medical-history': 'Medical History',
      'anaesthesia-management': 'Anaesthesia Management',
    };

    return titleMap[route] ?? 'Unknown Screen';
  }

  Widget _buildCurrentScreen() {
    final currentScreenData = _screenStack.last;
    final route = currentScreenData['route'];
    final data = currentScreenData['data'];

    // Handle built-in screens
    if (route == AppRoutes.otList) {
      return OtListScreen(
        onPatientAction: _handlePatientAction,
        userRole: _currentUserRole,
      );
    }

    // Handle patient screens
    switch (route) {
      case 'medical-history':
        return PatientMedicalHistoryScreen(patientData: data);
      case 'anaesthesia-management':
        return AnaesthesiaManagementScreen(patientData: data);
      default:
        return _buildUnderConstructionScreen();
    }
  }

  Widget _buildUnderConstructionScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.construction, size: 64, color: Colors.orange),
          const SizedBox(height: 16),
          Text(
            'Under Construction',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Screen "$_screenTitle" is coming soon!',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }

  Widget _buildBackButton() {
    if (_screenStack.length <= 1) return const SizedBox.shrink();

    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: _handleBackNavigation,
      tooltip: 'Back',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppHeader(
            onMenuSelect: _handleMenuSelect,
            currentTime: _formatTime(_currentTime),
            patientName: _currentPatientName,
            surgeonName: _currentSurgeonName,
            isPatientActive: _showActivePatient,
            userName: _currentUserName,
            userRole: _currentUserRole,
            userRoleColor: _currentUserRoleColor,
            userRoleIcon: _currentUserRoleIcon,
            onLogout: _handleLogout,
            userDepartment: _currentUserDepartment,
          ),
          Expanded(
            child: Container(
              color: Colors.grey[50],
              child: Column(
                children: [
                  // Optional: Add a small app bar for back navigation
                  if (_screenStack.length > 1)
                    Container(
                      height: 48,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          _buildBackButton(),
                          Text(
                            _screenTitle,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Screen ${_screenStack.length}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Expanded(child: _buildCurrentScreen()),
                ],
              ),
            ),
          ),
          StatusBar(
            currentScreen: _screenTitle,
            lastUpdated: DateTime.now(),
            userRole: _currentUserRole, // Add this if StatusBar accepts it
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
