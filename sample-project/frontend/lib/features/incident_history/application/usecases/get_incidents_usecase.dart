import 'package:dartz/dartz.dart';
import 'package:mamoai/core/error/failures.dart';
import 'package:mamoai/features/incident_history/domain/entities/search_criteria.dart';
import 'package:mamoai/features/incident_history/domain/repositories/i_incident_repository.dart';

/// GetIncidentsUseCaseのパラメータ
class GetIncidentsParams {
  final SearchCriteria? criteria;

  const GetIncidentsParams({this.criteria});
}

/// 異常イベント一覧取得UseCase
class GetIncidentsUseCase {
  final IIncidentRepository repository;

  GetIncidentsUseCase(this.repository);

  /// 異常イベント一覧を取得
  ///
  /// [params] 検索パラメータ
  /// 戻り値: Either<Failure, IncidentListResult>
  Future<Either<Failure, IncidentListResult>> call(
    GetIncidentsParams params,
  ) async {
    return await repository.getIncidents(criteria: params.criteria);
  }
}
