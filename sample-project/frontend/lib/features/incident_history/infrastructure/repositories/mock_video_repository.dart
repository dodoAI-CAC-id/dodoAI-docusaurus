import 'package:dartz/dartz.dart';
import 'package:mamoai/core/error/failures.dart';
import 'package:mamoai/features/incident_history/domain/repositories/i_video_repository.dart';

/// モック用ビデオリポジトリ
/// APIサーバーなしでUIを確認するためのモックデータを提供
class MockVideoRepository implements IVideoRepository {
  @override
  Future<Either<Failure, String>> getVideoUrl(String videoId) async {
    // 少し遅延を入れる
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      // モック用のビデオURL（実際には存在しないが、UIテスト用）
      final mockVideoUrl = 'https://example.com/videos/$videoId.mp4';
      
      return Right(mockVideoUrl);
    } catch (e) {
      return Left(ServerFailure('ビデオURLの取得に失敗しました: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> downloadVideo(
    String videoId,
    String savePath,
  ) async {
    // 少し遅延を入れる
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // モック用のダウンロードパス
      final mockDownloadPath = '$savePath/$videoId.mp4';
      
      return Right(mockDownloadPath);
    } catch (e) {
      return Left(ServerFailure('ビデオのダウンロードに失敗しました: $e'));
    }
  }
}
