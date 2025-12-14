import 'package:flutter/material.dart';

class MonitoringScreen extends StatelessWidget {
  const MonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monitoring')),
      body: const Center(child: Text('Monitoring demo page')),
    );
  }
}
