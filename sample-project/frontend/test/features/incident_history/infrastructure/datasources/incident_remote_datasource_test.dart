import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:mamoai/features/incident_history/infrastructure/datasources/incident_remote_datasource.dart';
import 'package:mamoai/features/incident_history/domain/entities/search_criteria.dart';

import 'incident_remote_datasource_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late IncidentRemoteDataSource dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = IncidentRemoteDataSource(mockDio);
  });

  group('IncidentRemoteDataSource', () {
    final tIncidentJson = {
      'id': '001',
      'detectedAt': '2025-02-25T12:14:59.000Z',
      'type': '転倒',
      'status': 'open',
      'personId': 'TWO2-02',
      'cameraId': 'CAM001',
      'roomId': 'ROOM101',
      'description': 'Test incident',
      'createdAt': '2025-02-25T12:14:59.000Z',
      'updatedAt': '2025-02-25T12:14:59.000Z',
    };

    test('should perform GET request to /api/v2/incidents', () async {
      // Arrange
      when(mockDio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: [tIncidentJson],
            statusCode: 200,
            requestOptions: RequestOptions(path: '/api/v2/incidents'),
          ));

      // Act
      await dataSource.getIncidents();

      // Assert
      verify(mockDio.get(
        '/api/v2/incidents',
        queryParameters: anyNamed('queryParameters'),
      ));
    });

    test('should return list of incidents when response is successful', () async {
      // Arrange
      when(mockDio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: [tIncidentJson],
            statusCode: 200,
            requestOptions: RequestOptions(path: '/api/v2/incidents'),
          ));

      // Act
      final result = await dataSource.getIncidents();

      // Assert
      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.length, 1);
      expect(result[0]['id'], '001');
    });

    test('should include query parameters when criteria is provided', () async {
      // Arrange
      final criteria = SearchCriteria(
        personId: 'TWO2-02',
        status: 'open',
        fromDate: DateTime(2025, 2, 1),
        toDate: DateTime(2025, 2, 28),
        page: 1,
        limit: 20,
      );

      when(mockDio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: [tIncidentJson],
            statusCode: 200,
            requestOptions: RequestOptions(path: '/api/v2/incidents'),
          ));

      // Act
      await dataSource.getIncidents(criteria: criteria);

      // Assert
      verify(mockDio.get(
        '/api/v2/incidents',
        queryParameters: argThat(
          isA<Map<String, dynamic>>()
              .having((m) => m['personId'], 'personId', 'TWO2-02')
              .having((m) => m['status'], 'status', 'open'),
          named: 'queryParameters',
        ),
      ));
    });

    test('should get incident by ID', () async {
      // Arrange
      const incidentId = '001';
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: tIncidentJson,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/api/v2/incidents/$incidentId'),
          ));

      // Act
      final result = await dataSource.getIncidentById(incidentId);

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['id'], '001');
      verify(mockDio.get('/api/v2/incidents/$incidentId'));
    });

    test('should throw exception when response status is not 200', () async {
      // Arrange
      when(mockDio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: {'error': 'Server error'},
            statusCode: 500,
            requestOptions: RequestOptions(path: '/api/v2/incidents'),
          ));

      // Act & Assert
      expect(
        () => dataSource.getIncidents(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
