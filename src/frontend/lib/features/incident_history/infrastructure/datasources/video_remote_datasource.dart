import 'package:dio/dio.dart';

/// 動画リモートデータソース
class VideoRemoteDataSource {
  final Dio dio;
  static const String baseUrl = '/api/v2';

  VideoRemoteDataSource(this.dio);

  /// 動画URLを取得
  ///
  /// [videoId] 動画ID
  /// 戻り値: String (動画URL)
  Future<String> getVideoUrl(String videoId) async {
    final response = await dio.get('$baseUrl/videos/$videoId/file');

    if (response.statusCode == 200) {
      // レスポンスから動画URLを取得
      // API仕様に応じて調整が必要
      if (response.data is Map<String, dynamic>) {
        return response.data['fileUrl'] as String;
      }
      // バイナリデータの場合は、URLを構築して返す
      return '$baseUrl/videos/$videoId/file';
    } else {
      throw Exception('Failed to load video: ${response.statusCode}');
    }
  }
}
