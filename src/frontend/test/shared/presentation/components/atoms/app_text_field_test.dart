import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/presentation/components/atoms/app_text_field.dart';

void main() {
  group('AppTextField', () {
    testWidgets('基本的なテキストフィールドが正しくレンダリングされる', (WidgetTester tester) async {
      String? inputValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              value: '',
              onChanged: (value) => inputValue = value,
              placeholder: 'テスト入力',
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('テスト入力'), findsOneWidget);

      // テキスト入力テスト
      await tester.enterText(find.byType(TextField), 'Hello');
      expect(inputValue, 'Hello');
    });

    testWidgets('ラベル付きテキストフィールドが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              value: '',
              onChanged: (_) {},
              label: '名前',
              placeholder: '名前を入力',
            ),
          ),
        ),
      );

      expect(find.text('名前'), findsOneWidget);
      expect(find.text('名前を入力'), findsOneWidget);
    });

    testWidgets('エラーメッセージが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              value: '',
              onChanged: (_) {},
              errorText: 'このフィールドは必須です',
            ),
          ),
        ),
      );

      expect(find.text('このフィールドは必須です'), findsOneWidget);
    });

    testWidgets('無効状態のテキストフィールド', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              value: 'disabled text',
              onChanged: (_) {},
              disabled: true,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, false);
    });

    testWidgets('パスワードフィールドとして表示できる', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              value: '',
              onChanged: (_) {},
              isPassword: true,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, true);
    });

    testWidgets('複数行入力が可能', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              value: '',
              onChanged: (_) {},
              maxLines: 3,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.maxLines, 3);
    });

    testWidgets('プレフィックスアイコンが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              value: '',
              onChanged: (_) {},
              prefixIcon: Icons.search,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('サフィックスアイコンが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              value: '',
              onChanged: (_) {},
              suffixIcon: Icons.clear,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('最大文字数制限が機能する', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              value: '',
              onChanged: (_) {},
              maxLength: 10,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.maxLength, 10);
    });
  });
}
