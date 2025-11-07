import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/history/domain/entities/action.dart';

void main() {
  group('Action Entity', () {
    test('should create an action with required properties', () {
      // Arrange
      final action = Action(
        id: 'act-1',
        incidentId: 'INC-001',
        performedAt: DateTime(2025, 10, 31, 10, 5),
        performedBy: '佐藤 花子',
        actionType: '確認',
        notes: '状況確認完了',
      );

      // Assert
      expect(action.id, 'act-1');
      expect(action.incidentId, 'INC-001');
      expect(action.performedAt, DateTime(2025, 10, 31, 10, 5));
      expect(action.performedBy, '佐藤 花子');
      expect(action.actionType, '確認');
      expect(action.notes, '状況確認完了');
    });

    test('should create an action with null notes', () {
      // Arrange
      final action = Action(
        id: 'act-1',
        incidentId: 'INC-001',
        performedAt: DateTime(2025, 10, 31, 10, 5),
        performedBy: '佐藤 花子',
        actionType: '確認',
      );

      // Assert
      expect(action.notes, isNull);
    });

    test('should support equality comparison', () {
      // Arrange
      final action1 = Action(
        id: 'act-1',
        incidentId: 'INC-001',
        performedAt: DateTime(2025, 10, 31, 10, 5),
        performedBy: '佐藤 花子',
        actionType: '確認',
        notes: '状況確認完了',
      );

      final action2 = Action(
        id: 'act-1',
        incidentId: 'INC-001',
        performedAt: DateTime(2025, 10, 31, 10, 5),
        performedBy: '佐藤 花子',
        actionType: '確認',
        notes: '状況確認完了',
      );

      final action3 = Action(
        id: 'act-2',
        incidentId: 'INC-002',
        performedAt: DateTime(2025, 10, 31, 11, 0),
        performedBy: '山田 太郎',
        actionType: '対応',
        notes: '対応完了',
      );

      // Assert
      expect(action1, equals(action2));
      expect(action1, isNot(equals(action3)));
      expect(action1.hashCode, equals(action2.hashCode));
      expect(action1.hashCode, isNot(equals(action3.hashCode)));
    });

    test('should create a copy with updated properties', () {
      // Arrange
      final original = Action(
        id: 'act-1',
        incidentId: 'INC-001',
        performedAt: DateTime(2025, 10, 31, 10, 5),
        performedBy: '佐藤 花子',
        actionType: '確認',
        notes: '状況確認完了',
      );

      // Act
      final updated = original.copyWith(
        actionType: '対応完了',
        notes: '対応完了しました',
      );

      // Assert
      expect(updated.id, original.id);
      expect(updated.incidentId, original.incidentId);
      expect(updated.performedAt, original.performedAt);
      expect(updated.performedBy, original.performedBy);
      expect(updated.actionType, '対応完了');
      expect(updated.notes, '対応完了しました');
      expect(original.actionType, '確認');
      expect(original.notes, '状況確認完了');
    });

    test('should handle different action types', () {
      // Arrange
      final actionTypes = ['確認', '対応', '完了', 'キャンセル', 'その他'];

      // Act & Assert
      for (final type in actionTypes) {
        final action = Action(
          id: 'act-1',
          incidentId: 'INC-001',
          performedAt: DateTime(2025, 10, 31, 10, 5),
          performedBy: '佐藤 花子',
          actionType: type,
        );

        expect(action.actionType, type);
      }
    });

    test('should preserve immutability when copying', () {
      // Arrange
      final original = Action(
        id: 'act-1',
        incidentId: 'INC-001',
        performedAt: DateTime(2025, 10, 31, 10, 5),
        performedBy: '佐藤 花子',
        actionType: '確認',
        notes: '状況確認完了',
      );

      // Act
      final updated1 = original.copyWith(actionType: '対応');
      final updated2 = original.copyWith(notes: '新しいメモ');

      // Assert
      expect(original.actionType, '確認');
      expect(original.notes, '状況確認完了');
      expect(updated1.actionType, '対応');
      expect(updated1.notes, '状況確認完了');
      expect(updated2.actionType, '確認');
      expect(updated2.notes, '新しいメモ');
    });
  });
}
