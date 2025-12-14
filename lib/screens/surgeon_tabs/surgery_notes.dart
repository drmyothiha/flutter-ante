import 'package:flutter/material.dart';

class SurgeryNotesScreen extends StatelessWidget {
  const SurgeryNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Surgery Notes')),
      body: const Center(child: Text('Surgery notes demo page')),
    );
  }
}
