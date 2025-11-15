import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/usecases/get_incident_items_usecase.dart';
import '../../application/usecases/update_incident_status_usecase.dart';
import '../../infrastructure/datasources/mock_incident_datasource.dart';
import '../../infrastructure/repositories/mock_view_screen_repository.dart';
import '../blocs/view_screen_bloc/view_screen_bloc.dart';
import 'view_screen_page.dart';

/// ビュー画面ラッパー（DI設定 + BlocProvider）
class ViewScreenPageWrapper extends StatelessWidget {
  const ViewScreenPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔄 Mockリポジトリを使用（モックデータで動作）
    final dataSource = MockIncidentDataSource();
    final repository = MockViewScreenRepository(dataSource);
    
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
