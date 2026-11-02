
import 'package:flutter/material.dart';
import 'screens/cipher_screen.dart';

void main() {
  runApp(const CipherLabApp());
}

class CipherLabApp extends StatelessWidget {
  const CipherLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CipherLab',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B1020),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF818CF8),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Arial',
      ),
      home: const CipherScreen(),
    );
  }
}
