import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/incident_item.dart';
import '../../domain/entities/incident_status.dart';
import '../../domain/repositories/i_view_screen_repository.dart';
import '../datasources/view_screen_remote_datasource.dart';

/// ビュー画面用のRepository実装（Remote）
class ViewScreenRepository implements IViewScreenRepository {
  final ViewScreenRemoteDataSource remoteDataSource;

  ViewScreenRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, List<IncidentItem>>> getIncidentItems() async {
    try {
      final incidentsData = await remoteDataSource.getIncidents();
      final items = incidentsData.map((data) => _mapToIncidentItem(data)).toList();
      return Right(items);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, IncidentItem>> getIncidentItemById(String id) async {
    try {
      final data = await remoteDataSource.getIncidentById(id);
      final item = _mapToIncidentItem(data);
      return Right(item);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, IncidentItem>> updateIncidentStatus({
    required String id,
    required IncidentStatus newStatus,
    required String actionType,
  }) async {
    try {
      final data = await remoteDataSource.updateIncidentStatus(
        incidentId: id,
        newStatus: newStatus,
        actionType: actionType,
      );
      final item = _mapToIncidentItem(data);
      return Right(item);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, IncidentItem>> toggleAlertStatus({
    required String id,
    required bool isActive,
  }) async {
    try {
      final data = await remoteDataSource.toggleAlertStatus(
        incidentId: id,
        isActive: isActive,
      );
      final item = _mapToIncidentItem(data);
      return Right(item);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// APIレスポンスをIncidentItemエンティティにマッピング
  IncidentItem _mapToIncidentItem(Map<String, dynamic> data) {
    // APIステータスをUIステータスに変換
    // デフォルトは'open'（未対応）として、カードが消えないようにする
    final apiStatus = data['status'] as String? ?? 'open';
    final status = IncidentStatus.fromApiStatus(apiStatus);

    // 検知日時のパース
    DateTime? detectedAt;
    if (data['detectedAt'] != null) {
      try {
        detectedAt = DateTime.parse(data['detectedAt'] as String);
      } catch (e) {
        // パースエラーは無視
      }
    }

    // 画像データの取得（picturesオブジェクトから）
    String? pictureAtDetection;
    String? pictureBeforeDetection;
    if (data['pictures'] != null && data['pictures'] is Map) {
      final pictures = data['pictures'] as Map<String, dynamic>;
      pictureAtDetection = pictures['pictureAtDetection'] as String?;
      pictureBeforeDetection = pictures['pictureBeforeDetection'] as String?;
    }

    // 部屋/ベッド番号の取得（roomIdは露出しない）
    String roomBedNumber = data['roomNumber'] as String? ?? '-';

    // 見守り対象者名の取得
    String personName = 'N/A';
    if (data['personName'] != null) {
      personName = data['personName'] as String;
    } else if (data['personId'] != null) {
      personName = data['personId'] as String;
    }

    // 異常姿勢（検知タイプ）の取得
    String detectionType = data['type'] as String? ?? '臥床';

    // カメラIDの取得（必須）
    // APIは camera_id または cameraId のいずれかで返す可能性があるため両方チェック
    String cameraId = (data['cameraId'] as String?) ?? 
                      (data['camera_id'] as String?) ?? 
                      'unknown-camera';

    return IncidentItem(
      id: data['id'] as String,
      cameraId: cameraId,
      roomBedNumber: roomBedNumber,
      personName: personName,
      detectionType: detectionType,
      status: status,
      pictureAtDetection: pictureAtDetection,
      pictureBeforeDetection: pictureBeforeDetection,
      detectedAt: detectedAt,
      isAlertActive: data['isAlertActive'] as bool? ?? true, // APIから取得、デフォルトは稼働中
    );
  }
}
