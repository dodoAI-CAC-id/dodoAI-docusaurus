import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:frontend/features/history/presentation/organisms/video_player_modal.dart';

/// VideoPlayerModal stories for Widgetbook
/// 
/// 注意: video_playerは実際のネットワーク動画URLが必要なため、
/// Widgetbookでは初期化エラーが表示される可能性があります。
/// 実際のアプリケーションでは正しいURLを使用してください。
WidgetbookComponent videoPlayerModalStories() {
  return WidgetbookComponent(
    name: 'VideoPlayerModal',
    useCases: [
      WidgetbookUseCase(
        name: 'Default',
        builder: (context) => _buildDefaultUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'With Error Handling',
        builder: (context) => _buildWithErrorHandlingUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'Compact Size',
        builder: (context) => _buildCompactSizeUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'Large Size',
        builder: (context) => _buildLargeSizeUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'In Dialog',
        builder: (context) => _buildInDialogUseCase(context),
      ),
    ],
  );
}

Widget _buildDefaultUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: SizedBox(
        width: 800,
        height: 600,
        child: VideoPlayerModal(
          videoId: 'video123',
          videoUrl: 'https://example.com/sample-video.mp4',
          onClose: () {
            debugPrint('Close button pressed');
          },
          onDownload: () {
            debugPrint('Download button pressed');
          },
          onError: (error) {
            debugPrint('Video error: $error');
          },
        ),
      ),
    ),
  );
}

Widget _buildWithErrorHandlingUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: SizedBox(
        width: 800,
        height: 600,
        child: VideoPlayerModal(
          videoId: 'video456',
          videoUrl: 'invalid_url', // 意図的に無効なURLを使用
          onClose: () {
            debugPrint('Close button pressed');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('モーダルを閉じました')),
            );
          },
          onDownload: () {
            debugPrint('Download button pressed');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('ダウンロードを開始しました')),
            );
          },
          onError: (error) {
            debugPrint('Video error: $error');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('エラー: $error'),
                backgroundColor: Colors.red,
              ),
            );
          },
        ),
      ),
    ),
  );
}

Widget _buildCompactSizeUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: SizedBox(
        width: 480,
        height: 360,
        child: VideoPlayerModal(
          videoId: 'video789',
          videoUrl: 'https://example.com/sample-video-small.mp4',
          onClose: () {
            debugPrint('Close button pressed');
          },
          onDownload: () {
            debugPrint('Download button pressed');
          },
        ),
      ),
    ),
  );
}

Widget _buildLargeSizeUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: SizedBox(
        width: 1280,
        height: 720,
        child: VideoPlayerModal(
          videoId: 'video101',
          videoUrl: 'https://example.com/sample-video-large.mp4',
          onClose: () {
            debugPrint('Close button pressed');
          },
          onDownload: () {
            debugPrint('Download button pressed');
          },
        ),
      ),
    ),
  );
}

Widget _buildInDialogUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              child: SizedBox(
                width: 800,
                height: 600,
                child: VideoPlayerModal(
                  videoId: 'video202',
                  videoUrl: 'https://example.com/sample-video.mp4',
                  onClose: () {
                    Navigator.of(context).pop();
                    debugPrint('Dialog closed');
                  },
                  onDownload: () {
                    debugPrint('Download button pressed');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('ダウンロードを開始しました'),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
        child: const Text('動画を再生'),
      ),
    ),
  );
}
