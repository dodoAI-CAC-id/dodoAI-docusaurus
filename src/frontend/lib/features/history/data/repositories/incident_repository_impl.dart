import 'package:dio/dio.dart';
import 'package:frontend/features/history/domain/repositories/i_incident_repository.dart';
import 'package:frontend/features/history/domain/entities/incident.dart';
import 'package:frontend/features/history/data/models/incident_dto.dart';
import 'package:frontend/core/network/api_exceptions.dart';

/// インシデントリポジトリの実装
/// 
/// IIncidentRepositoryインターフェースの実装クラス。
/// DioクライアントでAPI通信を行い、インシデント情報を取得します。
class IncidentRepositoryImpl implements IIncidentRepository {
  final Dio _dio;

  IncidentRepositoryImpl(this._dio);

  @override
  Future<List<Incident>> fetchIncidents({
    int limit = 20,
    int offset = 0,
    String orderBy = 'detectedAt',
    bool descending = true,
  }) async {
    try {
      final response = await _dio.get(
        '/api/v2/incidents',
      );
      
      // BackEndのレスポンス形式: {"success": true, "data": [...]}
      final responseData = response.data as Map<String, dynamic>;
      final dataList = responseData['data'] as List<dynamic>?;
      
      // データが存在しない場合は空のリストを返す
      if (dataList == null) {
        return [];
      }
      
      final incidents = dataList
          .map((json) => IncidentDTO.fromJson(json as Map<String, dynamic>))
          .map((dto) => dto.toEntity())
          .toList();
      
      return incidents;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw InvalidResponseException(
        message: 'Failed to parse incidents data: $e',
        originalException: e,
      );
    }
  }

  @override
  Future<Incident> fetchIncidentById(String id) async {
    try {
      final response = await _dio.get('/api/v2/incidents/$id');
      
      // BackEndのレスポンス形式: {"success": true, "data": {...}}
      final responseData = response.data as Map<String, dynamic>;
      final data = responseData['data'] as Map<String, dynamic>;
      final incidentDto = IncidentDTO.fromJson(data);
      
      return incidentDto.toEntity();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw InvalidResponseException(
        message: 'Failed to parse incident data: $e',
        originalException: e,
      );
    }
  }

  @override
  Future<List<Incident>> searchIncidents({
    DateTime? startDate,
    DateTime? endDate,
    String? roomNumber,
    String? bedNumber,
    String? residentName,
    String? performedBy,
    String? detectionType,
    IncidentStatus? status,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      // API仕様書に従い、GETクエリパラメータで検索
      final queryParams = <String, dynamic>{};
      
      if (startDate != null) queryParams['from'] = startDate.toIso8601String();
      if (endDate != null) queryParams['to'] = endDate.toIso8601String();
      if (status != null) queryParams['status'] = _statusToString(status);
      // personId でフィルタするため、residentName は現在未対応
      // その他のフィルタ条件も現在のAPI仕様書には含まれていない

      final response = await _dio.get(
        '/api/v2/incidents',
        queryParameters: queryParams,
      );
      
      // BackEndのレスポンス形式: {"success": true, "data": [...]}
      final responseData = response.data as Map<String, dynamic>;
      final dataList = responseData['data'] as List<dynamic>?;
      
      // データが存在しない場合は空のリストを返す
      if (dataList == null) {
        return [];
      }
      
      final incidents = dataList
          .map((json) => IncidentDTO.fromJson(json as Map<String, dynamic>))
          .map((dto) => dto.toEntity())
          .toList();
      
      return incidents;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw InvalidResponseException(
        message: 'Failed to parse search results: $e',
        originalException: e,
      );
    }
  }

  @override
  Future<int> countIncidents() async {
    try {
      // API仕様書にcountエンドポイントがないため、
      // 全件取得してカウントする（実際の運用ではAPI追加が必要）
      final response = await _dio.get('/api/v2/incidents');
      final responseData = response.data as Map<String, dynamic>;
      final dataList = responseData['data'] as List<dynamic>?;
      return dataList?.length ?? 0;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw InvalidResponseException(
        message: 'Failed to get incidents count: $e',
        originalException: e,
      );
    }
  }

  @override
  Future<int> countSearchResults({
    DateTime? startDate,
    DateTime? endDate,
    String? roomNumber,
    String? bedNumber,
    String? residentName,
    String? performedBy,
    String? detectionType,
    IncidentStatus? status,
  }) async {
    try {
      // API仕様書にcountエンドポイントがないため、
      // 検索結果を取得してカウントする（実際の運用ではAPI追加が必要）
      final queryParams = <String, dynamic>{};
      
      if (startDate != null) queryParams['from'] = startDate.toIso8601String();
      if (endDate != null) queryParams['to'] = endDate.toIso8601String();
      if (status != null) queryParams['status'] = _statusToString(status);

      final response = await _dio.get(
        '/api/v2/incidents',
        queryParameters: queryParams,
      );
      
      final responseData = response.data as Map<String, dynamic>;
      final dataList = responseData['data'] as List<dynamic>?;
      return dataList?.length ?? 0;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw InvalidResponseException(
        message: 'Failed to get search results count: $e',
        originalException: e,
      );
    }
  }

  /// IncidentStatusを文字列に変換（API仕様書の値に合わせる）
  String _statusToString(IncidentStatus status) {
    switch (status) {
      case IncidentStatus.detected:
        return 'open';
      case IncidentStatus.confirmed:
        return 'open';
      case IncidentStatus.inProgress:
        return 'monitoring';
      case IncidentStatus.resolved:
        return 'resolved';
    }
  }

  /// DioExceptionを適切なApiExceptionに変換
  ApiException _handleDioException(DioException e) {
    final response = e.response;
    final statusCode = response?.statusCode;

    // ネットワークエラー
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return NetworkException(
        message: e.message ?? 'Network error occurred',
        originalException: e,
      );
    }

    // タイムアウト
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return TimeoutException(
        message: 'Request timeout',
        originalException: e,
      );
    }

    // HTTPステータスコードによる分類
    if (statusCode != null) {
      final message = _getErrorMessage(response);

      switch (statusCode) {
        case 400:
          return ValidationException(
            message: message,
            originalException: e,
          );
        case 401:
          return UnauthorizedException(
            message: message,
            originalException: e,
          );
        case 403:
          return ForbiddenException(
            message: message,
            originalException: e,
          );
        case 404:
          return NotFoundException(
            message: message,
            originalException: e,
          );
        case >= 500:
          return ServerException(
            message: message,
            statusCode: statusCode,
            originalException: e,
          );
        default:
          return InvalidResponseException(
            message: message,
            statusCode: statusCode,
            originalException: e,
          );
      }
    }

    // その他のエラー
    return InvalidResponseException(
      message: e.message ?? 'Unknown error occurred',
      originalException: e,
    );
  }

  /// レスポンスからエラーメッセージを取得
  String _getErrorMessage(Response? response) {
    if (response?.data is Map) {
      final data = response!.data as Map<String, dynamic>;
      return data['message'] as String? ?? 'An error occurred';
    }
    return 'An error occurred';
  }
}
