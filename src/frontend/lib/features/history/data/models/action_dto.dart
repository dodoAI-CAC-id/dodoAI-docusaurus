import 'package:frontend/features/history/domain/entities/action.dart';

/// 対応履歴のデータ転送オブジェクト (DTO)
/// 
/// APIレスポンスとドメインエンティティ間のマッピングを担当します。
class ActionDTO {
  /// アクションID
  final String id;

  /// 関連するインシデントID
  final String incidentId;

  /// 対応実施日時
  final DateTime performedAt;

  /// 対応実施者
  final String performedBy;

  /// 対応種別
  final String actionType;

  /// 備考・メモ（オプション）
  final String? notes;

  const ActionDTO({
    required this.id,
    required this.incidentId,
    required this.performedAt,
    required this.performedBy,
    required this.actionType,
    this.notes,
  });

  /// JSONからActionDTOを生成
  factory ActionDTO.fromJson(Map<String, dynamic> json) {
    return ActionDTO(
      id: json['id'] as String,
      incidentId: json['incident_id'] as String,
      performedAt: DateTime.parse(json['performed_at'] as String),
      performedBy: json['performed_by'] as String,
      actionType: json['action_type'] as String,
      notes: json['notes'] as String?,
    );
  }

  /// ActionDTOをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'incident_id': incidentId,
      'performed_at': performedAt.toIso8601String(),
      'performed_by': performedBy,
      'action_type': actionType,
      'notes': notes,
    };
  }

  /// DTOをドメインエンティティ (Action) に変換
  Action toEntity() {
    return Action(
      id: id,
      incidentId: incidentId,
      performedAt: performedAt,
      performedBy: performedBy,
      actionType: actionType,
      notes: notes,
    );
  }
}
