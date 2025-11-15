import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mamoai/features/view_screen/domain/entities/incident_status.dart';
import 'package:mamoai/features/view_screen/infrastructure/datasources/view_screen_remote_datasource.dart';

@GenerateMocks([Dio])
import 'view_screen_remote_datasource_test.mocks.dart';

void main() {
  late ViewScreenRemoteDataSource dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = ViewScreenRemoteDataSource(mockDio);
  });

  group('ViewScreenRemoteDataSource', () {
    group('getIncidents', () {
      test('一覧取得が成功した場合、List<Map<String, dynamic>>を返す（配列直接形式）', () async {
        // Arrange
        final responseData = [
          {
            'id': '1',
            'status': 'open',
            'type': '起床',
            'detectedAt': '2024-01-15T10:00:00Z',
            'personName': '山田 太郎',
            'roomNumber': '101-A',
          },
          {
            'id': '2',
            'status': 'monitoring',
            'type': '離床',
            'detectedAt': '2024-01-15T11:00:00Z',
            'personName': '佐藤 花子',
            'roomNumber': '102-B',
          },
        ];

        when(mockDio.get(any)).thenAnswer(
          (_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/api/v2/incidents'),
          ),
        );

        // Act
        final result = await dataSource.getIncidents();

        // Assert
        expect(result, isA<List<Map<String, dynamic>>>());
        expect(result.length, 2);
        expect(result[0]['id'], '1');
        expect(result[1]['id'], '2');
        verify(mockDio.get('/api/v2/incidents')).called(1);
      });

      test('一覧取得が成功した場合、List<Map<String, dynamic>>を返す（data wrapped形式）',
          () async {
        // Arrange
        final responseData = {
          'success': true,
          'data': [
            {
              'id': '1',
              'status': 'open',
              'type': '起床',
            },
          ],
        };

        when(mockDio.get(any)).thenAnswer(
          (_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/api/v2/incidents'),
          ),
        );

        // Act
        final result = await dataSource.getIncidents();

        // Assert
        expect(result, isA<List<Map<String, dynamic>>>());
        expect(result.length, 1);
        expect(result[0]['id'], '1');
      });

      test('一覧取得でdataがnullの場合、空配列を返す', () async {
        // Arrange
        final responseData = {
          'success': true,
          'data': null,
        };

        when(mockDio.get(any)).thenAnswer(
          (_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/api/v2/incidents'),
          ),
        );

        // Act
        final result = await dataSource.getIncidents();

        // Assert
        expect(result, isEmpty);
      });

      test('一覧取得でステータスコードが200以外の場合、Exceptionをスローする', () async {
        // Arrange
        when(mockDio.get(any)).thenAnswer(
          (_) async => Response(
            data: null,
            statusCode: 500,
            requestOptions: RequestOptions(path: '/api/v2/incidents'),
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.getIncidents(),
          throwsA(isA<Exception>()),
        );
      });

      test('一覧取得でDioExceptionが発生した場合、Exceptionをスローする', () async {
        // Arrange
        when(mockDio.get(any)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/v2/incidents'),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.getIncidents(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getIncidentById', () {
      test('詳細取得が成功した場合、Map<String, dynamic>を返す（直接オブジェクト形式）',
          () async {
        // Arrange
        final responseData = {
          'id': '1',
          'status': 'open',
          'type': '起床',
          'detectedAt': '2024-01-15T10:00:00Z',
          'personName': '山田 太郎',
          'roomNumber': '101-A',
          'pictures': {
            'pictureAtDetection': 'base64_image_1',
            'pictureBeforeDetection': 'base64_image_2',
          },
        };

        when(mockDio.get(any)).thenAnswer(
          (_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/api/v2/incidents/1'),
          ),
        );

        // Act
        final result = await dataSource.getIncidentById('1');

        // Assert
        expect(result, isA<Map<String, dynamic>>());
        expect(result['id'], '1');
        expect(result['pictures'], isNotNull);
        verify(mockDio.get('/api/v2/incidents/1')).called(1);
      });

      test('詳細取得が成功した場合、Map<String, dynamic>を返す（data wrapped形式）',
          () async {
        // Arrange
        final responseData = {
          'success': true,
          'data': {
            'id': '1',
            'status': 'open',
            'type': '起床',
          },
        };

        when(mockDio.get(any)).thenAnswer(
          (_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/api/v2/incidents/1'),
          ),
        );

        // Act
        final result = await dataSource.getIncidentById('1');

        // Assert
        expect(result, isA<Map<String, dynamic>>());
        expect(result['id'], '1');
      });

      test('詳細取得でステータスコードが200以外の場合、Exceptionをスローする', () async {
        // Arrange
        when(mockDio.get(any)).thenAnswer(
          (_) async => Response(
            data: null,
            statusCode: 404,
            requestOptions: RequestOptions(path: '/api/v2/incidents/999'),
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.getIncidentById('999'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('updateIncidentStatus', () {
      test('ステータス更新が成功した場合、更新後のデータを返す', () async {
        // Arrange
        final incidentData = {
          'id': '1',
          'status': 'monitoring',
          'type': '起床',
        };

        when(mockDio.patch(any, data: anyNamed('data'))).thenAnswer(
          (_) async => Response(
            data: {'success': true},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/api/v2/incidents/1'),
          ),
        );

        when(mockDio.post(any, data: anyNamed('data'))).thenAnswer(
          (_) async => Response(
            data: {'success': true},
            statusCode: 201,
            requestOptions: RequestOptions(path: '/api/v2/incidents/1/actions'),
          ),
        );

        when(mockDio.get(any)).thenAnswer(
          (_) async => Response(
            data: incidentData,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/api/v2/incidents/1'),
          ),
        );

        // Act
        final result = await dataSource.updateIncidentStatus(
          incidentId: '1',
          newStatus: IncidentStatus.inProgress,
          actionType: 'start_response',
        );

        // Assert
        expect(result, isA<Map<String, dynamic>>());
        expect(result['id'], '1');
        expect(result['status'], 'monitoring');
        verify(mockDio.post(
          '/api/v2/incidents/1/actions',
          data: anyNamed('data'),
        )).called(1);
        verify(mockDio.get('/api/v2/incidents/1')).called(1);
      });

      test('ステータス更新でステータスコードが201/200以外の場合、Exceptionをスローする',
          () async {
        // Arrange
        when(mockDio.patch(any, data: anyNamed('data'))).thenAnswer(
          (_) async => Response(
            data: null,
            statusCode: 400,
            requestOptions: RequestOptions(path: '/api/v2/incidents/1'),
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.updateIncidentStatus(
            incidentId: '1',
            newStatus: IncidentStatus.inProgress,
            actionType: 'start_response',
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('toggleAlertStatus', () {
      test('アラート状態切り替えが成功した場合、更新後のデータを返す', () async {
        // Arrange
        final responseData = {
          'success': true,
          'data': {
            'id': '1',
            'status': 'open',
            'type': '起床',
            'isAlertActive': false,
          },
        };

        when(mockDio.patch(any, data: anyNamed('data'))).thenAnswer(
          (_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions:
                RequestOptions(path: '/api/v2/incidents/1/alert'),
          ),
        );

        // Act
        final result = await dataSource.toggleAlertStatus(
          incidentId: '1',
          isActive: false,
        );

        // Assert
        expect(result, isA<Map<String, dynamic>>());
        expect(result['id'], '1');
        expect(result['isAlertActive'], false);
        verify(mockDio.patch(
          '/api/v2/incidents/1/alert',
          data: {'isActive': false},
        )).called(1);
      });

      test('アラート状態切り替えでステータスコードが200以外の場合、Exceptionをスローする',
          () async {
        // Arrange
        when(mockDio.patch(any, data: anyNamed('data'))).thenAnswer(
          (_) async => Response(
            data: null,
            statusCode: 404,
            requestOptions:
                RequestOptions(path: '/api/v2/incidents/999/alert'),
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.toggleAlertStatus(
            incidentId: '999',
            isActive: false,
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('_handleDioError', () {
      test('connectionTimeoutの場合、適切なExceptionを返す', () async {
        // Arrange
        when(mockDio.get(any)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/v2/incidents'),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.getIncidents(),
          throwsA(
            predicate((e) =>
                e is Exception && e.toString().contains('Connection timeout')),
          ),
        );
      });

      test('badResponseの場合、適切なExceptionを返す', () async {
        // Arrange
        when(mockDio.get(any)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/v2/incidents'),
            type: DioExceptionType.badResponse,
            response: Response(
              statusCode: 500,
              requestOptions: RequestOptions(path: '/api/v2/incidents'),
            ),
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.getIncidents(),
          throwsA(
            predicate((e) =>
                e is Exception && e.toString().contains('Server error')),
          ),
        );
      });

      test('cancelの場合、適切なExceptionを返す', () async {
        // Arrange
        when(mockDio.get(any)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/v2/incidents'),
            type: DioExceptionType.cancel,
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.getIncidents(),
          throwsA(
            predicate((e) =>
                e is Exception && e.toString().contains('Request cancelled')),
          ),
        );
      });
    });
  });
}
