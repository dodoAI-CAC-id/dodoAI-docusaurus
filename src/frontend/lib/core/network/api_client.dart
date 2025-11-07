import 'package:dio/dio.dart';

/// APIクライアントの設定クラス
/// 
/// Dioクライアントの設定とインスタンス管理を行います。
/// リトライロジックとエラーハンドリングを含みます。
class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;

  /// リトライ設定
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  /// シングルトンインスタンスを取得
  factory ApiClient({
    required String baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Map<String, dynamic>? headers,
  }) {
    _instance ??= ApiClient._internal(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      headers: headers,
    );
    return _instance!;
  }

  /// 内部コンストラクタ
  ApiClient._internal({
    required String baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Map<String, dynamic>? headers,
  }) {
    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout ?? const Duration(seconds: 30),
      receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
      headers: headers ?? _defaultHeaders(),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    );

    _dio = Dio(options);
    
    // インターセプターの追加
    _dio.interceptors.add(_createLoggingInterceptor());
    _dio.interceptors.add(_createRetryInterceptor());
    _dio.interceptors.add(_createErrorInterceptor());
  }

  /// Dioインスタンスを取得
  Dio get dio => _dio;

  /// デフォルトヘッダー
  Map<String, dynamic> _defaultHeaders() {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  /// ログインターセプターの作成
  Interceptor _createLoggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        print('[API Request] ${options.method} ${options.path}');
        print('[API Request Headers] ${options.headers}');
        if (options.data != null) {
          print('[API Request Data] ${options.data}');
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('[API Response] ${response.statusCode} ${response.requestOptions.path}');
        print('[API Response Data] ${response.data}');
        handler.next(response);
      },
      onError: (error, handler) {
        print('[API Error] ${error.message}');
        print('[API Error Response] ${error.response?.data}');
        handler.next(error);
      },
    );
  }

  /// リトライインターセプターの作成
  Interceptor _createRetryInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        // リトライ可能なエラーかチェック
        if (_shouldRetry(error)) {
          final retryCount = error.requestOptions.extra['retryCount'] as int? ?? 0;
          
          if (retryCount < maxRetries) {
            // リトライカウントを更新
            error.requestOptions.extra['retryCount'] = retryCount + 1;
            
            // 遅延を入れてリトライ
            await Future.delayed(retryDelay * (retryCount + 1));
            
            try {
              print('[API Retry] Attempt ${retryCount + 1}/${maxRetries} for ${error.requestOptions.path}');
              final response = await _dio.fetch(error.requestOptions);
              return handler.resolve(response);
            } catch (e) {
              if (e is DioException) {
                return handler.next(e);
              }
              rethrow;
            }
          }
        }
        
        return handler.next(error);
      },
    );
  }

  /// エラーインターセプターの作成
  Interceptor _createErrorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        // 詳細なエラーログ
        if (error.type == DioExceptionType.connectionTimeout) {
          print('[API Error] Connection timeout for ${error.requestOptions.path}');
        } else if (error.type == DioExceptionType.receiveTimeout) {
          print('[API Error] Receive timeout for ${error.requestOptions.path}');
        } else if (error.type == DioExceptionType.connectionError) {
          print('[API Error] Connection error for ${error.requestOptions.path}');
        }
        
        handler.next(error);
      },
    );
  }

  /// リトライすべきエラーかどうかを判定
  bool _shouldRetry(DioException error) {
    // ネットワークエラーやタイムアウトの場合はリトライ
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError ||
        (error.response?.statusCode != null && 
         (error.response!.statusCode! >= 500 || error.response!.statusCode == 429));
  }

  /// 認証トークンを設定
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// 認証トークンをクリア
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// カスタムヘッダーを追加
  void addHeader(String key, String value) {
    _dio.options.headers[key] = value;
  }

  /// カスタムヘッダーを削除
  void removeHeader(String key) {
    _dio.options.headers.remove(key);
  }
}
