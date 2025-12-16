// lib/app/main_app_layout.dart (corrected)
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_app/widgets/bottom_panel/bottom_panel.dart';
import 'package:my_app/widgets/header/app_header.dart';
import 'package:my_app/screens/patient/ot_list_screen.dart';
import 'package:my_app/screens/patient/patient_medical_history_screen.dart';
import 'package:my_app/screens/anaesthesia/anaesthesia_management_screen.dart';
import 'package:my_app/app/app_routes.dart';
import 'package:my_app/services/local_storage_service.dart';
import 'package:my_app/services/auth_service.dart';

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
  
  // User info
  String _currentUserName = '';
  String _currentUserRole = '';
  String _currentUserDepartment = '';
  Color _currentUserRoleColor = Colors.grey;
  IconData _currentUserRoleIcon = Icons.person;

  // Track navigation stack
  final List<Map<String, dynamic>> _screenStack = [];

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadActivePatient();
    _startTimer();
    
    _screenStack.add({
      'route': AppRoutes.otList,
      'title': 'OT List',
      'data': null,
    });
  }

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
        _currentPatientName = activePatient.patientData['patientName'] ?? 'Active Patient';
        _currentSurgeonName = activePatient.patientData['doctorName'] ?? 'Surgeon';
        _showActivePatient = true;
      });
    }
  }

  void _handlePatientAction(Map<String, dynamic> patientData, String actionType) async {
    // Check permissions based on action type
    bool hasPermission = false;
    
    switch (actionType) {
      case 'medical-history':
        hasPermission = await AuthService.canAccess('view_patient_history');
        break;
      case 'anaesthesia-management':
        hasPermission = await AuthService.canAccess('manage_anaesthesia');
        break;
    }

    if (!hasPermission) {
      _showPermissionDeniedDialog();
      return;
    }

    setState(() {
      _screenStack.add({
        'route': actionType,
        'title': actionType == 'medical-history' ? 'Medical History' : 'Anaesthesia Management',
        'data': patientData,
      });
      _currentScreen = actionType;
      _screenTitle = actionType == 'medical-history' ? 'Medical History' : 'Anaesthesia Management';
      
      _currentPatientName = patientData['patientName'] ?? 'Viewing Patient';
      _currentSurgeonName = patientData['doctorName'] ?? 'Unknown Surgeon';
      _showActivePatient = false;
    });
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content: Text(
          'Your role ($_currentUserRole) does not have permission to access this feature.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelect(String route) async {
    // Check if user has permission for this menu item
    bool hasPermission = true;
    
    // Define which roles can access which routes
    final Map<String, List<String>> routePermissions = {
      AppRoutes.otList: ['admin', 'doctor', 'nurse'],
      AppRoutes.preopAssessment: ['admin', 'doctor'],
      AppRoutes.induction: ['admin', 'doctor'],
      AppRoutes.maintenance: ['admin', 'doctor'],
      AppRoutes.monitoring: ['admin', 'doctor', 'nurse'],
      AppRoutes.recovery: ['admin', 'doctor', 'nurse'],
      AppRoutes.settings: ['admin'],
      AppRoutes.profile: ['admin', 'doctor', 'nurse'],
    };

    final allowedRoles = routePermissions[route];
    if (allowedRoles != null && !allowedRoles.contains(_currentUserRole)) {
      _showPermissionDeniedDialog();
      return;
    }

    setState(() {
      _screenStack.clear();
      _screenStack.add({
        'route': route,
        'title': _getScreenTitle(route),
        'data': null,
      });
      _currentScreen = route;
      _screenTitle = _getScreenTitle(route);
      
      if (route != AppRoutes.otList) {
        _currentPatientName = 'No Patient Selected';
        _currentSurgeonName = 'No Surgeon';
        _showActivePatient = false;
      } else {
        _loadActivePatient();
      }
    });
  }

  void _handleLogout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await AuthService.logout();
              if (widget.onLogout != null) {
                widget.onLogout!();
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
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

    switch (route) {
      case AppRoutes.otList:
        return OtListScreen(
          onPatientAction: _handlePatientAction,
          userRole: _currentUserRole,
        );
      case 'medical-history':
        return PatientMedicalHistoryScreen(
          patientData: data,
        );
      case 'anaesthesia-management':
        return AnaesthesiaManagementScreen(
          patientData: data,
        );
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
                  if (_screenStack.length > 1)
                    Container(
                      height: 48,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              if (_screenStack.length > 1) {
                                setState(() {
                                  _screenStack.removeLast();
                                  final previousScreen = _screenStack.last;
                                  _currentScreen = previousScreen['route'];
                                  _screenTitle = previousScreen['title'];
                                  
                                  // Reset toolbar if going back to OT List
                                  if (_currentScreen == AppRoutes.otList) {
                                    _loadActivePatient();
                                  } else if (_currentScreen == 'medical-history' || 
                                             _currentScreen == 'anaesthesia-management') {
                                    final screenData = previousScreen['data'];
                                    if (screenData != null) {
                                      _currentPatientName = screenData['patientName'] ?? 'Viewing Patient';
                                      _currentSurgeonName = screenData['doctorName'] ?? 'Unknown Surgeon';
                                      _showActivePatient = false;
                                    }
                                  }
                                });
                              }
                            },
                          ),
                          Text(
                            _screenTitle,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: _buildCurrentScreen(),
                  ),
                ],
              ),
            ),
          ),
          StatusBar(
            currentScreen: _screenTitle,
            lastUpdated: DateTime.now(),
            userRole: _currentUserRole,
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