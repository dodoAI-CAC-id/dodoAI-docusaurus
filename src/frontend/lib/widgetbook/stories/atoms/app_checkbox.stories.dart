import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:frontend/shared/presentation/components/atoms/app_checkbox.dart';

WidgetbookComponent appCheckboxStories() {
  return WidgetbookComponent(
    name: 'AppCheckbox',
    useCases: [
      WidgetbookUseCase(
        name: 'Unchecked',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppCheckbox(
            value: false,
            onChanged: (value) {},
            label: 'チェックなし',
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Checked',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppCheckbox(
            value: true,
            onChanged: (value) {},
            label: 'チェック済み',
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Without Label',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppCheckbox(
            value: false,
            onChanged: (value) {},
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Disabled Unchecked',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppCheckbox(
            value: false,
            onChanged: (value) {},
            label: '無効（チェックなし）',
            disabled: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Disabled Checked',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppCheckbox(
            value: true,
            onChanged: (value) {},
            label: '無効（チェック済み）',
            disabled: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With Error',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppCheckbox(
            value: false,
            onChanged: (value) {},
            label: '利用規約に同意する',
            errorText: 'この項目は必須です',
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Interactive',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: StatefulBuilder(
            builder: (context, setState) {
              bool isChecked = false;
              return AppCheckbox(
                value: isChecked,
                onChanged: (value) {
                  setState(() => isChecked = value);
                },
                label: 'クリックして状態を変更',
              );
            },
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Multiple Checkboxes',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: StatefulBuilder(
            builder: (context, setState) {
              bool option1 = false;
              bool option2 = true;
              bool option3 = false;
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '興味のあるトピックを選択してください',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  AppCheckbox(
                    value: option1,
                    onChanged: (value) {
                      setState(() => option1 = value);
                    },
                    label: 'プログラミング',
                  ),
                  const SizedBox(height: 8),
                  AppCheckbox(
                    value: option2,
                    onChanged: (value) {
                      setState(() => option2 = value);
                    },
                    label: 'デザイン',
                  ),
                  const SizedBox(height: 8),
                  AppCheckbox(
                    value: option3,
                    onChanged: (value) {
                      setState(() => option3 = value);
                    },
                    label: 'マーケティング',
                  ),
                ],
              );
            },
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'All Variations',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCheckbox(
                value: false,
                onChanged: (value) {},
                label: 'チェックなし',
              ),
              const SizedBox(height: 16),
              AppCheckbox(
                value: true,
                onChanged: (value) {},
                label: 'チェック済み',
              ),
              const SizedBox(height: 16),
              AppCheckbox(
                value: false,
                onChanged: (value) {},
                label: '無効状態',
                disabled: true,
              ),
              const SizedBox(height: 16),
              AppCheckbox(
                value: false,
                onChanged: (value) {},
                label: 'エラー表示',
                errorText: 'この項目は必須です',
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
