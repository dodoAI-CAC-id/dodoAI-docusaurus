import 'package:frontend/features/history/domain/entities/action.dart';

/// 対応履歴のデータ転送オブジェクト (DTO)
/// 
/// APIレスポンスとドメインエンティティ間のマッピングを担当します。
class ActionDTO {
  /// アクションID（API: id）
  final String id;

  /// 関連するインシデントID（API: incidentId）
  final String incidentId;

  /// スタッフID（API: staffId）
  final String staffId;

  /// 対応種別（API: actionType）
  final String actionType;

  /// 進捗状態（API: progress）
  final String? progress;

  /// 開始時刻（API: startAt）
  final DateTime? startAt;

  /// 終了時刻（API: endAt）
  final DateTime? endAt;

  /// 作成日時（API: createdAt）
  final DateTime createdAt;

  /// 備考・メモ（API: note）
  final String? note;

  /// 部屋/ベッド名または番号（API拡張フィールド: roomBedNameOrNumber）
  final String? roomBedNameOrNumber;

  /// 見守り対象者名（API拡張フィールド: personName）
  final String? personName;

  /// 異常検出動作（API拡張フィールド: incidentDetectionType）
  final String? incidentDetectionType;

  const ActionDTO({
    required this.id,
    required this.incidentId,
    required this.staffId,
    required this.actionType,
    this.progress,
    this.startAt,
    this.endAt,
    required this.createdAt,
    this.note,
    this.roomBedNameOrNumber,
    this.personName,
    this.incidentDetectionType,
  });

  /// JSONからActionDTOを生成（API仕様書に基づく）
  factory ActionDTO.fromJson(Map<String, dynamic> json) {
    return ActionDTO(
      id: json['id'] as String,
      incidentId: json['incidentId'] as String,
      staffId: json['staffId'] as String,
      actionType: json['actionType'] as String,
      progress: json['progress'] as String?,
      startAt: json['startAt'] != null ? DateTime.parse(json['startAt'] as String) : null,
      endAt: json['endAt'] != null ? DateTime.parse(json['endAt'] as String) : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      note: json['note'] as String?,
      roomBedNameOrNumber: json['roomBedNameOrNumber'] as String?,
      personName: json['personName'] as String?,
      incidentDetectionType: json['incidentDetectionType'] as String?,
    );
  }

  /// ActionDTOをJSONに変換（API仕様書に基づく）
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'incidentId': incidentId,
      'staffId': staffId,
      'actionType': actionType,
      'progress': progress,
      'startAt': startAt?.toIso8601String(),
      'endAt': endAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'note': note,
      'roomBedNameOrNumber': roomBedNameOrNumber,
      'personName': personName,
      'incidentDetectionType': incidentDetectionType,
    };
  }

  /// DTOをドメインエンティティ (Action) に変換
  Action toEntity() {
    return Action(
      id: id,
      incidentId: incidentId,
      performedAt: startAt ?? createdAt,
      performedBy: staffId,
      actionType: actionType,
      notes: note,
    );
  }
}
