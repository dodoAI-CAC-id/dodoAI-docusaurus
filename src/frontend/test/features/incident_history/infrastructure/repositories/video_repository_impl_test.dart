import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:mamoai/features/incident_history/infrastructure/repositories/video_repository_impl.dart';
import 'package:mamoai/features/incident_history/infrastructure/datasources/video_remote_datasource.dart';
import 'package:mamoai/core/error/failures.dart';

import 'video_repository_impl_test.mocks.dart';

@GenerateMocks([VideoRemoteDataSource])
void main() {
  late VideoRepositoryImpl repository;
  late MockVideoRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockVideoRemoteDataSource();
    repository = VideoRepositoryImpl(mockDataSource);
  });

  group('VideoRepositoryImpl', () {
    const tVideoId = 'video_001';
    const tVideoUrl = 'https://example.com/videos/video_001.mp4';

    test('should return video URL when getVideoUrl succeeds', () async {
      // Arrange
      when(mockDataSource.getVideoUrl(any))
          .thenAnswer((_) async => tVideoUrl);

      // Act
      final result = await repository.getVideoUrl(tVideoId);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (videoUrl) {
          expect(videoUrl, tVideoUrl);
        },
      );
      verify(mockDataSource.getVideoUrl(tVideoId));
    });

    test('should return ServerFailure when getVideoUrl throws exception', () async {
      // Arrange
      when(mockDataSource.getVideoUrl(any))
          .thenThrow(Exception('Video not found'));

      // Act
      final result = await repository.getVideoUrl(tVideoId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should not return success'),
      );
    });

    test('should pass videoId to datasource', () async {
      // Arrange
      when(mockDataSource.getVideoUrl(any))
          .thenAnswer((_) async => tVideoUrl);

      // Act
      await repository.getVideoUrl(tVideoId);

      // Assert
      verify(mockDataSource.getVideoUrl(tVideoId)).called(1);
    });
  });
}
