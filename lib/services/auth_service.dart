// lib/services/auth_service.dart (corrected)
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/models/user_model.dart';

class AuthService {
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';
  
  // Demo users database
  static final List<User> _demoUsers = [
    User(
      id: '1',
      name: 'Dr. John Smith',
      email: 'admin@hospital.com',
      role: 'admin',
      department: 'Administration',
      employeeId: 'EMP-001',
    ),
    User(
      id: '2',
      name: 'Dr. Sarah Johnson',
      email: 'doctor@hospital.com',
      role: 'doctor',
      department: 'Anesthesiology',
      employeeId: 'EMP-002',
    ),
    User(
      id: '3',
      name: 'Nurse Emily Davis',
      email: 'nurse@hospital.com',
      role: 'nurse',
      department: 'Operating Room',
      employeeId: 'EMP-003',
    ),
    User(
      id: '4',
      name: 'Dr. Michael Chen',
      email: 'michael@hospital.com',
      role: 'doctor',
      department: 'Surgery',
      employeeId: 'EMP-004',
    ),
    User(
      id: '5',
      name: 'Nurse Robert Wilson',
      email: 'robert@hospital.com',
      role: 'nurse',
      department: 'Recovery',
      employeeId: 'EMP-005',
    ),
  ];

  static Future<bool> login(String email, String password) async {
    // Demo authentication - in real app, this would call an API
    // For demo, any non-empty password works
    
    if (email.isEmpty || password.isEmpty) {
      return false;
    }

    // Find user by email (case insensitive)
    final user = _demoUsers.firstWhere(
      (user) => user.email.toLowerCase() == email.toLowerCase(),
      orElse: () => User(
        id: '',
        name: '',
        email: '',
        role: '',
      ),
    );

    if (user.id.isEmpty) {
      return false;
    }

    // Save user to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    await prefs.setBool(_isLoggedInKey, true);
    
    return true;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    
    if (userJson == null) {
      return null;
    }

    try {
      final userMap = jsonDecode(userJson);
      return User.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getUserRole() async {
    final user = await getCurrentUser();
    return user?.role;
  }

  static Future<String?> getUserName() async {
    final user = await getCurrentUser();
    return user?.name;
  }

  static Future<String?> getUserDepartment() async {
    final user = await getCurrentUser();
    return user?.department;
  }

  static bool hasPermission(String role, List<String> allowedRoles) {
    return allowedRoles.contains(role);
  }

  // Role-based permissions
  static final Map<String, List<String>> _rolePermissions = {
    'admin': [
      'view_ot_list',
      'edit_ot_list',
      'view_patient_history',
      'edit_patient_history',
      'manage_anaesthesia',
      'view_reports',
      'manage_users',
      'manage_settings',
    ],
    'doctor': [
      'view_ot_list',
      'edit_ot_list',
      'view_patient_history',
      'edit_patient_history',
      'manage_anaesthesia',
      'view_reports',
    ],
    'nurse': [
      'view_ot_list',
      'view_patient_history',
      'view_reports',
    ],
  };

  static Future<bool> canAccess(String permission) async {
    final user = await getCurrentUser();
    if (user == null) return false;
    
    final userPermissions = _rolePermissions[user.role] ?? [];
    return userPermissions.contains(permission);
  }

  // Get role display name
  static String getRoleDisplayName(String role) {
    switch (role) {
      case 'admin':
        return 'Administrator';
      case 'doctor':
        return 'Doctor';
      case 'nurse':
        return 'Nurse';
      default:
        return 'User';
    }
  }

  // Get role icon
  static IconData getRoleIcon(String role) {
    switch (role) {
      case 'admin':
        return Icons.admin_panel_settings;
      case 'doctor':
        return Icons.medical_services;
      case 'nurse':
        return Icons.health_and_safety;
      default:
        return Icons.person;
    }
  }

  // Get role color
  static Color getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.purple;
      case 'doctor':
        return Colors.blue;
      case 'nurse':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}