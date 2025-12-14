import 'package:flutter/material.dart';

class InductionScreen extends StatelessWidget {
  const InductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Induction')),
      body: const Center(child: Text('Induction demo page')),
    );
  }
}
