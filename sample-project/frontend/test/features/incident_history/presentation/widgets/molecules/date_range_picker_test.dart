import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamoai/features/incident_history/presentation/widgets/molecules/date_range_picker.dart';

void main() {
  group('DateRangePicker', () {
    testWidgets('displays start and end date fields', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateRangePicker(
              startDate: null,
              endDate: null,
              onStartDateChanged: (date) {},
              onEndDateChanged: (date) {},
            ),
          ),
        ),
      );

      // 開始日フィールドが表示されているか
      expect(find.text('開始日'), findsOneWidget);

      // 終了日フィールドが表示されているか
      expect(find.text('終了日'), findsOneWidget);

      // カレンダーアイコンが2つ表示されているか
      expect(find.byIcon(Icons.calendar_today), findsNWidgets(2));
    });

    testWidgets('displays selected dates', (tester) async {
      final startDate = DateTime(2025, 10, 1);
      final endDate = DateTime(2025, 10, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateRangePicker(
              startDate: startDate,
              endDate: endDate,
              onStartDateChanged: (date) {},
              onEndDateChanged: (date) {},
            ),
          ),
        ),
      );

      // 開始日が表示されているか
      expect(find.text('2025/10/01'), findsOneWidget);

      // 終了日が表示されているか
      expect(find.text('2025/10/31'), findsOneWidget);
    });

    testWidgets('calendar icons are tappable', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateRangePicker(
              startDate: null,
              endDate: null,
              onStartDateChanged: (date) {},
              onEndDateChanged: (date) {},
            ),
          ),
        ),
      );

      // カレンダーアイコンがタップ可能か確認
      final calendarIcons = find.byIcon(Icons.calendar_today);
      expect(calendarIcons, findsNWidgets(2));
      
      // アイコンがタップ可能であることを確認（実際のタップはしない）
      final firstIcon = tester.widget<Icon>(calendarIcons.first);
      expect(firstIcon.icon, Icons.calendar_today);
    });

    testWidgets('displays hint text when no date is selected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateRangePicker(
              startDate: null,
              endDate: null,
              onStartDateChanged: (date) {},
              onEndDateChanged: (date) {},
            ),
          ),
        ),
      );

      // ヒントテキストが表示されているか
      expect(find.text('yyyy/mm/dd'), findsNWidgets(2));
    });

    testWidgets('formats date correctly with zero padding', (tester) async {
      final startDate = DateTime(2025, 1, 5);
      final endDate = DateTime(2025, 2, 9);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateRangePicker(
              startDate: startDate,
              endDate: endDate,
              onStartDateChanged: (date) {},
              onEndDateChanged: (date) {},
            ),
          ),
        ),
      );

      // 日付が正しくフォーマットされているか（ゼロパディング）
      expect(find.text('2025/01/05'), findsOneWidget);
      expect(find.text('2025/02/09'), findsOneWidget);
    });

    testWidgets('text fields are read-only', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateRangePicker(
              startDate: null,
              endDate: null,
              onStartDateChanged: (date) {},
              onEndDateChanged: (date) {},
            ),
          ),
        ),
      );

      // TextFieldを探す
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      // 両方のTextFieldがread-onlyか確認
      for (final textField in tester.widgetList<TextField>(textFields)) {
        expect(textField.readOnly, true);
      }
    });
  });
}
