import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/history/presentation/pages/history_page.dart';
import 'package:frontend/features/history/presentation/blocs/history/history_bloc.dart';
import 'package:frontend/features/history/data/repositories/incident_repository_impl.dart';
import 'package:frontend/features/history/data/repositories/incident_repository_mock.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/config/api_config.dart';

// モックデータ使用フラグ
// true: モックデータを使用（開発・テスト用）
// false: 実APIを使用（本番用）
const bool USE_MOCK_DATA = false;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // リポジトリの初期化
    // USE_MOCK_DATAフラグで切り替え
    final incidentRepository = USE_MOCK_DATA
        ? IncidentRepositoryMock()
        : IncidentRepositoryImpl(
            ApiClient(baseUrl: ApiConfig.baseUrl).dio,
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
