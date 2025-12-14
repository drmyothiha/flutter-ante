import 'package:flutter/material.dart';

class RecoveryScreen extends StatelessWidget {
  const RecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recovery')),
      body: const Center(child: Text('Recovery demo page')),
    );
  }
}
