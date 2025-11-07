import 'package:flutter/material.dart';

/// アイコンボタンのバリエーションを定義
enum IconButtonVariant {
  primary,
  secondary,
  text,
}

/// アイコンボタンのサイズを定義
enum IconButtonSize {
  small,
  medium,
  large,
}

/// アプリケーション全体で使用する統一されたアイコンボタンコンポーネント
///
/// バリエーション（primary, secondary, text）、サイズ、
/// カスタムカラー、ツールチップに対応したアイコンボタン
class AppIconButton extends StatelessWidget {
  /// 表示するアイコン
  final IconData icon;

  /// ボタンがタップされたときのコールバック
  final VoidCallback onPressed;

  /// ボタンのバリエーション（デフォルト: primary）
  final IconButtonVariant variant;

  /// ボタンのサイズ（デフォルト: medium）
  final IconButtonSize size;

  /// ボタンを無効化するかどうか（デフォルト: false）
  final bool disabled;

  /// ツールチップテキスト（オプショナル）
  final String? tooltip;

  /// カスタムカラー（オプショナル）
  final Color? color;

  const AppIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.variant = IconButtonVariant.primary,
    this.size = IconButtonSize.medium,
    this.disabled = false,
    this.tooltip,
    this.color,
  }) : super(key: key);

  /// サイズに応じたアイコンサイズを取得
  double _getIconSize() {
    switch (size) {
      case IconButtonSize.small:
        return 20;
      case IconButtonSize.medium:
        return 24;
      case IconButtonSize.large:
        return 28;
    }
  }

  /// サイズに応じたパディングを取得
  double _getPadding() {
    switch (size) {
      case IconButtonSize.small:
        return 8;
      case IconButtonSize.medium:
        return 12;
      case IconButtonSize.large:
        return 16;
    }
  }

  /// バリアントとコンテキストに応じたアイコンカラーを取得
  Color? _getIconColor(BuildContext context) {
    // カスタムカラーが指定されている場合はそれを使用
    if (color != null) return color;

    if (disabled) return Colors.grey;

    switch (variant) {
      case IconButtonVariant.primary:
        return Theme.of(context).colorScheme.primary;
      case IconButtonVariant.secondary:
        return Theme.of(context).colorScheme.secondary;
      case IconButtonVariant.text:
        return Theme.of(context).textTheme.bodyLarge?.color;
    }
  }

  /// バリアントに応じた背景色を取得
  Color? _getBackgroundColor(BuildContext context) {
    if (disabled) return Colors.grey.withOpacity(0.1);

    switch (variant) {
      case IconButtonVariant.primary:
        return Theme.of(context).colorScheme.primary.withOpacity(0.1);
      case IconButtonVariant.secondary:
        return Theme.of(context).colorScheme.secondary.withOpacity(0.1);
      case IconButtonVariant.text:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final VoidCallback? effectiveOnPressed = disabled ? null : onPressed;
    final iconColor = _getIconColor(context);

    Widget button = Container(
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: effectiveOnPressed,
        iconSize: _getIconSize(),
        padding: EdgeInsets.all(_getPadding()),
        color: iconColor,
        tooltip: tooltip,
        splashRadius: _getIconSize() + _getPadding(),
      ),
    );

    return button;
  }
}
