import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'app_routes.dart';

class AnesthesiaApp extends StatelessWidget {
  const AnesthesiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anesthesia Management System',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
