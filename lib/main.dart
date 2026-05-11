import 'package:flutter/material.dart';
import 'ui/registration_screen.dart';
import 'ui/login_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inmate Connect',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
