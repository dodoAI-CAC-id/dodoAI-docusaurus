import 'package:flutter/material.dart';

/// バッジのバリエーションを定義
enum BadgeVariant {
  primary,
  success,
  warning,
  error,
  info,
  neutral,
}

/// バッジのサイズを定義
enum BadgeSize {
  small,
  medium,
  large,
}

/// ステータスバッジコンポーネント
///
/// 異常検知の状態や操作のステータスを視覚的に表示するバッジ
/// 複数のカラーバリアント、サイズ、アイコン付きに対応
class StatusBadge extends StatelessWidget {
  /// バッジに表示するテキスト
  final String label;

  /// バッジのバリアント（デフォルト: primary）
  final BadgeVariant variant;

  /// バッジのサイズ（デフォルト: medium）
  final BadgeSize size;

  /// バッジに表示するアイコン（オプショナル）
  final IconData? icon;

  const StatusBadge({
    Key? key,
    required this.label,
    this.variant = BadgeVariant.primary,
    this.size = BadgeSize.medium,
    this.icon,
  }) : super(key: key);

  /// バリアントに応じた背景色を取得
  Color _getBackgroundColor(BuildContext context) {
    switch (variant) {
      case BadgeVariant.primary:
        return Theme.of(context).colorScheme.primary.withOpacity(0.1);
      case BadgeVariant.success:
        return Colors.green.withOpacity(0.1);
      case BadgeVariant.warning:
        return Colors.orange.withOpacity(0.1);
      case BadgeVariant.error:
        return Colors.red.withOpacity(0.1);
      case BadgeVariant.info:
        return Colors.blue.withOpacity(0.1);
      case BadgeVariant.neutral:
        return Colors.grey.withOpacity(0.1);
    }
  }

  /// バリアントに応じたテキスト色を取得
  Color _getTextColor(BuildContext context) {
    switch (variant) {
      case BadgeVariant.primary:
        return Theme.of(context).colorScheme.primary;
      case BadgeVariant.success:
        return Colors.green.shade700;
      case BadgeVariant.warning:
        return Colors.orange.shade700;
      case BadgeVariant.error:
        return Colors.red.shade700;
      case BadgeVariant.info:
        return Colors.blue.shade700;
      case BadgeVariant.neutral:
        return Colors.grey.shade700;
    }
  }

  /// サイズに応じたパディングを取得
  EdgeInsets _getPadding() {
    switch (size) {
      case BadgeSize.small:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case BadgeSize.medium:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case BadgeSize.large:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    }
  }

  /// サイズに応じたフォントサイズを取得
  double _getFontSize() {
    switch (size) {
      case BadgeSize.small:
        return 11;
      case BadgeSize.medium:
        return 13;
      case BadgeSize.large:
        return 15;
    }
  }

  /// サイズに応じたアイコンサイズを取得
  double _getIconSize() {
    switch (size) {
      case BadgeSize.small:
        return 14;
      case BadgeSize.medium:
        return 16;
      case BadgeSize.large:
        return 18;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = _getTextColor(context);

    return Container(
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: _getIconSize(),
              color: textColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: _getFontSize(),
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
