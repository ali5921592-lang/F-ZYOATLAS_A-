import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/ai_assistant/presentation/screens/ai_assistant_screen.dart';

void main() {
  runApp(const ProviderScope(child: FizyoAtlasApp()));
}

class FizyoAtlasApp extends StatelessWidget {
  const FizyoAtlasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FizyoAtlas AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D6B)),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D6B),
          brightness: Brightness.dark,
        ),
      ),
      // Şu an tek ekranımız var: AI Fizyo Asistan.
      // Diğer özellikler (Ana Sayfa, Anatomi vb.) eklendikçe
      // burada bir GoRouter ile değiştirilecek.
      home: const AiAssistantScreen(),
    );
  }
}
