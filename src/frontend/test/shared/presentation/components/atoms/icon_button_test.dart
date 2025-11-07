import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/presentation/components/atoms/icon_button.dart';

void main() {
  group('AppIconButton', () {
    testWidgets('基本的なアイコンボタンが正しくレンダリングされる', (WidgetTester tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppIconButton(
              icon: Icons.add,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);

      // タップ動作確認
      await tester.tap(find.byType(IconButton));
      expect(pressed, true);
    });

    testWidgets('プライマリバリアントのボタン', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppIconButton(
              icon: Icons.star,
              onPressed: () {},
              variant: IconButtonVariant.primary,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('セカンダリバリアントのボタン', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppIconButton(
              icon: Icons.settings,
              onPressed: () {},
              variant: IconButtonVariant.secondary,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('テキストバリアントのボタン', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppIconButton(
              icon: Icons.close,
              onPressed: () {},
              variant: IconButtonVariant.text,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('無効状態のボタン', (WidgetTester tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppIconButton(
              icon: Icons.delete,
              onPressed: () => pressed = true,
              disabled: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.delete), findsOneWidget);

      // 無効状態でタップしても反応しない
      await tester.tap(find.byType(IconButton));
      expect(pressed, false);
    });

    testWidgets('小サイズのボタン', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppIconButton(
              icon: Icons.edit,
              onPressed: () {},
              size: IconButtonSize.small,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('中サイズのボタン', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppIconButton(
              icon: Icons.edit,
              onPressed: () {},
              size: IconButtonSize.medium,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('大サイズのボタン', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppIconButton(
              icon: Icons.edit,
              onPressed: () {},
              size: IconButtonSize.large,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('ツールチップ付きボタン', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppIconButton(
              icon: Icons.help,
              onPressed: () {},
              tooltip: 'ヘルプ',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.help), findsOneWidget);
      
      // ツールチップの確認
      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(iconButton.tooltip, 'ヘルプ');
    });

    testWidgets('カスタムカラーのボタン', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppIconButton(
              icon: Icons.favorite,
              onPressed: () {},
              color: Colors.red,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });
}
