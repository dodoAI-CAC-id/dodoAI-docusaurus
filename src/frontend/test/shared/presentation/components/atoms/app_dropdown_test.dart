import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/presentation/components/atoms/app_dropdown.dart';

void main() {
  group('AppDropdown', () {
    final testOptions = [
      DropdownOption(value: '1', label: 'オプション1'),
      DropdownOption(value: '2', label: 'オプション2'),
      DropdownOption(value: '3', label: 'オプション3'),
    ];

    testWidgets('基本的なドロップダウンが正しくレンダリングされる', (WidgetTester tester) async {
      String? selectedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDropdown(
              options: testOptions,
              value: '1',
              onChanged: (value) => selectedValue = value,
            ),
          ),
        ),
      );

      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      expect(find.text('オプション1'), findsOneWidget);
    });

    testWidgets('ドロップダウンの値を変更できる', (WidgetTester tester) async {
      String? selectedValue = '1';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AppDropdown(
                  options: testOptions,
                  value: selectedValue,
                  onChanged: (value) {
                    setState(() => selectedValue = value);
                  },
                );
              },
            ),
          ),
        ),
      );

      // ドロップダウンをタップして開く
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      // オプション2を選択
      await tester.tap(find.text('オプション2').last);
      await tester.pumpAndSettle();

      expect(selectedValue, '2');
    });

    testWidgets('ラベル付きドロップダウンが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDropdown(
              options: testOptions,
              value: '1',
              onChanged: (_) {},
              label: 'カテゴリー',
            ),
          ),
        ),
      );

      expect(find.text('カテゴリー'), findsOneWidget);
    });

    testWidgets('プレースホルダーが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDropdown(
              options: testOptions,
              value: null,
              onChanged: (_) {},
              placeholder: '選択してください',
            ),
          ),
        ),
      );

      expect(find.text('選択してください'), findsOneWidget);
    });

    testWidgets('エラーメッセージが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDropdown(
              options: testOptions,
              value: null,
              onChanged: (_) {},
              errorText: '選択が必要です',
            ),
          ),
        ),
      );

      expect(find.text('選択が必要です'), findsOneWidget);
    });

    testWidgets('無効状態のドロップダウン', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDropdown(
              options: testOptions,
              value: '1',
              onChanged: (_) {},
              disabled: true,
            ),
          ),
        ),
      );

      final dropdown = tester.widget<DropdownButtonFormField<String>>(
        find.byType(DropdownButtonFormField<String>),
      );
      expect(dropdown.enabled, false);
    });

    testWidgets('空のオプションリストでも動作する', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDropdown(
              options: const [],
              value: null,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    });
  });
}
