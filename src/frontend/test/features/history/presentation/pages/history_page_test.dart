import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:frontend/features/history/presentation/pages/history_page.dart';
import 'package:frontend/features/history/presentation/blocs/history/history_bloc.dart';
import 'package:frontend/features/history/presentation/blocs/history/history_event.dart';
import 'package:frontend/features/history/presentation/blocs/history/history_state.dart';
import 'package:frontend/features/history/domain/entities/incident.dart';
import 'package:frontend/features/history/domain/repositories/i_incident_repository.dart';

// モック生成用のアノテーション
@GenerateMocks([IIncidentRepository])
import 'history_page_test.mocks.dart';

void main() {
  late MockIIncidentRepository mockRepository;
  late HistoryBloc historyBloc;

  // テスト用のモックIncidentデータ
  final mockIncident = Incident(
    id: '1',
    incidentId: 'INC001',
    roomNumber: 'TW02',
    bedNumber: '01',
    residentName: 'テスト太郎',
    detectionType: '起床',
    detectedAt: DateTime(2025, 1, 1, 10, 30),
    status: IncidentStatus.detected,
    videoId: 'video-001',
    actions: [],
  );

  setUp(() {
    mockRepository = MockIIncidentRepository();
    historyBloc = HistoryBloc(incidentRepository: mockRepository);
  });

  tearDown(() {
    historyBloc.close();
  });

  /// テスト用のウィジェットツリーを構築
  Widget createTestWidget({HistoryState? initialState}) {
    return MaterialApp(
      home: BlocProvider<HistoryBloc>.value(
        value: historyBloc,
        child: const HistoryPage(),
      ),
    );
  }

  group('HistoryPage - Initial Display', () {
    testWidgets('初期表示時にローディングインジケーターが表示される', (WidgetTester tester) async {
      // モックの設定：データ取得を遅延させる
      when(mockRepository.fetchIncidents(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
        orderBy: anyNamed('orderBy'),
        descending: anyNamed('descending'),
      )).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 1));
        return [mockIncident];
      });

      when(mockRepository.countIncidents()).thenAnswer((_) async => 1);

      // ウィジェットをビルド
      await tester.pumpWidget(createTestWidget());

      // 初期状態の確認：AppBarが表示されている
      expect(find.text('異常検知履歴'), findsOneWidget);

      // 少し待ってからローディング状態を確認
      await tester.pump(const Duration(milliseconds: 100));

      // ローディングインジケーターが表示される
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('データ取得成功時にHistoryTableが表示される', (WidgetTester tester) async {
      // モックの設定
      when(mockRepository.fetchIncidents(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
        orderBy: anyNamed('orderBy'),
        descending: anyNamed('descending'),
      )).thenAnswer((_) async => [mockIncident]);

      when(mockRepository.countIncidents()).thenAnswer((_) async => 1);

      // ウィジェットをビルド
      await tester.pumpWidget(createTestWidget());

      // 非同期処理の完了を待つ
      await tester.pumpAndSettle();

      // HistoryTableが表示される
      expect(find.text('履歴番号'), findsOneWidget);
      expect(find.text('INC001'), findsOneWidget);
      expect(find.text('テスト太郎'), findsOneWidget);
    });

    testWidgets('データ取得失敗時にエラーメッセージが表示される', (WidgetTester tester) async {
      // モックの設定：エラーを返す
      when(mockRepository.fetchIncidents(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
        orderBy: anyNamed('orderBy'),
        descending: anyNamed('descending'),
      )).thenThrow(Exception('ネットワークエラー'));

      // ウィジェットをビルド
      await tester.pumpWidget(createTestWidget());

      // 非同期処理の完了を待つ
      await tester.pumpAndSettle();

      // エラーアイコンが表示される
      expect(find.byIcon(Icons.error_outline), findsOneWidget);

      // エラーメッセージが表示される（SnackBar）
      expect(find.text('データの取得に失敗しました'), findsOneWidget);
    });

    testWidgets('データが空の場合に空状態メッセージが表示される', (WidgetTester tester) async {
      // モックの設定：空のリストを返す
      when(mockRepository.fetchIncidents(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
        orderBy: anyNamed('orderBy'),
        descending: anyNamed('descending'),
      )).thenAnswer((_) async => []);

      when(mockRepository.countIncidents()).thenAnswer((_) async => 0);

      // ウィジェットをビルド
      await tester.pumpWidget(createTestWidget());

      // 非同期処理の完了を待つ
      await tester.pumpAndSettle();

      // 空状態のメッセージが表示される
      expect(find.text('データがありません'), findsOneWidget);
      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    });
  });

  group('HistoryPage - Search Functionality', () {
    testWidgets('検索ボタンをタップすると検索フォームが表示される', (WidgetTester tester) async {
      // モックの設定
      when(mockRepository.fetchIncidents(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
        orderBy: anyNamed('orderBy'),
        descending: anyNamed('descending'),
      )).thenAnswer((_) async => [mockIncident]);

      when(mockRepository.countIncidents()).thenAnswer((_) async => 1);

      // ウィジェットをビルド
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 初期状態：検索フォームは表示されていない
      expect(find.text('部屋/ベッド番号'), findsNothing);

      // 検索ボタンをタップ
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // 検索フォームが表示される
      expect(find.text('部屋/ベッド番号'), findsOneWidget);
      expect(find.text('見守り対象者名'), findsOneWidget);
      expect(find.text('担当者'), findsOneWidget);
    });

    testWidgets('検索フォームで検索を実行するとAPIが呼ばれる', (WidgetTester tester) async {
      // モックの設定
      when(mockRepository.fetchIncidents(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
        orderBy: anyNamed('orderBy'),
        descending: anyNamed('descending'),
      )).thenAnswer((_) async => [mockIncident]);

      when(mockRepository.countIncidents()).thenAnswer((_) async => 1);

      when(mockRepository.searchIncidents(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        roomNumber: anyNamed('roomNumber'),
        bedNumber: anyNamed('bedNumber'),
        residentName: anyNamed('residentName'),
        performedBy: anyNamed('performedBy'),
        detectionType: anyNamed('detectionType'),
        status: anyNamed('status'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
        orderBy: anyNamed('orderBy'),
        descending: anyNamed('descending'),
      )).thenAnswer((_) async => [mockIncident]);

      when(mockRepository.countSearchResults(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        roomNumber: anyNamed('roomNumber'),
        bedNumber: anyNamed('bedNumber'),
        residentName: anyNamed('residentName'),
        performedBy: anyNamed('performedBy'),
        detectionType: anyNamed('detectionType'),
        status: anyNamed('status'),
      )).thenAnswer((_) async => 1);

      // ウィジェットをビルド
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 検索ボタンをタップして検索フォームを表示
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // 部屋番号を入力
      await tester.enterText(
        find.widgetWithText(TextField, '例: TW02-01'),
        'TW02/01',
      );

      // 検索ボタンをタップ
      await tester.tap(find.widgetWithText(ElevatedButton, '検索'));
      await tester.pumpAndSettle();

      // searchIncidentsが呼ばれたことを確認
      verify(mockRepository.searchIncidents(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        roomNumber: 'TW02',
        bedNumber: '01',
        residentName: anyNamed('residentName'),
        performedBy: anyNamed('performedBy'),
        detectionType: anyNamed('detectionType'),
        status: anyNamed('status'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
        orderBy: anyNamed('orderBy'),
        descending: anyNamed('descending'),
      )).called(1);
    });
  });

  group('HistoryPage - Pagination', () {
    testWidgets('ページネーションボタンをタップすると次のページが表示される', (WidgetTester tester) async {
      // モックの設定：複数ページ分のデータ
      when(mockRepository.fetchIncidents(
        limit: anyNamed('limit'),
        offset: 0,
        orderBy: anyNamed('orderBy'),
        descending: anyNamed('descending'),
      )).thenAnswer((_) async => List.generate(20, (i) => mockIncident));

      when(mockRepository.fetchIncidents(
        limit: anyNamed('limit'),
        offset: 20,
        orderBy: anyNamed('orderBy'),
        descending: anyNamed('descending'),
      )).thenAnswer((_) async => List.generate(20, (i) => mockIncident));

      when(mockRepository.countIncidents()).thenAnswer((_) async => 50);

      // ウィジェットをビルド
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 次ページボタンをタップ
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();

      // 2ページ目のデータ取得が呼ばれたことを確認
      verify(mockRepository.fetchIncidents(
        limit: 20,
        offset: 20,
        orderBy: 'detectedAt',
        descending: true,
      )).called(1);
    });
  });

  group('HistoryPage - Refresh', () {
    testWidgets('リフレッシュボタンをタップするとデータが再取得される', (WidgetTester tester) async {
      // モックの設定
      when(mockRepository.fetchIncidents(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
        orderBy: anyNamed('orderBy'),
        descending: anyNamed('descending'),
      )).thenAnswer((_) async => [mockIncident]);

      when(mockRepository.countIncidents()).thenAnswer((_) async => 1);

      // ウィジェットをビルド
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 最初のfetchIncidentsの呼び出しを確認
      verify(mockRepository.fetchIncidents(
        limit: 20,
        offset: 0,
        orderBy: 'detectedAt',
        descending: true,
      )).called(1);

      // リフレッシュボタンをタップ
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      // fetchIncidentsが再度呼ばれたことを確認
      verify(mockRepository.fetchIncidents(
        limit: 20,
        offset: 0,
        orderBy: 'detectedAt',
        descending: true,
      )).called(1);
    });
  });

  group('HistoryPage - Video Player', () {
    testWidgets('動画再生ボタンをタップすると動画プレーヤーモーダルが表示される', (WidgetTester tester) async {
      // モックの設定
      when(mockRepository.fetchIncidents(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
        orderBy: anyNamed('orderBy'),
        descending: anyNamed('descending'),
      )).thenAnswer((_) async => [mockIncident]);

      when(mockRepository.countIncidents()).thenAnswer((_) async => 1);

      // ウィジェットをビルド
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 動画再生ボタンを探す（テーブル内のplay_arrowアイコン）
      final playButtons = find.byIcon(Icons.play_arrow);
      expect(playButtons, findsWidgets);

      // 最初の動画再生ボタンをタップ
      await tester.tap(playButtons.first);
      await tester.pumpAndSettle();

      // 動画プレーヤーモーダルが表示される
      expect(find.text('動画再生'), findsOneWidget);
      expect(find.byType(VideoPlayerModal), findsOneWidget);
    });
  });

  group('HistoryPage - Error Handling', () {
    testWidgets('エラー発生時にSnackBarが表示される', (WidgetTester tester) async {
      // モックの設定：エラーを返す
      when(mockRepository.fetchIncidents(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
        orderBy: anyNamed('orderBy'),
        descending: anyNamed('descending'),
      )).thenThrow(Exception('API Error'));

      // ウィジェットをビルド
      await tester.pumpWidget(createTestWidget());

      // 非同期処理の完了を待つ
      await tester.pumpAndSettle();

      // SnackBarが表示される
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('データの取得に失敗しました'), findsOneWidget);

      // 再試行ボタンが表示される
      expect(find.text('再試行'), findsOneWidget);
    });

    testWidgets('再試行ボタンをタップするとデータが再取得される', (WidgetTester tester) async {
      // 最初はエラー、2回目は成功
      var callCount = 0;
      when(mockRepository.fetchIncidents(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
        orderBy: anyNamed('orderBy'),
        descending: anyNamed('descending'),
      )).thenAnswer((_) async {
        callCount++;
        if (callCount == 1) {
          throw Exception('API Error');
        }
        return [mockIncident];
      });

      when(mockRepository.countIncidents()).thenAnswer((_) async => 1);

      // ウィジェットをビルド
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // SnackBarが表示される
      expect(find.byType(SnackBar), findsOneWidget);

      // 再試行ボタンをタップ
      await tester.tap(find.text('再試行'));
      await tester.pumpAndSettle();

      // データが正常に取得されてHistoryTableが表示される
      expect(find.text('INC001'), findsOneWidget);
    });
  });

  group('HistoryPage - Responsive Layout', () {
    testWidgets('画面サイズに応じて検索フォームのレイアウトが変わる', (WidgetTester tester) async {
      // モックの設定
      when(mockRepository.fetchIncidents(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
        orderBy: anyNamed('orderBy'),
        descending: anyNamed('descending'),
      )).thenAnswer((_) async => [mockIncident]);

      when(mockRepository.countIncidents()).thenAnswer((_) async => 1);

      // 小さい画面サイズでテスト
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      // ウィジェットをビルド
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 検索ボタンをタップ
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // 検索フォームが表示される（レスポンシブレイアウト）
      expect(find.text('部屋/ベッド番号'), findsOneWidget);

      // 画面サイズをリセット
      addTearDown(tester.view.resetPhysicalSize);
    });
  });
}
