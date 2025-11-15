import 'package:equatable/equatable.dart';
import 'incident_status.dart';

/// ビュー画面に表示する異常検知アイテムのエンティティ
class IncidentItem extends Equatable {
  const IncidentItem({
    required this.id,
    required this.roomBedNumber,
    required this.personName,
    required this.detectionType,
    required this.status,
    this.pictureAtDetection,
    this.pictureBeforeDetection,
    this.detectedAt,
    this.cameraId,
    this.isAlertActive = true,
  });

  /// インシデントID
  final String id;

  /// 部屋/ベッド番号
  final String roomBedNumber;

  /// 見守り対象者名
  final String personName;

  /// 異常姿勢（起床/端坐位/転倒/離床/臥床）
  final String detectionType;

  /// ステータス（未対応/対応中/検知なし）
  final IncidentStatus status;

  /// 検知画像（検知時）base64形式
  final String? pictureAtDetection;

  /// 検知画像（検知直前）base64形式
  final String? pictureBeforeDetection;

  /// 検知日時
  final DateTime? detectedAt;

  /// カメラID
  final String? cameraId;

  /// アラート稼働状態（true: 稼働中, false: 停止中）
  final bool isAlertActive;

  /// 異常検知画像が存在するか
  bool get hasDetectionImages {
    return pictureAtDetection != null || pictureBeforeDetection != null;
  }

  /// 異常検知中かどうか
  bool get isDetected {
    return status.isDetected;
  }

  /// コピーメソッド
  IncidentItem copyWith({
    String? id,
    String? roomBedNumber,
    String? personName,
    String? detectionType,
    IncidentStatus? status,
    String? pictureAtDetection,
    String? pictureBeforeDetection,
    DateTime? detectedAt,
    String? cameraId,
    bool? isAlertActive,
  }) {
    return IncidentItem(
      id: id ?? this.id,
      roomBedNumber: roomBedNumber ?? this.roomBedNumber,
      personName: personName ?? this.personName,
      detectionType: detectionType ?? this.detectionType,
      status: status ?? this.status,
      pictureAtDetection: pictureAtDetection ?? this.pictureAtDetection,
      pictureBeforeDetection:
          pictureBeforeDetection ?? this.pictureBeforeDetection,
      detectedAt: detectedAt ?? this.detectedAt,
      cameraId: cameraId ?? this.cameraId,
      isAlertActive: isAlertActive ?? this.isAlertActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        roomBedNumber,
        personName,
        detectionType,
        status,
        pictureAtDetection,
        pictureBeforeDetection,
        detectedAt,
        cameraId,
        isAlertActive,
      ];
}
