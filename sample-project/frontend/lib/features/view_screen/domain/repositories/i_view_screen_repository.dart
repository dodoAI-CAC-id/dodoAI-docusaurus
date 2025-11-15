import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/incident_item.dart';
import '../entities/incident_status.dart';

/// ビュー画面用のRepositoryインターフェース
abstract class IViewScreenRepository {
  /// 全てのインシデントアイテムを取得
  /// 
  /// Returns:
  /// - Right: インシデントアイテムのリスト
  /// - Left: エラー情報
  Future<Either<Failure, List<IncidentItem>>> getIncidentItems();

  /// 特定のインシデントアイテムを取得
  /// 
  /// Parameters:
  /// - [id]: インシデントID
  /// 
  /// Returns:
  /// - Right: インシデントアイテム
  /// - Left: エラー情報
  Future<Either<Failure, IncidentItem>> getIncidentItemById(String id);

  /// インシデントのステータスを更新
  /// 
  /// Parameters:
  /// - [id]: インシデントID
  /// - [newStatus]: 新しいステータス
  /// - [actionType]: アクションタイプ（対応/完了/訪室不要/誤検知等）
  /// 
  /// Returns:
  /// - Right: 更新後のインシデントアイテム
  /// - Left: エラー情報
  Future<Either<Failure, IncidentItem>> updateIncidentStatus({
    required String id,
    required IncidentStatus newStatus,
    required String actionType,
  });

  /// アラートの稼働状態を切り替え
  /// 
  /// Parameters:
  /// - [id]: インシデントID
  /// - [isActive]: アラート稼働状態（true: 稼働中, false: 停止中）
  /// 
  /// Returns:
  /// - Right: 更新後のインシデントアイテム
  /// - Left: エラー情報
  Future<Either<Failure, IncidentItem>> toggleAlertStatus({
    required String id,
    required bool isActive,
  });
}
