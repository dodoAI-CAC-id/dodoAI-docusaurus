import 'package:equatable/equatable.dart';

/// 異常イベントエンティティ
class Incident extends Equatable {
  /// 異常イベントID
  final String id;

  /// 検知日時
  final DateTime detectedAt;

  /// 異常タイプ（転倒、徘徊など）
  final String type;

  /// 見守り対象者ID
  final String personId;

  /// 見守り対象者名
  final String personName;

  /// 部屋番号
  final String roomNumber;

  /// ステータス（open, resolved, monitoring）
  final String status;

  /// 動画ID
  final String? videoId;

  /// 作成日時
  final DateTime createdAt;

  /// 更新日時
  final DateTime updatedAt;

  /// 対応担当者（オプション）
  final String? assignedTo;

  /// 対応開始時刻（オプション）
  final DateTime? responseStartedAt;

  /// 対応終了時刻（オプション）
  final DateTime? responseCompletedAt;

  /// エピソード記録（オプション）
  final String? episodeNote;

  /// 履歴番号（表示用）
  final int? historyNumber;

  /// 操作タイプ（対応、完了、訪室不要、対応不要、誤検知）
  final String? actionType;

  const Incident({
    required this.id,
    required this.detectedAt,
    required this.type,
    required this.personId,
    required this.personName,
    required this.roomNumber,
    required this.status,
    this.videoId,
    required this.createdAt,
    required this.updatedAt,
    this.assignedTo,
    this.responseStartedAt,
    this.responseCompletedAt,
    this.episodeNote,
    this.historyNumber,
    this.actionType,
  });

  /// JSONからIncidentを生成
  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      id: json['id'] as String,
      detectedAt: DateTime.parse(json['detectedAt'] as String),
      type: json['type'] as String,
      personId: json['personId'] as String,
      personName: json['personName'] as String,
      roomNumber: json['roomNumber'] as String,
      status: json['status'] as String,
      videoId: json['videoId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      assignedTo: json['assignedTo'] as String?,
      responseStartedAt: json['responseStartedAt'] != null
          ? DateTime.parse(json['responseStartedAt'] as String)
          : null,
      responseCompletedAt: json['responseCompletedAt'] != null
          ? DateTime.parse(json['responseCompletedAt'] as String)
          : null,
      episodeNote: json['episodeNote'] as String?,
    );
  }

  /// IncidentをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'detectedAt': detectedAt.toIso8601String(),
      'type': type,
      'personId': personId,
      'personName': personName,
      'roomNumber': roomNumber,
      'status': status,
      'videoId': videoId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'assignedTo': assignedTo,
      'responseStartedAt': responseStartedAt?.toIso8601String(),
      'responseCompletedAt': responseCompletedAt?.toIso8601String(),
      'episodeNote': episodeNote,
    };
  }

  @override
  List<Object?> get props => [
        id,
        detectedAt,
        type,
        personId,
        personName,
        roomNumber,
        status,
        videoId,
        createdAt,
        updatedAt,
        assignedTo,
        responseStartedAt,
        responseCompletedAt,
        episodeNote,
        historyNumber,
        actionType,
      ];
}
