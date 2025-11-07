import 'package:frontend/features/history/domain/entities/video.dart';

/// 動画のデータ転送オブジェクト (DTO)
/// 
/// APIレスポンスとドメインエンティティ間のマッピングを担当します。
class VideoDTO {
  /// 動画ID
  final String id;

  /// 関連するインシデントID
  final String incidentId;

  /// ファイル名
  final String fileName;

  /// ファイルサイズ（バイト）
  final int fileSize;

  /// 動画の長さ（秒）
  final int duration;

  /// 録画日時
  final DateTime recordedAt;

  /// 動画URL
  final String url;

  /// サムネイルURL（オプション）
  final String? thumbnailUrl;

  const VideoDTO({
    required this.id,
    required this.incidentId,
    required this.fileName,
    required this.fileSize,
    required this.duration,
    required this.recordedAt,
    required this.url,
    this.thumbnailUrl,
  });

  /// JSONからVideoDTOを生成
  factory VideoDTO.fromJson(Map<String, dynamic> json) {
    return VideoDTO(
      id: json['id'] as String,
      incidentId: json['incident_id'] as String,
      fileName: json['file_name'] as String,
      fileSize: json['file_size'] as int,
      duration: json['duration'] as int,
      recordedAt: DateTime.parse(json['recorded_at'] as String),
      url: json['url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
    );
  }

  /// VideoDTOをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'incident_id': incidentId,
      'file_name': fileName,
      'file_size': fileSize,
      'duration': duration,
      'recorded_at': recordedAt.toIso8601String(),
      'url': url,
      'thumbnail_url': thumbnailUrl,
    };
  }

  /// DTOをドメインエンティティ (Video) に変換
  Video toEntity() {
    return Video(
      id: id,
      incidentId: incidentId,
      fileName: fileName,
      fileSize: fileSize,
      duration: duration,
      recordedAt: recordedAt,
      url: url,
      thumbnailUrl: thumbnailUrl,
    );
  }
}
