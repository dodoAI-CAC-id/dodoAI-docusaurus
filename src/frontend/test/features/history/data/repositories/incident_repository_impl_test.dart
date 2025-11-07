import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:frontend/features/history/data/repositories/incident_repository_impl.dart';
import 'package:frontend/features/history/domain/entities/incident.dart';
import 'package:frontend/features/history/domain/models/search_criteria.dart';
import 'package:frontend/core/network/api_exceptions.dart';

// Mock生成のためのアノテーション
@GenerateMocks([Dio])
import 'incident_repository_impl_test.mocks.dart';

void main() {
  late IncidentRepositoryImpl repository;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    repository = IncidentRepositoryImpl(mockDio);
  });

  group('IncidentRepositoryImpl', () {
    group('fetchIncidents', () {
      final testResponseData = {
        'status': 'success',
        'data': [
          {
            'id': 'incident_001',
            'incident_id': 'INC-001',
            'detected_at': '2025-10-31T09:00:00Z',
            'room_number': '101',
            'bed_number': 'A',
            'resident_name': '田中花子',
            'detection_type': '転倒検知',
            'status': 'detected',
            'actions': [],
            'video_id': 'video_001',
          },
        ],
        'pagination': {
          'page': 1,
          'page_size': 20,
          'total_count': 50,
          'total_pages': 3,
        },
      };

      test('should return list of Incidents when API call is successful', () async {
        // Arrange
        when(mockDio.get(
          '/api/incidents',
          queryParameters: {'page': 1, 'page_size': 20},
        )).thenAnswer((_) async => Response(
              data: testResponseData,
              statusCode: 200,
              requestOptions: RequestOptions(path: '/api/incidents'),
            ));

        // Act
        final result = await repository.fetchIncidents(page: 1, pageSize: 20);

        // Assert
        expect(result, isA<List<Incident>>());
        expect(result.length, 1);
        expect(result[0].id, 'incident_001');
        expect(result[0].incidentId, 'INC-001');
        verify(mockDio.get(
          '/api/incidents',
          queryParameters: {'page': 1, 'page_size': 20},
        )).called(1);
      });

      test('should throw ServerException when server error occurs', () async {
        // Arrange
        when(mockDio.get(
          '/api/incidents',
          queryParameters: anyNamed('queryParameters'),
        )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/incidents'),
            response: Response(
              statusCode: 500,
              data: {'status': 'error', 'message': 'Internal server error'},
              requestOptions: RequestOptions(path: '/api/incidents'),
            ),
          ),
        );

        // Act & Assert
        expect(
          () => repository.fetchIncidents(page: 1, pageSize: 20),
          throwsA(isA<ServerException>()),
        );
      });
    });

    group('fetchIncidentById', () {
      const testIncidentId = 'incident_001';
      final testResponseData = {
        'status': 'success',
        'data': {
          'id': 'incident_001',
          'incident_id': 'INC-001',
          'detected_at': '2025-10-31T09:00:00Z',
          'room_number': '101',
          'bed_number': 'A',
          'resident_name': '田中花子',
          'detection_type': '転倒検知',
          'status': 'detected',
          'actions': [],
          'video_id': 'video_001',
        },
      };

      test('should return Incident when API call is successful', () async {
        // Arrange
        when(mockDio.get('/api/incidents/$testIncidentId'))
            .thenAnswer((_) async => Response(
                  data: testResponseData,
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/api/incidents/$testIncidentId'),
                ));

        // Act
        final result = await repository.fetchIncidentById(testIncidentId);

        // Assert
        expect(result, isA<Incident>());
        expect(result.id, 'incident_001');
        expect(result.incidentId, 'INC-001');
        verify(mockDio.get('/api/incidents/$testIncidentId')).called(1);
      });

      test('should throw NotFoundException when incident not found', () async {
        // Arrange
        when(mockDio.get('/api/incidents/$testIncidentId')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/incidents/$testIncidentId'),
            response: Response(
              statusCode: 404,
              data: {'status': 'error', 'message': 'Incident not found'},
              requestOptions: RequestOptions(path: '/api/incidents/$testIncidentId'),
            ),
          ),
        );

        // Act & Assert
        expect(
          () => repository.fetchIncidentById(testIncidentId),
          throwsA(isA<NotFoundException>()),
        );
      });
    });

    group('searchIncidents', () {
      final testCriteria = SearchCriteria(
        startDate: DateTime.parse('2025-10-01'),
        endDate: DateTime.parse('2025-10-31'),
        roomNumber: '101',
      );

      final testResponseData = {
        'status': 'success',
        'data': [
          {
            'id': 'incident_001',
            'incident_id': 'INC-001',
            'detected_at': '2025-10-15T09:00:00Z',
            'room_number': '101',
            'bed_number': 'A',
            'resident_name': '田中花子',
            'detection_type': '転倒検知',
            'status': 'detected',
            'actions': [],
            'video_id': 'video_001',
          },
        ],
        'pagination': {
          'page': 1,
          'page_size': 20,
          'total_count': 1,
          'total_pages': 1,
        },
      };

      test('should return search results when API call is successful', () async {
        // Arrange
        when(mockDio.post(
          '/api/incidents/search',
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              data: testResponseData,
              statusCode: 200,
              requestOptions: RequestOptions(path: '/api/incidents/search'),
            ));

        // Act
        final result = await repository.searchIncidents(
          criteria: testCriteria,
          page: 1,
          pageSize: 20,
        );

        // Assert
        expect(result, isA<List<Incident>>());
        expect(result.length, 1);
        expect(result[0].roomNumber, '101');
        verify(mockDio.post(
          '/api/incidents/search',
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
        )).called(1);
      });

      test('should throw ValidationException for invalid search criteria', () async {
        // Arrange
        when(mockDio.post(
          '/api/incidents/search',
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
        )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/incidents/search'),
            response: Response(
              statusCode: 400,
              data: {'status': 'error', 'message': 'Invalid search criteria'},
              requestOptions: RequestOptions(path: '/api/incidents/search'),
            ),
          ),
        );

        // Act & Assert
        expect(
          () => repository.searchIncidents(
            criteria: testCriteria,
            page: 1,
            pageSize: 20,
          ),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('countIncidents', () {
      test('should return total count when API call is successful', () async {
        // Arrange
        when(mockDio.get('/api/incidents/count')).thenAnswer((_) async => Response(
              data: {
                'status': 'success',
                'data': {'count': 100},
              },
              statusCode: 200,
              requestOptions: RequestOptions(path: '/api/incidents/count'),
            ));

        // Act
        final result = await repository.countIncidents();

        // Assert
        expect(result, 100);
        verify(mockDio.get('/api/incidents/count')).called(1);
      });

      test('should throw ServerException when server error occurs', () async {
        // Arrange
        when(mockDio.get('/api/incidents/count')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/incidents/count'),
            response: Response(
              statusCode: 500,
              data: {'status': 'error', 'message': 'Internal server error'},
              requestOptions: RequestOptions(path: '/api/incidents/count'),
            ),
          ),
        );

        // Act & Assert
        expect(
          () => repository.countIncidents(),
          throwsA(isA<ServerException>()),
        );
      });
    });

    group('countSearchResults', () {
      final testCriteria = SearchCriteria(
        startDate: DateTime.parse('2025-10-01'),
        endDate: DateTime.parse('2025-10-31'),
      );

      test('should return search result count when API call is successful', () async {
        // Arrange
        when(mockDio.post(
          '/api/incidents/search/count',
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
              data: {
                'status': 'success',
                'data': {'count': 15},
              },
              statusCode: 200,
              requestOptions: RequestOptions(path: '/api/incidents/search/count'),
            ));

        // Act
        final result = await repository.countSearchResults(testCriteria);

        // Assert
        expect(result, 15);
        verify(mockDio.post(
          '/api/incidents/search/count',
          data: anyNamed('data'),
        )).called(1);
      });
    });
  });
}
