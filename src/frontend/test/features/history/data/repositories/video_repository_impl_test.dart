import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:frontend/features/history/data/repositories/video_repository_impl.dart';
import 'package:frontend/features/history/domain/entities/video.dart';
import 'package:frontend/core/network/api_exceptions.dart';

// Mock生成のためのアノテーション
@GenerateMocks([Dio])
import 'video_repository_impl_test.mocks.dart';

void main() {
  late VideoRepositoryImpl repository;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    repository = VideoRepositoryImpl(mockDio);
  });

  group('VideoRepositoryImpl', () {
    group('fetchVideoById', () {
      const testVideoId = 'video_001';
      final testResponseData = {
        'status': 'success',
        'data': {
          'id': 'video_001',
          'incident_id': 'incident_001',
          'file_name': 'test.mp4',
          'file_size': 1024000,
          'duration': 120,
          'recorded_at': '2025-10-31T10:00:00Z',
          'url': 'https://example.com/video_001',
          'thumbnail_url': 'https://example.com/thumb_001',
        },
      };

      test('should return Video when API call is successful', () async {
        // Arrange
        when(mockDio.get('/api/videos/$testVideoId'))
            .thenAnswer((_) async => Response(
                  data: testResponseData,
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/api/videos/$testVideoId'),
                ));

        // Act
        final result = await repository.fetchVideoById(testVideoId);

        // Assert
        expect(result, isA<Video>());
        expect(result.id, 'video_001');
        expect(result.incidentId, 'incident_001');
        expect(result.fileName, 'test.mp4');
        verify(mockDio.get('/api/videos/$testVideoId')).called(1);
      });

      test('should throw NotFoundException when video not found', () async {
        // Arrange
        when(mockDio.get('/api/videos/$testVideoId')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/videos/$testVideoId'),
            response: Response(
              statusCode: 404,
              data: {'status': 'error', 'message': 'Video not found'},
              requestOptions: RequestOptions(path: '/api/videos/$testVideoId'),
            ),
          ),
        );

        // Act & Assert
        expect(
          () => repository.fetchVideoById(testVideoId),
          throwsA(isA<NotFoundException>()),
        );
      });

      test('should throw ServerException when server error occurs', () async {
        // Arrange
        when(mockDio.get('/api/videos/$testVideoId')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/videos/$testVideoId'),
            response: Response(
              statusCode: 500,
              data: {'status': 'error', 'message': 'Internal server error'},
              requestOptions: RequestOptions(path: '/api/videos/$testVideoId'),
            ),
          ),
        );

        // Act & Assert
        expect(
          () => repository.fetchVideoById(testVideoId),
          throwsA(isA<ServerException>()),
        );
      });

      test('should throw NetworkException when network error occurs', () async {
        // Arrange
        when(mockDio.get('/api/videos/$testVideoId')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/videos/$testVideoId'),
            type: DioExceptionType.connectionError,
            message: 'No internet connection',
          ),
        );

        // Act & Assert
        expect(
          () => repository.fetchVideoById(testVideoId),
          throwsA(isA<NetworkException>()),
        );
      });
    });

    group('fetchVideoByIncidentId', () {
      const testIncidentId = 'incident_001';
      final testResponseData = {
        'status': 'success',
        'data': {
          'id': 'video_001',
          'incident_id': 'incident_001',
          'file_name': 'test.mp4',
          'file_size': 1024000,
          'duration': 120,
          'recorded_at': '2025-10-31T10:00:00Z',
          'url': 'https://example.com/video_001',
          'thumbnail_url': 'https://example.com/thumb_001',
        },
      };

      test('should return Video when video exists for incident', () async {
        // Arrange
        when(mockDio.get('/api/incidents/$testIncidentId/video'))
            .thenAnswer((_) async => Response(
                  data: testResponseData,
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/api/incidents/$testIncidentId/video'),
                ));

        // Act
        final result = await repository.fetchVideoByIncidentId(testIncidentId);

        // Assert
        expect(result, isA<Video>());
        expect(result?.id, 'video_001');
        verify(mockDio.get('/api/incidents/$testIncidentId/video')).called(1);
      });

      test('should return null when video not found for incident', () async {
        // Arrange
        when(mockDio.get('/api/incidents/$testIncidentId/video')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/incidents/$testIncidentId/video'),
            response: Response(
              statusCode: 404,
              data: {'status': 'error', 'message': 'Video not found'},
              requestOptions: RequestOptions(path: '/api/incidents/$testIncidentId/video'),
            ),
          ),
        );

        // Act
        final result = await repository.fetchVideoByIncidentId(testIncidentId);

        // Assert
        expect(result, isNull);
      });
    });

    group('videoExists', () {
      const testVideoId = 'video_001';

      test('should return true when video exists', () async {
        // Arrange
        when(mockDio.head('/api/videos/$testVideoId'))
            .thenAnswer((_) async => Response(
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/api/videos/$testVideoId'),
                ));

        // Act
        final result = await repository.videoExists(testVideoId);

        // Assert
        expect(result, true);
        verify(mockDio.head('/api/videos/$testVideoId')).called(1);
      });

      test('should return false when video does not exist', () async {
        // Arrange
        when(mockDio.head('/api/videos/$testVideoId')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/videos/$testVideoId'),
            response: Response(
              statusCode: 404,
              requestOptions: RequestOptions(path: '/api/videos/$testVideoId'),
            ),
          ),
        );

        // Act
        final result = await repository.videoExists(testVideoId);

        // Assert
        expect(result, false);
      });
    });

    group('getStreamingUrl', () {
      const testVideoId = 'video_001';
      const testStreamingUrl = 'https://streaming.example.com/video_001';

      test('should return streaming URL when successful', () async {
        // Arrange
        when(mockDio.get('/api/videos/$testVideoId/streaming-url'))
            .thenAnswer((_) async => Response(
                  data: {
                    'status': 'success',
                    'data': {'streaming_url': testStreamingUrl},
                  },
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/api/videos/$testVideoId/streaming-url'),
                ));

        // Act
        final result = await repository.getStreamingUrl(testVideoId);

        // Assert
        expect(result, testStreamingUrl);
        verify(mockDio.get('/api/videos/$testVideoId/streaming-url')).called(1);
      });

      test('should throw NotFoundException when video not found', () async {
        // Arrange
        when(mockDio.get('/api/videos/$testVideoId/streaming-url')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/videos/$testVideoId/streaming-url'),
            response: Response(
              statusCode: 404,
              data: {'status': 'error', 'message': 'Video not found'},
              requestOptions: RequestOptions(path: '/api/videos/$testVideoId/streaming-url'),
            ),
          ),
        );

        // Act & Assert
        expect(
          () => repository.getStreamingUrl(testVideoId),
          throwsA(isA<NotFoundException>()),
        );
      });
    });
  });
}
