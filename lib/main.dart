import 'package:amritdhara/screens/report_screen.dart';
import 'package:amritdhara/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import './rainwater_backend/data_fetch.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for async operations
  await initializeCsvData(); // Load CSV data during app startup
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amritdhara',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:  SplashScreen(),
    );
  }
}




