import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import '../../lib/features/view_screen/domain/entities/incident_item.dart';
import '../../lib/features/view_screen/domain/entities/incident_status.dart';
import '../../lib/features/view_screen/presentation/widgets/molecules/incident_item_card.dart';

/// IncidentItemCard - 未対応
@widgetbook.UseCase(
  name: 'Unhandled',
  type: IncidentItemCard,
)
Widget incidentItemCardUnhandled(BuildContext context) {
  final item = IncidentItem(
    id: '1',
    roomBedNumber: '101-A',
    personName: '山田 太郎',
    detectionType: '起床',
    status: IncidentStatus.unhandled,
    detectedAt: DateTime.now().subtract(const Duration(minutes: 5)),
    cameraId: 'camera_001',
    isAlertActive: true,
  );

  return Center(
    child: IncidentItemCard(
      item: item,
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('カードがタップされました')),
        );
      },
      onActionButtonPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('対応ボタンが押されました')),
        );
      },
    ),
  );
}

/// IncidentItemCard - 対応中
@widgetbook.UseCase(
  name: 'In Progress',
  type: IncidentItemCard,
)
Widget incidentItemCardInProgress(BuildContext context) {
  final item = IncidentItem(
    id: '2',
    roomBedNumber: '102-B',
    personName: '佐藤 花子',
    detectionType: '離床',
    status: IncidentStatus.inProgress,
    detectedAt: DateTime.now().subtract(const Duration(minutes: 10)),
    cameraId: 'camera_002',
    isAlertActive: true,
  );

  return Center(
    child: IncidentItemCard(
      item: item,
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('カードがタップされました')),
        );
      },
      onActionButtonPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('対応ボタンが押されました')),
        );
      },
    ),
  );
}

/// IncidentItemCard - 検知なし
@widgetbook.UseCase(
  name: 'No Detection',
  type: IncidentItemCard,
)
Widget incidentItemCardNoDetection(BuildContext context) {
  final item = IncidentItem(
    id: '3',
    roomBedNumber: '103-A',
    personName: '鈴木 一郎',
    detectionType: '臥床',
    status: IncidentStatus.noDetection,
    cameraId: 'camera_003',
    isAlertActive: true,
  );

  return Center(
    child: IncidentItemCard(
      item: item,
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('カードがタップされました')),
        );
      },
    ),
  );
}

/// IncidentItemCard - リスト表示
@widgetbook.UseCase(
  name: 'List View',
  type: IncidentItemCard,
)
Widget incidentItemCardList(BuildContext context) {
  final items = [
    IncidentItem(
      id: '1',
      roomBedNumber: '101-A',
      personName: '山田 太郎',
      detectionType: '起床',
      status: IncidentStatus.unhandled,
      detectedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      cameraId: 'camera_001',
      isAlertActive: true,
    ),
    IncidentItem(
      id: '2',
      roomBedNumber: '102-B',
      personName: '佐藤 花子',
      detectionType: '離床',
      status: IncidentStatus.inProgress,
      detectedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      cameraId: 'camera_002',
      isAlertActive: true,
    ),
    IncidentItem(
      id: '3',
      roomBedNumber: '103-A',
      personName: '鈴木 一郎',
      detectionType: '臥床',
      status: IncidentStatus.noDetection,
      cameraId: 'camera_003',
      isAlertActive: true,
    ),
  ];

  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
      return IncidentItemCard(
        item: items[index],
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${items[index].roomBedNumber} がタップされました')),
          );
        },
        onActionButtonPressed: items[index].isDetected
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('${items[index].roomBedNumber} の対応ボタンが押されました')),
                );
              }
            : null,
      );
    },
  );
}
