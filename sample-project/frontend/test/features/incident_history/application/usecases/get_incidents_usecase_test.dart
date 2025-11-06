import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:mamoai/features/incident_history/domain/entities/incident.dart';
import 'package:mamoai/features/incident_history/domain/entities/search_criteria.dart';
import 'package:mamoai/features/incident_history/domain/entities/pagination_info.dart';
import 'package:mamoai/features/incident_history/domain/repositories/i_incident_repository.dart';
import 'package:mamoai/features/incident_history/application/usecases/get_incidents_usecase.dart';
import 'package:mamoai/core/error/failures.dart';

import 'get_incidents_usecase_test.mocks.dart';

@GenerateMocks([IIncidentRepository])
void main() {
  late GetIncidentsUseCase useCase;
  late MockIIncidentRepository mockRepository;

  setUp(() {
    mockRepository = MockIIncidentRepository();
    useCase = GetIncidentsUseCase(mockRepository);
  });

  group('GetIncidentsUseCase', () {
    final tIncidents = [
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

    final tPaginationInfo = PaginationInfo.fromTotalCount(
      totalCount: 1,
      limit: 20,
      currentPage: 1,
    );

    final tIncidentListResult = IncidentListResult(
      incidents: tIncidents,
      paginationInfo: tPaginationInfo,
    );

    test('should get incidents from the repository', () async {
      // Arrange
      when(mockRepository.getIncidents(criteria: anyNamed('criteria')))
          .thenAnswer((_) async => Right(tIncidentListResult));

      // Act
      final result = await useCase(const GetIncidentsParams());

      // Assert
      expect(result, Right(tIncidentListResult));
      verify(mockRepository.getIncidents(criteria: anyNamed('criteria')));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should get incidents with search criteria', () async {
      // Arrange
      final tCriteria = SearchCriteria(
        personId: 'TWO2-02',
        status: 'open',
        page: 1,
        limit: 20,
      );

      when(mockRepository.getIncidents(criteria: anyNamed('criteria')))
          .thenAnswer((_) async => Right(tIncidentListResult));

      // Act
      final result = await useCase(GetIncidentsParams(criteria: tCriteria));

      // Assert
      expect(result, Right(tIncidentListResult));
      verify(mockRepository.getIncidents(criteria: tCriteria));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      const tFailure = ServerFailure('Server error');
      when(mockRepository.getIncidents(criteria: anyNamed('criteria')))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(const GetIncidentsParams());

      // Assert
      expect(result, const Left(tFailure));
      verify(mockRepository.getIncidents(criteria: anyNamed('criteria')));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when network error occurs', () async {
      // Arrange
      const tFailure = NetworkFailure('Network error');
      when(mockRepository.getIncidents(criteria: anyNamed('criteria')))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(const GetIncidentsParams());

      // Assert
      expect(result, const Left(tFailure));
    });
  });
}
