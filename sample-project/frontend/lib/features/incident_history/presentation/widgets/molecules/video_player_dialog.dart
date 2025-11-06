import 'package:flutter/material.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_button.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_text.dart';

/// 動画再生ダイアログのMoleculeコンポーネント
class VideoPlayerDialog extends StatelessWidget {
  final String videoId;
  final String incidentId;
  final VoidCallback onClose;

  const VideoPlayerDialog({
    Key? key,
    required this.videoId,
    required this.incidentId,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ヘッダー
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: 'インシデント: $incidentId',
                  type: TextStyleType.h3,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                  tooltip: '閉じる',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 動画プレーヤー（プレースホルダー）
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        size: 64,
                        color: Colors.white,
                      ),
                      SizedBox(height: 16),
                      Text(
                        '動画プレーヤー',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '※実際の動画プレーヤーは後で実装',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // コントロールボタン
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  text: 'ダウンロード',
                  icon: Icons.download,
                  type: ButtonType.secondary,
                  onPressed: () {
                    // TODO: 動画ダウンロード機能を実装
                  },
                ),
                const SizedBox(width: 16),
                AppButton(
                  text: '閉じる',
                  onPressed: onClose,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
