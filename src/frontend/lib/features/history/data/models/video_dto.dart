import 'package:frontend/features/history/domain/entities/video.dart';

/// 動画のデータ転送オブジェクト (DTO)
/// 
/// APIレスポンスとドメインエンティティ間のマッピングを担当します。
class VideoDTO {
  /// 動画ID（API: id）
  final String id;

  /// 関連するインシデントID（API: incidentId）
  final String incidentId;

  /// ファイルURL（API: fileUrl）
  final String fileUrl;

  /// サムネイルURL（API: thumbnailUrl）
  final String? thumbnailUrl;

  /// モザイク処理フラグ（API: mosaic）
  final bool mosaic;

  /// 録画開始時刻（API: spanStart）
  final DateTime spanStart;

  /// 録画終了時刻（API: spanEnd）
  final DateTime spanEnd;

  const VideoDTO({
    required this.id,
    required this.incidentId,
    required this.fileUrl,
    this.thumbnailUrl,
    required this.mosaic,
    required this.spanStart,
    required this.spanEnd,
  });

  /// JSONからVideoDTOを生成（API仕様書に基づく）
  factory VideoDTO.fromJson(Map<String, dynamic> json) {
    return VideoDTO(
      id: json['id'] as String,
      incidentId: json['incidentId'] as String,
      fileUrl: json['fileUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      mosaic: json['mosaic'] as bool? ?? false,
      spanStart: DateTime.parse(json['spanStart'] as String),
      spanEnd: DateTime.parse(json['spanEnd'] as String),
    );
  }

  /// VideoDTOをJSONに変換（API仕様書に基づく）
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'incidentId': incidentId,
      'fileUrl': fileUrl,
      'thumbnailUrl': thumbnailUrl,
      'mosaic': mosaic,
      'spanStart': spanStart.toIso8601String(),
      'spanEnd': spanEnd.toIso8601String(),
    };
  }

  /// DTOをドメインエンティティ (Video) に変換
  Video toEntity() {
    // 動画の長さを秒単位で計算
    final duration = spanEnd.difference(spanStart).inSeconds;
    
    // ファイル名をURLから抽出（または生成）
    final fileName = fileUrl.split('/').last;
    
    return Video(
      id: id,
      incidentId: incidentId,
      fileName: fileName,
      fileSize: 0, // API仕様書にファイルサイズがないため0とする
      duration: duration,
      recordedAt: spanStart,
      url: fileUrl,
      thumbnailUrl: thumbnailUrl,
    );
  }
}
