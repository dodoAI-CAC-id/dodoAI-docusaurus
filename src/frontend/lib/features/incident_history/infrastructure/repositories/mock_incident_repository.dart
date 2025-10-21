import 'package:dartz/dartz.dart';
import 'package:mamoai/core/error/failures.dart';
import 'package:mamoai/features/incident_history/domain/entities/incident.dart';
import 'package:mamoai/features/incident_history/domain/entities/pagination_info.dart';
import 'package:mamoai/features/incident_history/domain/entities/search_criteria.dart';
import 'package:mamoai/features/incident_history/domain/repositories/i_incident_repository.dart';

/// モック用インシデントリポジトリ
/// APIサーバーなしでUIを確認するためのモックデータを提供
class MockIncidentRepository implements IIncidentRepository {
  /// モックデータ
  final List<Incident> _mockIncidents = [
    Incident(
      id: 'INC-001',
      detectedAt: DateTime.now().subtract(const Duration(hours: 2)),
      type: '転倒',
      personId: 'P001',
      personName: '山田太郎',
      roomNumber: '101',
      status: 'open',
      videoId: 'VIDEO-001',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      assignedTo: '佐藤看護師',
      responseStartedAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
      responseCompletedAt: null,
      episodeNote: '転倒を検知しました',
      historyNumber: 1,
      actionType: '対応',
    ),
    Incident(
      id: 'INC-002',
      detectedAt: DateTime.now().subtract(const Duration(hours: 5)),
      type: '離床',
      personId: 'P002',
      personName: '佐藤花子',
      roomNumber: '102',
      status: 'resolved',
      videoId: 'VIDEO-002',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
      assignedTo: '田中看護師',
      responseStartedAt: DateTime.now().subtract(const Duration(hours: 4, minutes: 55)),
      responseCompletedAt: DateTime.now().subtract(const Duration(hours: 4, minutes: 30)),
      episodeNote: '離床を検知し、対応完了',
      historyNumber: 2,
      actionType: '完了',
    ),
    Incident(
      id: 'INC-003',
      detectedAt: DateTime.now().subtract(const Duration(hours: 8)),
      type: '起床',
      personId: 'P003',
      personName: '鈴木一郎',
      roomNumber: '103',
      status: 'resolved',
      videoId: 'VIDEO-003',
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 7)),
      assignedTo: '高橋看護師',
      responseStartedAt: DateTime.now().subtract(const Duration(hours: 7, minutes: 55)),
      responseCompletedAt: DateTime.now().subtract(const Duration(hours: 7, minutes: 40)),
      episodeNote: '起床を検知し、対応完了',
      historyNumber: 3,
      actionType: '完了',
    ),
    Incident(
      id: 'INC-004',
      detectedAt: DateTime.now().subtract(const Duration(hours: 12)),
      type: '端坐位',
      personId: 'P004',
      personName: '田中美咲',
      roomNumber: '104',
      status: 'monitoring',
      videoId: 'VIDEO-004',
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 11)),
      assignedTo: '伊藤看護師',
      responseStartedAt: DateTime.now().subtract(const Duration(hours: 11, minutes: 55)),
      responseCompletedAt: null,
      episodeNote: '端坐位を検知、経過観察中',
      historyNumber: 4,
      actionType: '対応',
    ),
    Incident(
      id: 'INC-005',
      detectedAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      type: '転倒',
      personId: 'P005',
      personName: '渡辺健太',
      roomNumber: '105',
      status: 'resolved',
      videoId: 'VIDEO-005',
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      assignedTo: '山本看護師',
      responseStartedAt: DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 55)),
      responseCompletedAt: DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 30)),
      episodeNote: '転倒を検知し、対応完了',
      historyNumber: 5,
      actionType: '完了',
    ),
    Incident(
      id: 'INC-006',
      detectedAt: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
      type: '離床',
      personId: 'P006',
      personName: '中村由美',
      roomNumber: '106',
      status: 'resolved',
      videoId: 'VIDEO-006',
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
      assignedTo: '小林看護師',
      responseStartedAt: DateTime.now().subtract(const Duration(days: 1, hours: 5, minutes: 55)),
      responseCompletedAt: DateTime.now().subtract(const Duration(days: 1, hours: 5, minutes: 35)),
      episodeNote: '離床を検知し、対応完了',
      historyNumber: 6,
      actionType: '完了',
    ),
    Incident(
      id: 'INC-007',
      detectedAt: DateTime.now().subtract(const Duration(days: 1, hours: 10)),
      type: '起床',
      personId: 'P007',
      personName: '加藤誠',
      roomNumber: '107',
      status: 'resolved',
      videoId: 'VIDEO-007',
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1, hours: 9)),
      assignedTo: '吉田看護師',
      responseStartedAt: DateTime.now().subtract(const Duration(days: 1, hours: 9, minutes: 55)),
      responseCompletedAt: DateTime.now().subtract(const Duration(days: 1, hours: 9, minutes: 45)),
      episodeNote: '起床を検知し、対応完了',
      historyNumber: 7,
      actionType: '訪室不要',
    ),
    Incident(
      id: 'INC-008',
      detectedAt: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
      type: '転倒',
      personId: 'P008',
      personName: '木村明子',
      roomNumber: '108',
      status: 'resolved',
      videoId: 'VIDEO-008',
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2, hours: 2)),
      assignedTo: '松本看護師',
      responseStartedAt: DateTime.now().subtract(const Duration(days: 2, hours: 2, minutes: 55)),
      responseCompletedAt: DateTime.now().subtract(const Duration(days: 2, hours: 2, minutes: 25)),
      episodeNote: '転倒を検知し、対応完了',
      historyNumber: 8,
      actionType: '完了',
    ),
    Incident(
      id: 'INC-009',
      detectedAt: DateTime.now().subtract(const Duration(days: 2, hours: 8)),
      type: '離床',
      personId: 'P009',
      personName: '井上隆',
      roomNumber: '109',
      status: 'resolved',
      videoId: 'VIDEO-009',
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 8)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2, hours: 7)),
      assignedTo: '林看護師',
      responseStartedAt: DateTime.now().subtract(const Duration(days: 2, hours: 7, minutes: 55)),
      responseCompletedAt: DateTime.now().subtract(const Duration(days: 2, hours: 7, minutes: 40)),
      episodeNote: '離床を検知し、対応完了',
      historyNumber: 9,
      actionType: '対応不要',
    ),
    Incident(
      id: 'INC-010',
      detectedAt: DateTime.now().subtract(const Duration(days: 3, hours: 1)),
      type: '端坐位',
      personId: 'P010',
      personName: '清水恵子',
      roomNumber: '110',
      status: 'resolved',
      videoId: 'VIDEO-010',
      createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      assignedTo: '森看護師',
      responseStartedAt: DateTime.now().subtract(const Duration(days: 3, minutes: 55)),
      responseCompletedAt: DateTime.now().subtract(const Duration(days: 3, minutes: 30)),
      episodeNote: '端坐位を検知し、対応完了',
      historyNumber: 10,
      actionType: '誤検知',
    ),
  ];

  @override
  Future<Either<Failure, IncidentListResult>> getIncidents({
    SearchCriteria? criteria,
  }) async {
    print('🔵 [MockIncidentRepository] getIncidents called');
    print('🔵 [MockIncidentRepository] Total mock data: ${_mockIncidents.length}');
    
    // 少し遅延を入れてローディング状態を確認できるようにする
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // フィルタリング処理
      var filteredIncidents = List<Incident>.from(_mockIncidents);
      print('🔵 [MockIncidentRepository] After filtering: ${filteredIncidents.length}');

      if (criteria != null) {
        // 見守り対象者名でフィルタ
        if (criteria.personName != null && criteria.personName!.isNotEmpty) {
          filteredIncidents = filteredIncidents
              .where((incident) =>
                  incident.personName.contains(criteria.personName!))
              .toList();
        }

        // 部屋/ベッド番号でフィルタ
        if (criteria.roomNumber != null && criteria.roomNumber!.isNotEmpty) {
          filteredIncidents = filteredIncidents
              .where((incident) =>
                  incident.roomNumber.contains(criteria.roomNumber!))
              .toList();
        }

        // 担当者でフィルタ
        if (criteria.assignedTo != null && criteria.assignedTo!.isNotEmpty) {
          filteredIncidents = filteredIncidents
              .where((incident) =>
                  incident.assignedTo != null &&
                  incident.assignedTo!.contains(criteria.assignedTo!))
              .toList();
        }

        // 操作タイプでフィルタ
        if (criteria.actionType != null && criteria.actionType!.isNotEmpty) {
          filteredIncidents = filteredIncidents
              .where((incident) =>
                  incident.actionType != null &&
                  incident.actionType == criteria.actionType)
              .toList();
        }

        // 異常検出動作でフィルタ
        if (criteria.incidentType != null && criteria.incidentType!.isNotEmpty) {
          filteredIncidents = filteredIncidents
              .where((incident) => incident.type == criteria.incidentType)
              .toList();
        }

        // ステータスでフィルタ
        if (criteria.status != null && criteria.status!.isNotEmpty) {
          filteredIncidents = filteredIncidents
              .where((incident) => incident.status == criteria.status)
              .toList();
        }

        // 開始日でフィルタ
        if (criteria.fromDate != null) {
          filteredIncidents = filteredIncidents
              .where((incident) =>
                  incident.detectedAt.isAfter(criteria.fromDate!) ||
                  incident.detectedAt.isAtSameMomentAs(criteria.fromDate!))
              .toList();
        }

        // 終了日でフィルタ
        if (criteria.toDate != null) {
          filteredIncidents = filteredIncidents
              .where((incident) =>
                  incident.detectedAt.isBefore(criteria.toDate!) ||
                  incident.detectedAt.isAtSameMomentAs(criteria.toDate!))
              .toList();
        }
      }

      // ページネーション処理
      final page = criteria?.page ?? 1;
      final limit = criteria?.limit ?? 20;
      final totalCount = filteredIncidents.length;
      final totalPages = (totalCount / limit).ceil();

      final startIndex = (page - 1) * limit;
      final endIndex = startIndex + limit;

      final paginatedIncidents = filteredIncidents.sublist(
        startIndex,
        endIndex > totalCount ? totalCount : endIndex,
      );

      final paginationInfo = PaginationInfo(
        currentPage: page,
        totalPages: totalPages > 0 ? totalPages : 1,
        totalCount: totalCount,
        limit: limit,
        hasNextPage: page < (totalPages > 0 ? totalPages : 1),
        hasPreviousPage: page > 1,
      );

      return Right(
        IncidentListResult(
          incidents: paginatedIncidents,
          paginationInfo: paginationInfo,
        ),
      );
    } catch (e) {
      return Left(ServerFailure('モックデータの取得に失敗しました: $e'));
    }
  }

  @override
  Future<Either<Failure, Incident>> getIncidentById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final incident = _mockIncidents.firstWhere(
        (incident) => incident.id == id,
        orElse: () => throw Exception('Incident not found'),
      );

      return Right(incident);
    } catch (e) {
      return Left(ServerFailure('インシデントが見つかりません: $id'));
    }
  }
}
