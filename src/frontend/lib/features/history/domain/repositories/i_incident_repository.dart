import 'package:frontend/features/history/domain/entities/incident.dart';

/// インシデントリポジトリインターフェース
/// 
/// インシデント（異常検知履歴）のデータアクセスを抽象化するインターフェース
/// Infrastructure層で実装される
abstract class IIncidentRepository {
  /// インシデント一覧を取得
  /// 
  /// [limit] 取得件数（デフォルト: 20）
  /// [offset] オフセット（デフォルト: 0）
  /// [orderBy] ソート順（デフォルト: detectedAt）
  /// [descending] 降順フラグ（デフォルト: true）
  /// 
  /// Returns インシデントのリスト
  /// Throws リポジトリ例外（ネットワークエラー、認証エラーなど）
  Future<List<Incident>> fetchIncidents({
    int limit = 20,
    int offset = 0,
    String orderBy = 'detectedAt',
    bool descending = true,
  });

  /// インシデントをIDで取得
  /// 
  /// [id] インシデントID
  /// 
  /// Returns インシデント
  /// Throws リポジトリ例外（見つからない、ネットワークエラーなど）
  Future<Incident> fetchIncidentById(String id);

  /// インシデントを検索
  /// 
  /// [startDate] 検索開始日
  /// [endDate] 検索終了日
  /// [roomNumber] 部屋番号
  /// [bedNumber] ベッド番号
  /// [residentName] 見守り対象者名
  /// [performedBy] 担当者
  /// [detectionType] 異常検出動作
  /// [status] ステータス
  /// [limit] 取得件数
  /// [offset] オフセット
  /// 
  /// Returns 検索結果のインシデントリスト
  /// Throws リポジトリ例外（ネットワークエラーなど）
  Future<List<Incident>> searchIncidents({
    DateTime? startDate,
    DateTime? endDate,
    String? roomNumber,
    String? bedNumber,
    String? residentName,
    String? performedBy,
    String? detectionType,
    IncidentStatus? status,
    int limit = 20,
    int offset = 0,
  });

  /// インシデントの総件数を取得
  /// 
  /// Returns 総件数
  /// Throws リポジトリ例外（ネットワークエラーなど）
  Future<int> countIncidents();

  /// 検索条件に一致するインシデントの総件数を取得
  /// 
  /// [startDate] 検索開始日
  /// [endDate] 検索終了日
  /// [roomNumber] 部屋番号
  /// [bedNumber] ベッド番号
  /// [residentName] 見守り対象者名
  /// [performedBy] 担当者
  /// [detectionType] 異常検出動作
  /// [status] ステータス
  /// 
  /// Returns 検索結果の総件数
  /// Throws リポジトリ例外（ネットワークエラーなど）
  Future<int> countSearchResults({
    DateTime? startDate,
    DateTime? endDate,
    String? roomNumber,
    String? bedNumber,
    String? residentName,
    String? performedBy,
    String? detectionType,
    IncidentStatus? status,
  });
}
