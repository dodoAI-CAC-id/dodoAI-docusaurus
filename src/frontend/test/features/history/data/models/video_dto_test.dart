import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/history/data/models/video_dto.dart';
import 'package:frontend/features/history/domain/entities/video.dart';

void main() {
  group('VideoDTO', () {
    final testJson = {
      'id': 'video_001',
      'incident_id': 'incident_001',
      'file_name': 'incident_001_20251031.mp4',
      'file_size': 10485760, // 10 MB
      'duration': 185, // 3:05
      'recorded_at': '2025-10-31T09:15:00Z',
      'url': 'https://api.example.com/videos/video_001',
      'thumbnail_url': 'https://api.example.com/thumbnails/video_001',
    };

    final testDto = VideoDTO(
      id: 'video_001',
      incidentId: 'incident_001',
      fileName: 'incident_001_20251031.mp4',
      fileSize: 10485760,
      duration: 185,
      recordedAt: DateTime.parse('2025-10-31T09:15:00Z'),
      url: 'https://api.example.com/videos/video_001',
      thumbnailUrl: 'https://api.example.com/thumbnails/video_001',
    );

    group('fromJson', () {
      test('should create VideoDTO from valid JSON', () {
        // Act
        final result = VideoDTO.fromJson(testJson);

        // Assert
        expect(result.id, 'video_001');
        expect(result.incidentId, 'incident_001');
        expect(result.fileName, 'incident_001_20251031.mp4');
        expect(result.fileSize, 10485760);
        expect(result.duration, 185);
        expect(result.recordedAt, DateTime.parse('2025-10-31T09:15:00Z'));
        expect(result.url, 'https://api.example.com/videos/video_001');
        expect(
          result.thumbnailUrl,
          'https://api.example.com/thumbnails/video_001',
        );
      });

      test('should handle null thumbnail_url field', () {
        // Arrange
        final jsonWithoutThumbnail = Map<String, dynamic>.from(testJson)
          ..remove('thumbnail_url');

        // Act
        final result = VideoDTO.fromJson(jsonWithoutThumbnail);

        // Assert
        expect(result.thumbnailUrl, isNull);
      });

      test('should handle various file sizes', () {
        // Arrange
        final fileSizes = [1024, 1048576, 10485760, 1073741824]; // KB, MB, 10MB, GB

        for (final fileSize in fileSizes) {
          final json = Map<String, dynamic>.from(testJson)
            ..['file_size'] = fileSize;

          // Act
          final result = VideoDTO.fromJson(json);

          // Assert
          expect(result.fileSize, fileSize);
        }
      });

      test('should handle various durations', () {
        // Arrange
        final durations = [30, 60, 185, 3665]; // 30s, 1min, 3:05, 1:01:05

        for (final duration in durations) {
          final json = Map<String, dynamic>.from(testJson)
            ..['duration'] = duration;

          // Act
          final result = VideoDTO.fromJson(json);

          // Assert
          expect(result.duration, duration);
        }
      });
    });

    group('toJson', () {
      test('should convert VideoDTO to JSON', () {
        // Act
        final result = testDto.toJson();

        // Assert
        expect(result['id'], 'video_001');
        expect(result['incident_id'], 'incident_001');
        expect(result['file_name'], 'incident_001_20251031.mp4');
        expect(result['file_size'], 10485760);
        expect(result['duration'], 185);
        expect(result['recorded_at'], '2025-10-31T09:15:00.000Z');
        expect(result['url'], 'https://api.example.com/videos/video_001');
        expect(
          result['thumbnail_url'],
          'https://api.example.com/thumbnails/video_001',
        );
      });

      test('should handle null thumbnail_url in JSON output', () {
        // Arrange
        final dtoWithoutThumbnail = VideoDTO(
          id: 'video_001',
          incidentId: 'incident_001',
          fileName: 'incident_001_20251031.mp4',
          fileSize: 10485760,
          duration: 185,
          recordedAt: DateTime.parse('2025-10-31T09:15:00Z'),
          url: 'https://api.example.com/videos/video_001',
          thumbnailUrl: null,
        );

        // Act
        final result = dtoWithoutThumbnail.toJson();

        // Assert
        expect(result['thumbnail_url'], isNull);
      });
    });

    group('toEntity', () {
      test('should convert VideoDTO to Video entity', () {
        // Act
        final result = testDto.toEntity();

        // Assert
        expect(result, isA<Video>());
        expect(result.id, 'video_001');
        expect(result.incidentId, 'incident_001');
        expect(result.fileName, 'incident_001_20251031.mp4');
        expect(result.fileSize, 10485760);
        expect(result.duration, 185);
        expect(result.recordedAt, DateTime.parse('2025-10-31T09:15:00Z'));
        expect(result.url, 'https://api.example.com/videos/video_001');
        expect(
          result.thumbnailUrl,
          'https://api.example.com/thumbnails/video_001',
        );
      });

      test('should convert VideoDTO with null thumbnail_url to Video entity',
          () {
        // Arrange
        final dtoWithoutThumbnail = VideoDTO(
          id: 'video_001',
          incidentId: 'incident_001',
          fileName: 'incident_001_20251031.mp4',
          fileSize: 10485760,
          duration: 185,
          recordedAt: DateTime.parse('2025-10-31T09:15:00Z'),
          url: 'https://api.example.com/videos/video_001',
          thumbnailUrl: null,
        );

        // Act
        final result = dtoWithoutThumbnail.toEntity();

        // Assert
        expect(result.thumbnailUrl, isNull);
      });
    });

    group('round-trip conversion', () {
      test('should maintain data integrity through JSON round-trip', () {
        // Arrange
        final originalDto = testDto;

        // Act: DTO -> JSON -> DTO
        final json = originalDto.toJson();
        final reconstructedDto = VideoDTO.fromJson(json);

        // Assert
        expect(reconstructedDto.id, originalDto.id);
        expect(reconstructedDto.incidentId, originalDto.incidentId);
        expect(reconstructedDto.fileName, originalDto.fileName);
        expect(reconstructedDto.fileSize, originalDto.fileSize);
        expect(reconstructedDto.duration, originalDto.duration);
        expect(
          reconstructedDto.recordedAt.toIso8601String(),
          originalDto.recordedAt.toIso8601String(),
        );
        expect(reconstructedDto.url, originalDto.url);
        expect(reconstructedDto.thumbnailUrl, originalDto.thumbnailUrl);
      });

      test('should maintain data integrity through Entity round-trip', () {
        // Arrange
        final originalEntity = Video(
          id: 'video_001',
          incidentId: 'incident_001',
          fileName: 'incident_001_20251031.mp4',
          fileSize: 10485760,
          duration: 185,
          recordedAt: DateTime.parse('2025-10-31T09:15:00Z'),
          url: 'https://api.example.com/videos/video_001',
          thumbnailUrl: 'https://api.example.com/thumbnails/video_001',
        );

        // Act: Entity -> DTO -> Entity
        final dto = VideoDTO(
          id: originalEntity.id,
          incidentId: originalEntity.incidentId,
          fileName: originalEntity.fileName,
          fileSize: originalEntity.fileSize,
          duration: originalEntity.duration,
          recordedAt: originalEntity.recordedAt,
          url: originalEntity.url,
          thumbnailUrl: originalEntity.thumbnailUrl,
        );
        final reconstructedEntity = dto.toEntity();

        // Assert
        expect(reconstructedEntity.id, originalEntity.id);
        expect(reconstructedEntity.incidentId, originalEntity.incidentId);
        expect(reconstructedEntity.fileName, originalEntity.fileName);
        expect(reconstructedEntity.fileSize, originalEntity.fileSize);
        expect(reconstructedEntity.duration, originalEntity.duration);
        expect(
          reconstructedEntity.recordedAt.toIso8601String(),
          originalEntity.recordedAt.toIso8601String(),
        );
        expect(reconstructedEntity.url, originalEntity.url);
        expect(reconstructedEntity.thumbnailUrl, originalEntity.thumbnailUrl);
      });
    });
  });
}
