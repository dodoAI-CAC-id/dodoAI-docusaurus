/// API設定
class ApiConfig {
  /// ベースURL（デフォルト）
  static const String baseUrl = 'http://localhost:8080';

  /// 環境変数で切り替え可能なAPIベースURL
  static String get apiBaseUrl {
    const envBaseUrl = String.fromEnvironment('API_BASE_URL');
    return envBaseUrl.isEmpty ? baseUrl : envBaseUrl;
  }

  /// APIバージョン
  static const String apiVersion = 'v2';

  /// 完全なAPIベースURL
  static String get fullApiBaseUrl => '$apiBaseUrl/api/$apiVersion';

  /// タイムアウト設定
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
