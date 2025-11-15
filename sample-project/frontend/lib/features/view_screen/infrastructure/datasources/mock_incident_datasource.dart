import '../../domain/entities/incident_item.dart';
import '../../domain/entities/incident_status.dart';

/// モックデータを提供するDataSource
class MockIncidentDataSource {
  // モックデータの内部状態
  final List<IncidentItem> _mockItems = [
    // 未対応の異常検知
    IncidentItem(
      id: '1',
      roomBedNumber: '101-A',
      personName: '山田 太郎',
      detectionType: '起床',
      status: IncidentStatus.unhandled,
      pictureAtDetection: 'mock_base64_image_1',
      pictureBeforeDetection: 'mock_base64_image_1_before',
      detectedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      cameraId: 'camera_001',
      isAlertActive: true,
    ),
    IncidentItem(
      id: '2',
      roomBedNumber: '102-B',
      personName: '佐藤 花子',
      detectionType: '離床',
      status: IncidentStatus.unhandled,
      pictureAtDetection: 'mock_base64_image_2',
      pictureBeforeDetection: 'mock_base64_image_2_before',
      detectedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      cameraId: 'camera_002',
      isAlertActive: true,
    ),
    // 対応中の異常検知
    IncidentItem(
      id: '3',
      roomBedNumber: '103-A',
      personName: '鈴木 一郎',
      detectionType: '端坐位',
      status: IncidentStatus.inProgress,
      pictureAtDetection: 'mock_base64_image_3',
      pictureBeforeDetection: 'mock_base64_image_3_before',
      detectedAt: DateTime.now().subtract(const Duration(minutes: 15)),
      cameraId: 'camera_003',
      isAlertActive: true,
    ),
    // 検知なし（通常状態）
    IncidentItem(
      id: '4',
      roomBedNumber: '104-B',
      personName: '田中 美咲',
      detectionType: '臥床',
      status: IncidentStatus.noDetection,
      detectedAt: null,
      cameraId: 'camera_004',
      isAlertActive: true,
    ),
    IncidentItem(
      id: '5',
      roomBedNumber: '105-A',
      personName: '高橋 健太',
      detectionType: '臥床',
      status: IncidentStatus.noDetection,
      detectedAt: null,
      cameraId: 'camera_005',
      isAlertActive: true,
    ),
    IncidentItem(
      id: '6',
      roomBedNumber: '106-B',
      personName: '伊藤 さくら',
      detectionType: '臥床',
      status: IncidentStatus.noDetection,
      detectedAt: null,
      cameraId: 'camera_006',
      isAlertActive: false, // アラート停止中
    ),
  ];

  /// 全てのインシデントアイテムを取得
  Future<List<IncidentItem>> getIncidentItems() async {
    // ネットワーク遅延をシミュレート
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockItems);
  }

  /// 特定のインシデントアイテムを取得
  Future<IncidentItem?> getIncidentItemById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  /// インシデントのステータスを更新
  Future<IncidentItem> updateIncidentStatus({
    required String id,
    required IncidentStatus newStatus,
    required String actionType,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _mockItems.indexWhere((item) => item.id == id);
    if (index == -1) {
      throw Exception('Incident not found');
    }

    final updatedItem = _mockItems[index].copyWith(
      status: newStatus,
    );

    _mockItems[index] = updatedItem;
    return updatedItem;
  }

  /// アラートの稼働状態を切り替え
  Future<IncidentItem> toggleAlertStatus({
    required String id,
    required bool isActive,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _mockItems.indexWhere((item) => item.id == id);
    if (index == -1) {
      throw Exception('Incident not found');
    }

    final updatedItem = _mockItems[index].copyWith(
      isAlertActive: isActive,
    );

    _mockItems[index] = updatedItem;
    return updatedItem;
  }
}
