import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/history/presentation/pages/history_page.dart';
import 'package:frontend/features/history/presentation/blocs/history/history_bloc.dart';
import 'package:frontend/features/history/data/repositories/incident_repository_impl.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/config/api_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // APIクライアントの初期化
    final apiClient = ApiClient(
      baseUrl: ApiConfig.baseUrl,
    );

    // リポジトリの初期化（DioインスタンスをApiClientから取得）
    final incidentRepository = IncidentRepositoryImpl(
      apiClient.dio,
    );

    return MaterialApp(
      title: '異常検知履歴システム',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => HistoryBloc(
          incidentRepository: incidentRepository,
        ),
        child: const HistoryPage(),
      ),
    );
  }
}
