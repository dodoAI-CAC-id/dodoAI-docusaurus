---
id: composition-layer
title: Composition Layer
---

# Composition Layer

## 概要

Composition Layerは、DIとルーティング設定を担当します。アプリケーション全体の構成、依存性注入の設定、ルーティング管理、モジュール間の調整を処理します。この層は、アプリケーション起動時の初期化処理を実行し、層間の依存関係を解決します。

## Flutter実装

### ディレクトリ構造
```
lib/
├── app/
│   ├── app.dart
│   ├── app_config.dart
│   ├── app_router.dart
│   └── app_theme.dart
└── modular/
    ├── injection/
    │   ├── injection_container.dart
    │   └── modules/
    │       ├── core_module.dart
    │       ├── network_module.dart
    │       └── feature_modules/
    ├── routing/
    │   ├── app_routes.dart
    │   ├── route_guards.dart
    │   └── route_transitions.dart
    └── config/
        ├── environment_config.dart
        └── feature_flags.dart
```

### 実装ガイドライン

#### 1. 依存性注入

Get_itとInjectableを使用して依存性注入を設定します。

```dart
// modular/injection/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection_container.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async => getIt.init();

Future<void> resetDependencies() async {
  await getIt.reset();
  await configureDependencies();
}

// modular/injection/modules/core_module.dart
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';

@module
abstract class CoreModule {
  @preResolve
  @singleton
  Future<SharedPreferences> get sharedPreferences => 
      SharedPreferences.getInstance();
  
  @singleton
  Connectivity get connectivity => Connectivity();
  
  @preResolve
  @singleton
  Future<void> initHive() async {
    await Hive.initFlutter();
    // Register adapters here
    return;
  }
}

// modular/injection/modules/network_module.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../infrastructure/core/network/network_info.dart';
import '../../config/environment_config.dart';

@module
abstract class NetworkModule {
  @singleton
  Dio provideDio(EnvironmentConfig config) {
    final dio = Dio();
    
    dio.options = BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: Duration(seconds: config.connectionTimeout),
      receiveTimeout: Duration(seconds: config.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    
    if (config.isDevelopment) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }
    
    dio.interceptors.addAll([
      AuthInterceptor(config),
      ErrorInterceptor(),
      RetryInterceptor(),
    ]);
    
    return dio;
  }
}

// modular/injection/modules/feature_modules/product_module.dart
import 'package:injectable/injectable.dart';

import '../../../../features/product/application/usecases/get_product_list_usecase.dart';
import '../../../../features/product/domain/repositories/product_repository.dart';
import '../../../../features/product/infrastructure/datasources/local/product_local_datasource.dart';
import '../../../../features/product/infrastructure/datasources/remote/product_remote_datasource.dart';
import '../../../../features/product/infrastructure/repositories/product_repository_impl.dart';
import '../../../../features/product/presentation/bloc/product_list_bloc.dart';

@module
abstract class ProductModule {
  // Repository
  @Injectable(as: ProductRepository)
  ProductRepositoryImpl productRepository(
    ProductRemoteDataSource remoteDataSource,
    ProductLocalDataSource localDataSource,
    NetworkInfo networkInfo,
    ProductInfrastructureMapper mapper,
  ) => ProductRepositoryImpl(
    remoteDataSource,
    localDataSource,
    networkInfo,
    mapper,
  );
  
  // Use Cases
  @injectable
  GetProductListUseCase getProductListUseCase(
    ProductRepository repository,
  ) => GetProductListUseCase(repository);
  
  // BLoCs
  @injectable
  ProductListBloc productListBloc(
    GetProductListUseCase getProductListUseCase,
  ) => ProductListBloc(getProductListUseCase);
}
```

#### 2. ルーティング設定

Go_routerを使用してルーティングを設定します。

```dart
// modular/routing/app_routes.dart
enum AppRoute {
  splash('/'),
  home('/home'),
  productList('/products'),
  productDetail('/products/:id'),
  cart('/cart'),
  checkout('/checkout'),
  profile('/profile'),
  login('/auth/login'),
  register('/auth/register'),
  settings('/settings');
  
  const AppRoute(this.path);
  final String path;
}

// app/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/product/presentation/pages/product_list_page.dart';
import '../features/product/presentation/pages/product_detail_page.dart';
import '../features/cart/presentation/pages/cart_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../modular/routing/route_guards.dart';
import '../modular/routing/route_transitions.dart';
import '../modular/routing/app_routes.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();
  
  static GoRouter get router => _router;
  
  static final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoute.splash.path,
    debugLogDiagnostics: true,
    redirect: (context, state) => _handleRedirect(context, state),
    routes: [
      // Splash Route
      GoRoute(
        path: AppRoute.splash.path,
        name: AppRoute.splash.name,
        builder: (context, state) => const SplashPage(),
      ),
      
      // Auth Routes
      GoRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginPage(),
          transitionsBuilder: SlideTransition.fromBottom,
        ),
      ),
      
      GoRoute(
        path: AppRoute.register.path,
        name: AppRoute.register.name,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterPage(),
          transitionsBuilder: SlideTransition.fromRight,
        ),
      ),
      
      // Main App Shell
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          // Home
          GoRoute(
            path: AppRoute.home.path,
            name: AppRoute.home.name,
            builder: (context, state) => const HomePage(),
          ),
          
          // Products
          GoRoute(
            path: AppRoute.productList.path,
            name: AppRoute.productList.name,
            builder: (context, state) => const ProductListPage(),
            routes: [
              GoRoute(
                path: '/:id',
                name: AppRoute.productDetail.name,
                builder: (context, state) {
                  final productId = state.pathParameters['id']!;
                  return ProductDetailPage(productId: productId);
                },
              ),
            ],
          ),
          
          // Cart
          GoRoute(
            path: AppRoute.cart.path,
            name: AppRoute.cart.name,
            builder: (context, state) => const CartPage(),
            routes: [
              GoRoute(
                path: '/checkout',
                name: AppRoute.checkout.name,
                builder: (context, state) => const CheckoutPage(),
              ),
            ],
          ),
          
          // Profile
          GoRoute(
            path: AppRoute.profile.path,
            name: AppRoute.profile.name,
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(error: state.error),
  );
  
  static String? _handleRedirect(BuildContext context, GoRouterState state) {
    final authState = context.read<AuthBloc>().state;
    final isLoggedIn = authState.maybeWhen(
      authenticated: (_) => true,
      orElse: () => false,
    );
    
    final isAuthRoute = state.matchedLocation.startsWith('/auth');
    final isSplashRoute = state.matchedLocation == '/';
    
    // Redirect logic
    if (!isLoggedIn && !isAuthRoute && !isSplashRoute) {
      return AppRoute.login.path;
    }
    
    if (isLoggedIn && isAuthRoute) {
      return AppRoute.home.path;
    }
    
    return null; // No redirect needed
  }
}

// modular/routing/route_guards.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import 'app_routes.dart';

class AuthGuard {
  static String? checkAuth(BuildContext context, GoRouterState state) {
    final authState = context.read<AuthBloc>().state;
    final isAuthenticated = authState.maybeWhen(
      authenticated: (_) => true,
      orElse: () => false,
    );
    
    if (!isAuthenticated) {
      return AppRoute.login.path;
    }
    
    return null;
  }
}

class AdminGuard {
  static String? checkAdmin(BuildContext context, GoRouterState state) {
    final authState = context.read<AuthBloc>().state;
    final isAdmin = authState.maybeWhen(
      authenticated: (user) => user.isAdmin,
      orElse: () => false,
    );
    
    if (!isAdmin) {
      return AppRoute.home.path;
    }
    
    return null;
  }
}
```

#### 3. アプリ設定

```dart
// app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/cart/presentation/bloc/cart_bloc.dart';
import '../features/theme/presentation/bloc/theme_bloc.dart';
import 'app_router.dart';
import 'app_theme.dart';
import '../modular/config/environment_config.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => GetIt.instance<AuthBloc>()
            ..add(const AuthEvent.checkAuthStatus()),
        ),
        BlocProvider<CartBloc>(
          create: (context) => GetIt.instance<CartBloc>(),
        ),
        BlocProvider<ThemeBloc>(
          create: (context) => GetIt.instance<ThemeBloc>()
            ..add(const ThemeEvent.loadTheme()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: 'ADF Flutter App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.maybeWhen(
              loaded: (themeMode) => themeMode,
              orElse: () => ThemeMode.system,
            ),
            routerConfig: AppRouter.router,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: 1.0, // Prevent font scaling
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}

// app/app_config.dart
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@singleton
class AppConfig {
  final String appName;
  final String version;
  final String buildNumber;
  final bool isProduction;
  final bool isDevelopment;
  final bool isStaging;
  
  AppConfig({
    required this.appName,
    required this.version,
    required this.buildNumber,
    required this.isProduction,
    required this.isDevelopment,
    required this.isStaging,
  });
  
  factory AppConfig.development() {
    return AppConfig(
      appName: 'ADF App (Dev)',
      version: '1.0.0',
      buildNumber: '1',
      isProduction: false,
      isDevelopment: true,
      isStaging: false,
    );
  }
  
  factory AppConfig.staging() {
    return AppConfig(
      appName: 'ADF App (Staging)',
      version: '1.0.0',
      buildNumber: '1',
      isProduction: false,
      isDevelopment: false,
      isStaging: true,
    );
  }
  
  factory AppConfig.production() {
    return AppConfig(
      appName: 'ADF App',
      version: '1.0.0',
      buildNumber: '1',
      isProduction: true,
      isDevelopment: false,
      isStaging: false,
    );
  }
}

// modular/config/environment_config.dart
import 'package:injectable/injectable.dart';

@singleton
class EnvironmentConfig {
  final String apiBaseUrl;
  final String apiKey;
  final int connectionTimeout;
  final int receiveTimeout;
  final bool enableLogging;
  final bool isDevelopment;
  
  EnvironmentConfig({
    required this.apiBaseUrl,
    required this.apiKey,
    required this.connectionTimeout,
    required this.receiveTimeout,
    required this.enableLogging,
    required this.isDevelopment,
  });
  
  factory EnvironmentConfig.development() {
    return EnvironmentConfig(
      apiBaseUrl: 'https://dev-api.example.com/v1',
      apiKey: 'YOUR_DEV_API_KEY_HERE',
      connectionTimeout: 30,
      receiveTimeout: 30,
      enableLogging: true,
      isDevelopment: true,
    );
  }
  
  factory EnvironmentConfig.production() {
    return EnvironmentConfig(
      apiBaseUrl: 'https://api.example.com/v1',
      apiKey: 'YOUR_PROD_API_KEY_HERE',
      connectionTimeout: 15,
      receiveTimeout: 15,
      enableLogging: false,
      isDevelopment: false,
    );
  }
}
```

#### 4. メインエントリーポイント

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';
import 'modular/injection/injection_container.dart';
import 'modular/config/environment_config.dart';

void main() async {
  await _initializeApp();
  runApp(const MyApp());
}

Future<void> _initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // System UI configuration
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Status bar configuration
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Configure dependencies
  await configureDependencies();
  
  // Initialize environment-specific configurations
  await _initializeEnvironment();
}

Future<void> _initializeEnvironment() async {
  // Register environment config based on build mode
  const environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
  
  late EnvironmentConfig config;
  switch (environment) {
    case 'production':
      config = EnvironmentConfig.production();
      break;
    case 'staging':
      config = EnvironmentConfig.staging();
      break;
    default:
      config = EnvironmentConfig.development();
  }
  
  getIt.registerSingleton<EnvironmentConfig>(config);
}

// main_development.dart
import 'package:flutter/material.dart';
import 'main.dart' as app;

void main() async {
  await app.initializeApp();
  runApp(const app.MyApp());
}

// main_production.dart
import 'package:flutter/material.dart';
import 'main.dart' as app;

void main() async {
  await app.initializeApp();
  runApp(const app.MyApp());
}
```

#### 5. フィーチャーフラグ

```dart
// modular/config/feature_flags.dart
import 'package:injectable/injectable.dart';

@singleton
class FeatureFlags {
  final Map<String, bool> _flags;
  
  FeatureFlags(this._flags);
  
  bool isEnabled(String feature) => _flags[feature] ?? false;
  
  factory FeatureFlags.development() {
    return FeatureFlags({
      'new_product_ui': true,
      'advanced_search': true,
      'social_login': false,
      'push_notifications': true,
      'analytics': false,
    });
  }
  
  factory FeatureFlags.production() {
    return FeatureFlags({
      'new_product_ui': false,
      'advanced_search': true,
      'social_login': true,
      'push_notifications': true,
      'analytics': true,
    });
  }
}

// ウィジェットでの使用例
class ProductListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final featureFlags = GetIt.instance<FeatureFlags>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          if (featureFlags.isEnabled('advanced_search'))
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _showAdvancedSearch(context),
            ),
        ],
      ),
      body: featureFlags.isEnabled('new_product_ui')
          ? const NewProductListView()
          : const LegacyProductListView(),
    );
  }
}
```

## テスト戦略

### 統合テスト

```dart
// test/integration/app_integration_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get_it/get_it.dart';

import 'package:myapp/main.dart' as app;
import 'package:myapp/modular/injection/injection_container.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('App Integration Tests', () {
    setUpAll(() async {
      await configureDependencies();
    });
    
    tearDownAll(() async {
      await GetIt.instance.reset();
    });
    
    testWidgets('should navigate through main user flow', (tester) async {
      await app.main();
      await tester.pumpAndSettle();
      
      // Test splash screen
      expect(find.byType(SplashPage), findsOneWidget);
      
      // Wait for navigation to home
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // Test home page
      expect(find.byType(HomePage), findsOneWidget);
      
      // Navigate to product list
      await tester.tap(find.text('Products'));
      await tester.pumpAndSettle();
      
      expect(find.byType(ProductListPage), findsOneWidget);
    });
  });
}
```

## 重要な注意事項

- 依存性注入の設定は起動時に一度だけ実行する
- ルーティング設定は型安全性を重視する
- 環境別設定を適切に管理する
- フィーチャーフラグを活用して段階的リリースを実現する
- 統合テストで全体の動作を確認する
- パフォーマンスを考慮した初期化処理を実装する
