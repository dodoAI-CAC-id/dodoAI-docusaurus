import 'package:dio/dio.dart';
import 'package:mamoai/features/incident_history/domain/entities/search_criteria.dart';

/// 異常イベントリモートデータソース
class IncidentRemoteDataSource {
  final Dio dio;
  static const String baseUrl = '/api/v2';

  IncidentRemoteDataSource(this.dio);

  /// 異常イベント一覧を取得
  ///
  /// [criteria] 検索条件（オプション）
  /// 戻り値: List<Map<String, dynamic>>
  Future<List<Map<String, dynamic>>> getIncidents({
    SearchCriteria? criteria,
  }) async {
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
      '$baseUrl/incidents',
      queryParameters: queryParameters,
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data as List);
    } else {
      throw Exception('Failed to load incidents: ${response.statusCode}');
    }
  }

  /// 異常イベント詳細を取得
  ///
  /// [incidentId] 異常イベントID
  /// 戻り値: Map<String, dynamic>
  Future<Map<String, dynamic>> getIncidentById(String incidentId) async {
    final response = await dio.get('$baseUrl/incidents/$incidentId');

    if (response.statusCode == 200) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load incident: ${response.statusCode}');
    }
  }
}
