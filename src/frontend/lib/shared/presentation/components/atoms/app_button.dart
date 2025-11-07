import 'package:flutter/material.dart';

/// ボタンのバリエーションを定義
enum ButtonVariant {
  primary,
  secondary,
  text,
}

/// アプリケーション全体で使用する統一されたボタンコンポーネント
///
/// [ButtonVariant]で3つのスタイル（primary, secondary, text）を提供
/// disabled状態、loading状態、アイコン付きボタンにも対応
class AppButton extends StatelessWidget {
  /// ボタンに表示するテキスト
  final String label;

  /// ボタンがタップされたときのコールバック
  final VoidCallback onPressed;

  /// ボタンのバリエーション（デフォルト: primary）
  final ButtonVariant variant;

  /// ボタンを無効化するかどうか（デフォルト: false）
  final bool disabled;

  /// ローディング状態を表示するかどうか（デフォルト: false）
  final bool isLoading;

  /// ボタンに表示するアイコン（オプショナル）
  final IconData? icon;

  const AppButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.disabled = false,
    this.isLoading = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 無効化またはローディング中の場合は、onPressedをnullにする
    final VoidCallback? effectiveOnPressed =
        (disabled || isLoading) ? null : onPressed;

    // ボタンの内容（ラベル＋オプションでアイコン）
    Widget buttonChild;
    if (isLoading) {
      // ローディング中はスピナーを表示
      buttonChild = const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else if (icon != null) {
      // アイコン付きの場合
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label),
        ],
      );
    } else {
      // 通常のテキストのみ
      buttonChild = Text(label);
    }

    // バリエーションに応じてボタンの種類を切り替え
    switch (variant) {
      case ButtonVariant.primary:
        return ElevatedButton(
          onPressed: effectiveOnPressed,
          child: buttonChild,
        );
      case ButtonVariant.secondary:
        return OutlinedButton(
          onPressed: effectiveOnPressed,
          child: buttonChild,
        );
      case ButtonVariant.text:
        return TextButton(
          onPressed: effectiveOnPressed,
          child: buttonChild,
        );
    }
  }
}
