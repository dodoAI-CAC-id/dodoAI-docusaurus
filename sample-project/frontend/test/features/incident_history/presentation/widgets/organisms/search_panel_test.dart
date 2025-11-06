import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamoai/features/incident_history/presentation/widgets/organisms/search_panel.dart';

void main() {
  group('SearchPanel', () {
    testWidgets('displays search criteria input', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchPanel(
              personName: null,
              incidentType: null,
              status: null,
              startDate: null,
              endDate: null,
              onPersonNameChanged: (value) {},
              onIncidentTypeChanged: (value) {},
              onStatusChanged: (value) {},
              onStartDateChanged: (date) {},
              onEndDateChanged: (date) {},
              onSearch: () {},
              onClear: () {},
            ),
          ),
        ),
      );

      // SearchCriteriaInputが表示されているか
      expect(find.text('見守り対象者名'), findsOneWidget);
      expect(find.text('異常タイプ'), findsOneWidget);
      expect(find.text('ステータス'), findsOneWidget);
    });

    testWidgets('displays search and clear buttons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchPanel(
              personName: null,
              incidentType: null,
              status: null,
              startDate: null,
              endDate: null,
              onPersonNameChanged: (value) {},
              onIncidentTypeChanged: (value) {},
              onStatusChanged: (value) {},
              onStartDateChanged: (date) {},
              onEndDateChanged: (date) {},
              onSearch: () {},
              onClear: () {},
            ),
          ),
        ),
      );

      // 検索ボタンとクリアボタンが表示されているか
      expect(find.text('検索'), findsOneWidget);
      expect(find.text('クリア'), findsOneWidget);
    });

    testWidgets('calls onSearch when search button is tapped', (tester) async {
      bool searchCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchPanel(
              personName: null,
              incidentType: null,
              status: null,
              startDate: null,
              endDate: null,
              onPersonNameChanged: (value) {},
              onIncidentTypeChanged: (value) {},
              onStatusChanged: (value) {},
              onStartDateChanged: (date) {},
              onEndDateChanged: (date) {},
              onSearch: () {
                searchCalled = true;
              },
              onClear: () {},
            ),
          ),
        ),
      );

      // 検索ボタンをタップ
      await tester.tap(find.text('検索'));
      await tester.pumpAndSettle();

      // コールバックが呼ばれたか
      expect(searchCalled, true);
    });

    testWidgets('calls onClear when clear button is tapped', (tester) async {
      bool clearCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchPanel(
              personName: null,
              incidentType: null,
              status: null,
              startDate: null,
              endDate: null,
              onPersonNameChanged: (value) {},
              onIncidentTypeChanged: (value) {},
              onStatusChanged: (value) {},
              onStartDateChanged: (date) {},
              onEndDateChanged: (date) {},
              onSearch: () {},
              onClear: () {
                clearCalled = true;
              },
            ),
          ),
        ),
      );

      // クリアボタンをタップ
      await tester.tap(find.text('クリア'));
      await tester.pumpAndSettle();

      // コールバックが呼ばれたか
      expect(clearCalled, true);
    });

    testWidgets('displays with initial values', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchPanel(
              personName: '山田太郎',
              incidentType: '転倒',
              status: 'open',
              startDate: DateTime(2025, 10, 1),
              endDate: DateTime(2025, 10, 31),
              onPersonNameChanged: (value) {},
              onIncidentTypeChanged: (value) {},
              onStatusChanged: (value) {},
              onStartDateChanged: (date) {},
              onEndDateChanged: (date) {},
              onSearch: () {},
              onClear: () {},
            ),
          ),
        ),
      );

      // 初期値が表示されているか
      expect(find.text('山田太郎'), findsOneWidget);
    });

    testWidgets('propagates value changes from SearchCriteriaInput', (tester) async {
      String? capturedPersonName;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchPanel(
              personName: null,
              incidentType: null,
              status: null,
              startDate: null,
              endDate: null,
              onPersonNameChanged: (value) {
                capturedPersonName = value;
              },
              onIncidentTypeChanged: (value) {},
              onStatusChanged: (value) {},
              onStartDateChanged: (date) {},
              onEndDateChanged: (date) {},
              onSearch: () {},
              onClear: () {},
            ),
          ),
        ),
      );

      // 見守り対象者名フィールドに入力
      await tester.enterText(
        find.widgetWithText(TextField, '例: 山田太郎'),
        '佐藤花子',
      );
      await tester.pumpAndSettle();

      // コールバックが呼ばれて値が伝播したか
      expect(capturedPersonName, '佐藤花子');
    });

    testWidgets('has proper layout structure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchPanel(
              personName: null,
              incidentType: null,
              status: null,
              startDate: null,
              endDate: null,
              onPersonNameChanged: (value) {},
              onIncidentTypeChanged: (value) {},
              onStatusChanged: (value) {},
              onStartDateChanged: (date) {},
              onEndDateChanged: (date) {},
              onSearch: () {},
              onClear: () {},
            ),
          ),
        ),
      );

      // Cardウィジェットが使用されているか
      expect(find.byType(Card), findsOneWidget);
    });
  });
}
