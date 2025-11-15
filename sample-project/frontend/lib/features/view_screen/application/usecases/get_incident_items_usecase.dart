import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/incident_item.dart';
import '../../domain/repositories/i_view_screen_repository.dart';

/// インシデントアイテム一覧を取得するUseCase
class GetIncidentItemsUseCase {
  final IViewScreenRepository repository;

  GetIncidentItemsUseCase(this.repository);

  /// インシデントアイテム一覧を取得
  /// 
  /// Returns:
  /// - Right: インシデントアイテムのリスト
  /// - Left: エラー情報
  Future<Either<Failure, List<IncidentItem>>> call() async {
    return await repository.getIncidentItems();
  }
}
