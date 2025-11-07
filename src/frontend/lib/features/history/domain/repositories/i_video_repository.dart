import 'package:frontend/features/history/domain/entities/video.dart';

/// 動画リポジトリインターフェース
/// 
/// 動画データのアクセスを抽象化するインターフェース
/// Infrastructure層で実装される
abstract class IVideoRepository {
  /// 動画をIDで取得
  /// 
  /// [id] 動画ID
  /// 
  /// Returns 動画エンティティ
  /// Throws リポジトリ例外（見つからない、ネットワークエラーなど）
  Future<Video> fetchVideoById(String id);

  /// インシデントに関連する動画を取得
  /// 
  /// [incidentId] インシデントID
  /// 
  /// Returns 動画エンティティ（存在する場合）、存在しない場合はnull
  /// Throws リポジトリ例外（ネットワークエラーなど）
  Future<Video?> fetchVideoByIncidentId(String incidentId);

  /// 動画ファイルをダウンロード
  /// 
  /// [videoId] 動画ID
  /// [savePath] 保存先パス
  /// [onProgress] ダウンロード進捗コールバック（0.0～1.0）
  /// 
  /// Returns ダウンロードしたファイルのパス
  /// Throws リポジトリ例外（ネットワークエラー、権限エラーなど）
  Future<String> downloadVideo(
    String videoId,
    String savePath, {
    void Function(double progress)? onProgress,
  });

  /// 動画のストリーミングURLを取得
  /// 
  /// [videoId] 動画ID
  /// 
  /// Returns ストリーミング用URL
  /// Throws リポジトリ例外（見つからない、ネットワークエラーなど）
  Future<String> getStreamingUrl(String videoId);

  /// 動画が存在するかチェック
  /// 
  /// [videoId] 動画ID
  /// 
  /// Returns 存在する場合true、存在しない場合false
  /// Throws リポジトリ例外（ネットワークエラーなど）
  Future<bool> videoExists(String videoId);
}
