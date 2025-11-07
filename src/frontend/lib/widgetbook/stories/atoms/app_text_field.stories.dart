import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:frontend/shared/presentation/components/atoms/app_text_field.dart';

WidgetbookComponent appTextFieldStories() {
  return WidgetbookComponent(
    name: 'AppTextField',
    useCases: [
      WidgetbookUseCase(
        name: 'Basic',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppTextField(
            value: '',
            onChanged: (value) {},
            placeholder: 'テキストを入力',
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With Label',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppTextField(
            value: '',
            onChanged: (value) {},
            label: '名前',
            placeholder: '名前を入力してください',
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With Error',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppTextField(
            value: '',
            onChanged: (value) {},
            label: 'メールアドレス',
            placeholder: 'email@example.com',
            errorText: 'このフィールドは必須です',
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Disabled',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppTextField(
            value: '無効なフィールド',
            onChanged: (value) {},
            disabled: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Password',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppTextField(
            value: '',
            onChanged: (value) {},
            label: 'パスワード',
            placeholder: 'パスワードを入力',
            isPassword: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With Prefix Icon',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppTextField(
            value: '',
            onChanged: (value) {},
            placeholder: '検索...',
            prefixIcon: Icons.search,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With Suffix Icon',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppTextField(
            value: 'クリア可能なテキスト',
            onChanged: (value) {},
            suffixIcon: Icons.clear,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Multiline',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppTextField(
            value: '',
            onChanged: (value) {},
            label: 'コメント',
            placeholder: 'コメントを入力してください',
            maxLines: 4,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With Max Length',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppTextField(
            value: '',
            onChanged: (value) {},
            label: 'ユーザー名',
            placeholder: '最大20文字',
            maxLength: 20,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'All Variations',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  value: '',
                  onChanged: (value) {},
                  label: '基本フィールド',
                  placeholder: 'テキストを入力',
                ),
                const SizedBox(height: 16),
                AppTextField(
                  value: '',
                  onChanged: (value) {},
                  label: 'エラー表示',
                  errorText: '入力が無効です',
                ),
                const SizedBox(height: 16),
                AppTextField(
                  value: '',
                  onChanged: (value) {},
                  label: '検索フィールド',
                  placeholder: '検索...',
                  prefixIcon: Icons.search,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  value: '',
                  onChanged: (value) {},
                  label: 'パスワード',
                  placeholder: '********',
                  isPassword: true,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  value: '無効なフィールド',
                  onChanged: (value) {},
                  label: '無効状態',
                  disabled: true,
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
