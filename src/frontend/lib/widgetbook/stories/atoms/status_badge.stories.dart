import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:frontend/shared/presentation/components/atoms/status_badge.dart';

WidgetbookComponent statusBadgeStories() {
  return WidgetbookComponent(
    name: 'StatusBadge',
    useCases: [
      WidgetbookUseCase(
        name: 'Primary',
        builder: (context) => const Center(
          child: StatusBadge(
            label: 'プライマリ',
            variant: BadgeVariant.primary,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Success',
        builder: (context) => const Center(
          child: StatusBadge(
            label: '完了',
            variant: BadgeVariant.success,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Warning',
        builder: (context) => const Center(
          child: StatusBadge(
            label: '警告',
            variant: BadgeVariant.warning,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Error',
        builder: (context) => const Center(
          child: StatusBadge(
            label: 'エラー',
            variant: BadgeVariant.error,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Info',
        builder: (context) => const Center(
          child: StatusBadge(
            label: '情報',
            variant: BadgeVariant.info,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Neutral',
        builder: (context) => const Center(
          child: StatusBadge(
            label: '中立',
            variant: BadgeVariant.neutral,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'With Icon',
        builder: (context) => const Center(
          child: StatusBadge(
            label: 'チェック済み',
            variant: BadgeVariant.success,
            icon: Icons.check_circle,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Small Size',
        builder: (context) => const Center(
          child: StatusBadge(
            label: '小サイズ',
            variant: BadgeVariant.primary,
            size: BadgeSize.small,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Medium Size',
        builder: (context) => const Center(
          child: StatusBadge(
            label: '中サイズ',
            variant: BadgeVariant.primary,
            size: BadgeSize.medium,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Large Size',
        builder: (context) => const Center(
          child: StatusBadge(
            label: '大サイズ',
            variant: BadgeVariant.primary,
            size: BadgeSize.large,
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Action Types (操作)',
        builder: (context) => Center(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              StatusBadge(label: '対応', variant: BadgeVariant.primary),
              StatusBadge(label: '完了', variant: BadgeVariant.success, icon: Icons.check),
              StatusBadge(label: '訪室不要', variant: BadgeVariant.info),
              StatusBadge(label: '対応不要', variant: BadgeVariant.neutral),
              StatusBadge(label: '誤検知', variant: BadgeVariant.warning),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Posture Types (異常検出動作)',
        builder: (context) => Center(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              StatusBadge(label: '起床', variant: BadgeVariant.warning, icon: Icons.bed),
              StatusBadge(label: '端坐位', variant: BadgeVariant.info, icon: Icons.chair),
              StatusBadge(label: '転倒', variant: BadgeVariant.error, icon: Icons.warning),
              StatusBadge(label: '離床', variant: BadgeVariant.primary, icon: Icons.directions_walk),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'All Variants',
        builder: (context) => Center(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              StatusBadge(label: 'Primary', variant: BadgeVariant.primary),
              StatusBadge(label: 'Success', variant: BadgeVariant.success),
              StatusBadge(label: 'Warning', variant: BadgeVariant.warning),
              StatusBadge(label: 'Error', variant: BadgeVariant.error),
              StatusBadge(label: 'Info', variant: BadgeVariant.info),
              StatusBadge(label: 'Neutral', variant: BadgeVariant.neutral),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'All Sizes',
        builder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              StatusBadge(
                label: '小サイズ',
                variant: BadgeVariant.primary,
                size: BadgeSize.small,
              ),
              SizedBox(height: 8),
              StatusBadge(
                label: '中サイズ',
                variant: BadgeVariant.primary,
                size: BadgeSize.medium,
              ),
              SizedBox(height: 8),
              StatusBadge(
                label: '大サイズ',
                variant: BadgeVariant.primary,
                size: BadgeSize.large,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
