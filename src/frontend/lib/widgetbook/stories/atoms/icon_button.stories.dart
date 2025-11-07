import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:frontend/shared/presentation/components/atoms/icon_button.dart';

WidgetbookComponent iconButtonStories() {
  return WidgetbookComponent(
    name: 'AppIconButton',
    useCases: [
      WidgetbookUseCase(
        name: 'Primary',
        builder: (context) => Center(
          child: AppIconButton(
            icon: Icons.add,
            onPressed: () {},
            variant: IconButtonVariant.primary,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Secondary',
        builder: (context) => Center(
          child: AppIconButton(
            icon: Icons.settings,
            onPressed: () {},
            variant: IconButtonVariant.secondary,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Text',
        builder: (context) => Center(
          child: AppIconButton(
            icon: Icons.close,
            onPressed: () {},
            variant: IconButtonVariant.text,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Disabled',
        builder: (context) => Center(
          child: AppIconButton(
            icon: Icons.delete,
            onPressed: () {},
            disabled: true,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Small Size',
        builder: (context) => Center(
          child: AppIconButton(
            icon: Icons.edit,
            onPressed: () {},
            size: IconButtonSize.small,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Medium Size',
        builder: (context) => Center(
          child: AppIconButton(
            icon: Icons.edit,
            onPressed: () {},
            size: IconButtonSize.medium,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Large Size',
        builder: (context) => Center(
          child: AppIconButton(
            icon: Icons.edit,
            onPressed: () {},
            size: IconButtonSize.large,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With Tooltip',
        builder: (context) => Center(
          child: AppIconButton(
            icon: Icons.help,
            onPressed: () {},
            tooltip: 'ヘルプ',
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Custom Color',
        builder: (context) => Center(
          child: AppIconButton(
            icon: Icons.favorite,
            onPressed: () {},
            color: Colors.red,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Common Icons',
        builder: (context) => Center(
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              AppIconButton(
                icon: Icons.add,
                onPressed: () {},
                tooltip: '追加',
              ),
              AppIconButton(
                icon: Icons.edit,
                onPressed: () {},
                tooltip: '編集',
              ),
              AppIconButton(
                icon: Icons.delete,
                onPressed: () {},
                tooltip: '削除',
                color: Colors.red,
              ),
              AppIconButton(
                icon: Icons.search,
                onPressed: () {},
                tooltip: '検索',
              ),
              AppIconButton(
                icon: Icons.settings,
                onPressed: () {},
                tooltip: '設定',
              ),
              AppIconButton(
                icon: Icons.close,
                onPressed: () {},
                tooltip: '閉じる',
              ),
              AppIconButton(
                icon: Icons.refresh,
                onPressed: () {},
                tooltip: '更新',
              ),
              AppIconButton(
                icon: Icons.download,
                onPressed: () {},
                tooltip: 'ダウンロード',
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Video Player Icons',
        builder: (context) => Center(
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              AppIconButton(
                icon: Icons.play_arrow,
                onPressed: () {},
                tooltip: '再生',
                size: IconButtonSize.large,
              ),
              AppIconButton(
                icon: Icons.pause,
                onPressed: () {},
                tooltip: '一時停止',
                size: IconButtonSize.large,
              ),
              AppIconButton(
                icon: Icons.stop,
                onPressed: () {},
                tooltip: '停止',
                size: IconButtonSize.large,
              ),
              AppIconButton(
                icon: Icons.download,
                onPressed: () {},
                tooltip: 'ダウンロード',
                size: IconButtonSize.large,
              ),
              AppIconButton(
                icon: Icons.fullscreen,
                onPressed: () {},
                tooltip: '全画面',
                size: IconButtonSize.large,
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'All Variants',
        builder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Primary', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              AppIconButton(
                icon: Icons.star,
                onPressed: () {},
                variant: IconButtonVariant.primary,
              ),
              const SizedBox(height: 24),
              const Text('Secondary', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              AppIconButton(
                icon: Icons.settings,
                onPressed: () {},
                variant: IconButtonVariant.secondary,
              ),
              const SizedBox(height: 24),
              const Text('Text', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              AppIconButton(
                icon: Icons.more_vert,
                onPressed: () {},
                variant: IconButtonVariant.text,
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'All Sizes',
        builder: (context) => Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIconButton(
                icon: Icons.star,
                onPressed: () {},
                size: IconButtonSize.small,
              ),
              const SizedBox(width: 16),
              AppIconButton(
                icon: Icons.star,
                onPressed: () {},
                size: IconButtonSize.medium,
              ),
              const SizedBox(width: 16),
              AppIconButton(
                icon: Icons.star,
                onPressed: () {},
                size: IconButtonSize.large,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
