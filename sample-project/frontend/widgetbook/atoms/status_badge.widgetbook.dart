import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import '../../lib/features/view_screen/domain/entities/incident_status.dart';
import '../../lib/features/view_screen/presentation/widgets/atoms/status_badge.dart';

/// StatusBadgeのWidgetbookストーリー
@widgetbook.UseCase(
  name: 'Default',
  type: StatusBadge,
)
Widget statusBadgeDefault(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('未対応ステータス:'),
        const SizedBox(height: 8),
        const StatusBadge(status: IncidentStatus.unhandled),
        const SizedBox(height: 24),
        const Text('対応中ステータス:'),
        const SizedBox(height: 8),
        const StatusBadge(status: IncidentStatus.inProgress),
        const SizedBox(height: 24),
        const Text('検知なしステータス:'),
        const SizedBox(height: 8),
        const StatusBadge(status: IncidentStatus.noDetection),
      ],
    ),
  );
}

/// StatusBadge - 大きいサイズ
@widgetbook.UseCase(
  name: 'Large Size',
  type: StatusBadge,
)
Widget statusBadgeLarge(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StatusBadge(
          status: IncidentStatus.unhandled,
          fontSize: 18,
        ),
        const SizedBox(height: 16),
        StatusBadge(
          status: IncidentStatus.inProgress,
          fontSize: 18,
        ),
        const SizedBox(height: 16),
        StatusBadge(
          status: IncidentStatus.noDetection,
          fontSize: 18,
        ),
      ],
    ),
  );
}

/// StatusBadge - 小さいサイズ
@widgetbook.UseCase(
  name: 'Small Size',
  type: StatusBadge,
)
Widget statusBadgeSmall(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StatusBadge(
          status: IncidentStatus.unhandled,
          fontSize: 12,
        ),
        const SizedBox(height: 16),
        StatusBadge(
          status: IncidentStatus.inProgress,
          fontSize: 12,
        ),
        const SizedBox(height: 16),
        StatusBadge(
          status: IncidentStatus.noDetection,
          fontSize: 12,
        ),
      ],
    ),
  );
}
