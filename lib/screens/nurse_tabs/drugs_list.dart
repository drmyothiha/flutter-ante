import 'package:flutter/material.dart';

class DrugsListScreen extends StatelessWidget {
  const DrugsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drugs List')),
      body: const Center(child: Text('Drugs list demo page')),
    );
  }
}
