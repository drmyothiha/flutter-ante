import 'package:flutter/material.dart';

class ShortcutsScreen extends StatelessWidget {
  const ShortcutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keyboard Shortcuts')),
      body: const Center(child: Text('Keyboard Shortcuts demo page')),
    );
  }
}
