import 'package:flutter/material.dart';

/// テキストスタイルタイプ
enum TextStyleType {
  h1,
  h2,
  h3,
  body1,
  body2,
  caption,
}

/// アプリケーション共通テキスト
class AppText extends StatelessWidget {
  final String text;
  final TextStyleType type;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppText({
    super.key,
    required this.text,
    this.type = TextStyleType.body1,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle style;

    switch (type) {
      case TextStyleType.h1:
        style = const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        );
        break;
      case TextStyleType.h2:
        style = const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        );
        break;
      case TextStyleType.h3:
        style = const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        );
        break;
      case TextStyleType.body1:
        style = const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
        );
        break;
      case TextStyleType.body2:
        style = const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        );
        break;
      case TextStyleType.caption:
        style = const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: Colors.grey,
        );
        break;
    }

    if (color != null) {
      style = style.copyWith(color: color);
    }

    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
