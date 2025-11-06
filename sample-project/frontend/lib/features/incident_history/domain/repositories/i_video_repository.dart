import 'package:dartz/dartz.dart';
import 'package:mamoai/core/error/failures.dart';

/// 動画リポジトリインターフェース
abstract class IVideoRepository {
  /// 動画URLを取得
  ///
  /// [videoId] 動画ID
  /// 戻り値: Either<Failure, String> (動画URL)
  Future<Either<Failure, String>> getVideoUrl(String videoId);

  /// 動画をダウンロード
  ///
  /// [videoId] 動画ID
  /// [savePath] 保存先パス
  /// 戻り値: Either<Failure, String> (保存されたファイルパス)
  Future<Either<Failure, String>> downloadVideo(
    String videoId,
    String savePath,
  );
}
