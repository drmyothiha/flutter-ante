import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/app/app_routes.dart';
import '../widgets/header/app_header.dart';
import '../widgets/content/content_area.dart';
import '../widgets/sidebar/progress_sidebar.dart';
import '../widgets/bottom_panel/bottom_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _activeTab = 'anaesthesia';
  String _currentTime = '00:00:00';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime = DateFormat('HH:mm:ss').format(now);
    });
  }

  // home_screen.dart
void _handleMenuSelect(String route) {
  // If it's the home route, do nothing (or handle differently)
  if (route == AppRoutes.home) {
    // Already on home page, maybe just close menus
    return;
  }
  
  // Navigate to the selected route
  Navigator.pushNamed(context, route);
}

  void _handleEventAdded(String event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Event Added'),
        content: Text('Event added: $event'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleDrugLogged(String drug) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Drug Logged'),
        content: Text('Drug logged: $drug'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header section with menu and toolbar
          AppHeader(
            onMenuSelect: _handleMenuSelect,
            currentTime: _currentTime,
          ),
          
          // Main content area
          Expanded(
            child: Row(
              children: [
                // Main content (tabs)
                ContentArea(activeTab: _activeTab),
                
                // Sidebar
                const ProgressSidebar(),
              ],
            ),
          ),
          
          // Bottom panel
          BottomPanel(
            onEventAdded: _handleEventAdded,
            onDrugLogged: _handleDrugLogged,
          ),
        ],
      ),
    );
  }
}