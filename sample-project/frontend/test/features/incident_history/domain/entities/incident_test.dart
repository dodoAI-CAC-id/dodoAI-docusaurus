import 'package:flutter_test/flutter_test.dart';
import 'package:mamoai/features/incident_history/domain/entities/incident.dart';

void main() {
  group('Incident Entity', () {
    test('should create an Incident instance with all required fields', () {
      // Arrange
      final incident = Incident(
        id: '001',
        detectedAt: DateTime(2025, 2, 25, 12, 14, 59),
        type: '転倒',
        personId: 'TWO2-02',
        personName: '山田太郎',
        roomNumber: '101',
        status: 'open',
        videoId: 'video_001',
        createdAt: DateTime(2025, 2, 25, 12, 14, 59),
        updatedAt: DateTime(2025, 2, 25, 12, 14, 59),
      );

      // Assert
      expect(incident.id, '001');
      expect(incident.detectedAt, DateTime(2025, 2, 25, 12, 14, 59));
      expect(incident.type, '転倒');
      expect(incident.personId, 'TWO2-02');
      expect(incident.personName, '山田太郎');
      expect(incident.roomNumber, '101');
      expect(incident.status, 'open');
      expect(incident.videoId, 'video_001');
    });

    test('should support equality comparison', () {
      // Arrange
      final incident1 = Incident(
        id: '001',
        detectedAt: DateTime(2025, 2, 25, 12, 14, 59),
        type: '転倒',
        personId: 'TWO2-02',
        personName: '山田太郎',
        roomNumber: '101',
        status: 'open',
        videoId: 'video_001',
        createdAt: DateTime(2025, 2, 25, 12, 14, 59),
        updatedAt: DateTime(2025, 2, 25, 12, 14, 59),
      );

      final incident2 = Incident(
        id: '001',
        detectedAt: DateTime(2025, 2, 25, 12, 14, 59),
        type: '転倒',
        personId: 'TWO2-02',
        personName: '山田太郎',
        roomNumber: '101',
        status: 'open',
        videoId: 'video_001',
        createdAt: DateTime(2025, 2, 25, 12, 14, 59),
        updatedAt: DateTime(2025, 2, 25, 12, 14, 59),
      );

      // Assert
      expect(incident1, equals(incident2));
    });

    test('should convert to JSON correctly', () {
      // Arrange
      final incident = Incident(
        id: '001',
        detectedAt: DateTime(2025, 2, 25, 12, 14, 59),
        type: '転倒',
        personId: 'TWO2-02',
        personName: '山田太郎',
        roomNumber: '101',
        status: 'open',
        videoId: 'video_001',
        createdAt: DateTime(2025, 2, 25, 12, 14, 59),
        updatedAt: DateTime(2025, 2, 25, 12, 14, 59),
      );

      // Act
      final json = incident.toJson();

      // Assert
      expect(json['id'], '001');
      expect(json['type'], '転倒');
      expect(json['personId'], 'TWO2-02');
      expect(json['personName'], '山田太郎');
      expect(json['status'], 'open');
    });

    test('should create from JSON correctly', () {
      // Arrange
      final json = {
        'id': '001',
        'detectedAt': '2025-02-25T12:14:59.000Z',
        'type': '転倒',
        'personId': 'TWO2-02',
        'personName': '山田太郎',
        'roomNumber': '101',
        'status': 'open',
        'videoId': 'video_001',
        'createdAt': '2025-02-25T12:14:59.000Z',
        'updatedAt': '2025-02-25T12:14:59.000Z',
      };

      // Act
      final incident = Incident.fromJson(json);

      // Assert
      expect(incident.id, '001');
      expect(incident.type, '転倒');
      expect(incident.personId, 'TWO2-02');
      expect(incident.personName, '山田太郎');
      expect(incident.status, 'open');
    });
  });
}
