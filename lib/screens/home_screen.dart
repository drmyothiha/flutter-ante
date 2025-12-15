// TODO Implement this library.
// lib/screens/home_screen.dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anesthesia Management System')),
      body: const Center(
        child: Text('Welcome to Anesthesia Management System'),
      ),
    );
  }
}
