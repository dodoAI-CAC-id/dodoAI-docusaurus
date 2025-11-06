import 'package:flutter/material.dart';

/// アプリケーション共通チェックボックス
class AppCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? label;
  final bool enabled;

  const AppCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (label != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeColor: theme.primaryColor,
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: enabled && onChanged != null
                ? () => onChanged!(!value)
                : null,
            child: Text(
              label!,
              style: TextStyle(
                fontSize: 14,
                color: enabled ? Colors.black87 : Colors.grey,
              ),
            ),
          ),
        ],
      );
    }

    return Checkbox(
      value: value,
      onChanged: enabled ? onChanged : null,
      activeColor: theme.primaryColor,
    );
  }
}
