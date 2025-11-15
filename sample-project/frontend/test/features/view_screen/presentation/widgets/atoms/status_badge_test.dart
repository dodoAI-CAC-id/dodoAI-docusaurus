import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamoai/features/view_screen/domain/entities/incident_status.dart';
import 'package:mamoai/features/view_screen/presentation/widgets/atoms/status_badge.dart';

void main() {
  group('StatusBadge Widget Tests', () {
    testWidgets('未対応ステータスが正しく表示される', (WidgetTester tester) async {
      // Arrange
      const status = IncidentStatus.unhandled;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(status: status),
          ),
        ),
      );

      // Assert
      expect(find.text('未対応'), findsOneWidget);
      
      // 背景色の確認
      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('未対応'),
          matching: find.byType(Container),
        ).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFFFFF9C4)); // 黄色
    });

    testWidgets('対応中ステータスが正しく表示される', (WidgetTester tester) async {
      // Arrange
      const status = IncidentStatus.inProgress;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(status: status),
          ),
        ),
      );

      // Assert
      expect(find.text('対応中'), findsOneWidget);
      
      // 背景色の確認
      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('対応中'),
          matching: find.byType(Container),
        ).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFFC8E6C9)); // 緑色
    });

    testWidgets('検知なしステータスが正しく表示される', (WidgetTester tester) async {
      // Arrange
      const status = IncidentStatus.noDetection;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(status: status),
          ),
        ),
      );

      // Assert
      expect(find.text('検知なし'), findsOneWidget);
      
      // 背景色の確認
      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('検知なし'),
          matching: find.byType(Container),
        ).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFFE0E0E0)); // 灰色
    });

    testWidgets('カスタムフォントサイズが適用される', (WidgetTester tester) async {
      // Arrange
      const status = IncidentStatus.unhandled;
      const customFontSize = 20.0;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(
              status: status,
              fontSize: customFontSize,
            ),
          ),
        ),
      );

      // Assert
      final textWidget = tester.widget<Text>(find.text('未対応'));
      expect(textWidget.style?.fontSize, customFontSize);
    });

    testWidgets('デフォルトフォントサイズが適用される', (WidgetTester tester) async {
      // Arrange
      const status = IncidentStatus.unhandled;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(status: status),
          ),
        ),
      );

      // Assert
      final textWidget = tester.widget<Text>(find.text('未対応'));
      expect(textWidget.style?.fontSize, 14.0); // デフォルト値
    });

    testWidgets('角丸のボーダーが適用される', (WidgetTester tester) async {
      // Arrange
      const status = IncidentStatus.unhandled;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(status: status),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('未対応'),
          matching: find.byType(Container),
        ).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(16));
      expect(decoration.border, isNotNull);
    });
  });
}
