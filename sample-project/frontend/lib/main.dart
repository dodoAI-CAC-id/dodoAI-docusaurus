import 'package:flutter/material.dart';
import 'package:mamoai/features/incident_history/presentation/pages/incident_history_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MamoAI - 履歴画面',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const IncidentHistoryPage(),
    );
  }
}
