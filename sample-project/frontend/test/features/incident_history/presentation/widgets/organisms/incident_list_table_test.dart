import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamoai/features/incident_history/domain/entities/incident.dart';
import 'package:mamoai/features/incident_history/presentation/widgets/organisms/incident_list_table.dart';

void main() {
  group('IncidentListTable', () {
    final testIncidents = [
      Incident(
        id: 'INC001',
        detectedAt: DateTime(2025, 10, 20, 14, 30),
        type: '転倒',
        personId: 'PERSON001',
        personName: '山田太郎',
        roomNumber: '101',
        status: 'open',
        videoId: 'VIDEO001',
        createdAt: DateTime(2025, 10, 20, 14, 30),
        updatedAt: DateTime(2025, 10, 20, 14, 30),
      ),
      Incident(
        id: 'INC002',
        detectedAt: DateTime(2025, 10, 20, 15, 45),
        type: '徘徊',
        personId: 'PERSON002',
        personName: '佐藤花子',
        roomNumber: '202',
        status: 'monitoring',
        videoId: 'VIDEO002',
        createdAt: DateTime(2025, 10, 20, 15, 45),
        updatedAt: DateTime(2025, 10, 20, 15, 45),
      ),
    ];

    testWidgets('displays table header', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncidentListTable(
              incidents: testIncidents,
              selectedIncidentIds: const {},
              onSelectionChanged: (id, selected) {},
              onPlayVideo: (id) {},
              onDownloadVideo: (id) {},
            ),
          ),
        ),
      );

      // ヘッダーが表示されているか
      expect(find.text('検知日時'), findsOneWidget);
      expect(find.text('異常タイプ'), findsOneWidget);
      expect(find.text('見守り対象者'), findsOneWidget);
      expect(find.text('部屋番号'), findsOneWidget);
      expect(find.text('ステータス'), findsOneWidget);
      expect(find.text('操作'), findsOneWidget);
    });

    testWidgets('displays incident rows', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncidentListTable(
              incidents: testIncidents,
              selectedIncidentIds: const {},
              onSelectionChanged: (id, selected) {},
              onPlayVideo: (id) {},
              onDownloadVideo: (id) {},
            ),
          ),
        ),
      );

      // インシデント行が表示されているか
      expect(find.text('山田太郎'), findsOneWidget);
      expect(find.text('佐藤花子'), findsOneWidget);
    });

    testWidgets('displays select all checkbox', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncidentListTable(
              incidents: testIncidents,
              selectedIncidentIds: const {},
              onSelectionChanged: (id, selected) {},
              onPlayVideo: (id) {},
              onDownloadVideo: (id) {},
            ),
          ),
        ),
      );

      // 全選択チェックボックスが表示されているか
      final checkboxes = find.byType(Checkbox);
      expect(checkboxes, findsWidgets);
    });

    testWidgets('handles empty incident list', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncidentListTable(
              incidents: const [],
              selectedIncidentIds: const {},
              onSelectionChanged: (id, selected) {},
              onPlayVideo: (id) {},
              onDownloadVideo: (id) {},
            ),
          ),
        ),
      );

      // 空のメッセージが表示されているか
      expect(find.text('データがありません'), findsOneWidget);
    });

    testWidgets('calls onSelectionChanged when row is selected', (tester) async {
      String? capturedId;
      bool? capturedSelected;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncidentListTable(
              incidents: testIncidents,
              selectedIncidentIds: const {},
              onSelectionChanged: (id, selected) {
                capturedId = id;
                capturedSelected = selected;
              },
              onPlayVideo: (id) {},
              onDownloadVideo: (id) {},
            ),
          ),
        ),
      );

      // 最初のチェックボックスをタップ（ヘッダーの全選択を除く）
      final checkboxes = find.byType(Checkbox);
      await tester.tap(checkboxes.at(1)); // 0はヘッダー、1は最初の行
      await tester.pumpAndSettle();

      // コールバックが呼ばれたか
      expect(capturedId, 'INC001');
      expect(capturedSelected, true);
    });

    testWidgets('calls onPlayVideo when play button is tapped', (tester) async {
      String? capturedId;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncidentListTable(
              incidents: testIncidents,
              selectedIncidentIds: const {},
              onSelectionChanged: (id, selected) {},
              onPlayVideo: (id) {
                capturedId = id;
              },
              onDownloadVideo: (id) {},
            ),
          ),
        ),
      );

      // 再生ボタンをタップ
      final playButtons = find.byIcon(Icons.play_circle);
      await tester.tap(playButtons.first);
      await tester.pumpAndSettle();

      // コールバックが呼ばれたか
      expect(capturedId, 'INC001');
    });

    testWidgets('shows selected state correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncidentListTable(
              incidents: testIncidents,
              selectedIncidentIds: const {'INC001'},
              onSelectionChanged: (id, selected) {},
              onPlayVideo: (id) {},
              onDownloadVideo: (id) {},
            ),
          ),
        ),
      );

      // 選択状態が反映されているか
      final checkboxes = find.byType(Checkbox);
      final firstRowCheckbox = tester.widget<Checkbox>(checkboxes.at(1));
      expect(firstRowCheckbox.value, true);
    });

    testWidgets('has proper scrollable layout', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncidentListTable(
              incidents: testIncidents,
              selectedIncidentIds: const {},
              onSelectionChanged: (id, selected) {},
              onPlayVideo: (id) {},
              onDownloadVideo: (id) {},
            ),
          ),
        ),
      );

      // SingleChildScrollViewが使用されているか
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
