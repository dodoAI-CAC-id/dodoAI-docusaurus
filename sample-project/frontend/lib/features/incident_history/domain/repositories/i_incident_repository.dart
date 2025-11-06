import 'package:dartz/dartz.dart';
import 'package:mamoai/core/error/failures.dart';
import 'package:mamoai/features/incident_history/domain/entities/incident.dart';
import 'package:mamoai/features/incident_history/domain/entities/search_criteria.dart';
import 'package:mamoai/features/incident_history/domain/entities/pagination_info.dart';

/// 異常イベント一覧取得結果
class IncidentListResult {
  final List<Incident> incidents;
  final PaginationInfo paginationInfo;

  const IncidentListResult({
    required this.incidents,
    required this.paginationInfo,
  });
}

/// 異常イベントリポジトリインターフェース
abstract class IIncidentRepository {
  /// 異常イベント一覧を取得
  ///
  /// [criteria] 検索条件（オプション）
  /// 戻り値: Either<Failure, IncidentListResult>
  Future<Either<Failure, IncidentListResult>> getIncidents({
    SearchCriteria? criteria,
  });

  /// 異常イベント詳細を取得
  ///
  /// [id] 異常イベントID
  /// 戻り値: Either<Failure, Incident>
  Future<Either<Failure, Incident>> getIncidentById(String id);
}
