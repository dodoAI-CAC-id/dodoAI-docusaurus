import 'package:dio/dio.dart';
import 'package:frontend/features/history/domain/repositories/i_video_repository.dart';
import 'package:frontend/features/history/domain/entities/video.dart';
import 'package:frontend/features/history/data/models/video_dto.dart';
import 'package:frontend/core/network/api_exceptions.dart';

/// 動画リポジトリの実装
/// 
/// IVideoRepositoryインターフェースの実装クラス。
/// DioクライアントでAPI通信を行い、動画情報を取得します。
class VideoRepositoryImpl implements IVideoRepository {
  final Dio _dio;

  VideoRepositoryImpl(this._dio);

  @override
  Future<Video> fetchVideoById(String id) async {
    try {
      // API仕様書: GET /videos/{videoId}/file
      // ただし、メタデータ取得用には別のエンドポイントが必要
      // 現状はincidentから取得する想定
      throw UnimplementedError('Use fetchVideoByIncidentId instead');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw InvalidResponseException(
        message: 'Failed to parse video data: $e',
        originalException: e,
      );
    }
  }

  @override
  Future<Video?> fetchVideoByIncidentId(String incidentId) async {
    try {
      // API仕様書: GET /incidents/{incidentId}/videos
      final response = await _dio.get('/api/v2/incidents/$incidentId/videos');
      
      // BackEndのレスポンス形式: {"success": true, "data": [...]}
      final responseData = response.data as Map<String, dynamic>;
      final dataList = responseData['data'] as List<dynamic>;
      if (dataList.isEmpty) {
        return null;
      }
      
      // 最初の動画を返す
      final videoDto = VideoDTO.fromJson(dataList.first as Map<String, dynamic>);
      return videoDto.toEntity();
    } on DioException catch (e) {
      // 404の場合はnullを返す
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw _handleDioException(e);
    } catch (e) {
      throw InvalidResponseException(
        message: 'Failed to parse video data: $e',
        originalException: e,
      );
    }
  }

  @override
  Future<String> downloadVideo(
    String videoId,
    String savePath, {
    void Function(double)? onProgress,
  }) async {
    try {
      // API仕様書: GET /videos/{videoId}/file
      await _dio.download(
        '/api/v2/videos/$videoId/file',
        savePath,
        onReceiveProgress: (received, total) {
          if (onProgress != null && total > 0) {
            final progress = received / total;
            onProgress(progress);
          }
        },
      );
      return savePath;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw InvalidResponseException(
        message: 'Failed to download video: $e',
        originalException: e,
      );
    }
  }

  @override
  Future<String> getStreamingUrl(String videoId) async {
    try {
      // API仕様書: GET /videos/{videoId}/file
      // ストリーミングURLとして使用
      return '/api/v2/videos/$videoId/file';
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw InvalidResponseException(
        message: 'Failed to get streaming URL: $e',
        originalException: e,
      );
    }
  }

  @override
  Future<bool> videoExists(String videoId) async {
    try {
      // API仕様書にHEADメソッドの定義がないため、GETを試みる
      await _dio.get(
        '/api/v2/videos/$videoId/file',
        options: Options(
          receiveDataWhenStatusError: false,
          validateStatus: (status) => status == 200,
        ),
      );
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return false;
      }
      throw _handleDioException(e);
    } catch (e) {
      throw InvalidResponseException(
        message: 'Failed to check video existence: $e',
        originalException: e,
      );
    }
  }

  /// DioExceptionを適切なApiExceptionに変換
  ApiException _handleDioException(DioException e) {
    final response = e.response;
    final statusCode = response?.statusCode;

    // ネットワークエラー
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return NetworkException(
        message: e.message ?? 'Network error occurred',
        originalException: e,
      );
    }

    // タイムアウト
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return TimeoutException(
        message: 'Request timeout',
        originalException: e,
      );
    }

    // HTTPステータスコードによる分類
    if (statusCode != null) {
      final message = _getErrorMessage(response);

      switch (statusCode) {
        case 400:
          return ValidationException(
            message: message,
            originalException: e,
          );
        case 401:
          return UnauthorizedException(
            message: message,
            originalException: e,
          );
        case 403:
          return ForbiddenException(
            message: message,
            originalException: e,
          );
        case 404:
          return NotFoundException(
            message: message,
            originalException: e,
          );
        case >= 500:
          return ServerException(
            message: message,
            statusCode: statusCode,
            originalException: e,
          );
        default:
          return InvalidResponseException(
            message: message,
            statusCode: statusCode,
            originalException: e,
          );
      }
    }

    // その他のエラー
    return InvalidResponseException(
      message: e.message ?? 'Unknown error occurred',
      originalException: e,
    );
  }

  /// レスポンスからエラーメッセージを取得
  String _getErrorMessage(Response? response) {
    if (response?.data is Map) {
      final data = response!.data as Map<String, dynamic>;
      return data['message'] as String? ?? 'An error occurred';
    }
    return 'An error occurred';
  }
}
