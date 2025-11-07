import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:frontend/shared/presentation/components/molecules/status_badge.dart';

/// StatusBadge stories for Widgetbook
WidgetbookComponent statusBadgeStoriesMolecules() {
  return WidgetbookComponent(
    name: 'StatusBadge (Molecules)',
    useCases: [
      WidgetbookUseCase(
        name: '対応',
        builder: (context) => _buildTaiouUseCase(context),
      ),
      WidgetbookUseCase(
        name: '完了',
        builder: (context) => _buildKanryoUseCase(context),
      ),
      WidgetbookUseCase(
        name: '訪室不要',
        builder: (context) => _buildHoushitsuFuyouUseCase(context),
      ),
      WidgetbookUseCase(
        name: '対応不要',
        builder: (context) => _buildTaiouFuyouUseCase(context),
      ),
      WidgetbookUseCase(
        name: '誤検知',
        builder: (context) => _buildGokenchiUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'All Status Types',
        builder: (context) => _buildAllStatusTypesUseCase(context),
      ),
    ],
  );
}

Widget _buildTaiouUseCase(BuildContext context) {
  return const Scaffold(
    body: Center(
      child: StatusBadge(status: '対応'),
    ),
  );
}

Widget _buildKanryoUseCase(BuildContext context) {
  return const Scaffold(
    body: Center(
      child: StatusBadge(status: '完了'),
    ),
  );
}

Widget _buildHoushitsuFuyouUseCase(BuildContext context) {
  return const Scaffold(
    body: Center(
      child: StatusBadge(status: '訪室不要'),
    ),
  );
}

Widget _buildTaiouFuyouUseCase(BuildContext context) {
  return const Scaffold(
    body: Center(
      child: StatusBadge(status: '対応不要'),
    ),
  );
}

Widget _buildGokenchiUseCase(BuildContext context) {
  return const Scaffold(
    body: Center(
      child: StatusBadge(status: '誤検知'),
    ),
  );
}

Widget _buildAllStatusTypesUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Wrap(
        spacing: 16.0,
        runSpacing: 16.0,
        children: const [
          StatusBadge(status: '対応'),
          StatusBadge(status: '完了'),
          StatusBadge(status: '訪室不要'),
          StatusBadge(status: '対応不要'),
          StatusBadge(status: '誤検知'),
        ],
      ),
    ),
  );
}
