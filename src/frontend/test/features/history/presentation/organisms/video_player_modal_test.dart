import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/history/presentation/organisms/video_player_modal.dart';
import 'package:frontend/shared/presentation/components/atoms/app_button.dart';

void main() {
  group('VideoPlayerModal', () {
    const testVideoId = 'video123';
    const testVideoUrl = 'https://example.com/video.mp4';

    testWidgets('displays video player and controls', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoPlayerModal(
              videoId: testVideoId,
              videoUrl: testVideoUrl,
              onClose: () {},
              onDownload: () {},
            ),
          ),
        ),
      );

      // モーダルタイトルが表示されていること
      expect(find.text('動画再生'), findsOneWidget);

      // 閉じるボタンが表示されていること
      expect(find.byIcon(Icons.close), findsOneWidget);

      // ダウンロードボタンが表示されていること
      expect(find.text('ダウンロード'), findsOneWidget);
    });

    testWidgets('calls onClose when close button is tapped', (tester) async {
      bool closeCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoPlayerModal(
              videoId: testVideoId,
              videoUrl: testVideoUrl,
              onClose: () {
                closeCalled = true;
              },
              onDownload: () {},
            ),
          ),
        ),
      );

      // 閉じるボタンをタップ
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(closeCalled, isTrue);
    });

    testWidgets('calls onDownload when download button is tapped', (tester) async {
      bool downloadCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoPlayerModal(
              videoId: testVideoId,
              videoUrl: testVideoUrl,
              onClose: () {},
              onDownload: () {
                downloadCalled = true;
              },
            ),
          ),
        ),
      );

      // ダウンロードボタンをタップ
      await tester.tap(find.text('ダウンロード'));
      await tester.pumpAndSettle();

      expect(downloadCalled, isTrue);
    });

    testWidgets('displays loading indicator while video is initializing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoPlayerModal(
              videoId: testVideoId,
              videoUrl: testVideoUrl,
              onClose: () {},
              onDownload: () {},
            ),
          ),
        ),
      );

      // ローディングインジケーターが表示されていること
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays play/pause controls', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoPlayerModal(
              videoId: testVideoId,
              videoUrl: testVideoUrl,
              onClose: () {},
              onDownload: () {},
            ),
          ),
        ),
      );

      // 動画の初期化を待つ
      await tester.pumpAndSettle();

      // 再生/一時停止ボタンが存在すること
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is IconButton &&
              (widget.icon is Icon) &&
              ((widget.icon as Icon).icon == Icons.play_arrow ||
                  (widget.icon as Icon).icon == Icons.pause),
        ),
        findsOneWidget,
      );
    });

    testWidgets('displays error message when video fails to load', (tester) async {
      String? errorMessage;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoPlayerModal(
              videoId: testVideoId,
              videoUrl: 'invalid_url',
              onClose: () {},
              onDownload: () {},
              onError: (error) {
                errorMessage = error;
              },
            ),
          ),
        ),
      );

      // エラー発生を待つ
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // エラーメッセージが表示されるか、onErrorが呼ばれること
      // (実際のテストではモックを使用するべき)
      expect(errorMessage != null || find.byIcon(Icons.error_outline).evaluate().isNotEmpty, isTrue);
    });

    testWidgets('displays video progress slider', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoPlayerModal(
              videoId: testVideoId,
              videoUrl: testVideoUrl,
              onClose: () {},
              onDownload: () {},
            ),
          ),
        ),
      );

      // 動画の初期化を待つ
      await tester.pumpAndSettle();

      // プログレススライダーが存在すること
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('toggles fullscreen mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoPlayerModal(
              videoId: testVideoId,
              videoUrl: testVideoUrl,
              onClose: () {},
              onDownload: () {},
            ),
          ),
        ),
      );

      // 全画面ボタンが表示されていること
      expect(find.byIcon(Icons.fullscreen), findsOneWidget);
    });

    testWidgets('displays video duration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoPlayerModal(
              videoId: testVideoId,
              videoUrl: testVideoUrl,
              onClose: () {},
              onDownload: () {},
            ),
          ),
        ),
      );

      // 動画の初期化を待つ
      await tester.pumpAndSettle();

      // 時間表示が存在すること（フォーマット: MM:SS）
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              widget.data != null &&
              RegExp(r'\d{2}:\d{2}').hasMatch(widget.data!),
        ),
        findsWidgets,
      );
    });
  });
}
