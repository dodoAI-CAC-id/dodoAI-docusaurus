import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/history/domain/entities/video.dart';

void main() {
  group('Video Entity', () {
    test('should create a video with required properties', () {
      // Arrange
      final video = Video(
        id: 'video-123',
        incidentId: 'INC-001',
        fileName: 'incident_2025_10_31_10_00.mp4',
        fileSize: 15728640, // 15 MB
        duration: 180, // 3 minutes in seconds
        recordedAt: DateTime(2025, 10, 31, 10, 0),
        url: 'https://storage.example.com/videos/video-123.mp4',
      );

      // Assert
      expect(video.id, 'video-123');
      expect(video.incidentId, 'INC-001');
      expect(video.fileName, 'incident_2025_10_31_10_00.mp4');
      expect(video.fileSize, 15728640);
      expect(video.duration, 180);
      expect(video.recordedAt, DateTime(2025, 10, 31, 10, 0));
      expect(video.url, 'https://storage.example.com/videos/video-123.mp4');
    });

    test('should support equality comparison', () {
      // Arrange
      final video1 = Video(
        id: 'video-123',
        incidentId: 'INC-001',
        fileName: 'incident_2025_10_31_10_00.mp4',
        fileSize: 15728640,
        duration: 180,
        recordedAt: DateTime(2025, 10, 31, 10, 0),
        url: 'https://storage.example.com/videos/video-123.mp4',
      );

      final video2 = Video(
        id: 'video-123',
        incidentId: 'INC-001',
        fileName: 'incident_2025_10_31_10_00.mp4',
        fileSize: 15728640,
        duration: 180,
        recordedAt: DateTime(2025, 10, 31, 10, 0),
        url: 'https://storage.example.com/videos/video-123.mp4',
      );

      final video3 = Video(
        id: 'video-456',
        incidentId: 'INC-002',
        fileName: 'incident_2025_10_31_11_00.mp4',
        fileSize: 20971520,
        duration: 240,
        recordedAt: DateTime(2025, 10, 31, 11, 0),
        url: 'https://storage.example.com/videos/video-456.mp4',
      );

      // Assert
      expect(video1, equals(video2));
      expect(video1, isNot(equals(video3)));
      expect(video1.hashCode, equals(video2.hashCode));
      expect(video1.hashCode, isNot(equals(video3.hashCode)));
    });

    test('should create a copy with updated properties', () {
      // Arrange
      final original = Video(
        id: 'video-123',
        incidentId: 'INC-001',
        fileName: 'incident_2025_10_31_10_00.mp4',
        fileSize: 15728640,
        duration: 180,
        recordedAt: DateTime(2025, 10, 31, 10, 0),
        url: 'https://storage.example.com/videos/video-123.mp4',
      );

      // Act
      final updated = original.copyWith(
        fileName: 'updated_incident_2025_10_31_10_00.mp4',
        url: 'https://storage.example.com/videos/updated-video-123.mp4',
      );

      // Assert
      expect(updated.id, original.id);
      expect(updated.incidentId, original.incidentId);
      expect(updated.fileName, 'updated_incident_2025_10_31_10_00.mp4');
      expect(updated.fileSize, original.fileSize);
      expect(updated.duration, original.duration);
      expect(updated.recordedAt, original.recordedAt);
      expect(updated.url, 'https://storage.example.com/videos/updated-video-123.mp4');
      expect(original.fileName, 'incident_2025_10_31_10_00.mp4');
      expect(original.url, 'https://storage.example.com/videos/video-123.mp4');
    });

    test('should format file size correctly', () {
      // Arrange
      final smallVideo = Video(
        id: 'video-1',
        incidentId: 'INC-001',
        fileName: 'small.mp4',
        fileSize: 1024, // 1 KB
        duration: 30,
        recordedAt: DateTime.now(),
        url: 'https://example.com/small.mp4',
      );

      final mediumVideo = Video(
        id: 'video-2',
        incidentId: 'INC-002',
        fileName: 'medium.mp4',
        fileSize: 1048576, // 1 MB
        duration: 60,
        recordedAt: DateTime.now(),
        url: 'https://example.com/medium.mp4',
      );

      final largeVideo = Video(
        id: 'video-3',
        incidentId: 'INC-003',
        fileName: 'large.mp4',
        fileSize: 1073741824, // 1 GB
        duration: 3600,
        recordedAt: DateTime.now(),
        url: 'https://example.com/large.mp4',
      );

      // Assert
      expect(smallVideo.formattedFileSize, '1.00 KB');
      expect(mediumVideo.formattedFileSize, '1.00 MB');
      expect(largeVideo.formattedFileSize, '1.00 GB');
    });

    test('should format duration correctly', () {
      // Arrange
      final shortVideo = Video(
        id: 'video-1',
        incidentId: 'INC-001',
        fileName: 'short.mp4',
        fileSize: 1024,
        duration: 45, // 45 seconds
        recordedAt: DateTime.now(),
        url: 'https://example.com/short.mp4',
      );

      final mediumVideo = Video(
        id: 'video-2',
        incidentId: 'INC-002',
        fileName: 'medium.mp4',
        fileSize: 1024,
        duration: 185, // 3 minutes 5 seconds
        recordedAt: DateTime.now(),
        url: 'https://example.com/medium.mp4',
      );

      final longVideo = Video(
        id: 'video-3',
        incidentId: 'INC-003',
        fileName: 'long.mp4',
        fileSize: 1024,
        duration: 3725, // 1 hour 2 minutes 5 seconds
        recordedAt: DateTime.now(),
        url: 'https://example.com/long.mp4',
      );

      // Assert
      expect(shortVideo.formattedDuration, '00:45');
      expect(mediumVideo.formattedDuration, '03:05');
      expect(longVideo.formattedDuration, '1:02:05');
    });

    test('should handle optional thumbnail URL', () {
      // Arrange
      final videoWithThumbnail = Video(
        id: 'video-123',
        incidentId: 'INC-001',
        fileName: 'incident.mp4',
        fileSize: 1048576,
        duration: 180,
        recordedAt: DateTime(2025, 10, 31, 10, 0),
        url: 'https://storage.example.com/videos/video-123.mp4',
        thumbnailUrl: 'https://storage.example.com/thumbnails/thumb-123.jpg',
      );

      final videoWithoutThumbnail = Video(
        id: 'video-124',
        incidentId: 'INC-002',
        fileName: 'incident2.mp4',
        fileSize: 1048576,
        duration: 180,
        recordedAt: DateTime(2025, 10, 31, 11, 0),
        url: 'https://storage.example.com/videos/video-124.mp4',
      );

      // Assert
      expect(videoWithThumbnail.thumbnailUrl, 'https://storage.example.com/thumbnails/thumb-123.jpg');
      expect(videoWithoutThumbnail.thumbnailUrl, isNull);
    });

    test('should preserve immutability when copying', () {
      // Arrange
      final original = Video(
        id: 'video-123',
        incidentId: 'INC-001',
        fileName: 'original.mp4',
        fileSize: 1048576,
        duration: 180,
        recordedAt: DateTime(2025, 10, 31, 10, 0),
        url: 'https://example.com/original.mp4',
      );

      // Act
      final updated1 = original.copyWith(fileName: 'updated1.mp4');
      final updated2 = original.copyWith(fileSize: 2097152);

      // Assert
      expect(original.fileName, 'original.mp4');
      expect(original.fileSize, 1048576);
      expect(updated1.fileName, 'updated1.mp4');
      expect(updated1.fileSize, 1048576);
      expect(updated2.fileName, 'original.mp4');
      expect(updated2.fileSize, 2097152);
    });
  });
}
