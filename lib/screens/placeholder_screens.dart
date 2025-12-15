// lib/screens/placeholder_screens.dart
import 'package:flutter/material.dart';

// Placeholder for OT List
class OtListPlaceholder extends StatelessWidget {
  const OtListPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.list_alt,
            size: 64,
            color: Colors.blue,
          ),
          SizedBox(height: 16),
          Text(
            'OT List Screen',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Operating Theater list will be displayed here',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// Placeholder for OT Information
class OtInformationPlaceholder extends StatelessWidget {
  const OtInformationPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('OT Information Screen'),
    );
  }
}

// Placeholder for Hand Out Form
class HandOutFormPlaceholder extends StatelessWidget {
  const HandOutFormPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Hand Out Form Screen'),
    );
  }
}

// Placeholder for Preop Assessment
class PreopAssessmentPlaceholder extends StatelessWidget {
  const PreopAssessmentPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Preoperative Assessment Screen'),
    );
  }
}

// Add similar placeholders for other routes...

// Placeholder for Settings
class SettingsPlaceholder extends StatelessWidget {
  const SettingsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Settings Screen'),
    );
  }
}

// Placeholder for Profile
class ProfilePlaceholder extends StatelessWidget {
  const ProfilePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile Screen'),
    );
  }
}

// Placeholder for Not Found
class NotFoundPlaceholder extends StatelessWidget {
  const NotFoundPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          SizedBox(height: 16),
          Text(
            'Screen Not Found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Add similar classes for all your routes...