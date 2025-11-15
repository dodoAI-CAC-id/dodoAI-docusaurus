import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamoai/features/view_screen/domain/entities/incident_item.dart';
import 'package:mamoai/features/view_screen/domain/entities/incident_status.dart';
import 'package:mamoai/features/view_screen/infrastructure/datasources/mock_incident_datasource.dart';
import 'package:mamoai/features/view_screen/infrastructure/repositories/mock_view_screen_repository.dart';

void main() {
  late MockViewScreenRepository repository;
  late MockIncidentDataSource dataSource;

  setUp(() {
    dataSource = MockIncidentDataSource();
    repository = MockViewScreenRepository(dataSource);
  });

  group('MockViewScreenRepository', () {
    test('getIncidentItems は DataSource からアイテムを取得できる', () async {
      // Act
      final result = await repository.getIncidentItems();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (items) {
          expect(items, isA<List<IncidentItem>>());
          expect(items.length, 6); // モックデータは6件
        },
      );
    });

    test('getIncidentItemById は 存在するIDで正しいアイテムを取得できる', () async {
      // Arrange
      const testId = '1';

      // Act
      final result = await repository.getIncidentItemById(testId);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (item) {
          expect(item.id, testId);
          expect(item.roomBedNumber, '101-A');
          expect(item.personName, '山田 太郎');
        },
      );
    });

    test('getIncidentItemById は 存在しないIDでNotFoundFailureを返す', () async {
      // Arrange
      const testId = 'non-existent-id';

      // Act
      final result = await repository.getIncidentItemById(testId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure.message, contains('not found'));
        },
        (item) => fail('Should return Left'),
      );
    });

    test('updateIncidentStatus は ステータスを正しく更新できる', () async {
      // Arrange
      const testId = '1';
      const newStatus = IncidentStatus.inProgress;
      const actionType = 'start';

      // Act
      final result = await repository.updateIncidentStatus(
        id: testId,
        newStatus: newStatus,
        actionType: actionType,
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (item) {
          expect(item.id, testId);
          expect(item.status, newStatus);
        },
      );

      // 更新後の確認
      final getResult = await repository.getIncidentItemById(testId);
      getResult.fold(
        (failure) => fail('Should return Right'),
        (item) {
          expect(item.status, newStatus);
        },
      );
    });

    test('updateIncidentStatus は 存在しないIDでエラーを返す', () async {
      // Arrange
      const testId = 'non-existent-id';
      const newStatus = IncidentStatus.inProgress;
      const actionType = 'start';

      // Act
      final result = await repository.updateIncidentStatus(
        id: testId,
        newStatus: newStatus,
        actionType: actionType,
      );

      // Assert
      expect(result.isLeft(), true);
    });

    test('toggleAlertStatus は アラート状態を正しく切り替えられる', () async {
      // Arrange
      const testId = '1';
      const newAlertStatus = false;

      // Act
      final result = await repository.toggleAlertStatus(
        id: testId,
        isActive: newAlertStatus,
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (item) {
          expect(item.id, testId);
          expect(item.isAlertActive, newAlertStatus);
        },
      );

      // 更新後の確認
      final getResult = await repository.getIncidentItemById(testId);
      getResult.fold(
        (failure) => fail('Should return Right'),
        (item) {
          expect(item.isAlertActive, newAlertStatus);
        },
      );
    });

    test('toggleAlertStatus は 存在しないIDでエラーを返す', () async {
      // Arrange
      const testId = 'non-existent-id';
      const newAlertStatus = false;

      // Act
      final result = await repository.toggleAlertStatus(
        id: testId,
        isActive: newAlertStatus,
      );

      // Assert
      expect(result.isLeft(), true);
    });

    test('複数回の更新が正しく反映される', () async {
      // Arrange
      const testId = '1';

      // Act & Assert - 1回目の更新
      final result1 = await repository.updateIncidentStatus(
        id: testId,
        newStatus: IncidentStatus.inProgress,
        actionType: 'start',
      );
      expect(result1.isRight(), true);

      // Act & Assert - 2回目の更新
      final result2 = await repository.updateIncidentStatus(
        id: testId,
        newStatus: IncidentStatus.noDetection,
        actionType: 'complete',
      );
      expect(result2.isRight(), true);

      // 最終状態の確認
      final getResult = await repository.getIncidentItemById(testId);
      getResult.fold(
        (failure) => fail('Should return Right'),
        (item) {
          expect(item.status, IncidentStatus.noDetection);
        },
      );
    });
  });
}
