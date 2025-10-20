import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mamoai/features/incident_history/domain/entities/incident.dart';
import 'package:mamoai/features/incident_history/domain/entities/search_criteria.dart';
import 'package:mamoai/features/incident_history/domain/entities/pagination_info.dart';
import 'package:mamoai/features/incident_history/domain/repositories/i_incident_repository.dart';
import 'package:mamoai/core/error/failures.dart';

// Mock implementation for testing
class MockIncidentRepository implements IIncidentRepository {
  @override
  Future<Either<Failure, IncidentListResult>> getIncidents({
    SearchCriteria? criteria,
  }) async {
    // Mock implementation
    final incidents = [
      Incident(
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
      ),
    ];

    final paginationInfo = PaginationInfo.fromTotalCount(
      totalCount: 1,
      limit: 20,
      currentPage: 1,
    );

    return Right(IncidentListResult(
      incidents: incidents,
      paginationInfo: paginationInfo,
    ));
  }

  @override
  Future<Either<Failure, Incident>> getIncidentById(String id) async {
    // Mock implementation
    return Right(Incident(
      id: id,
      detectedAt: DateTime(2025, 2, 25, 12, 14, 59),
      type: '転倒',
      personId: 'TWO2-02',
      personName: '山田太郎',
      roomNumber: '101',
      status: 'open',
      videoId: 'video_001',
      createdAt: DateTime(2025, 2, 25, 12, 14, 59),
      updatedAt: DateTime(2025, 2, 25, 12, 14, 59),
    ));
  }
}

void main() {
  group('IIncidentRepository Interface', () {
    late IIncidentRepository repository;

    setUp(() {
      repository = MockIncidentRepository();
    });

    test('should return IncidentListResult when getIncidents is called', () async {
      // Arrange
      final criteria = SearchCriteria(
        page: 1,
        limit: 20,
      );

      // Act
      final result = await repository.getIncidents(criteria: criteria);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (incidentListResult) {
          expect(incidentListResult.incidents, isA<List<Incident>>());
          expect(incidentListResult.paginationInfo, isA<PaginationInfo>());
        },
      );
    });

    test('should return Incident when getIncidentById is called', () async {
      // Arrange
      const incidentId = '001';

      // Act
      final result = await repository.getIncidentById(incidentId);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (incident) {
          expect(incident, isA<Incident>());
          expect(incident.id, incidentId);
        },
      );
    });

    test('should handle repository methods returning Either type', () async {
      // Act
      final listResult = await repository.getIncidents();
      final detailResult = await repository.getIncidentById('001');

      // Assert
      expect(listResult, isA<Either<Failure, IncidentListResult>>());
      expect(detailResult, isA<Either<Failure, Incident>>());
    });
  });
}
