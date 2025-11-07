import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/presentation/components/atoms/app_checkbox.dart';

void main() {
  group('AppCheckbox', () {
    testWidgets('基本的なチェックボックスが正しくレンダリングされる', (WidgetTester tester) async {
      bool isChecked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCheckbox(
              value: isChecked,
              onChanged: (value) => isChecked = value,
              label: 'チェック項目',
            ),
          ),
        ),
      );

      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.text('チェック項目'), findsOneWidget);
    });

    testWidgets('チェックボックスの状態を変更できる', (WidgetTester tester) async {
      bool isChecked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AppCheckbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() => isChecked = value);
                  },
                  label: 'チェック項目',
                );
              },
            ),
          ),
        ),
      );

      // 初期状態はfalse
      Checkbox checkbox = tester.widget(find.byType(Checkbox));
      expect(checkbox.value, false);

      // チェックボックスをタップ
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(isChecked, true);
    });

    testWidgets('ラベルなしのチェックボックス', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCheckbox(
              value: false,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('無効状態のチェックボックス', (WidgetTester tester) async {
      bool isChecked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCheckbox(
              value: false,
              onChanged: (value) => isChecked = value,
              disabled: true,
            ),
          ),
        ),
      );

      // タップしても状態が変わらない
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(isChecked, false);
    });

    testWidgets('チェック済み状態で表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCheckbox(
              value: true,
              onChanged: (_) {},
              label: 'チェック済み',
            ),
          ),
        ),
      );

      Checkbox checkbox = tester.widget(find.byType(Checkbox));
      expect(checkbox.value, true);
    });

    testWidgets('ラベルをタップしてもチェック状態が変わる', (WidgetTester tester) async {
      bool isChecked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AppCheckbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() => isChecked = value);
                  },
                  label: 'ラベルテキスト',
                );
              },
            ),
          ),
        ),
      );

      // ラベルをタップ
      await tester.tap(find.text('ラベルテキスト'));
      await tester.pumpAndSettle();

      expect(isChecked, true);
    });

    testWidgets('エラー状態の表示', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCheckbox(
              value: false,
              onChanged: (_) {},
              label: 'チェック項目',
              errorText: 'この項目は必須です',
            ),
          ),
        ),
      );

      expect(find.text('この項目は必須です'), findsOneWidget);
    });
  });
}
