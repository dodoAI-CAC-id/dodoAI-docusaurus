import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/incident_item.dart';
import '../../domain/entities/incident_status.dart';
import '../../domain/repositories/i_view_screen_repository.dart';
import '../datasources/mock_incident_datasource.dart';

/// ビュー画面用のMock Repository実装
class MockViewScreenRepository implements IViewScreenRepository {
  final MockIncidentDataSource dataSource;

  MockViewScreenRepository(this.dataSource);

  @override
  Future<Either<Failure, List<IncidentItem>>> getIncidentItems() async {
    try {
      final items = await dataSource.getIncidentItems();
      return Right(items);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, IncidentItem>> getIncidentItemById(String id) async {
    try {
      final item = await dataSource.getIncidentItemById(id);
      if (item == null) {
        return Left(NotFoundFailure('Incident not found: $id'));
      }
      return Right(item);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, IncidentItem>> updateIncidentStatus({
    required String id,
    required IncidentStatus newStatus,
    required String actionType,
  }) async {
    try {
      final updatedItem = await dataSource.updateIncidentStatus(
        id: id,
        newStatus: newStatus,
        actionType: actionType,
      );
      return Right(updatedItem);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, IncidentItem>> toggleAlertStatus({
    required String id,
    required bool isActive,
  }) async {
    try {
      final updatedItem = await dataSource.toggleAlertStatus(
        id: id,
        isActive: isActive,
      );
      return Right(updatedItem);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
