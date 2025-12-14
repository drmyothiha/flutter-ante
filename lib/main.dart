import 'package:flutter/material.dart';
import 'app/app.dart';
import 'package:my_app/services/local_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await LocalStorageService.init();
  runApp(const AnesthesiaApp());
}