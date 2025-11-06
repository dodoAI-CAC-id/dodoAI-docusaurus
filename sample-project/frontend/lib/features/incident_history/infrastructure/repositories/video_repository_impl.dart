import 'package:dartz/dartz.dart';
import 'package:mamoai/core/error/failures.dart';
import 'package:mamoai/features/incident_history/domain/repositories/i_video_repository.dart';
import 'package:mamoai/features/incident_history/infrastructure/datasources/video_remote_datasource.dart';

/// 動画リポジトリ実装
class VideoRepositoryImpl implements IVideoRepository {
  final VideoRemoteDataSource remoteDataSource;

  VideoRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> getVideoUrl(String videoId) async {
    try {
      final videoUrl = await remoteDataSource.getVideoUrl(videoId);
      return Right(videoUrl);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> downloadVideo(
    String videoId,
    String savePath,
  ) async {
    try {
      // TODO: 実装が必要な場合は、DataSourceにdownloadVideoメソッドを追加
      // 現時点では未実装としてエラーを返す
      return Left(ServerFailure('Download video not implemented yet'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
