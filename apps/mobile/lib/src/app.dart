import 'package:flutter/material.dart';

import 'features/dashboard/dashboard_screen.dart';

class StLatexApp extends StatelessWidget {
  const StLatexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StLaTeX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1F7A8C),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF101418),
        cardTheme: const CardThemeData(
          color: Color(0xFF182027),
          margin: EdgeInsets.zero,
        ),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}
