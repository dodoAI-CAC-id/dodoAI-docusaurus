import 'package:get_it/get_it.dart';
import '../application/usecases/get_incident_items_usecase.dart';
import '../application/usecases/update_incident_status_usecase.dart';
import '../domain/repositories/i_view_screen_repository.dart';
import '../infrastructure/datasources/mock_incident_datasource.dart';
import '../infrastructure/repositories/mock_view_screen_repository.dart';
import '../presentation/blocs/view_screen_bloc/view_screen_bloc.dart';

final getIt = GetIt.instance;

/// ビュー画面機能の依存性注入設定
void setupViewScreenDependencies() {
  // DataSource
  getIt.registerLazySingleton<MockIncidentDataSource>(
    () => MockIncidentDataSource(),
  );

  // Repository
  getIt.registerLazySingleton<IViewScreenRepository>(
    () => MockViewScreenRepository(getIt<MockIncidentDataSource>()),
  );

  // UseCases
  getIt.registerLazySingleton<GetIncidentItemsUseCase>(
    () => GetIncidentItemsUseCase(getIt<IViewScreenRepository>()),
  );

  getIt.registerLazySingleton<UpdateIncidentStatusUseCase>(
    () => UpdateIncidentStatusUseCase(getIt<IViewScreenRepository>()),
  );

  // BLoC
  getIt.registerFactory<ViewScreenBloc>(
    () => ViewScreenBloc(
      getIncidentItemsUseCase: getIt<GetIncidentItemsUseCase>(),
      updateIncidentStatusUseCase: getIt<UpdateIncidentStatusUseCase>(),
      repository: getIt<IViewScreenRepository>(),
    ),
  );
}

/// 依存性注入のクリーンアップ（テスト用）
void cleanupViewScreenDependencies() {
  if (getIt.isRegistered<ViewScreenBloc>()) {
    getIt.unregister<ViewScreenBloc>();
  }
  if (getIt.isRegistered<UpdateIncidentStatusUseCase>()) {
    getIt.unregister<UpdateIncidentStatusUseCase>();
  }
  if (getIt.isRegistered<GetIncidentItemsUseCase>()) {
    getIt.unregister<GetIncidentItemsUseCase>();
  }
  if (getIt.isRegistered<IViewScreenRepository>()) {
    getIt.unregister<IViewScreenRepository>();
  }
  if (getIt.isRegistered<MockIncidentDataSource>()) {
    getIt.unregister<MockIncidentDataSource>();
  }
}
