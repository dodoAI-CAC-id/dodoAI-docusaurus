import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:mamoai/features/incident_history/infrastructure/repositories/incident_repository_impl.dart';
import 'package:mamoai/features/incident_history/infrastructure/datasources/incident_remote_datasource.dart';
import 'package:mamoai/features/incident_history/domain/entities/incident.dart';
import 'package:mamoai/features/incident_history/domain/entities/search_criteria.dart';
import 'package:mamoai/core/error/failures.dart';

import 'incident_repository_impl_test.mocks.dart';

@GenerateMocks([IncidentRemoteDataSource])
void main() {
  late IncidentRepositoryImpl repository;
  late MockIncidentRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockIncidentRemoteDataSource();
    repository = IncidentRepositoryImpl(mockDataSource);
  });

  group('IncidentRepositoryImpl', () {
    final tIncidentJson = {
      'id': '001',
      'detectedAt': '2025-02-25T12:14:59.000Z',
      'type': '転倒',
      'status': 'open',
      'personId': 'TWO2-02',
      'personName': '山田太郎',
      'roomNumber': '101',
      'cameraId': 'CAM001',
      'roomId': 'ROOM101',
      'description': 'Test incident',
      'createdAt': '2025-02-25T12:14:59.000Z',
      'updatedAt': '2025-02-25T12:14:59.000Z',
    };

    test('should return IncidentListResult when getIncidents succeeds', () async {
      // Arrange
      when(mockDataSource.getIncidents(criteria: anyNamed('criteria')))
          .thenAnswer((_) async => [tIncidentJson]);

      // Act
      final result = await repository.getIncidents();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (incidentListResult) {
          expect(incidentListResult.incidents.length, 1);
          expect(incidentListResult.incidents[0].id, '001');
        },
      );
    });

    test('should return ServerFailure when getIncidents throws exception', () async {
      // Arrange
      when(mockDataSource.getIncidents(criteria: anyNamed('criteria')))
          .thenThrow(Exception('Server error'));

      // Act
      final result = await repository.getIncidents();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should not return success'),
      );
    });

    test('should pass SearchCriteria to datasource', () async {
      // Arrange
      final criteria = SearchCriteria(
        personId: 'TWO2-02',
        status: 'open',
        page: 1,
        limit: 20,
      );
      when(mockDataSource.getIncidents(criteria: anyNamed('criteria')))
          .thenAnswer((_) async => [tIncidentJson]);

      // Act
      await repository.getIncidents(criteria: criteria);

      // Assert
      verify(mockDataSource.getIncidents(criteria: criteria));
    });

    test('should return Incident when getIncidentById succeeds', () async {
      // Arrange
      const incidentId = '001';
      when(mockDataSource.getIncidentById(any))
          .thenAnswer((_) async => tIncidentJson);

      // Act
      final result = await repository.getIncidentById(incidentId);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (incident) {
          expect(incident.id, '001');
          expect(incident.type, '転倒');
        },
      );
    });

    test('should return ServerFailure when getIncidentById throws exception', () async {
      // Arrange
      const incidentId = '001';
      when(mockDataSource.getIncidentById(any))
          .thenThrow(Exception('Not found'));

      // Act
      final result = await repository.getIncidentById(incidentId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should not return success'),
      );
    });
  });
}
