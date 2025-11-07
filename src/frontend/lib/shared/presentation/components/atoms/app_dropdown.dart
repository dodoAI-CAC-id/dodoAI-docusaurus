import 'package:flutter/material.dart';

/// ドロップダウンの選択肢を表すデータクラス
class DropdownOption {
  final String value;
  final String label;

  const DropdownOption({
    required this.value,
    required this.label,
  });
}

/// アプリケーション全体で使用する統一されたドロップダウンコンポーネント
///
/// 選択肢のリストから1つの値を選択するためのドロップダウン
/// ラベル、プレースホルダー、エラー表示、無効化に対応
class AppDropdown extends StatelessWidget {
  /// 選択肢のリスト
  final List<DropdownOption> options;

  /// 現在選択されている値
  final String? value;

  /// 値が変更されたときのコールバック
  final ValueChanged<String?> onChanged;

  /// ラベルテキスト
  final String? label;

  /// プレースホルダーテキスト
  final String? placeholder;

  /// エラーメッセージ
  final String? errorText;

  /// ドロップダウンを無効化するかどうか（デフォルト: false）
  final bool disabled;

  const AppDropdown({
    Key? key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.label,
    this.placeholder,
    this.errorText,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ラベル表示
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 8),
        ],

        // ドロップダウン本体
        DropdownButtonFormField<String>(
          value: value,
          onChanged: disabled ? null : onChanged,
          decoration: InputDecoration(
            hintText: placeholder,
            errorText: errorText,
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: errorText != null
                    ? Theme.of(context).colorScheme.error
                    : Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: errorText != null
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 2,
              ),
            ),
            filled: disabled,
            fillColor: disabled ? Colors.grey[100] : null,
          ),
          items: options.isEmpty
              ? null
              : options.map((option) {
                  return DropdownMenuItem<String>(
                    value: option.value,
                    child: Text(option.label),
                  );
                }).toList(),
          hint: placeholder != null ? Text(placeholder!) : null,
        ),
      ],
    );
  }
}
