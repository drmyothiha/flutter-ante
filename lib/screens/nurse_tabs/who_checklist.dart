import 'package:flutter/material.dart';

class WhoChecklistScreen extends StatelessWidget {
  const WhoChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WHO Checklist')),
      body: const Center(child: Text('WHO checklist demo page')),
    );
  }
}
