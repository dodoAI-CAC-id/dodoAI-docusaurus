import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:frontend/shared/presentation/components/atoms/app_dropdown.dart';

WidgetbookComponent appDropdownStories() {
  final sampleOptions = [
    const DropdownOption(value: '1', label: 'オプション1'),
    const DropdownOption(value: '2', label: 'オプション2'),
    const DropdownOption(value: '3', label: 'オプション3'),
    const DropdownOption(value: '4', label: 'オプション4'),
  ];

  final actionOptions = [
    const DropdownOption(value: 'response', label: '対応'),
    const DropdownOption(value: 'complete', label: '完了'),
    const DropdownOption(value: 'no_visit', label: '訪室不要'),
    const DropdownOption(value: 'no_action', label: '対応不要'),
    const DropdownOption(value: 'false_detection', label: '誤検知'),
  ];

  final postureOptions = [
    const DropdownOption(value: 'wakeup', label: '起床'),
    const DropdownOption(value: 'sitting', label: '端坐位'),
    const DropdownOption(value: 'fall', label: '転倒'),
    const DropdownOption(value: 'leave', label: '離床'),
  ];

  return WidgetbookComponent(
    name: 'AppDropdown',
    useCases: [
      WidgetbookUseCase(
        name: 'Basic',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppDropdown(
            options: sampleOptions,
            value: '1',
            onChanged: (value) {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With Label',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppDropdown(
            options: sampleOptions,
            value: '2',
            onChanged: (value) {},
            label: 'カテゴリー',
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With Placeholder',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppDropdown(
            options: sampleOptions,
            value: null,
            onChanged: (value) {},
            placeholder: '選択してください',
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With Error',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppDropdown(
            options: sampleOptions,
            value: null,
            onChanged: (value) {},
            label: '必須項目',
            placeholder: '選択してください',
            errorText: 'この項目は必須です',
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Disabled',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppDropdown(
            options: sampleOptions,
            value: '1',
            onChanged: (value) {},
            disabled: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Action Type (操作)',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppDropdown(
            options: actionOptions,
            value: null,
            onChanged: (value) {},
            label: '操作',
            placeholder: '操作を選択',
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Posture Type (異常検出動作)',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppDropdown(
            options: postureOptions,
            value: null,
            onChanged: (value) {},
            label: '異常検出動作',
            placeholder: '動作を選択',
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
                AppDropdown(
                  options: sampleOptions,
                  value: '1',
                  onChanged: (value) {},
                  label: '基本ドロップダウン',
                ),
                const SizedBox(height: 16),
                AppDropdown(
                  options: sampleOptions,
                  value: null,
                  onChanged: (value) {},
                  label: 'プレースホルダー付き',
                  placeholder: '選択してください',
                ),
                const SizedBox(height: 16),
                AppDropdown(
                  options: sampleOptions,
                  value: null,
                  onChanged: (value) {},
                  label: 'エラー表示',
                  errorText: 'この項目は必須です',
                ),
                const SizedBox(height: 16),
                AppDropdown(
                  options: sampleOptions,
                  value: '2',
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
