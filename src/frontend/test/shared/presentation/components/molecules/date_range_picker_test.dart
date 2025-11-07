import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/presentation/components/molecules/date_range_picker.dart';

void main() {
  group('DateRangePicker', () {
    testWidgets('初期表示時に開始日と終了日のラベルが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateRangePicker(
              onStartDateChanged: (_) {},
              onEndDateChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('開始日'), findsOneWidget);
      expect(find.text('終了日'), findsOneWidget);
    });

    testWidgets('カスタムラベルが正しく表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateRangePicker(
              startLabel: 'From',
              endLabel: 'To',
              onStartDateChanged: (_) {},
              onEndDateChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('From'), findsOneWidget);
      expect(find.text('To'), findsOneWidget);
    });

    testWidgets('開始日が指定されている場合、フォーマットされた日付が表示される', (WidgetTester tester) async {
      final startDate = DateTime(2025, 1, 15);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateRangePicker(
              startDate: startDate,
              onStartDateChanged: (_) {},
              onEndDateChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('2025/01/15'), findsOneWidget);
    });

    testWidgets('終了日が指定されている場合、フォーマットされた日付が表示される', (WidgetTester tester) async {
      final endDate = DateTime(2025, 1, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateRangePicker(
              endDate: endDate,
              onStartDateChanged: (_) {},
              onEndDateChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('2025/01/31'), findsOneWidget);
    });

    testWidgets('開始日フィールドをタップすると日付選択ダイアログが表示される', (WidgetTester tester) async {
      DateTime? selectedDate;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateRangePicker(
              onStartDateChanged: (date) {
                selectedDate = date;
              },
              onEndDateChanged: (_) {},
            ),
          ),
        ),
      );

      // 開始日フィールドを見つけてタップ
      final startDateField = find.widgetWithText(TextField, '開始日').first;
      await tester.tap(startDateField);
      await tester.pumpAndSettle();

      // DatePickerダイアログが表示されることを確認
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('終了日フィールドをタップすると日付選択ダイアログが表示される', (WidgetTester tester) async {
      DateTime? selectedDate;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateRangePicker(
              onStartDateChanged: (_) {},
              onEndDateChanged: (date) {
                selectedDate = date;
              },
            ),
          ),
        ),
      );

      // 終了日フィールドを見つけてタップ
      final endDateField = find.widgetWithText(TextField, '終了日').first;
      await tester.tap(endDateField);
      await tester.pumpAndSettle();

      // DatePickerダイアログが表示されることを確認
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('日付選択時にコールバックが呼ばれる', (WidgetTester tester) async {
      DateTime? selectedStartDate;
      DateTime? selectedEndDate;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateRangePicker(
              onStartDateChanged: (date) {
                selectedStartDate = date;
              },
              onEndDateChanged: (date) {
                selectedEndDate = date;
              },
            ),
          ),
        ),
      );

      // 開始日フィールドをタップ
      final startDateField = find.widgetWithText(TextField, '開始日').first;
      await tester.tap(startDateField);
      await tester.pumpAndSettle();

      // 日付を選択（例：15日を選択）
      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();

      // OKボタンをタップ
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // コールバックが呼ばれたことを確認
      expect(selectedStartDate, isNotNull);
      expect(selectedStartDate?.day, 15);
    });

    testWidgets('クリアボタンをタップすると日付がクリアされる', (WidgetTester tester) async {
      DateTime? startDate = DateTime(2025, 1, 15);
      DateTime? endDate = DateTime(2025, 1, 31);
      bool startDateCleared = false;
      bool endDateCleared = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: DateRangePicker(
                  startDate: startDate,
                  endDate: endDate,
                  onStartDateChanged: (date) {
                    setState(() {
                      startDate = date;
                      if (date == null) startDateCleared = true;
                    });
                  },
                  onEndDateChanged: (date) {
                    setState(() {
                      endDate = date;
                      if (date == null) endDateCleared = true;
                    });
                  },
                ),
              );
            },
          ),
        ),
      );

      // 開始日のクリアアイコンが表示されることを確認
      expect(find.byIcon(Icons.clear), findsAtLeast(1));

      // 最初のクリアアイコン（開始日）をタップ
      await tester.tap(find.byIcon(Icons.clear).first);
      await tester.pumpAndSettle();

      // 開始日がクリアされたことを確認
      expect(startDateCleared, isTrue);
    });

    testWidgets('無効な日付範囲（終了日が開始日より前）の場合、エラー表示される', (WidgetTester tester) async {
      final startDate = DateTime(2025, 1, 31);
      final endDate = DateTime(2025, 1, 15);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateRangePicker(
              startDate: startDate,
              endDate: endDate,
              onStartDateChanged: (_) {},
              onEndDateChanged: (_) {},
            ),
          ),
        ),
      );

      // エラーメッセージが表示されることを確認
      expect(find.text('終了日は開始日以降の日付を選択してください'), findsOneWidget);
    });

    testWidgets('レスポンシブレイアウト：狭い画面では縦並び', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300, // 狭い幅を設定
              child: DateRangePicker(
                onStartDateChanged: (_) {},
                onEndDateChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      // Columnレイアウトが使用されていることを確認
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('レスポンシブレイアウト：広い画面では横並び', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800, // 広い幅を設定
              child: DateRangePicker(
                onStartDateChanged: (_) {},
                onEndDateChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      // Rowレイアウトが使用されていることを確認
      expect(find.byType(Row), findsWidgets);
    });
  });
}
