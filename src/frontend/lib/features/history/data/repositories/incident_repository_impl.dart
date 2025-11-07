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
        '/api/incidents',
        queryParameters: {
          'limit': limit,
          'offset': offset,
          'order_by': orderBy,
          'descending': descending,
        },
      );
      
      final dataList = response.data['data'] as List<dynamic>;
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
      final response = await _dio.get('/api/incidents/$id');
      
      final data = response.data['data'] as Map<String, dynamic>;
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
      final queryParams = <String, dynamic>{
        'limit': limit,
        'offset': offset,
      };

      final searchData = <String, dynamic>{};
      if (startDate != null) searchData['start_date'] = startDate.toIso8601String();
      if (endDate != null) searchData['end_date'] = endDate.toIso8601String();
      if (roomNumber != null) searchData['room_number'] = roomNumber;
      if (bedNumber != null) searchData['bed_number'] = bedNumber;
      if (residentName != null) searchData['resident_name'] = residentName;
      if (performedBy != null) searchData['performed_by'] = performedBy;
      if (detectionType != null) searchData['detection_type'] = detectionType;
      if (status != null) searchData['status'] = _statusToString(status);

      final response = await _dio.post(
        '/api/incidents/search',
        queryParameters: queryParams,
        data: searchData,
      );
      
      final dataList = response.data['data'] as List<dynamic>;
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
      final response = await _dio.get('/api/incidents/count');
      
      final data = response.data['data'] as Map<String, dynamic>;
      return data['count'] as int;
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
      final searchData = <String, dynamic>{};
      if (startDate != null) searchData['start_date'] = startDate.toIso8601String();
      if (endDate != null) searchData['end_date'] = endDate.toIso8601String();
      if (roomNumber != null) searchData['room_number'] = roomNumber;
      if (bedNumber != null) searchData['bed_number'] = bedNumber;
      if (residentName != null) searchData['resident_name'] = residentName;
      if (performedBy != null) searchData['performed_by'] = performedBy;
      if (detectionType != null) searchData['detection_type'] = detectionType;
      if (status != null) searchData['status'] = _statusToString(status);

      final response = await _dio.post(
        '/api/incidents/search/count',
        data: searchData,
      );
      
      final data = response.data['data'] as Map<String, dynamic>;
      return data['count'] as int;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw InvalidResponseException(
        message: 'Failed to get search results count: $e',
        originalException: e,
      );
    }
  }

  /// IncidentStatusを文字列に変換
  String _statusToString(IncidentStatus status) {
    switch (status) {
      case IncidentStatus.detected:
        return 'detected';
      case IncidentStatus.confirmed:
        return 'confirmed';
      case IncidentStatus.inProgress:
        return 'in_progress';
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
