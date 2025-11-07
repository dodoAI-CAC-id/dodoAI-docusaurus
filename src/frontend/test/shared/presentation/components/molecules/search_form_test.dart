import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/presentation/components/molecules/search_form.dart';
import 'package:frontend/shared/domain/models/search_criteria.dart';

void main() {
  group('SearchForm', () {
    testWidgets('初期表示時に全ての検索フィールドが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchForm(
              onSearch: (_) {},
            ),
          ),
        ),
      );

      // 日付範囲フィールド
      expect(find.text('開始日'), findsOneWidget);
      expect(find.text('終了日'), findsOneWidget);

      // テキストフィールド
      expect(find.byType(TextField), findsAtLeast(3));
      
      // 検索ボタン
      expect(find.text('検索'), findsOneWidget);
    });

    testWidgets('部屋/ベッド番号フィールドが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchForm(
              onSearch: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('部屋/ベッド番号'), findsOneWidget);
    });

    testWidgets('見守り対象者名フィールドが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchForm(
              onSearch: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('見守り対象者名'), findsOneWidget);
    });

    testWidgets('担当者フィールドが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchForm(
              onSearch: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('担当者'), findsOneWidget);
    });

    testWidgets('操作ドロップダウンが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchForm(
              onSearch: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('操作'), findsOneWidget);
    });

    testWidgets('異常検出動作ドロップダウンが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchForm(
              onSearch: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('異常検出動作'), findsOneWidget);
    });

    testWidgets('初期値が設定されている場合、フィールドに値が表示される', (WidgetTester tester) async {
      final initialValues = SearchCriteria(
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 1, 31),
        roomBedNumber: 'TW02-02',
        targetPersonName: '田中太郎',
        staffName: 'Admin',
        actionType: '対応',
        detectionType: '起床',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchForm(
              initialValues: initialValues,
              onSearch: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('2025/01/01'), findsOneWidget);
      expect(find.text('2025/01/31'), findsOneWidget);
      expect(find.text('TW02-02'), findsOneWidget);
      expect(find.text('田中太郎'), findsOneWidget);
      expect(find.text('Admin'), findsOneWidget);
    });

    testWidgets('検索ボタンをタップすると検索条件とともにコールバックが呼ばれる', (WidgetTester tester) async {
      SearchCriteria? capturedCriteria;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchForm(
              onSearch: (criteria) {
                capturedCriteria = criteria;
              },
            ),
          ),
        ),
      );

      // 部屋/ベッド番号を入力
      await tester.enterText(
        find.widgetWithText(TextField, '部屋/ベッド番号'),
        'TW02-01',
      );

      // 検索ボタンをタップ
      await tester.tap(find.text('検索'));
      await tester.pumpAndSettle();

      expect(capturedCriteria, isNotNull);
      expect(capturedCriteria?.roomBedNumber, 'TW02-01');
    });

    testWidgets('複数の検索条件を入力して検索できる', (WidgetTester tester) async {
      SearchCriteria? capturedCriteria;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchForm(
              onSearch: (criteria) {
                capturedCriteria = criteria;
              },
            ),
          ),
        ),
      );

      // 部屋/ベッド番号を入力
      await tester.enterText(
        find.widgetWithText(TextField, '部屋/ベッド番号'),
        'TW02-01',
      );

      // 見守り対象者名を入力
      await tester.enterText(
        find.widgetWithText(TextField, '見守り対象者名'),
        '田中太郎',
      );

      // 担当者を入力
      await tester.enterText(
        find.widgetWithText(TextField, '担当者'),
        'Admin',
      );

      // 検索ボタンをタップ
      await tester.tap(find.text('検索'));
      await tester.pumpAndSettle();

      expect(capturedCriteria, isNotNull);
      expect(capturedCriteria?.roomBedNumber, 'TW02-01');
      expect(capturedCriteria?.targetPersonName, '田中太郎');
      expect(capturedCriteria?.staffName, 'Admin');
    });

    testWidgets('クリアボタンで全ての入力がクリアされる', (WidgetTester tester) async {
      final initialValues = SearchCriteria(
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 1, 31),
        roomBedNumber: 'TW02-02',
        targetPersonName: '田中太郎',
        staffName: 'Admin',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchForm(
              initialValues: initialValues,
              onSearch: (_) {},
            ),
          ),
        ),
      );

      // クリアボタンをタップ
      await tester.tap(find.text('クリア'));
      await tester.pumpAndSettle();

      // 全てのフィールドが空になっていることを確認
      expect(find.text('2025/01/01'), findsNothing);
      expect(find.text('2025/01/31'), findsNothing);
      expect(find.text('TW02-02'), findsNothing);
      expect(find.text('田中太郎'), findsNothing);
      expect(find.text('Admin'), findsNothing);
    });

    testWidgets('レスポンシブレイアウト：狭い画面では縦並び', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              child: SearchForm(
                onSearch: (_) {},
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('レスポンシブレイアウト：広い画面では横並び', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 1200,
              child: SearchForm(
                onSearch: (_) {},
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('バリデーション：日付範囲が無効な場合エラーが表示される', (WidgetTester tester) async {
      final initialValues = SearchCriteria(
        startDate: DateTime(2025, 1, 31),
        endDate: DateTime(2025, 1, 1), // Invalid: end before start
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchForm(
              initialValues: initialValues,
              onSearch: (_) {},
            ),
          ),
        ),
      );

      // エラーメッセージが表示されることを確認
      expect(find.text('終了日は開始日以降の日付を選択してください'), findsOneWidget);
    });
  });
}
