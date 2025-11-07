import 'package:equatable/equatable.dart';
import 'package:frontend/features/history/domain/entities/action.dart';

/// インシデントステータス
enum IncidentStatus {
  /// 検知済み
  detected,

  /// 確認済み
  confirmed,

  /// 対応中
  inProgress,

  /// 解決済み
  resolved,
}

/// インシデントエンティティ
/// 
/// 異常検知インシデントを表現するドメインエンティティ
class Incident extends Equatable {
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

  /// 異常検出動作（転倒検知、離床検知など）
  final String detectionType;

  /// ステータス
  final IncidentStatus status;

  /// 対応履歴リスト
  final List<Action> actions;

  /// 関連動画ID（オプション）
  final String? videoId;

  const Incident({
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

  /// コピーして新しいインスタンスを作成
  Incident copyWith({
    String? id,
    String? incidentId,
    DateTime? detectedAt,
    String? roomNumber,
    String? bedNumber,
    String? residentName,
    String? detectionType,
    IncidentStatus? status,
    List<Action>? actions,
    String? videoId,
  }) {
    return Incident(
      id: id ?? this.id,
      incidentId: incidentId ?? this.incidentId,
      detectedAt: detectedAt ?? this.detectedAt,
      roomNumber: roomNumber ?? this.roomNumber,
      bedNumber: bedNumber ?? this.bedNumber,
      residentName: residentName ?? this.residentName,
      detectionType: detectionType ?? this.detectionType,
      status: status ?? this.status,
      actions: actions ?? this.actions,
      videoId: videoId ?? this.videoId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        incidentId,
        detectedAt,
        roomNumber,
        bedNumber,
        residentName,
        detectionType,
        status,
        actions,
        videoId,
      ];

  @override
  bool get stringify => true;
}
