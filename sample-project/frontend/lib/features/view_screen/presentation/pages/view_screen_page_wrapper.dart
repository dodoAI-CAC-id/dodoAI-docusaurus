import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../application/usecases/get_incident_items_usecase.dart';
import '../../application/usecases/update_incident_status_usecase.dart';
import '../../infrastructure/datasources/view_screen_remote_datasource.dart';
import '../../infrastructure/repositories/view_screen_repository.dart';
import '../blocs/view_screen_bloc/view_screen_bloc.dart';
import 'view_screen_page.dart';
import 'package:mamoai/core/config/api_config.dart';

/// ビュー画面ラッパー（DI設定 + BlocProvider）
class ViewScreenPageWrapper extends StatelessWidget {
  const ViewScreenPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // 🌐 実APIリポジトリを使用（バックエンドAPIと通信）
    final dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
    
    final dataSource = ViewScreenRemoteDataSource(dio);
    final repository = ViewScreenRepository(dataSource);
    
    final getIncidentItemsUseCase = GetIncidentItemsUseCase(repository);
    final updateIncidentStatusUseCase = UpdateIncidentStatusUseCase(repository);

    return BlocProvider(
      create: (context) => ViewScreenBloc(
        getIncidentItemsUseCase: getIncidentItemsUseCase,
        updateIncidentStatusUseCase: updateIncidentStatusUseCase,
        repository: repository,
      ),
      child: const ViewScreenPage(),
    );
  }
}
