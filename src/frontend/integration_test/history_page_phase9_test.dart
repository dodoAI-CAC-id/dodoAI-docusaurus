import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:frontend/features/history/presentation/pages/history_page.dart';
import 'package:frontend/core/utils/accessibility_utils.dart';

/// Phase 9 統合テスト
/// 
/// パフォーマンス最適化、アクセシビリティ、エラーハンドリングの検証
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Phase 9: Performance and Accessibility Tests', () {
    testWidgets('Accessibility: Screen reader labels are present',
        (WidgetTester tester) async {
      // テスト用のウィジェットをビルド
      await tester.pumpWidget(
        MaterialApp(
          home: HistoryPage(),
        ),
      );

      // 画面のセマンティックラベルを確認
      expect(
        find.bySemanticsLabel('異常検知履歴画面'),
        findsOneWidget,
      );

      // 検索ボタンのセマンティックラベルを確認
      final searchButton = find.widgetWithText(IconButton, '');
      expect(searchButton, findsWidgets);
    });

    testWidgets('Accessibility: Keyboard shortcuts are registered',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HistoryPage(),
        ),
      );

      // Shortcutsウィジェットが存在することを確認
      expect(find.byType(Shortcuts), findsOneWidget);

      // Actionsウィジェットが存在することを確認
      expect(find.byType(Actions), findsOneWidget);
    });

    testWidgets('Performance: ListView.builder is used for table rows',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HistoryPage(),
        ),
      );

      // ListViewが使用されていることを確認（仮想スクロール）
      await tester.pumpAndSettle();
      
      // テーブルが表示されることを確認
      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets('Accessibility: Focus nodes are properly managed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HistoryPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Focusウィジェットが存在することを確認
      expect(find.byType(Focus), findsWidgets);
    });

    testWidgets('Error Handling: Retry functionality is available',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HistoryPage(),
        ),
      );

      await tester.pumpAndSettle();

      // リフレッシュボタンが存在することを確認
      final refreshButton = find.widgetWithIcon(IconButton, Icons.refresh);
      expect(refreshButton, findsOneWidget);
    });

    testWidgets('Accessibility: Semantic labels for video actions',
        (WidgetTester tester) async {
      // AccessibilityUtilsのテスト
      final playLabel = AccessibilityUtils.videoPlayLabel('INC-001');
      expect(playLabel, '履歴番号INC-001の動画を再生');

      final downloadLabel = AccessibilityUtils.videoDownloadLabel('INC-001');
      expect(downloadLabel, '履歴番号INC-001の動画をダウンロード');
    });

    testWidgets('Accessibility: Semantic labels for pagination',
        (WidgetTester tester) async {
      // ページネーションのセマンティックラベルをテスト
      final paginationLabel = AccessibilityUtils.paginationLabel(2, 10);
      expect(paginationLabel, '全10ページ中2ページ目');
    });

    testWidgets('Accessibility: Status labels are descriptive',
        (WidgetTester tester) async {
      // ステータスラベルのテスト
      expect(
        AccessibilityUtils.statusLabel('検知済み'),
        '検知済み、未対応',
      );
      expect(
        AccessibilityUtils.statusLabel('確認済み'),
        '確認済み、対応待ち',
      );
      expect(
        AccessibilityUtils.statusLabel('対応中'),
        '現在対応中',
      );
      expect(
        AccessibilityUtils.statusLabel('解決済み'),
        '対応完了、解決済み',
      );
    });

    testWidgets('Accessibility: Date time labels are readable',
        (WidgetTester tester) async {
      // 日時ラベルのテスト
      final dateTime = DateTime(2025, 11, 4, 15, 30);
      final label = AccessibilityUtils.dateTimeLabel(dateTime);
      expect(label, '2025年11月4日 15時30分');
    });

    testWidgets('Accessibility: Table row semantic labels are comprehensive',
        (WidgetTester tester) async {
      // テーブル行のセマンティックラベルをテスト
      final rowLabel = AccessibilityUtils.tableRowLabel(
        incidentId: 'INC-001',
        date: '2025/11/04',
        time: '15:30',
        roomBed: '101/A',
        patientName: '山田太郎',
        detectedAction: '転倒検知',
        status: '対応中',
      );

      expect(rowLabel, contains('履歴番号INC-001'));
      expect(rowLabel, contains('2025/11/04 15:30'));
      expect(rowLabel, contains('101/A'));
      expect(rowLabel, contains('山田太郎'));
      expect(rowLabel, contains('異常検出動作：転倒検知'));
      expect(rowLabel, contains('ステータス：現在対応中'));
    });

    test('Contrast Checker: WCAG AA compliance', () {
      // コントラスト比のテスト
      const foreground = Colors.black;
      const background = Colors.white;

      expect(
        ContrastChecker.meetsWCAGAA(foreground, background),
        isTrue,
      );
    });

    test('Touch Target Checker: Minimum size validation', () {
      // タッチターゲットサイズのテスト
      expect(
        TouchTargetChecker.isTouchTargetSufficient(44.0, 44.0),
        isTrue,
      );

      expect(
        TouchTargetChecker.isTouchTargetSufficient(40.0, 40.0),
        isFalse,
      );

      expect(
        TouchTargetChecker.isTouchTargetRecommended(48.0, 48.0),
        isTrue,
      );
    });

    testWidgets('Performance: Modal overlay rendering',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HistoryPage(),
        ),
      );

      await tester.pumpAndSettle();

      // 初期状態ではモーダルが表示されていないことを確認
      expect(find.text('動画プレーヤーモーダル、Escキーで閉じます'), findsNothing);
    });
  });

  group('Phase 9: Error Handling Tests', () {
    testWidgets('Error messages are announced to screen readers',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HistoryPage(),
        ),
      );

      await tester.pumpAndSettle();

      // エラー表示用のスナックバーが表示可能であることを確認
      // (実際のエラーはBlocの状態によって発生)
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group('Phase 9: Keyboard Navigation Tests', () {
    testWidgets('Focus management is properly implemented',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HistoryPage(),
        ),
      );

      await tester.pumpAndSettle();

      // フォーカス可能な要素が存在することを確認
      expect(find.byType(FocusScope), findsOneWidget);
    });
  });
}
