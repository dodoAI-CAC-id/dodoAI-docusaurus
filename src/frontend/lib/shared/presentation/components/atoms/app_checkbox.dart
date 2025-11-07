import 'package:flutter/material.dart';

/// アプリケーション全体で使用する統一されたチェックボックスコンポーネント
///
/// ラベル付き、無効化、エラー表示に対応したチェックボックス
/// ラベルをタップしても状態が変わる使いやすいUI
class AppCheckbox extends StatelessWidget {
  /// チェック状態
  final bool value;

  /// 状態が変更されたときのコールバック
  final ValueChanged<bool> onChanged;

  /// ラベルテキスト（オプショナル）
  final String? label;

  /// エラーメッセージ
  final String? errorText;

  /// チェックボックスを無効化するかどうか（デフォルト: false）
  final bool disabled;

  const AppCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.label,
    this.errorText,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: disabled
              ? null
              : () {
                  onChanged(!value);
                },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: value,
                onChanged: disabled ? null : (newValue) => onChanged(newValue ?? false),
              ),
              if (label != null) ...[
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: disabled ? Colors.grey : null,
                        ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              errorText!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
        ],
      ],
    );
  }
}
