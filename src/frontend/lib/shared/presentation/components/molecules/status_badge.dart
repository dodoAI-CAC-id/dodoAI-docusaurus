import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_typography.dart';

/// ステータスバッジコンポーネント
/// 
/// 操作ステータス（対応、完了、訪室不要、対応不要、誤検知）を色分けして表示します。
class StatusBadge extends StatelessWidget {
  /// 表示するステータス
  final String status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 6.0,
      ),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        status,
        style: AppTypography.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// ステータスに応じた色を返す
  Color _getStatusColor(String status) {
    switch (status) {
      case '対応':
        return const Color(0xFFFF9800); // Orange - warning
      case '完了':
        return const Color(0xFF4CAF50); // Green - success
      case '訪室不要':
        return const Color(0xFF2196F3); // Blue - info
      case '対応不要':
        return const Color(0xFF9E9E9E); // Gray - secondary
      case '誤検知':
        return const Color(0xFFF44336); // Red - error
      default:
        return const Color(0xFF9E9E9E); // Gray - default
    }
  }
}
