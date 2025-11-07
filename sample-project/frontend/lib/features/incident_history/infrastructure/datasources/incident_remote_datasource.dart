import 'package:dio/dio.dart';
import 'package:mamoai/core/config/api_config.dart';
import 'package:mamoai/features/incident_history/domain/entities/search_criteria.dart';

/// 異常イベントリモートデータソース
class IncidentRemoteDataSource {
  final Dio dio;

  IncidentRemoteDataSource(this.dio) {
    // baseURLを設定
    dio.options.baseUrl = ApiConfig.apiBaseUrl;
    dio.options.connectTimeout = ApiConfig.connectTimeout;
    dio.options.receiveTimeout = ApiConfig.receiveTimeout;

    // ロギングインターセプターの追加（デバッグ用）
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print('[Dio] $obj'),
    ));
  }

  /// 異常イベント一覧を取得
  ///
  /// [criteria] 検索条件（オプション）
  /// 戻り値: List<Map<String, dynamic>>
  Future<List<Map<String, dynamic>>> getIncidents({
    SearchCriteria? criteria,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (criteria != null) {
        if (criteria.personId != null) {
          queryParameters['personId'] = criteria.personId;
        }
        if (criteria.status != null) {
          queryParameters['status'] = criteria.status;
        }
        if (criteria.fromDate != null) {
          queryParameters['from'] = criteria.fromDate!.toIso8601String();
        }
        if (criteria.toDate != null) {
          queryParameters['to'] = criteria.toDate!.toIso8601String();
        }
      }

      final response = await dio.get(
        '/api/v2/incidents',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        // レスポンスが {data: [...], success: true} 形式の場合
        if (data is Map && data.containsKey('data')) {
          final incidentsData = data['data'];
          if (incidentsData == null) {
            return [];
          }
          if (incidentsData is List) {
            return List<Map<String, dynamic>>.from(
              incidentsData.map((item) => item as Map<String, dynamic>),
            );
          }
        }
        
        // レスポンスが直接配列の場合
        if (data is List) {
          return List<Map<String, dynamic>>.from(
            data.map((item) => item as Map<String, dynamic>),
          );
        }
        
        throw Exception('Unexpected response format');
      }
      throw Exception('Failed to load incidents: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Dioエラーをハンドリング
  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout');
      case DioExceptionType.badResponse:
        return Exception('Server error: ${e.response?.statusCode}');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      default:
        return Exception('Network error: ${e.message}');
    }
  }

  /// 異常イベント詳細を取得
  ///
  /// [incidentId] 異常イベントID
  /// 戻り値: Map<String, dynamic>
  Future<Map<String, dynamic>> getIncidentById(String incidentId) async {
    try {
      final response = await dio.get('/api/v2/incidents/$incidentId');

      if (response.statusCode == 200) {
        final data = response.data;
        
        // レスポンスが {data: {...}, success: true} 形式の場合
        if (data is Map && data.containsKey('data')) {
          return data['data'] as Map<String, dynamic>;
        }
        
        // レスポンスが直接オブジェクトの場合
        if (data is Map) {
          return data as Map<String, dynamic>;
        }
        
        throw Exception('Unexpected response format');
      }
      throw Exception('Failed to load incident: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
}
