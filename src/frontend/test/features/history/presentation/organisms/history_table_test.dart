import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/history/domain/entities/incident.dart';
import 'package:frontend/features/history/domain/entities/action.dart' as domain;
import 'package:frontend/features/history/presentation/organisms/history_table.dart';
import 'package:frontend/shared/presentation/components/molecules/table_row.dart';
import 'package:frontend/shared/presentation/components/molecules/pagination.dart';
import 'package:frontend/shared/presentation/components/molecules/loading_indicator.dart';

void main() {
  group('HistoryTable', () {
    late List<Incident> mockIncidents;

    setUp(() {
      mockIncidents = [
        Incident(
          id: '1',
          facilityId: 'facility1',
          roomNumber: 'TW02',
          bedNumber: '01',
          residentName: '田中太郎',
          detectedAt: DateTime(2025, 1, 15, 10, 30),
          detectionType: '起床',
          videoId: 'video1',
          status: '対応',
          actions: [
            domain.Action(
              id: 'action1',
              incidentId: '1',
              performedBy: 'Admin',
              performedAt: DateTime(2025, 1, 15, 10, 32),
              actionType: '対応',
              note: 'Test note',
            ),
          ],
        ),
        Incident(
          id: '2',
          facilityId: 'facility1',
          roomNumber: 'TW03',
          bedNumber: '02',
          residentName: '山田花子',
          detectedAt: DateTime(2025, 1, 15, 11, 45),
          detectionType: '離床',
          videoId: 'video2',
          status: '完了',
          actions: [],
        ),
      ];
    });

    testWidgets('displays incidents correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryTable(
              incidents: mockIncidents,
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
          ),
        ),
      );

      // ヘッダーが表示されていること
      expect(find.text('履歴番号'), findsOneWidget);
      expect(find.text('日付'), findsOneWidget);
      expect(find.text('部屋/ベッド番号'), findsOneWidget);

      // データ行が表示されていること
      expect(find.text('1'), findsOneWidget);
      expect(find.text('TW02/01'), findsOneWidget);
      expect(find.text('田中太郎'), findsOneWidget);
      expect(find.text('起床'), findsOneWidget);
    });

    testWidgets('displays loading indicator when isLoading is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
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
          ),
        ),
      );

      expect(find.byType(LoadingIndicator), findsOneWidget);
      expect(find.byType(HistoryTableRow), findsNothing);
    });

    testWidgets('displays error message when error is provided', (tester) async {
      const errorMessage = 'データの取得に失敗しました';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryTable(
              incidents: [],
              isLoading: false,
              error: errorMessage,
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
          ),
        ),
      );

      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.byType(HistoryTableRow), findsNothing);
    });

    testWidgets('displays empty message when no incidents', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
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
          ),
        ),
      );

      expect(find.text('データがありません'), findsOneWidget);
      expect(find.byType(HistoryTableRow), findsNothing);
    });

    testWidgets('displays pagination controls', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryTable(
              incidents: mockIncidents,
              isLoading: false,
              currentPage: 2,
              totalPages: 5,
              pageSize: 20,
              onPageChanged: (_) {},
              onPageSizeChanged: (_) {},
              onVideoPlay: (_) {},
              onVideoDownload: (_) {},
              onSort: (_, __) {},
              onSelectionChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(Pagination), findsOneWidget);
    });

    testWidgets('calls onPageChanged when page is changed', (tester) async {
      int? changedPage;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryTable(
              incidents: mockIncidents,
              isLoading: false,
              currentPage: 1,
              totalPages: 3,
              pageSize: 20,
              onPageChanged: (page) {
                changedPage = page;
              },
              onPageSizeChanged: (_) {},
              onVideoPlay: (_) {},
              onVideoDownload: (_) {},
              onSort: (_, __) {},
              onSelectionChanged: (_) {},
            ),
          ),
        ),
      );

      // 次ページボタンをタップ
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();

      expect(changedPage, equals(2));
    });

    testWidgets('calls onVideoPlay when play button is tapped', (tester) async {
      String? playedVideoId;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryTable(
              incidents: mockIncidents,
              isLoading: false,
              currentPage: 1,
              totalPages: 1,
              pageSize: 20,
              onPageChanged: (_) {},
              onPageSizeChanged: (_) {},
              onVideoPlay: (videoId) {
                playedVideoId = videoId;
              },
              onVideoDownload: (_) {},
              onSort: (_, __) {},
              onSelectionChanged: (_) {},
            ),
          ),
        ),
      );

      // 再生ボタンをタップ
      await tester.tap(find.byIcon(Icons.play_circle_outline).first);
      await tester.pumpAndSettle();

      expect(playedVideoId, equals('video1'));
    });

    testWidgets('calls onVideoDownload when download button is tapped', (tester) async {
      String? downloadedVideoId;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryTable(
              incidents: mockIncidents,
              isLoading: false,
              currentPage: 1,
              totalPages: 1,
              pageSize: 20,
              onPageChanged: (_) {},
              onPageSizeChanged: (_) {},
              onVideoPlay: (_) {},
              onVideoDownload: (videoId) {
                downloadedVideoId = videoId;
              },
              onSort: (_, __) {},
              onSelectionChanged: (_) {},
            ),
          ),
        ),
      );

      // ダウンロードボタンをタップ
      await tester.tap(find.byIcon(Icons.download).first);
      await tester.pumpAndSettle();

      expect(downloadedVideoId, equals('video1'));
    });

    testWidgets('handles checkbox selection', (tester) async {
      List<String>? selectedIds;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryTable(
              incidents: mockIncidents,
              isLoading: false,
              currentPage: 1,
              totalPages: 1,
              pageSize: 20,
              onPageChanged: (_) {},
              onPageSizeChanged: (_) {},
              onVideoPlay: (_) {},
              onVideoDownload: (_) {},
              onSort: (_, __) {},
              onSelectionChanged: (ids) {
                selectedIds = ids;
              },
            ),
          ),
        ),
      );

      // チェックボックスをタップ
      final checkboxes = find.byType(Checkbox);
      await tester.tap(checkboxes.at(1)); // 最初のデータ行のチェックボックス
      await tester.pumpAndSettle();

      expect(selectedIds, isNotNull);
      expect(selectedIds!.contains('1'), isTrue);
    });

    testWidgets('is scrollable horizontally on narrow screens', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400, // Narrow screen
              child: HistoryTable(
                incidents: mockIncidents,
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
            ),
          ),
        ),
      );

      // 横スクロール可能なウィジェットが存在することを確認
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
