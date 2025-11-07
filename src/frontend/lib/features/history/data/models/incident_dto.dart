import 'package:frontend/features/history/data/models/action_dto.dart';
import 'package:frontend/features/history/domain/entities/incident.dart';

/// インシデントのデータ転送オブジェクト (DTO)
/// 
/// APIレスポンスとドメインエンティティ間のマッピングを担当します。
class IncidentDTO {
  /// インシデントID
  final String id;

  /// インシデント番号（表示用）
  final String incidentId;

  /// 検知日時
  final DateTime detectedAt;

  /// 部屋番号
  final String roomNumber;

  /// ベッド番号
  final String bedNumber;

  /// 見守り対象者名
  final String residentName;

  /// 異常検出動作
  final String detectionType;

  /// ステータス
  final String status;

  /// 対応履歴リスト
  final List<ActionDTO> actions;

  /// 関連動画ID（オプション）
  final String? videoId;

  const IncidentDTO({
    required this.id,
    required this.incidentId,
    required this.detectedAt,
    required this.roomNumber,
    required this.bedNumber,
    required this.residentName,
    required this.detectionType,
    required this.status,
    required this.actions,
    this.videoId,
  });

  /// JSONからIncidentDTOを生成
  factory IncidentDTO.fromJson(Map<String, dynamic> json) {
    final actionsList = json['actions'] as List<dynamic>? ?? [];
    final actions = actionsList
        .map((actionJson) => ActionDTO.fromJson(actionJson as Map<String, dynamic>))
        .toList();

    return IncidentDTO(
      id: json['id'] as String,
      incidentId: json['incident_id'] as String,
      detectedAt: DateTime.parse(json['detected_at'] as String),
      roomNumber: json['room_number'] as String,
      bedNumber: json['bed_number'] as String,
      residentName: json['resident_name'] as String,
      detectionType: json['detection_type'] as String,
      status: json['status'] as String,
      actions: actions,
      videoId: json['video_id'] as String?,
    );
  }

  /// IncidentDTOをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'incident_id': incidentId,
      'detected_at': detectedAt.toIso8601String(),
      'room_number': roomNumber,
      'bed_number': bedNumber,
      'resident_name': residentName,
      'detection_type': detectionType,
      'status': status,
      'actions': actions.map((action) => action.toJson()).toList(),
      'video_id': videoId,
    };
  }

  /// DTOをドメインエンティティ (Incident) に変換
  Incident toEntity() {
    return Incident(
      id: id,
      incidentId: incidentId,
      detectedAt: detectedAt,
      roomNumber: roomNumber,
      bedNumber: bedNumber,
      residentName: residentName,
      detectionType: detectionType,
      status: _stringToStatus(status),
      actions: actions.map((actionDto) => actionDto.toEntity()).toList(),
      videoId: videoId,
    );
  }

  /// ステータス文字列をIncidentStatus enumに変換
  static IncidentStatus _stringToStatus(String status) {
    switch (status) {
      case 'detected':
        return IncidentStatus.detected;
      case 'confirmed':
        return IncidentStatus.confirmed;
      case 'in_progress':
        return IncidentStatus.inProgress;
      case 'resolved':
        return IncidentStatus.resolved;
      default:
        return IncidentStatus.detected; // デフォルト値
    }
  }
}
