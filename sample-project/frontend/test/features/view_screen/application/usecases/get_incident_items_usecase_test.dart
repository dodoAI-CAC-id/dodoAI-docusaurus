import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mamoai/core/error/failures.dart';
import 'package:mamoai/features/view_screen/application/usecases/get_incident_items_usecase.dart';
import 'package:mamoai/features/view_screen/domain/entities/incident_item.dart';
import 'package:mamoai/features/view_screen/domain/entities/incident_status.dart';
import 'package:mamoai/features/view_screen/domain/repositories/i_view_screen_repository.dart';

@GenerateMocks([IViewScreenRepository])
import 'get_incident_items_usecase_test.mocks.dart';

void main() {
  late GetIncidentItemsUseCase useCase;
  late MockIViewScreenRepository mockRepository;

  setUp(() {
    mockRepository = MockIViewScreenRepository();
    useCase = GetIncidentItemsUseCase(mockRepository);
  });

  group('GetIncidentItemsUseCase', () {
    final tIncidentItems = [
      const IncidentItem(
        id: '1',
        roomBedNumber: '101-A',
        personName: '山田 太郎',
        detectionType: '起床',
        status: IncidentStatus.unhandled,
      ),
      const IncidentItem(
        id: '2',
        roomBedNumber: '102-B',
        personName: '佐藤 花子',
        detectionType: '離床',
        status: IncidentStatus.inProgress,
      ),
      const IncidentItem(
        id: '3',
        roomBedNumber: '103-A',
        personName: '鈴木 一郎',
        detectionType: '臥床',
        status: IncidentStatus.noDetection,
      ),
    ];

    test('リポジトリからインシデントアイテムのリストを取得できる', () async {
      // Arrange
      when(mockRepository.getIncidentItems())
          .thenAnswer((_) async => Right(tIncidentItems));

      // Act
      final result = await useCase();

      // Assert
      expect(result, Right(tIncidentItems));
      verify(mockRepository.getIncidentItems()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('リポジトリがエラーを返した場合、Failureを返す', () async {
      // Arrange
      final tFailure = ServerFailure('Server Error');
      when(mockRepository.getIncidentItems())
          .thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, Left(tFailure));
      verify(mockRepository.getIncidentItems()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('空のリストを正しく処理できる', () async {
      // Arrange
      when(mockRepository.getIncidentItems())
          .thenAnswer((_) async => const Right([]));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (items) => expect(items, isEmpty),
      );
      verify(mockRepository.getIncidentItems()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('リポジトリが例外をスローした場合、適切に処理される', () async {
      // Arrange
      when(mockRepository.getIncidentItems())
          .thenThrow(Exception('Unexpected error'));

      // Act & Assert
      expect(
        () => useCase(),
        throwsA(isA<Exception>()),
      );
      verify(mockRepository.getIncidentItems()).called(1);
    });
  });
}
