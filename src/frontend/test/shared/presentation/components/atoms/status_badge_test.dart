import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/presentation/components/atoms/status_badge.dart';

void main() {
  group('StatusBadge', () {
    testWidgets('基本的なバッジが正しくレンダリングされる', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(
              label: '対応',
              variant: BadgeVariant.primary,
            ),
          ),
        ),
      );

      expect(find.text('対応'), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('Primaryバリアントのバッジ', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(
              label: 'プライマリ',
              variant: BadgeVariant.primary,
            ),
          ),
        ),
      );

      expect(find.text('プライマリ'), findsOneWidget);
    });

    testWidgets('Successバリアントのバッジ', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(
              label: '成功',
              variant: BadgeVariant.success,
            ),
          ),
        ),
      );

      expect(find.text('成功'), findsOneWidget);
    });

    testWidgets('Warningバリアントのバッジ', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(
              label: '警告',
              variant: BadgeVariant.warning,
            ),
          ),
        ),
      );

      expect(find.text('警告'), findsOneWidget);
    });

    testWidgets('Errorバリアントのバッジ', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(
              label: 'エラー',
              variant: BadgeVariant.error,
            ),
          ),
        ),
      );

      expect(find.text('エラー'), findsOneWidget);
    });

    testWidgets('Infoバリアントのバッジ', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(
              label: '情報',
              variant: BadgeVariant.info,
            ),
          ),
        ),
      );

      expect(find.text('情報'), findsOneWidget);
    });

    testWidgets('Neutralバリアントのバッジ', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(
              label: '中立',
              variant: BadgeVariant.neutral,
            ),
          ),
        ),
      );

      expect(find.text('中立'), findsOneWidget);
    });

    testWidgets('アイコン付きバッジ', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(
              label: 'アイコン',
              variant: BadgeVariant.success,
              icon: Icons.check,
            ),
          ),
        ),
      );

      expect(find.text('アイコン'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('小サイズのバッジ', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(
              label: '小',
              variant: BadgeVariant.primary,
              size: BadgeSize.small,
            ),
          ),
        ),
      );

      expect(find.text('小'), findsOneWidget);
    });

    testWidgets('中サイズのバッジ', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(
              label: '中',
              variant: BadgeVariant.primary,
              size: BadgeSize.medium,
            ),
          ),
        ),
      );

      expect(find.text('中'), findsOneWidget);
    });

    testWidgets('大サイズのバッジ', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(
              label: '大',
              variant: BadgeVariant.primary,
              size: BadgeSize.large,
            ),
          ),
        ),
      );

      expect(find.text('大'), findsOneWidget);
    });
  });
}
