import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:frontend/features/history/presentation/organisms/history_table.dart';
import 'package:frontend/features/history/domain/entities/incident.dart';
import 'package:frontend/features/history/domain/entities/action.dart' as domain;

/// HistoryTable stories for Widgetbook
WidgetbookComponent historyTableStories() {
  return WidgetbookComponent(
    name: 'HistoryTable',
    useCases: [
      WidgetbookUseCase(
        name: 'With Data',
        builder: (context) => _buildWithDataUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'Loading State',
        builder: (context) => _buildLoadingStateUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'Empty State',
        builder: (context) => _buildEmptyStateUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'Error State',
        builder: (context) => _buildErrorStateUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'Multiple Pages',
        builder: (context) => _buildMultiplePagesUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'Single Incident',
        builder: (context) => _buildSingleIncidentUseCase(context),
      ),
    ],
  );
}

Widget _buildWithDataUseCase(BuildContext context) {
  final mockIncidents = _generateMockIncidents();

  return Scaffold(
    body: HistoryTable(
      incidents: mockIncidents,
      isLoading: false,
      currentPage: 1,
      totalPages: 5,
      pageSize: 20,
      onPageChanged: (page) {
        debugPrint('Page changed: $page');
      },
      onPageSizeChanged: (pageSize) {
        debugPrint('Page size changed: $pageSize');
      },
      onVideoPlay: (videoId) {
        debugPrint('Play video: $videoId');
      },
      onVideoDownload: (videoId) {
        debugPrint('Download video: $videoId');
      },
      onSort: (columnId, order) {
        debugPrint('Sort: $columnId, $order');
      },
      onSelectionChanged: (selectedIds) {
        debugPrint('Selection changed: $selectedIds');
      },
    ),
  );
}

Widget _buildLoadingStateUseCase(BuildContext context) {
  return Scaffold(
    body: HistoryTable(
      incidents: [],
      isLoading: true,
      currentPage: 1,
      totalPages: 1,
      pageSize: 20,
      onPageChanged: (_) {},
      onPageSizeChanged: (_) {},
      onVideoPlay: (_) {},
      onVideoDownload: (_) {},
      onSort: (_, __) {},
      onSelectionChanged: (_) {},
    ),
  );
}

Widget _buildEmptyStateUseCase(BuildContext context) {
  return Scaffold(
    body: HistoryTable(
      incidents: [],
      isLoading: false,
      currentPage: 1,
      totalPages: 1,
      pageSize: 20,
      onPageChanged: (_) {},
      onPageSizeChanged: (_) {},
      onVideoPlay: (_) {},
      onVideoDownload: (_) {},
      onSort: (_, __) {},
      onSelectionChanged: (_) {},
    ),
  );
}

Widget _buildErrorStateUseCase(BuildContext context) {
  return Scaffold(
    body: HistoryTable(
      incidents: [],
      isLoading: false,
      error: 'データの取得に失敗しました。ネットワーク接続を確認してください。',
      currentPage: 1,
      totalPages: 1,
      pageSize: 20,
      onPageChanged: (_) {},
      onPageSizeChanged: (_) {},
      onVideoPlay: (_) {},
      onVideoDownload: (_) {},
      onSort: (_, __) {},
      onSelectionChanged: (_) {},
    ),
  );
}

Widget _buildMultiplePagesUseCase(BuildContext context) {
  final mockIncidents = _generateMockIncidents();

  return Scaffold(
    body: HistoryTable(
      incidents: mockIncidents,
      isLoading: false,
      currentPage: 3,
      totalPages: 10,
      pageSize: 20,
      onPageChanged: (page) {
        debugPrint('Page changed: $page');
      },
      onPageSizeChanged: (pageSize) {
        debugPrint('Page size changed: $pageSize');
      },
      onVideoPlay: (videoId) {
        debugPrint('Play video: $videoId');
      },
      onVideoDownload: (videoId) {
        debugPrint('Download video: $videoId');
      },
      onSort: (columnId, order) {
        debugPrint('Sort: $columnId, $order');
      },
      onSelectionChanged: (selectedIds) {
        debugPrint('Selection changed: $selectedIds');
      },
    ),
  );
}

Widget _buildSingleIncidentUseCase(BuildContext context) {
  final singleIncident = [
    Incident(
      id: '1',
      incidentId: 'INC-001',
      roomNumber: 'TW02',
      bedNumber: '01',
      residentName: '田中太郎',
      detectedAt: DateTime.now().subtract(const Duration(hours: 2)),
      detectionType: '起床',
      videoId: 'video1',
      status: IncidentStatus.inProgress,
      actions: [
        domain.Action(
          id: 'action1',
          incidentId: '1',
          performedBy: 'Admin',
          performedAt: DateTime.now().subtract(const Duration(hours: 1)),
          actionType: '対応',
          notes: '対応完了',
        ),
      ],
    ),
  ];

  return Scaffold(
    body: HistoryTable(
      incidents: singleIncident,
      isLoading: false,
      currentPage: 1,
      totalPages: 1,
      pageSize: 20,
      onPageChanged: (_) {},
      onPageSizeChanged: (_) {},
      onVideoPlay: (_) {},
      onVideoDownload: (_) {},
      onSort: (_, __) {},
      onSelectionChanged: (_) {},
    ),
  );
}

// ヘルパー関数：モックデータ生成
List<Incident> _generateMockIncidents() {
  return List.generate(5, (index) {
    final statusEnum = _getRandomStatusEnum(index);
    return Incident(
      id: '${index + 1}',
      incidentId: 'INC-00${index + 1}',
      roomNumber: 'TW0${(index % 3) + 2}',
      bedNumber: '0${(index % 2) + 1}',
      residentName: _getRandomResidentName(index),
      detectedAt: DateTime.now().subtract(Duration(hours: index * 2)),
      detectionType: _getRandomDetectionType(index),
      videoId: 'video${index + 1}',
      status: statusEnum,
      actions: index % 2 == 0
          ? [
              domain.Action(
                id: 'action${index + 1}',
                incidentId: '${index + 1}',
                performedBy: 'Admin',
                performedAt: DateTime.now().subtract(Duration(hours: index * 2 - 1)),
                actionType: _getRandomActionType(index),
                notes: 'Test note ${index + 1}',
              ),
            ]
          : [],
    );
  });
}

String _getRandomResidentName(int index) {
  final names = ['田中太郎', '山田花子', '佐藤次郎', '鈴木三郎', '高橋四郎'];
  return names[index % names.length];
}

String _getRandomDetectionType(int index) {
  final types = ['起床', '端坐位', '転倒', '離床'];
  return types[index % types.length];
}

IncidentStatus _getRandomStatusEnum(int index) {
  final statuses = [
    IncidentStatus.detected,
    IncidentStatus.confirmed,
    IncidentStatus.inProgress,
    IncidentStatus.resolved,
  ];
  return statuses[index % statuses.length];
}

String _getRandomActionType(int index) {
  final actionTypes = ['確認', '対応', '完了', 'キャンセル', 'その他'];
  return actionTypes[index % actionTypes.length];
}
