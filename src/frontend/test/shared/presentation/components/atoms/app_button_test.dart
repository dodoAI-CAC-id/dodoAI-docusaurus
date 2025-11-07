import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/presentation/components/atoms/app_button.dart';

void main() {
  group('AppButton', () {
    testWidgets('プライマリボタンが正しくレンダリングされる', (WidgetTester tester) async {
      // Arrange
      var pressed = false;
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: 'テストボタン',
              onPressed: () => pressed = true,
              variant: ButtonVariant.primary,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('テストボタン'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      
      // タップ動作確認
      await tester.tap(find.byType(ElevatedButton));
      expect(pressed, true);
    });

    testWidgets('セカンダリボタンが正しくレンダリングされる', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: 'セカンダリ',
              onPressed: () {},
              variant: ButtonVariant.secondary,
            ),
          ),
        ),
      );

      expect(find.text('セカンダリ'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('テキストボタンが正しくレンダリングされる', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: 'テキスト',
              onPressed: () {},
              variant: ButtonVariant.text,
            ),
          ),
        ),
      );

      expect(find.text('テキスト'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('無効状態のボタンはタップできない', (WidgetTester tester) async {
      var pressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: '無効ボタン',
              onPressed: () => pressed = true,
              disabled: true,
            ),
          ),
        ),
      );

      expect(find.text('無効ボタン'), findsOneWidget);
      
      // 無効状態でタップしても反応しない
      await tester.tap(find.byType(ElevatedButton));
      expect(pressed, false);
    });

    testWidgets('ローディング状態を表示できる', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: 'ローディング',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('アイコン付きボタンが表示できる', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: 'アイコン',
              onPressed: () {},
              icon: Icons.add,
            ),
          ),
        ),
      );

      expect(find.text('アイコン'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });
}
