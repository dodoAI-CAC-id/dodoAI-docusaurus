import 'package:flutter_test/flutter_test.dart';
import 'package:mamoai/features/incident_history/domain/entities/pagination_info.dart';

void main() {
  group('PaginationInfo Entity', () {
    test('should create a PaginationInfo instance with all fields', () {
      // Arrange
      final paginationInfo = PaginationInfo(
        currentPage: 1,
        totalPages: 3,
        totalCount: 57,
        limit: 20,
        hasNextPage: true,
        hasPreviousPage: false,
      );

      // Assert
      expect(paginationInfo.currentPage, 1);
      expect(paginationInfo.totalPages, 3);
      expect(paginationInfo.totalCount, 57);
      expect(paginationInfo.limit, 20);
      expect(paginationInfo.hasNextPage, true);
      expect(paginationInfo.hasPreviousPage, false);
    });

    test('should calculate hasNextPage correctly', () {
      // Arrange
      final lastPage = PaginationInfo(
        currentPage: 3,
        totalPages: 3,
        totalCount: 57,
        limit: 20,
        hasNextPage: false,
        hasPreviousPage: true,
      );

      // Assert
      expect(lastPage.hasNextPage, false);
    });

    test('should calculate hasPreviousPage correctly', () {
      // Arrange
      final firstPage = PaginationInfo(
        currentPage: 1,
        totalPages: 3,
        totalCount: 57,
        limit: 20,
        hasNextPage: true,
        hasPreviousPage: false,
      );

      // Assert
      expect(firstPage.hasPreviousPage, false);
    });

    test('should support equality comparison', () {
      // Arrange
      final info1 = PaginationInfo(
        currentPage: 1,
        totalPages: 3,
        totalCount: 57,
        limit: 20,
        hasNextPage: true,
        hasPreviousPage: false,
      );

      final info2 = PaginationInfo(
        currentPage: 1,
        totalPages: 3,
        totalCount: 57,
        limit: 20,
        hasNextPage: true,
        hasPreviousPage: false,
      );

      // Assert
      expect(info1, equals(info2));
    });

    test('should convert to JSON correctly', () {
      // Arrange
      final paginationInfo = PaginationInfo(
        currentPage: 1,
        totalPages: 3,
        totalCount: 57,
        limit: 20,
        hasNextPage: true,
        hasPreviousPage: false,
      );

      // Act
      final json = paginationInfo.toJson();

      // Assert
      expect(json['currentPage'], 1);
      expect(json['totalPages'], 3);
      expect(json['totalCount'], 57);
      expect(json['limit'], 20);
      expect(json['hasNextPage'], true);
      expect(json['hasPreviousPage'], false);
    });

    test('should create from JSON correctly', () {
      // Arrange
      final json = {
        'currentPage': 1,
        'totalPages': 3,
        'totalCount': 57,
        'limit': 20,
        'hasNextPage': true,
        'hasPreviousPage': false,
      };

      // Act
      final paginationInfo = PaginationInfo.fromJson(json);

      // Assert
      expect(paginationInfo.currentPage, 1);
      expect(paginationInfo.totalPages, 3);
      expect(paginationInfo.totalCount, 57);
      expect(paginationInfo.limit, 20);
      expect(paginationInfo.hasNextPage, true);
      expect(paginationInfo.hasPreviousPage, false);
    });

    test('should calculate total pages from total count and limit', () {
      // Arrange & Act
      final paginationInfo = PaginationInfo.fromTotalCount(
        totalCount: 57,
        limit: 20,
        currentPage: 1,
      );

      // Assert
      expect(paginationInfo.totalPages, 3); // ceil(57 / 20) = 3
      expect(paginationInfo.totalCount, 57);
      expect(paginationInfo.limit, 20);
      expect(paginationInfo.currentPage, 1);
      expect(paginationInfo.hasNextPage, true);
      expect(paginationInfo.hasPreviousPage, false);
    });

    test('should handle exact division in total pages calculation', () {
      // Arrange & Act
      final paginationInfo = PaginationInfo.fromTotalCount(
        totalCount: 60,
        limit: 20,
        currentPage: 2,
      );

      // Assert
      expect(paginationInfo.totalPages, 3); // 60 / 20 = 3
      expect(paginationInfo.hasNextPage, true);
      expect(paginationInfo.hasPreviousPage, true);
    });

    test('should handle single page scenario', () {
      // Arrange & Act
      final paginationInfo = PaginationInfo.fromTotalCount(
        totalCount: 15,
        limit: 20,
        currentPage: 1,
      );

      // Assert
      expect(paginationInfo.totalPages, 1);
      expect(paginationInfo.hasNextPage, false);
      expect(paginationInfo.hasPreviousPage, false);
    });

    test('should handle empty results', () {
      // Arrange & Act
      final paginationInfo = PaginationInfo.fromTotalCount(
        totalCount: 0,
        limit: 20,
        currentPage: 1,
      );

      // Assert
      expect(paginationInfo.totalPages, 0);
      expect(paginationInfo.totalCount, 0);
      expect(paginationInfo.hasNextPage, false);
      expect(paginationInfo.hasPreviousPage, false);
    });
  });
}
