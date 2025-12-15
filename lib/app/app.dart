// lib/main.dart (or wherever AnesthesiaApp is)
import 'package:flutter/material.dart';
import 'package:my_app/app/app_theme.dart';
import 'package:my_app/app/main_app_layout.dart';

class AnesthesiaApp extends StatelessWidget {
  const AnesthesiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anesthesia Management System',
      theme: AppTheme.lightTheme,
      home: const MainAppLayout(), // Use MainAppLayout as home
      debugShowCheckedModeBanner: false,
    );
  }
}