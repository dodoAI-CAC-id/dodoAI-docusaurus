import 'package:flutter/material.dart';

/// アプリケーション共通アイコンボタン
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;
  final Color? color;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.size = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      icon: Icon(icon, size: size),
      onPressed: onPressed,
      color: color ?? Theme.of(context).primaryColor,
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}
