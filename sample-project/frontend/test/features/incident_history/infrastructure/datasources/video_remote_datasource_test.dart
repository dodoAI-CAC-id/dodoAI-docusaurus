import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:mamoai/features/incident_history/infrastructure/datasources/video_remote_datasource.dart';

import 'video_remote_datasource_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late VideoRemoteDataSource dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = VideoRemoteDataSource(mockDio);
  });

  group('VideoRemoteDataSource', () {
    const tVideoId = 'video_001';
    const tVideoUrl = 'https://example.com/videos/video_001.mp4';

    test('should perform GET request to /api/v2/videos/{videoId}/file', () async {
      // Arrange
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: {'fileUrl': tVideoUrl},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/api/v2/videos/$tVideoId/file'),
          ));

      // Act
      await dataSource.getVideoUrl(tVideoId);

      // Assert
      verify(mockDio.get('/api/v2/videos/$tVideoId/file'));
    });

    test('should return video URL when response is successful', () async {
      // Arrange
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: {'fileUrl': tVideoUrl},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/api/v2/videos/$tVideoId/file'),
          ));

      // Act
      final result = await dataSource.getVideoUrl(tVideoId);

      // Assert
      expect(result, tVideoUrl);
    });

    test('should throw exception when response status is not 200', () async {
      // Arrange
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: {'error': 'Video not found'},
            statusCode: 404,
            requestOptions: RequestOptions(path: '/api/v2/videos/$tVideoId/file'),
          ));

      // Act & Assert
      expect(
        () => dataSource.getVideoUrl(tVideoId),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle network errors', () async {
      // Arrange
      when(mockDio.get(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/v2/videos/$tVideoId/file'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.getVideoUrl(tVideoId),
        throwsA(isA<DioException>()),
      );
    });
  });
}
