import 'package:flutter/material.dart';
import 'package:mamoai/features/view_screen/di/view_screen_injection.dart';
import 'package:mamoai/features/view_screen/presentation/pages/view_screen_page_wrapper.dart';

void main() {
  // ViewScreen機能の依存性注入（Mockデータを使用）
  setupViewScreenDependencies(useMockData: true);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MamoAI - ビュー画面',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ViewScreenPageWrapper(),
    );
  }
}
