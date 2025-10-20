import 'package:flutter_test/flutter_test.dart';
import 'package:mamoai/features/incident_history/domain/entities/search_criteria.dart';

void main() {
  group('SearchCriteria Entity', () {
    test('should create a SearchCriteria instance with all fields', () {
      // Arrange
      final criteria = SearchCriteria(
        personId: 'TWO2-02',
        personName: '山田太郎',
        roomNumber: '101',
        status: 'open',
        fromDate: DateTime(2025, 2, 1),
        toDate: DateTime(2025, 2, 28),
        page: 1,
        limit: 20,
      );

      // Assert
      expect(criteria.personId, 'TWO2-02');
      expect(criteria.personName, '山田太郎');
      expect(criteria.roomNumber, '101');
      expect(criteria.status, 'open');
      expect(criteria.fromDate, DateTime(2025, 2, 1));
      expect(criteria.toDate, DateTime(2025, 2, 28));
      expect(criteria.page, 1);
      expect(criteria.limit, 20);
    });

    test('should create a SearchCriteria with optional fields as null', () {
      // Arrange
      final criteria = SearchCriteria(
        page: 1,
        limit: 20,
      );

      // Assert
      expect(criteria.personId, isNull);
      expect(criteria.personName, isNull);
      expect(criteria.roomNumber, isNull);
      expect(criteria.status, isNull);
      expect(criteria.fromDate, isNull);
      expect(criteria.toDate, isNull);
      expect(criteria.page, 1);
      expect(criteria.limit, 20);
    });

    test('should support equality comparison', () {
      // Arrange
      final criteria1 = SearchCriteria(
        personId: 'TWO2-02',
        status: 'open',
        page: 1,
        limit: 20,
      );

      final criteria2 = SearchCriteria(
        personId: 'TWO2-02',
        status: 'open',
        page: 1,
        limit: 20,
      );

      // Assert
      expect(criteria1, equals(criteria2));
    });

    test('should convert to JSON correctly', () {
      // Arrange
      final criteria = SearchCriteria(
        personId: 'TWO2-02',
        personName: '山田太郎',
        status: 'open',
        fromDate: DateTime(2025, 2, 1),
        toDate: DateTime(2025, 2, 28),
        page: 1,
        limit: 20,
      );

      // Act
      final json = criteria.toJson();

      // Assert
      expect(json['personId'], 'TWO2-02');
      expect(json['personName'], '山田太郎');
      expect(json['status'], 'open');
      expect(json['page'], 1);
      expect(json['limit'], 20);
      expect(json['fromDate'], isNotNull);
      expect(json['toDate'], isNotNull);
    });

    test('should convert to query parameters correctly', () {
      // Arrange
      final criteria = SearchCriteria(
        personId: 'TWO2-02',
        status: 'open',
        page: 1,
        limit: 20,
      );

      // Act
      final queryParams = criteria.toQueryParameters();

      // Assert
      expect(queryParams['personId'], 'TWO2-02');
      expect(queryParams['status'], 'open');
      expect(queryParams['page'], '1');
      expect(queryParams['limit'], '20');
    });

    test('should exclude null values from query parameters', () {
      // Arrange
      final criteria = SearchCriteria(
        personId: 'TWO2-02',
        page: 1,
        limit: 20,
      );

      // Act
      final queryParams = criteria.toQueryParameters();

      // Assert
      expect(queryParams.containsKey('personId'), true);
      expect(queryParams.containsKey('personName'), false);
      expect(queryParams.containsKey('roomNumber'), false);
      expect(queryParams.containsKey('status'), false);
    });

    test('should create a copy with updated values', () {
      // Arrange
      final original = SearchCriteria(
        personId: 'TWO2-02',
        status: 'open',
        page: 1,
        limit: 20,
      );

      // Act
      final updated = original.copyWith(
        status: 'resolved',
        page: 2,
      );

      // Assert
      expect(updated.personId, 'TWO2-02');
      expect(updated.status, 'resolved');
      expect(updated.page, 2);
      expect(updated.limit, 20);
    });
  });
}
