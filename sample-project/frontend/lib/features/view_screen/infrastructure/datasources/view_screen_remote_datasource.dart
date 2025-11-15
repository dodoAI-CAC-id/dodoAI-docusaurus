import 'package:dio/dio.dart';
import '../../../../core/config/api_config.dart';
import '../../domain/entities/incident_status.dart';

/// ビュー画面用のリモートデータソース
class ViewScreenRemoteDataSource {
  final Dio dio;

  ViewScreenRemoteDataSource(this.dio);

  /// 異常イベント一覧を取得
  ///
  /// 戻り値: List<Map<String, dynamic>>
  Future<List<Map<String, dynamic>>> getIncidents() async {
    try {
      final response = await dio.get('/api/v2/incidents');

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

  /// 特定の異常イベント詳細を取得（画像含む）
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

  /// インシデントのステータスを更新（アクション登録）
  ///
  /// [incidentId] インシデントID
  /// [newStatus] 新しいステータス
  /// [actionType] アクションタイプ
  /// 戻り値: Map<String, dynamic>
  Future<Map<String, dynamic>> updateIncidentStatus({
    required String incidentId,
    required IncidentStatus newStatus,
    required String actionType,
  }) async {
    try {
      // 1. ステータスを更新（PATCH /api/v2/incidents/:id）
      final statusResponse = await dio.patch(
        '/api/v2/incidents/$incidentId',
        data: {
          'status': newStatus.toApiStatus(),
        },
      );

      if (statusResponse.statusCode != 200) {
        throw Exception(
            'Failed to update incident status: ${statusResponse.statusCode}');
      }

      // 2. アクションタイプをバックエンド形式にマッピング
      final mappedActionType = _mapActionType(actionType);

      // 3. アクション記録（POST /api/v2/incidents/:id/actions）
      final actionResponse = await dio.post(
        '/api/v2/incidents/$incidentId/actions',
        data: {
          'actionType': mappedActionType,
          'staffId': 'current_user', // TODO: 実際のユーザーIDを取得
          'note': actionType != mappedActionType ? actionType : null,
        },
      );

      if (actionResponse.statusCode != 201 && actionResponse.statusCode != 200) {
        throw Exception(
            'Failed to create action: ${actionResponse.statusCode}');
      }

      // 4. 最新のインシデント情報を取得して返す
      return await getIncidentById(incidentId);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// フロントエンドのactionTypeをバックエンド形式にマッピング
  String _mapActionType(String actionType) {
    switch (actionType) {
      case 'start_response':
        return 'start';
      case 'no_visit_needed':
      case 'false_detection':
      case 'complete':
        return 'complete';
      case 'revert':
        return 'revert';
      default:
        return actionType;
    }
  }

  /// アラートの稼働状態を切り替え
  ///
  /// [incidentId] インシデントID
  /// [isActive] アラート稼働状態
  /// 戻り値: Map<String, dynamic>
  Future<Map<String, dynamic>> toggleAlertStatus({
    required String incidentId,
    required bool isActive,
  }) async {
    try {
      final response = await dio.patch(
        '/api/v2/incidents/$incidentId/alert',
        data: {
          'isActive': isActive,
        },
      );

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
      throw Exception(
          'Failed to toggle alert status: ${response.statusCode}');
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
}
