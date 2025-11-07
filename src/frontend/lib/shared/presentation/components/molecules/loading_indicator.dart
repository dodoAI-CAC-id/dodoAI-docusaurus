import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/core/themes/app_typography.dart';

/// ローディングインジケーターコンポーネント
/// 
/// データの読み込み中に表示するローディング表示を提供します。
/// オーバーレイモードを有効にすると、画面全体を覆う半透明の背景とともに表示されます。
class LoadingIndicator extends StatelessWidget {
  /// ローディング中に表示するメッセージ
  final String? message;

  /// インジケーターのサイズ
  final double size;

  /// オーバーレイモード（画面全体を覆う半透明背景を表示）
  final bool overlay;

  const LoadingIndicator({
    super.key,
    this.message,
    this.size = 40.0,
    this.overlay = false,
  });

  @override
  Widget build(BuildContext context) {
    final indicator = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16.0),
            Text(
              message!,
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );

    if (overlay) {
      return Container(
        color: Colors.black.withOpacity(0.3),
        child: indicator,
      );
    }

    return indicator;
  }
}
