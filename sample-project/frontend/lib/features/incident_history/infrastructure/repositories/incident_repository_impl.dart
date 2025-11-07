import 'package:dartz/dartz.dart';
import 'package:mamoai/core/error/failures.dart';
import 'package:mamoai/features/incident_history/domain/entities/incident.dart';
import 'package:mamoai/features/incident_history/domain/entities/search_criteria.dart';
import 'package:mamoai/features/incident_history/domain/entities/pagination_info.dart';
import 'package:mamoai/features/incident_history/domain/repositories/i_incident_repository.dart';
import 'package:mamoai/features/incident_history/infrastructure/datasources/incident_remote_datasource.dart';

/// 異常イベントリポジトリ実装
class IncidentRepositoryImpl implements IIncidentRepository {
  final IncidentRemoteDataSource remoteDataSource;

  IncidentRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, IncidentListResult>> getIncidents({
    SearchCriteria? criteria,
  }) async {
    try {
      final incidentsJson = await remoteDataSource.getIncidents(
        criteria: criteria,
      );

      final incidents = incidentsJson
          .map((json) => Incident.fromJson(json))
          .toList();

      // ページネーション情報を作成
      // 実際のAPIレスポンスに応じて調整が必要
      final paginationInfo = PaginationInfo.fromTotalCount(
        totalCount: incidents.length,
        limit: criteria?.limit ?? 20,
        currentPage: criteria?.page ?? 1,
      );

      return Right(IncidentListResult(
        incidents: incidents,
        paginationInfo: paginationInfo,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Incident>> getIncidentById(String incidentId) async {
    try {
      final incidentJson = await remoteDataSource.getIncidentById(incidentId);
      final incident = Incident.fromJson(incidentJson);
      return Right(incident);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
