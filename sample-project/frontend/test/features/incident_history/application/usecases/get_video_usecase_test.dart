import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:mamoai/features/incident_history/domain/repositories/i_video_repository.dart';
import 'package:mamoai/features/incident_history/application/usecases/get_video_usecase.dart';
import 'package:mamoai/core/error/failures.dart';

import 'get_video_usecase_test.mocks.dart';

@GenerateMocks([IVideoRepository])
void main() {
  late GetVideoUseCase useCase;
  late MockIVideoRepository mockRepository;

  setUp(() {
    mockRepository = MockIVideoRepository();
    useCase = GetVideoUseCase(mockRepository);
  });

  group('GetVideoUseCase', () {
    const tVideoId = 'video_001';
    const tVideoUrl = 'https://example.com/videos/video_001.mp4';

    test('should get video URL from the repository', () async {
      // Arrange
      when(mockRepository.getVideoUrl(any))
          .thenAnswer((_) async => const Right(tVideoUrl));

      // Act
      final result = await useCase(const GetVideoParams(videoId: tVideoId));

      // Assert
      expect(result, const Right(tVideoUrl));
      verify(mockRepository.getVideoUrl(tVideoId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      const tFailure = ServerFailure('Video not found');
      when(mockRepository.getVideoUrl(any))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(const GetVideoParams(videoId: tVideoId));

      // Assert
      expect(result, const Left(tFailure));
      verify(mockRepository.getVideoUrl(tVideoId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when network error occurs', () async {
      // Arrange
      const tFailure = NetworkFailure('Network error');
      when(mockRepository.getVideoUrl(any))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(const GetVideoParams(videoId: tVideoId));

      // Assert
      expect(result, const Left(tFailure));
    });

    test('should handle empty video ID', () async {
      // Arrange
      const tFailure = ValidationFailure('Video ID is required');
      when(mockRepository.getVideoUrl(any))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(const GetVideoParams(videoId: ''));

      // Assert
      expect(result, const Left(tFailure));
    });
  });
}
