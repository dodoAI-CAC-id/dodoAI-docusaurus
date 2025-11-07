import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/history/data/models/action_dto.dart';
import 'package:frontend/features/history/domain/entities/action.dart';

void main() {
  group('ActionDTO', () {
    final testJson = {
      'id': 'action_001',
      'incident_id': 'incident_001',
      'performed_at': '2025-10-31T10:30:00Z',
      'performed_by': '山田太郎',
      'action_type': 'confirmed',
      'notes': '対応完了',
    };

    final testDto = ActionDTO(
      id: 'action_001',
      incidentId: 'incident_001',
      performedAt: DateTime.parse('2025-10-31T10:30:00Z'),
      performedBy: '山田太郎',
      actionType: 'confirmed',
      notes: '対応完了',
    );

    group('fromJson', () {
      test('should create ActionDTO from valid JSON', () {
        // Act
        final result = ActionDTO.fromJson(testJson);

        // Assert
        expect(result.id, 'action_001');
        expect(result.incidentId, 'incident_001');
        expect(result.performedAt, DateTime.parse('2025-10-31T10:30:00Z'));
        expect(result.performedBy, '山田太郎');
        expect(result.actionType, 'confirmed');
        expect(result.notes, '対応完了');
      });

      test('should handle null notes field', () {
        // Arrange
        final jsonWithoutNotes = Map<String, dynamic>.from(testJson)
          ..remove('notes');

        // Act
        final result = ActionDTO.fromJson(jsonWithoutNotes);

        // Assert
        expect(result.notes, isNull);
      });

      test('should parse different action types', () {
        // Arrange
        final actionTypes = [
          'detected',
          'confirmed',
          'in_progress',
          'resolved',
          'cancelled',
          'other'
        ];

        for (final actionType in actionTypes) {
          final json = Map<String, dynamic>.from(testJson)
            ..['action_type'] = actionType;

          // Act
          final result = ActionDTO.fromJson(json);

          // Assert
          expect(result.actionType, actionType);
        }
      });
    });

    group('toJson', () {
      test('should convert ActionDTO to JSON', () {
        // Act
        final result = testDto.toJson();

        // Assert
        expect(result['id'], 'action_001');
        expect(result['incident_id'], 'incident_001');
        expect(result['performed_at'], '2025-10-31T10:30:00.000Z');
        expect(result['performed_by'], '山田太郎');
        expect(result['action_type'], 'confirmed');
        expect(result['notes'], '対応完了');
      });

      test('should handle null notes in JSON output', () {
        // Arrange
        final dtoWithoutNotes = ActionDTO(
          id: 'action_001',
          incidentId: 'incident_001',
          performedAt: DateTime.parse('2025-10-31T10:30:00Z'),
          performedBy: '山田太郎',
          actionType: 'confirmed',
          notes: null,
        );

        // Act
        final result = dtoWithoutNotes.toJson();

        // Assert
        expect(result['notes'], isNull);
      });
    });

    group('toEntity', () {
      test('should convert ActionDTO to Action entity', () {
        // Act
        final result = testDto.toEntity();

        // Assert
        expect(result, isA<Action>());
        expect(result.id, 'action_001');
        expect(result.incidentId, 'incident_001');
        expect(result.performedAt, DateTime.parse('2025-10-31T10:30:00Z'));
        expect(result.performedBy, '山田太郎');
        expect(result.actionType, 'confirmed');
        expect(result.notes, '対応完了');
      });

      test('should convert ActionDTO with null notes to Action entity', () {
        // Arrange
        final dtoWithoutNotes = ActionDTO(
          id: 'action_001',
          incidentId: 'incident_001',
          performedAt: DateTime.parse('2025-10-31T10:30:00Z'),
          performedBy: '山田太郎',
          actionType: 'confirmed',
          notes: null,
        );

        // Act
        final result = dtoWithoutNotes.toEntity();

        // Assert
        expect(result.notes, isNull);
      });
    });

    group('round-trip conversion', () {
      test('should maintain data integrity through JSON round-trip', () {
        // Arrange
        final originalDto = testDto;

        // Act: DTO -> JSON -> DTO
        final json = originalDto.toJson();
        final reconstructedDto = ActionDTO.fromJson(json);

        // Assert
        expect(reconstructedDto.id, originalDto.id);
        expect(reconstructedDto.incidentId, originalDto.incidentId);
        expect(
          reconstructedDto.performedAt.toIso8601String(),
          originalDto.performedAt.toIso8601String(),
        );
        expect(reconstructedDto.performedBy, originalDto.performedBy);
        expect(reconstructedDto.actionType, originalDto.actionType);
        expect(reconstructedDto.notes, originalDto.notes);
      });

      test('should maintain data integrity through Entity round-trip', () {
        // Arrange
        final originalEntity = Action(
          id: 'action_001',
          incidentId: 'incident_001',
          performedAt: DateTime.parse('2025-10-31T10:30:00Z'),
          performedBy: '山田太郎',
          actionType: 'confirmed',
          notes: '対応完了',
        );

        // Act: Entity -> JSON -> DTO -> Entity
        final json = {
          'id': originalEntity.id,
          'incident_id': originalEntity.incidentId,
          'performed_at': originalEntity.performedAt.toIso8601String(),
          'performed_by': originalEntity.performedBy,
          'action_type': originalEntity.actionType,
          'notes': originalEntity.notes,
        };
        final dto = ActionDTO.fromJson(json);
        final reconstructedEntity = dto.toEntity();

        // Assert
        expect(reconstructedEntity.id, originalEntity.id);
        expect(reconstructedEntity.incidentId, originalEntity.incidentId);
        expect(
          reconstructedEntity.performedAt.toIso8601String(),
          originalEntity.performedAt.toIso8601String(),
        );
        expect(reconstructedEntity.performedBy, originalEntity.performedBy);
        expect(reconstructedEntity.actionType, originalEntity.actionType);
        expect(reconstructedEntity.notes, originalEntity.notes);
      });
    });
  });
}
