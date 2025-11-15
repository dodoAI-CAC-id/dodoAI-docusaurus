import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/incident_item.dart';
import '../../domain/entities/incident_status.dart';
import '../../domain/repositories/i_view_screen_repository.dart';

/// インシデントのステータスを更新するUseCase
class UpdateIncidentStatusUseCase {
  final IViewScreenRepository repository;

  UpdateIncidentStatusUseCase(this.repository);

  /// インシデントのステータスを更新
  /// 
  /// Parameters:
  /// - [params]: 更新パラメータ
  /// 
  /// Returns:
  /// - Right: 更新後のインシデントアイテム
  /// - Left: エラー情報
  Future<Either<Failure, IncidentItem>> call(UpdateStatusParams params) async {
    return await repository.updateIncidentStatus(
      id: params.id,
      newStatus: params.newStatus,
      actionType: params.actionType,
    );
  }
}

/// ステータス更新パラメータ
class UpdateStatusParams {
  final String id;
  final IncidentStatus newStatus;
  final String actionType;

  UpdateStatusParams({
    required this.id,
    required this.newStatus,
    required this.actionType,
  });
}
