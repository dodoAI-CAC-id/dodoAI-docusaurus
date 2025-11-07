import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamoai/features/incident_history/presentation/widgets/molecules/search_criteria_input.dart';

void main() {
  group('SearchCriteriaInput', () {
    testWidgets('displays all search fields', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchCriteriaInput(
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
            ),
          ),
        ),
      );

      // 見守り対象者名フィールドが表示されているか
      expect(find.text('見守り対象者名'), findsOneWidget);

      // 異常タイプドロップダウンが表示されているか
      expect(find.text('異常タイプ'), findsOneWidget);

      // ステータスドロップダウンが表示されているか
      expect(find.text('ステータス'), findsOneWidget);

      // 期間選択（DateRangePicker）が表示されているか
      expect(find.text('開始日'), findsOneWidget);
      expect(find.text('終了日'), findsOneWidget);
    });

    testWidgets('displays entered person name', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchCriteriaInput(
              personName: '山田太郎',
              incidentType: null,
              status: null,
              startDate: null,
              endDate: null,
              onPersonNameChanged: (value) {},
              onIncidentTypeChanged: (value) {},
              onStatusChanged: (value) {},
              onStartDateChanged: (date) {},
              onEndDateChanged: (date) {},
            ),
          ),
        ),
      );

      // 入力された名前が表示されているか
      expect(find.text('山田太郎'), findsOneWidget);
    });

    testWidgets('displays selected incident type', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchCriteriaInput(
              personName: null,
              incidentType: '転倒',
              status: null,
              startDate: null,
              endDate: null,
              onPersonNameChanged: (value) {},
              onIncidentTypeChanged: (value) {},
              onStatusChanged: (value) {},
              onStartDateChanged: (date) {},
              onEndDateChanged: (date) {},
            ),
          ),
        ),
      );

      // 選択された異常タイプが表示されているか
      expect(find.text('転倒'), findsOneWidget);
    });

    testWidgets('displays selected status', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchCriteriaInput(
              personName: null,
              incidentType: null,
              status: 'open',
              startDate: null,
              endDate: null,
              onPersonNameChanged: (value) {},
              onIncidentTypeChanged: (value) {},
              onStatusChanged: (value) {},
              onStartDateChanged: (date) {},
              onEndDateChanged: (date) {},
            ),
          ),
        ),
      );

      // 選択されたステータスが表示されているか
      expect(find.text('未対応'), findsOneWidget);
    });

    testWidgets('displays selected date range', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchCriteriaInput(
              personName: null,
              incidentType: null,
              status: null,
              startDate: DateTime(2025, 10, 1),
              endDate: DateTime(2025, 10, 31),
              onPersonNameChanged: (value) {},
              onIncidentTypeChanged: (value) {},
              onStatusChanged: (value) {},
              onStartDateChanged: (date) {},
              onEndDateChanged: (date) {},
            ),
          ),
        ),
      );

      // 選択された期間が表示されているか
      expect(find.text('2025/10/01'), findsOneWidget);
      expect(find.text('2025/10/31'), findsOneWidget);
    });

    testWidgets('text field is present for person name', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchCriteriaInput(
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
            ),
          ),
        ),
      );

      // テキストフィールドが存在するか
      expect(find.byType(TextField), findsAtLeastNWidgets(1));
    });

    testWidgets('incident type dropdown is present', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchCriteriaInput(
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
            ),
          ),
        ),
      );

      // ドロップダウンが存在するか
      expect(find.byType(DropdownButton<String>), findsAtLeastNWidgets(2));
    });

    testWidgets('status dropdown is present', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchCriteriaInput(
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
            ),
          ),
        ),
      );

      // ドロップダウンが存在するか
      expect(find.byType(DropdownButton<String>), findsAtLeastNWidgets(2));
    });

    testWidgets('displays hint texts when no values are selected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchCriteriaInput(
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
            ),
          ),
        ),
      );

      // ヒントテキストが表示されているか
      expect(find.text('例: 山田太郎'), findsOneWidget);
      expect(find.text('選択してください'), findsNWidgets(2)); // 異常タイプとステータス
      expect(find.text('yyyy/mm/dd'), findsNWidgets(2)); // 開始日と終了日
    });
  });
}
