// lib/models/user_model.dart
class User {
  final String id;
  final String name;
  final String email;
  final String role; // 'admin', 'doctor', 'nurse'
  final String? department;
  final String? employeeId;
  final bool isActive;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.department,
    this.employeeId,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'department': department,
      'employeeId': employeeId,
      'isActive': isActive,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      department: json['department'],
      employeeId: json['employeeId'],
      isActive: json['isActive'] ?? true,
    );
  }
}