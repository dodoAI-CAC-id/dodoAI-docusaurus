import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamoai/features/view_screen/domain/entities/incident_item.dart';
import 'package:mamoai/features/view_screen/domain/entities/incident_status.dart';
import 'package:mamoai/features/view_screen/presentation/widgets/molecules/incident_item_card.dart';

void main() {
  group('IncidentItemCard Widget Tests', () {
    testWidgets('未対応ステータスのカードが正しく表示される', (WidgetTester tester) async {
      // Arrange
      final item = IncidentItem(
        id: '1',
        roomBedNumber: '101-A',
        personName: '山田 太郎',
        detectionType: '起床',
        status: IncidentStatus.unhandled,
        detectedAt: DateTime(2025, 1, 14, 10, 30),
        cameraId: 'camera_001',
        isAlertActive: true,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncidentItemCard(item: item),
          ),
        ),
      );

      // Assert
      expect(find.text('101-A'), findsOneWidget);
      expect(find.text('山田 太郎'), findsOneWidget);
      expect(find.text('起床'), findsOneWidget);
      expect(find.text('未対応'), findsOneWidget);
    });

    testWidgets('対応中ステータスのカードが正しく表示される', (WidgetTester tester) async {
      // Arrange
      final item = IncidentItem(
        id: '2',
        roomBedNumber: '102-B',
        personName: '佐藤 花子',
        detectionType: '離床',
        status: IncidentStatus.inProgress,
        detectedAt: DateTime(2025, 1, 14, 11, 0),
        cameraId: 'camera_002',
        isAlertActive: true,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncidentItemCard(item: item),
          ),
        ),
      );

      // Assert
      expect(find.text('102-B'), findsOneWidget);
      expect(find.text('佐藤 花子'), findsOneWidget);
      expect(find.text('離床'), findsOneWidget);
      expect(find.text('対応中'), findsOneWidget);
    });

    testWidgets('検知なしステータスのカードが正しく表示される（isAlertActive未指定）', (WidgetTester tester) async {
      // Arrange
      const item = IncidentItem(
        id: '3',
        roomBedNumber: '103-A',
        personName: '鈴木 一郎',
        detectionType: '臥床',
        status: IncidentStatus.noDetection,
        cameraId: 'camera_003',
        isAlertActive: true, // デフォルトtrue
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: IncidentItemCard(item: item),
          ),
        ),
      );

      // Assert
      expect(find.text('103-A'), findsOneWidget);
      expect(find.text('鈴木 一郎'), findsOneWidget);
      expect(find.text('臥床'), findsNWidgets(2)); // 検知タイプとプレースホルダーの2箇所
      expect(find.text('アラート稼働中'), findsOneWidget); // isAlertActive=trueなので稼働中
    });

    testWidgets('異常検知中の場合、対応ボタンが表示される', (WidgetTester tester) async {
      // Arrange
      final item = IncidentItem(
        id: '1',
        roomBedNumber: '101-A',
        personName: '山田 太郎',
        detectionType: '起床',
        status: IncidentStatus.unhandled,
        detectedAt: DateTime.now(),
        cameraId: 'camera_001',
        isAlertActive: true,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncidentItemCard(
              item: item,
              onActionButtonPressed: (actionType) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('対応'), findsOneWidget);
      expect(find.text('訪室不要'), findsOneWidget);
      expect(find.text('誤検知'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNWidgets(3));
    });

    testWidgets('検知なしの場合、アラート稼働中バッジが表示され、ボタンは表示されない', (WidgetTester tester) async {
      // Arrange
      const item = IncidentItem(
        id: '3',
        roomBedNumber: '103-A',
        personName: '鈴木 一郎',
        detectionType: '臥床',
        status: IncidentStatus.noDetection,
        cameraId: 'camera_003',
        isAlertActive: true,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncidentItemCard(
              item: item,
              onActionButtonPressed: (actionType) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('アラート稼働中'), findsOneWidget); // バッジに表示
      expect(find.byType(ElevatedButton), findsNothing); // ボタンなし
    });

    testWidgets('検知なしでアラート停止中の場合、アラート停止中バッジが表示される', (WidgetTester tester) async {
      // Arrange
      const item = IncidentItem(
        id: '4',
        roomBedNumber: '104-A',
        personName: '田中 次郎',
        detectionType: '臥床',
        status: IncidentStatus.noDetection,
        cameraId: 'camera_004',
        isAlertActive: false,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncidentItemCard(
              item: item,
              onActionButtonPressed: (actionType) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('アラート停止中'), findsOneWidget); // バッジに表示
      expect(find.byType(ElevatedButton), findsNothing); // ボタンなし
    });

    testWidgets('カードタップ時にコールバックが呼ばれる', (WidgetTester tester) async {
      // Arrange
      const item = IncidentItem(
        id: '1',
        roomBedNumber: '101-A',
        personName: '山田 太郎',
        detectionType: '起床',
        status: IncidentStatus.unhandled,
        cameraId: 'camera_001',
        isAlertActive: true,
      );
      var tapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncidentItemCard(
              item: item,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Card));
      await tester.pumpAndSettle();

      // Assert
      expect(tapped, true);
    });

    testWidgets('対応ボタンタップ時にコールバックが呼ばれる', (WidgetTester tester) async {
      // Arrange
      final item = IncidentItem(
        id: '1',
        roomBedNumber: '101-A',
        personName: '山田 太郎',
        detectionType: '起床',
        status: IncidentStatus.unhandled,
        detectedAt: DateTime.now(),
        cameraId: 'camera_001',
        isAlertActive: true,
      );
      String? actionType;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncidentItemCard(
              item: item,
              onActionButtonPressed: (type) {
                actionType = type;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('対応'));
      await tester.pumpAndSettle();

      // Assert
      expect(actionType, 'start_response');
    });

    testWidgets('Cardウィジェットが正しいスタイルで表示される', (WidgetTester tester) async {
      // Arrange
      const item = IncidentItem(
        id: '1',
        roomBedNumber: '101-A',
        personName: '山田 太郎',
        detectionType: '起床',
        status: IncidentStatus.unhandled,
        cameraId: 'camera_001',
        isAlertActive: true,
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: IncidentItemCard(item: item),
          ),
        ),
      );

      // Assert
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 3);
      expect(card.shape, isA<RoundedRectangleBorder>());
      expect(card.color, Colors.white);
    });
  });
}
