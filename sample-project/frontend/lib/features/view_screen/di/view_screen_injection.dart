import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../application/usecases/get_incident_items_usecase.dart';
import '../application/usecases/update_incident_status_usecase.dart';
import '../domain/repositories/i_view_screen_repository.dart';
import '../infrastructure/datasources/mock_incident_datasource.dart';
import '../infrastructure/datasources/view_screen_remote_datasource.dart';
import '../infrastructure/repositories/mock_view_screen_repository.dart';
import '../infrastructure/repositories/view_screen_repository.dart';
import '../presentation/blocs/view_screen_bloc/view_screen_bloc.dart';

final getIt = GetIt.instance;

/// ビュー画面機能の依存性注入設定
/// 
/// [useMockData] trueの場合はMockデータを使用、falseの場合はRemote APIを使用
void setupViewScreenDependencies({bool useMockData = false}) {
  if (useMockData) {
    _setupMockDependencies();
  } else {
    _setupRemoteDependencies();
  }

  // UseCases（共通）
  getIt.registerLazySingleton<GetIncidentItemsUseCase>(
    () => GetIncidentItemsUseCase(getIt<IViewScreenRepository>()),
  );

  getIt.registerLazySingleton<UpdateIncidentStatusUseCase>(
    () => UpdateIncidentStatusUseCase(getIt<IViewScreenRepository>()),
  );

  // BLoC（共通）
  getIt.registerFactory<ViewScreenBloc>(
    () => ViewScreenBloc(
      getIncidentItemsUseCase: getIt<GetIncidentItemsUseCase>(),
      updateIncidentStatusUseCase: getIt<UpdateIncidentStatusUseCase>(),
      repository: getIt<IViewScreenRepository>(),
    ),
  );
}

/// Mock実装の依存性注入
void _setupMockDependencies() {
  // DataSource
  getIt.registerLazySingleton<MockIncidentDataSource>(
    () => MockIncidentDataSource(),
  );

  // Repository
  getIt.registerLazySingleton<IViewScreenRepository>(
    () => MockViewScreenRepository(getIt<MockIncidentDataSource>()),
  );
}

/// Remote実装の依存性注入
void _setupRemoteDependencies() {
  // Dio instance
  if (!getIt.isRegistered<Dio>()) {
    final dio = Dio();
    // baseURLを設定
    dio.options.baseUrl = 'http://localhost:8080'; // TODO: ApiConfig.apiBaseUrlから取得
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    
    // ロギングインターセプターの追加（デバッグ用）
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print('[Dio] $obj'),
    ));
    
    getIt.registerLazySingleton<Dio>(() => dio);
  }

  // DataSource
  getIt.registerLazySingleton<ViewScreenRemoteDataSource>(
    () => ViewScreenRemoteDataSource(getIt<Dio>()),
  );

  // Repository
  getIt.registerLazySingleton<IViewScreenRepository>(
    () => ViewScreenRepository(getIt<ViewScreenRemoteDataSource>()),
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
