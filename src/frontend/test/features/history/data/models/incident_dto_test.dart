import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/history/data/models/incident_dto.dart';
import 'package:frontend/features/history/data/models/action_dto.dart';
import 'package:frontend/features/history/domain/entities/incident.dart';
import 'package:frontend/features/history/domain/entities/action.dart';

void main() {
  group('IncidentDTO', () {
    final testActionJson = {
      'id': 'action_001',
      'incident_id': 'incident_001',
      'performed_at': '2025-10-31T10:30:00Z',
      'performed_by': '山田太郎',
      'action_type': 'confirmed',
      'notes': '対応完了',
    };

    final testJson = {
      'id': 'incident_001',
      'incident_id': 'INC-20251031-001',
      'detected_at': '2025-10-31T09:15:00Z',
      'room_number': '101',
      'bed_number': 'A',
      'resident_name': '田中花子',
      'detection_type': '転倒検知',
      'status': 'detected',
      'actions': [testActionJson],
      'video_id': 'video_001',
    };

    final testActionDto = ActionDTO(
      id: 'action_001',
      incidentId: 'incident_001',
      performedAt: DateTime.parse('2025-10-31T10:30:00Z'),
      performedBy: '山田太郎',
      actionType: 'confirmed',
      notes: '対応完了',
    );

    final testDto = IncidentDTO(
      id: 'incident_001',
      incidentId: 'INC-20251031-001',
      detectedAt: DateTime.parse('2025-10-31T09:15:00Z'),
      roomNumber: '101',
      bedNumber: 'A',
      residentName: '田中花子',
      detectionType: '転倒検知',
      status: 'detected',
      actions: [testActionDto],
      videoId: 'video_001',
    );

    group('fromJson', () {
      test('should create IncidentDTO from valid JSON', () {
        // Act
        final result = IncidentDTO.fromJson(testJson);

        // Assert
        expect(result.id, 'incident_001');
        expect(result.incidentId, 'INC-20251031-001');
        expect(result.detectedAt, DateTime.parse('2025-10-31T09:15:00Z'));
        expect(result.roomNumber, '101');
        expect(result.bedNumber, 'A');
        expect(result.residentName, '田中花子');
        expect(result.detectionType, '転倒検知');
        expect(result.status, 'detected');
        expect(result.actions.length, 1);
        expect(result.actions[0].id, 'action_001');
        expect(result.videoId, 'video_001');
      });

      test('should handle null video_id field', () {
        // Arrange
        final jsonWithoutVideo = Map<String, dynamic>.from(testJson)
          ..remove('video_id');

        // Act
        final result = IncidentDTO.fromJson(jsonWithoutVideo);

        // Assert
        expect(result.videoId, isNull);
      });

      test('should handle empty actions list', () {
        // Arrange
        final jsonWithoutActions = Map<String, dynamic>.from(testJson)
          ..['actions'] = [];

        // Act
        final result = IncidentDTO.fromJson(jsonWithoutActions);

        // Assert
        expect(result.actions, isEmpty);
      });

      test('should handle multiple actions', () {
        // Arrange
        final action2Json = {
          'id': 'action_002',
          'incident_id': 'incident_001',
          'performed_at': '2025-10-31T11:00:00Z',
          'performed_by': '佐藤次郎',
          'action_type': 'resolved',
          'notes': '完了確認',
        };
        final jsonWithMultipleActions = Map<String, dynamic>.from(testJson)
          ..['actions'] = [testActionJson, action2Json];

        // Act
        final result = IncidentDTO.fromJson(jsonWithMultipleActions);

        // Assert
        expect(result.actions.length, 2);
        expect(result.actions[0].id, 'action_001');
        expect(result.actions[1].id, 'action_002');
      });

      test('should parse different status values', () {
        // Arrange
        final statuses = ['detected', 'confirmed', 'in_progress', 'resolved'];

        for (final status in statuses) {
          final json = Map<String, dynamic>.from(testJson)..['status'] = status;

          // Act
          final result = IncidentDTO.fromJson(json);

          // Assert
          expect(result.status, status);
        }
      });

      test('should parse different detection types', () {
        // Arrange
        final detectionTypes = ['転倒検知', '離床検知', 'その他'];

        for (final detectionType in detectionTypes) {
          final json = Map<String, dynamic>.from(testJson)
            ..['detection_type'] = detectionType;

          // Act
          final result = IncidentDTO.fromJson(json);

          // Assert
          expect(result.detectionType, detectionType);
        }
      });
    });

    group('toJson', () {
      test('should convert IncidentDTO to JSON', () {
        // Act
        final result = testDto.toJson();

        // Assert
        expect(result['id'], 'incident_001');
        expect(result['incident_id'], 'INC-20251031-001');
        expect(result['detected_at'], '2025-10-31T09:15:00.000Z');
        expect(result['room_number'], '101');
        expect(result['bed_number'], 'A');
        expect(result['resident_name'], '田中花子');
        expect(result['detection_type'], '転倒検知');
        expect(result['status'], 'detected');
        expect(result['actions'], isA<List>());
        expect(result['actions'].length, 1);
        expect(result['video_id'], 'video_001');
      });

      test('should handle null video_id in JSON output', () {
        // Arrange
        final dtoWithoutVideo = IncidentDTO(
          id: 'incident_001',
          incidentId: 'INC-20251031-001',
          detectedAt: DateTime.parse('2025-10-31T09:15:00Z'),
          roomNumber: '101',
          bedNumber: 'A',
          residentName: '田中花子',
          detectionType: '転倒検知',
          status: 'detected',
          actions: [],
          videoId: null,
        );

        // Act
        final result = dtoWithoutVideo.toJson();

        // Assert
        expect(result['video_id'], isNull);
      });

      test('should convert actions list correctly', () {
        // Act
        final result = testDto.toJson();
        final actionsJson = result['actions'] as List;

        // Assert
        expect(actionsJson.length, 1);
        expect(actionsJson[0]['id'], 'action_001');
        expect(actionsJson[0]['incident_id'], 'incident_001');
      });
    });

    group('toEntity', () {
      test('should convert IncidentDTO to Incident entity', () {
        // Act
        final result = testDto.toEntity();

        // Assert
        expect(result, isA<Incident>());
        expect(result.id, 'incident_001');
        expect(result.incidentId, 'INC-20251031-001');
        expect(result.detectedAt, DateTime.parse('2025-10-31T09:15:00Z'));
        expect(result.roomNumber, '101');
        expect(result.bedNumber, 'A');
        expect(result.residentName, '田中花子');
        expect(result.detectionType, '転倒検知');
        expect(result.status, IncidentStatus.detected);
        expect(result.actions.length, 1);
        expect(result.actions[0], isA<Action>());
        expect(result.actions[0].id, 'action_001');
        expect(result.videoId, 'video_001');
      });

      test('should convert IncidentDTO with null video_id to Incident entity',
          () {
        // Arrange
        final dtoWithoutVideo = IncidentDTO(
          id: 'incident_001',
          incidentId: 'INC-20251031-001',
          detectedAt: DateTime.parse('2025-10-31T09:15:00Z'),
          roomNumber: '101',
          bedNumber: 'A',
          residentName: '田中花子',
          detectionType: '転倒検知',
          status: 'detected',
          actions: [],
          videoId: null,
        );

        // Act
        final result = dtoWithoutVideo.toEntity();

        // Assert
        expect(result.videoId, isNull);
      });

      test('should convert status string to IncidentStatus enum', () {
        // Arrange
        final statusMappings = {
          'detected': IncidentStatus.detected,
          'confirmed': IncidentStatus.confirmed,
          'in_progress': IncidentStatus.inProgress,
          'resolved': IncidentStatus.resolved,
        };

        for (final entry in statusMappings.entries) {
          final dto = IncidentDTO(
            id: 'incident_001',
            incidentId: 'INC-20251031-001',
            detectedAt: DateTime.parse('2025-10-31T09:15:00Z'),
            roomNumber: '101',
            bedNumber: 'A',
            residentName: '田中花子',
            detectionType: '転倒検知',
            status: entry.key,
            actions: [],
            videoId: null,
          );

          // Act
          final result = dto.toEntity();

          // Assert
          expect(result.status, entry.value);
        }
      });
    });

    group('round-trip conversion', () {
      test('should maintain data integrity through JSON round-trip', () {
        // Arrange
        final originalDto = testDto;

        // Act: DTO -> JSON -> DTO
        final json = originalDto.toJson();
        final reconstructedDto = IncidentDTO.fromJson(json);

        // Assert
        expect(reconstructedDto.id, originalDto.id);
        expect(reconstructedDto.incidentId, originalDto.incidentId);
        expect(
          reconstructedDto.detectedAt.toIso8601String(),
          originalDto.detectedAt.toIso8601String(),
        );
        expect(reconstructedDto.roomNumber, originalDto.roomNumber);
        expect(reconstructedDto.bedNumber, originalDto.bedNumber);
        expect(reconstructedDto.residentName, originalDto.residentName);
        expect(reconstructedDto.detectionType, originalDto.detectionType);
        expect(reconstructedDto.status, originalDto.status);
        expect(reconstructedDto.actions.length, originalDto.actions.length);
        expect(reconstructedDto.videoId, originalDto.videoId);
      });

      test('should maintain data integrity through Entity round-trip', () {
        // Arrange
        final originalAction = Action(
          id: 'action_001',
          incidentId: 'incident_001',
          performedAt: DateTime.parse('2025-10-31T10:30:00Z'),
          performedBy: '山田太郎',
          actionType: 'confirmed',
          notes: '対応完了',
        );

        final originalEntity = Incident(
          id: 'incident_001',
          incidentId: 'INC-20251031-001',
          detectedAt: DateTime.parse('2025-10-31T09:15:00Z'),
          roomNumber: '101',
          bedNumber: 'A',
          residentName: '田中花子',
          detectionType: '転倒検知',
          status: IncidentStatus.detected,
          actions: [originalAction],
          videoId: 'video_001',
        );

        // Act: Entity -> DTO -> Entity
        final dto = IncidentDTO(
          id: originalEntity.id,
          incidentId: originalEntity.incidentId,
          detectedAt: originalEntity.detectedAt,
          roomNumber: originalEntity.roomNumber,
          bedNumber: originalEntity.bedNumber,
          residentName: originalEntity.residentName,
          detectionType: originalEntity.detectionType,
          status: _statusToString(originalEntity.status),
          actions: originalEntity.actions.map((action) {
            return ActionDTO(
              id: action.id,
              incidentId: action.incidentId,
              performedAt: action.performedAt,
              performedBy: action.performedBy,
              actionType: action.actionType,
              notes: action.notes,
            );
          }).toList(),
          videoId: originalEntity.videoId,
        );
        final reconstructedEntity = dto.toEntity();

        // Assert
        expect(reconstructedEntity.id, originalEntity.id);
        expect(reconstructedEntity.incidentId, originalEntity.incidentId);
        expect(
          reconstructedEntity.detectedAt.toIso8601String(),
          originalEntity.detectedAt.toIso8601String(),
        );
        expect(reconstructedEntity.roomNumber, originalEntity.roomNumber);
        expect(reconstructedEntity.bedNumber, originalEntity.bedNumber);
        expect(reconstructedEntity.residentName, originalEntity.residentName);
        expect(reconstructedEntity.detectionType, originalEntity.detectionType);
        expect(reconstructedEntity.status, originalEntity.status);
        expect(reconstructedEntity.actions.length, originalEntity.actions.length);
        expect(reconstructedEntity.videoId, originalEntity.videoId);
      });
    });
  });
}

// Helper function for Entity -> DTO status conversion
String _statusToString(IncidentStatus status) {
  switch (status) {
    case IncidentStatus.detected:
      return 'detected';
    case IncidentStatus.confirmed:
      return 'confirmed';
    case IncidentStatus.inProgress:
      return 'in_progress';
    case IncidentStatus.resolved:
      return 'resolved';
  }
}
