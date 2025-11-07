import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:frontend/shared/presentation/components/atoms/app_button.dart';

WidgetbookComponent appButtonStories() {
  return WidgetbookComponent(
    name: 'AppButton',
    useCases: [
      WidgetbookUseCase(
        name: 'Primary',
        builder: (context) => Center(
          child: AppButton(
            label: 'プライマリボタン',
            onPressed: () {},
            variant: ButtonVariant.primary,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Secondary',
        builder: (context) => Center(
          child: AppButton(
            label: 'セカンダリボタン',
            onPressed: () {},
            variant: ButtonVariant.secondary,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Text',
        builder: (context) => Center(
          child: AppButton(
            label: 'テキストボタン',
            onPressed: () {},
            variant: ButtonVariant.text,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Disabled',
        builder: (context) => Center(
          child: AppButton(
            label: '無効ボタン',
            onPressed: () {},
            disabled: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Loading',
        builder: (context) => Center(
          child: AppButton(
            label: 'ローディング',
            onPressed: () {},
            isLoading: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With Icon',
        builder: (context) => Center(
          child: AppButton(
            label: 'アイコン付き',
            onPressed: () {},
            icon: Icons.add,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'All Variants',
        builder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppButton(
                label: 'プライマリ',
                onPressed: () {},
                variant: ButtonVariant.primary,
              ),
              const SizedBox(height: 16),
              AppButton(
                label: 'セカンダリ',
                onPressed: () {},
                variant: ButtonVariant.secondary,
              ),
              const SizedBox(height: 16),
              AppButton(
                label: 'テキスト',
                onPressed: () {},
                variant: ButtonVariant.text,
              ),
              const SizedBox(height: 16),
              AppButton(
                label: '無効',
                onPressed: () {},
                disabled: true,
              ),
              const SizedBox(height: 16),
              AppButton(
                label: 'アイコン付き',
                onPressed: () {},
                icon: Icons.check,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
