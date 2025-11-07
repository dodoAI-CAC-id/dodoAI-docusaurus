import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// アプリケーション全体で使用する統一されたテキストフィールドコンポーネント
///
/// バリデーション機能、エラー表示、ラベル、アイコン、パスワード入力など
/// 様々な機能に対応した柔軟なテキスト入力フィールド
class AppTextField extends StatelessWidget {
  /// 現在の入力値
  final String value;

  /// 値が変更されたときのコールバック
  final ValueChanged<String> onChanged;

  /// プレースホルダーテキスト
  final String? placeholder;

  /// ラベルテキスト
  final String? label;

  /// エラーメッセージ
  final String? errorText;

  /// フィールドを無効化するかどうか（デフォルト: false）
  final bool disabled;

  /// パスワードフィールドとして表示するかどうか（デフォルト: false）
  final bool isPassword;

  /// 最大行数（デフォルト: 1）
  final int maxLines;

  /// 最大文字数制限
  final int? maxLength;

  /// プレフィックスアイコン
  final IconData? prefixIcon;

  /// サフィックスアイコン
  final IconData? suffixIcon;

  /// キーボードタイプ
  final TextInputType? keyboardType;

  /// 入力フォーマッター
  final List<TextInputFormatter>? inputFormatters;

  const AppTextField({
    Key? key,
    required this.value,
    required this.onChanged,
    this.placeholder,
    this.label,
    this.errorText,
    this.disabled = false,
    this.isPassword = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
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
        
        // テキストフィールド本体
        TextField(
          controller: TextEditingController(text: value)
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: value.length),
            ),
          onChanged: onChanged,
          enabled: !disabled,
          obscureText: isPassword,
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: placeholder,
            errorText: errorText,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
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
        ),
      ],
    );
  }
}
