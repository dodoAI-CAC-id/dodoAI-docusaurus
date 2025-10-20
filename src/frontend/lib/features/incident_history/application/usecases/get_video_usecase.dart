import 'package:dartz/dartz.dart';
import 'package:mamoai/core/error/failures.dart';
import 'package:mamoai/features/incident_history/domain/repositories/i_video_repository.dart';

/// GetVideoUseCaseのパラメータ
class GetVideoParams {
  final String videoId;

  const GetVideoParams({required this.videoId});
}

/// 動画URL取得UseCase
class GetVideoUseCase {
  final IVideoRepository repository;

  GetVideoUseCase(this.repository);

  /// 動画URLを取得
  ///
  /// [params] 動画取得パラメータ
  /// 戻り値: Either<Failure, String> (動画URL)
  Future<Either<Failure, String>> call(GetVideoParams params) async {
    return await repository.getVideoUrl(params.videoId);
  }
}
