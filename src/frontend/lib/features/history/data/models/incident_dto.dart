import 'package:frontend/features/history/data/models/action_dto.dart';
import 'package:frontend/features/history/domain/entities/incident.dart';

/// インシデントのデータ転送オブジェクト (DTO)
/// 
/// APIレスポンスとドメインエンティティ間のマッピングを担当します。
class IncidentDTO {
  /// インシデントID
  final String id;

  /// 検知日時（API: detectedAt）
  final DateTime detectedAt;

  /// 異常検出動作（API: type）
  final String type;

  /// ステータス（API: status）
  final String status;

  /// 対象者ID（API: personId）
  final String? personId;

  /// カメラID（API: cameraId）
  final String? cameraId;

  /// 部屋ID（API: roomId）
  final String? roomId;

  /// 検知エリアID（API: detectionAreaId）
  final String? detectionAreaId;

  /// 説明（API: description）
  final String? description;

  /// 対応履歴リスト（API: actions）
  final List<ActionDTO> actions;

  /// 関連通知リスト（API: notifications）
  final List<dynamic>? notifications;

  /// 関連動画リスト（API: videos）
  final List<dynamic>? videos;

  const IncidentDTO({
    required this.id,
    required this.detectedAt,
    required this.type,
    required this.status,
    this.personId,
    this.cameraId,
    this.roomId,
    this.detectionAreaId,
    this.description,
    required this.actions,
    this.notifications,
    this.videos,
  });

  /// JSONからIncidentDTOを生成（API仕様書に基づく）
  factory IncidentDTO.fromJson(Map<String, dynamic> json) {
    final actionsList = json['actions'] as List<dynamic>? ?? [];
    final actions = actionsList
        .map((actionJson) => ActionDTO.fromJson(actionJson as Map<String, dynamic>))
        .toList();

    return IncidentDTO(
      id: json['id'] as String,
      detectedAt: DateTime.parse(json['detectedAt'] as String),
      type: json['type'] as String,
      status: json['status'] as String,
      personId: json['personId'] as String?,
      cameraId: json['cameraId'] as String?,
      roomId: json['roomId'] as String?,
      detectionAreaId: json['detectionAreaId'] as String?,
      description: json['description'] as String?,
      actions: actions,
      notifications: json['notifications'] as List<dynamic>?,
      videos: json['videos'] as List<dynamic>?,
    );
  }

  /// IncidentDTOをJSONに変換（API仕様書に基づく）
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'detectedAt': detectedAt.toIso8601String(),
      'type': type,
      'status': status,
      'personId': personId,
      'cameraId': cameraId,
      'roomId': roomId,
      'detectionAreaId': detectionAreaId,
      'description': description,
      'actions': actions.map((action) => action.toJson()).toList(),
      'notifications': notifications,
      'videos': videos,
    };
  }

  /// DTOをドメインエンティティ (Incident) に変換
  Incident toEntity() {
    // actionsから最新のものを取得して表示用データを構築
    String roomNumber = roomId ?? '';
    String bedNumber = '';
    String residentName = '';
    
    if (actions.isNotEmpty) {
      final latestAction = actions.first;
      roomNumber = latestAction.roomBedNameOrNumber ?? roomNumber;
      residentName = latestAction.personName ?? residentName;
    }

    // 動画IDの取得（最初の動画がある場合）
    String? videoId;
    if (videos != null && videos!.isNotEmpty) {
      final firstVideo = videos!.first as Map<String, dynamic>;
      videoId = firstVideo['id'] as String?;
    }

    return Incident(
      id: id,
      incidentId: id, // API仕様書にincidentIdフィールドがないため、idを使用
      detectedAt: detectedAt,
      roomNumber: roomNumber,
      bedNumber: bedNumber,
      residentName: residentName,
      detectionType: type,
      status: _stringToStatus(status),
      actions: actions.map((actionDto) => actionDto.toEntity()).toList(),
      videoId: videoId,
    );
  }

  /// ステータス文字列をIncidentStatus enumに変換（API仕様書の値に対応）
  static IncidentStatus _stringToStatus(String status) {
    switch (status) {
      case 'open':
        return IncidentStatus.detected;
      case 'monitoring':
        return IncidentStatus.inProgress;
      case 'resolved':
        return IncidentStatus.resolved;
      default:
        return IncidentStatus.detected; // デフォルト値
    }
  }
}
