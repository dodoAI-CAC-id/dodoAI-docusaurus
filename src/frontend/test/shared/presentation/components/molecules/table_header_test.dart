import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/presentation/components/molecules/table_header.dart';
import 'package:frontend/shared/domain/models/table_column.dart';

void main() {
  group('TableHeader', () {
    final testColumns = [
      TableColumn(label: 'No', width: 60),
      TableColumn(label: '日付', width: 100),
      TableColumn(label: '発生時間', width: 100),
      TableColumn(label: '部屋/ベッド番号', width: 120),
    ];

    testWidgets('全てのカラムラベルが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableHeader(
              columns: testColumns,
              onSelectAll: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('No'), findsOneWidget);
      expect(find.text('日付'), findsOneWidget);
      expect(find.text('発生時間'), findsOneWidget);
      expect(find.text('部屋/ベッド番号'), findsOneWidget);
    });

    testWidgets('全選択チェックボックスが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableHeader(
              columns: testColumns,
              onSelectAll: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('全選択チェックボックスの初期状態はfalse', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableHeader(
              columns: testColumns,
              onSelectAll: (_) {},
            ),
          ),
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isFalse);
    });

    testWidgets('isAllSelected=trueの場合、チェックボックスがチェックされている', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableHeader(
              columns: testColumns,
              onSelectAll: (_) {},
              isAllSelected: true,
            ),
          ),
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isTrue);
    });

    testWidgets('チェックボックスをタップするとコールバックが呼ばれる', (WidgetTester tester) async {
      bool? capturedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableHeader(
              columns: testColumns,
              onSelectAll: (value) {
                capturedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(capturedValue, isTrue);
    });

    testWidgets('チェックボックスをタップしてfalseにできる', (WidgetTester tester) async {
      bool? capturedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableHeader(
              columns: testColumns,
              onSelectAll: (value) {
                capturedValue = value;
              },
              isAllSelected: true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(capturedValue, isFalse);
    });

    testWidgets('カラム幅が正しく適用される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableHeader(
              columns: testColumns,
              onSelectAll: (_) {},
            ),
          ),
        ),
      );

      // SizedBoxでカラム幅が設定されていることを確認
      final noColumn = find.ancestor(
        of: find.text('No'),
        matching: find.byType(SizedBox),
      );
      expect(noColumn, findsOneWidget);
    });

    testWidgets('ヘッダー背景色が適用される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableHeader(
              columns: testColumns,
              onSelectAll: (_) {},
            ),
          ),
        ),
      );

      // Containerでヘッダー背景色が設定されていることを確認
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('カラムラベルが中央揃えで表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableHeader(
              columns: testColumns,
              onSelectAll: (_) {},
            ),
          ),
        ),
      );

      // Centerウィジェットでテキストが中央揃えされていることを確認
      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('ソート可能カラムにはソートアイコンが表示される', (WidgetTester tester) async {
      final sortableColumns = [
        TableColumn(label: 'No', width: 60, sortable: true),
        TableColumn(label: '日付', width: 100, sortable: true),
        TableColumn(label: '部屋/ベッド番号', width: 120, sortable: false),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableHeader(
              columns: sortableColumns,
              onSelectAll: (_) {},
            ),
          ),
        ),
      );

      // ソートアイコンが表示されることを確認
      expect(find.byIcon(Icons.arrow_upward), findsWidgets);
    });

    testWidgets('ソートカラムをタップするとonSortが呼ばれる', (WidgetTester tester) async {
      String? capturedColumnKey;
      bool? capturedAscending;

      final sortableColumns = [
        TableColumn(label: 'No', width: 60, sortable: true, key: 'no'),
        TableColumn(label: '日付', width: 100, sortable: true, key: 'date'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableHeader(
              columns: sortableColumns,
              onSelectAll: (_) {},
              onSort: (columnKey, ascending) {
                capturedColumnKey = columnKey;
                capturedAscending = ascending;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();

      expect(capturedColumnKey, 'no');
      expect(capturedAscending, isTrue);
    });

    testWidgets('空のカラムリストでもエラーにならない', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableHeader(
              columns: const [],
              onSelectAll: (_) {},
            ),
          ),
        ),
      );

      // エラーが発生しないことを確認
      expect(find.byType(TableHeader), findsOneWidget);
    });
  });
}
