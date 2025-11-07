import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/history/domain/entities/incident.dart';
import 'package:frontend/features/history/domain/entities/action.dart';

void main() {
  group('Incident Entity', () {
    test('should create an incident with required properties', () {
      // Arrange
      final incident = Incident(
        id: '123',
        incidentId: 'INC-001',
        detectedAt: DateTime(2025, 10, 31, 10, 0),
        roomNumber: '101',
        bedNumber: 'A',
        residentName: '田中 太郎',
        detectionType: '転倒検知',
        status: IncidentStatus.detected,
        actions: [],
      );

      // Assert
      expect(incident.id, '123');
      expect(incident.incidentId, 'INC-001');
      expect(incident.detectedAt, DateTime(2025, 10, 31, 10, 0));
      expect(incident.roomNumber, '101');
      expect(incident.bedNumber, 'A');
      expect(incident.residentName, '田中 太郎');
      expect(incident.detectionType, '転倒検知');
      expect(incident.status, IncidentStatus.detected);
      expect(incident.actions, isEmpty);
    });

    test('should create an incident with actions', () {
      // Arrange
      final action = Action(
        id: 'act-1',
        incidentId: 'INC-001',
        performedAt: DateTime(2025, 10, 31, 10, 5),
        performedBy: '佐藤 花子',
        actionType: '確認',
        notes: '状況確認完了',
      );

      final incident = Incident(
        id: '123',
        incidentId: 'INC-001',
        detectedAt: DateTime(2025, 10, 31, 10, 0),
        roomNumber: '101',
        bedNumber: 'A',
        residentName: '田中 太郎',
        detectionType: '転倒検知',
        status: IncidentStatus.confirmed,
        actions: [action],
      );

      // Assert
      expect(incident.actions.length, 1);
      expect(incident.actions.first.id, 'act-1');
      expect(incident.actions.first.actionType, '確認');
    });

    test('should support equality comparison', () {
      // Arrange
      final incident1 = Incident(
        id: '123',
        incidentId: 'INC-001',
        detectedAt: DateTime(2025, 10, 31, 10, 0),
        roomNumber: '101',
        bedNumber: 'A',
        residentName: '田中 太郎',
        detectionType: '転倒検知',
        status: IncidentStatus.detected,
        actions: [],
      );

      final incident2 = Incident(
        id: '123',
        incidentId: 'INC-001',
        detectedAt: DateTime(2025, 10, 31, 10, 0),
        roomNumber: '101',
        bedNumber: 'A',
        residentName: '田中 太郎',
        detectionType: '転倒検知',
        status: IncidentStatus.detected,
        actions: [],
      );

      final incident3 = Incident(
        id: '456',
        incidentId: 'INC-002',
        detectedAt: DateTime(2025, 10, 31, 11, 0),
        roomNumber: '102',
        bedNumber: 'B',
        residentName: '鈴木 次郎',
        detectionType: '離床検知',
        status: IncidentStatus.detected,
        actions: [],
      );

      // Assert
      expect(incident1, equals(incident2));
      expect(incident1, isNot(equals(incident3)));
      expect(incident1.hashCode, equals(incident2.hashCode));
      expect(incident1.hashCode, isNot(equals(incident3.hashCode)));
    });

    test('should create a copy with updated properties', () {
      // Arrange
      final original = Incident(
        id: '123',
        incidentId: 'INC-001',
        detectedAt: DateTime(2025, 10, 31, 10, 0),
        roomNumber: '101',
        bedNumber: 'A',
        residentName: '田中 太郎',
        detectionType: '転倒検知',
        status: IncidentStatus.detected,
        actions: [],
      );

      // Act
      final updated = original.copyWith(
        status: IncidentStatus.confirmed,
        actions: [
          Action(
            id: 'act-1',
            incidentId: 'INC-001',
            performedAt: DateTime(2025, 10, 31, 10, 5),
            performedBy: '佐藤 花子',
            actionType: '確認',
            notes: '状況確認完了',
          ),
        ],
      );

      // Assert
      expect(updated.id, original.id);
      expect(updated.status, IncidentStatus.confirmed);
      expect(updated.actions.length, 1);
      expect(original.status, IncidentStatus.detected);
      expect(original.actions, isEmpty);
    });

    test('should handle optional video ID', () {
      // Arrange
      final incidentWithVideo = Incident(
        id: '123',
        incidentId: 'INC-001',
        detectedAt: DateTime(2025, 10, 31, 10, 0),
        roomNumber: '101',
        bedNumber: 'A',
        residentName: '田中 太郎',
        detectionType: '転倒検知',
        status: IncidentStatus.detected,
        actions: [],
        videoId: 'video-123',
      );

      final incidentWithoutVideo = Incident(
        id: '124',
        incidentId: 'INC-002',
        detectedAt: DateTime(2025, 10, 31, 11, 0),
        roomNumber: '102',
        bedNumber: 'B',
        residentName: '鈴木 次郎',
        detectionType: '離床検知',
        status: IncidentStatus.detected,
        actions: [],
      );

      // Assert
      expect(incidentWithVideo.videoId, 'video-123');
      expect(incidentWithoutVideo.videoId, isNull);
    });

    test('should validate incident status enum', () {
      // Assert
      expect(IncidentStatus.values, [
        IncidentStatus.detected,
        IncidentStatus.confirmed,
        IncidentStatus.inProgress,
        IncidentStatus.resolved,
      ]);
    });
  });
}
