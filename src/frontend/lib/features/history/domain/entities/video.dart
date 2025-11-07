import 'package:equatable/equatable.dart';

/// 動画エンティティ
/// 
/// 異常検知時に録画された動画を表現するドメインエンティティ
class Video extends Equatable {
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

  const Video({
    required this.id,
    required this.incidentId,
    required this.fileName,
    required this.fileSize,
    required this.duration,
    required this.recordedAt,
    required this.url,
    this.thumbnailUrl,
  });

  /// ファイルサイズを読みやすい形式でフォーマット
  String get formattedFileSize {
    const int kb = 1024;
    const int mb = kb * 1024;
    const int gb = mb * 1024;

    if (fileSize >= gb) {
      return '${(fileSize / gb).toStringAsFixed(2)} GB';
    } else if (fileSize >= mb) {
      return '${(fileSize / mb).toStringAsFixed(2)} MB';
    } else if (fileSize >= kb) {
      return '${(fileSize / kb).toStringAsFixed(2)} KB';
    } else {
      return '$fileSize B';
    }
  }

  /// 動画の長さを読みやすい形式でフォーマット
  String get formattedDuration {
    final int hours = duration ~/ 3600;
    final int minutes = (duration % 3600) ~/ 60;
    final int seconds = duration % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// コピーして新しいインスタンスを作成
  Video copyWith({
    String? id,
    String? incidentId,
    String? fileName,
    int? fileSize,
    int? duration,
    DateTime? recordedAt,
    String? url,
    String? thumbnailUrl,
  }) {
    return Video(
      id: id ?? this.id,
      incidentId: incidentId ?? this.incidentId,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      duration: duration ?? this.duration,
      recordedAt: recordedAt ?? this.recordedAt,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        incidentId,
        fileName,
        fileSize,
        duration,
        recordedAt,
        url,
        thumbnailUrl,
      ];

  @override
  bool get stringify => true;
}
