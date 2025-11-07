import 'package:frontend/features/history/domain/repositories/i_incident_repository.dart';
import 'package:frontend/features/history/domain/entities/incident.dart';
import 'package:frontend/features/history/domain/entities/action.dart';

/// モックインシデントリポジトリ
/// 
/// テスト用のダミーデータを返すリポジトリ実装
/// API開発前のUI確認や開発時のテストに使用
class IncidentRepositoryMock implements IIncidentRepository {
  // ダミーデータ（30件）
  static final List<Incident> _mockIncidents = [
    // 1-10件目
    Incident(
      id: '1',
      incidentId: '1',
      detectedAt: DateTime(2025, 1, 1, 8, 15, 30),
      roomNumber: '１０１',
      bedNumber: '',
      residentName: '山田 太郎',
      detectionType: '起床',
      status: IncidentStatus.resolved,
      actions: [
        Action(
          id: 'a1',
          incidentId: '1',
          performedAt: DateTime(2025, 1, 1, 8, 20, 0),
          performedBy: '佐藤 花子',
          actionType: '対応済み',
          notes: '正常な起床を確認',
        ),
      ],
      videoId: 'video_001',
    ),
    Incident(
      id: '2',
      incidentId: '2',
      detectedAt: DateTime(2025, 1, 2, 14, 30, 45),
      roomNumber: '２０５',
      bedNumber: '',
      residentName: '鈴木 花子',
      detectionType: '離床',
      status: IncidentStatus.detected,
      actions: [],
      videoId: 'video_002',
    ),
    Incident(
      id: '3',
      incidentId: '3',
      detectedAt: DateTime(2025, 1, 3, 2, 45, 12),
      roomNumber: '３１２',
      bedNumber: '',
      residentName: '田中 一郎',
      detectionType: '転倒',
      status: IncidentStatus.inProgress,
      actions: [
        Action(
          id: 'a3',
          incidentId: '3',
          performedAt: DateTime(2025, 1, 3, 2, 50, 0),
          performedBy: '高橋 次郎',
          actionType: '対応中',
          notes: '現場に向かっています',
        ),
      ],
      videoId: 'video_003',
    ),
    Incident(
      id: '4',
      incidentId: '4',
      detectedAt: DateTime(2025, 1, 4, 18, 20, 33),
      roomNumber: '１２３',
      bedNumber: '',
      residentName: '渡辺 美咲',
      detectionType: '端坐位',
      status: IncidentStatus.confirmed,
      actions: [
        Action(
          id: 'a4',
          incidentId: '4',
          performedAt: DateTime(2025, 1, 4, 18, 25, 0),
          performedBy: '伊藤 愛',
          actionType: '誤検知',
          notes: 'ベッド上での姿勢変換',
        ),
      ],
      videoId: 'video_004',
    ),
    Incident(
      id: '5',
      incidentId: '5',
      detectedAt: DateTime(2025, 1, 5, 22, 10, 18),
      roomNumber: '４０８',
      bedNumber: '',
      residentName: '中村 健太',
      detectionType: '離床',
      status: IncidentStatus.confirmed,
      actions: [
        Action(
          id: 'a5',
          incidentId: '5',
          performedAt: DateTime(2025, 1, 5, 22, 15, 0),
          performedBy: '山本 さくら',
          actionType: '訪室不要',
          notes: 'トイレ使用のため',
        ),
      ],
      videoId: 'video_005',
    ),
    Incident(
      id: '6',
      incidentId: '6',
      detectedAt: DateTime(2025, 1, 6, 11, 35, 55),
      roomNumber: '２１５',
      bedNumber: '',
      residentName: '小林 京子',
      detectionType: '起床',
      status: IncidentStatus.resolved,
      actions: [
        Action(
          id: 'a6',
          incidentId: '6',
          performedAt: DateTime(2025, 1, 6, 11, 40, 0),
          performedBy: '加藤 大輔',
          actionType: '対応済み',
          notes: '正常な起床、問題なし',
        ),
      ],
      videoId: 'video_006',
    ),
    Incident(
      id: '7',
      incidentId: '7',
      detectedAt: DateTime(2025, 1, 7, 3, 50, 22),
      roomNumber: '３３３',
      bedNumber: '',
      residentName: '佐々木 明',
      detectionType: '転倒',
      status: IncidentStatus.detected,
      actions: [],
      videoId: 'video_007',
    ),
    Incident(
      id: '8',
      incidentId: '8',
      detectedAt: DateTime(2025, 1, 8, 16, 15, 40),
      roomNumber: '１４７',
      bedNumber: '',
      residentName: '吉田 陽子',
      detectionType: '端坐位',
      status: IncidentStatus.confirmed,
      actions: [
        Action(
          id: 'a8',
          incidentId: '8',
          performedAt: DateTime(2025, 1, 8, 16, 20, 0),
          performedBy: '松本 翔太',
          actionType: '対応不要',
          notes: '自立動作可能な方',
        ),
      ],
      videoId: 'video_008',
    ),
    Incident(
      id: '9',
      incidentId: '9',
      detectedAt: DateTime(2025, 1, 9, 7, 25, 8),
      roomNumber: '５０２',
      bedNumber: '',
      residentName: '木村 敏子',
      detectionType: '起床',
      status: IncidentStatus.inProgress,
      actions: [
        Action(
          id: 'a9',
          incidentId: '9',
          performedAt: DateTime(2025, 1, 9, 7, 28, 0),
          performedBy: '井上 真由美',
          actionType: '対応中',
          notes: '確認のため訪室中',
        ),
      ],
      videoId: 'video_009',
    ),
    Incident(
      id: '10',
      incidentId: '10',
      detectedAt: DateTime(2025, 1, 10, 20, 40, 15),
      roomNumber: '２８９',
      bedNumber: '',
      residentName: '林 正夫',
      detectionType: '離床',
      status: IncidentStatus.detected,
      actions: [],
      videoId: 'video_010',
    ),
    // 11-20件目
    Incident(
      id: '11',
      incidentId: '11',
      detectedAt: DateTime(2025, 1, 11, 13, 55, 27),
      roomNumber: '３５６',
      bedNumber: '',
      residentName: '斎藤 幸子',
      detectionType: '端坐位',
      status: IncidentStatus.resolved,
      actions: [
        Action(
          id: 'a11',
          incidentId: '11',
          performedAt: DateTime(2025, 1, 11, 14, 0, 0),
          performedBy: '森田 健一',
          actionType: '対応済み',
          notes: '看護師による確認完了',
        ),
      ],
      videoId: 'video_011',
    ),
    Incident(
      id: '12',
      incidentId: '12',
      detectedAt: DateTime(2025, 1, 12, 1, 20, 50),
      roomNumber: '１１８',
      bedNumber: '',
      residentName: '前田 和子',
      detectionType: '転倒',
      status: IncidentStatus.inProgress,
      actions: [
        Action(
          id: 'a12',
          incidentId: '12',
          performedAt: DateTime(2025, 1, 12, 1, 22, 0),
          performedBy: '岡田 雄一',
          actionType: '対応中',
          notes: '緊急対応中',
        ),
      ],
      videoId: 'video_012',
    ),
    Incident(
      id: '13',
      incidentId: '13',
      detectedAt: DateTime(2025, 1, 13, 9, 10, 35),
      roomNumber: '４２１',
      bedNumber: '',
      residentName: '藤田 清',
      detectionType: '起床',
      status: IncidentStatus.confirmed,
      actions: [
        Action(
          id: 'a13',
          incidentId: '13',
          performedAt: DateTime(2025, 1, 13, 9, 15, 0),
          performedBy: '長谷川 優子',
          actionType: '誤検知',
          notes: 'ベッド上での起き上がり',
        ),
      ],
      videoId: 'video_013',
    ),
    Incident(
      id: '14',
      incidentId: '14',
      detectedAt: DateTime(2025, 1, 14, 17, 45, 12),
      roomNumber: '２３４',
      bedNumber: '',
      residentName: '村上 文子',
      detectionType: '離床',
      status: IncidentStatus.detected,
      actions: [],
      videoId: 'video_014',
    ),
    Incident(
      id: '15',
      incidentId: '15',
      detectedAt: DateTime(2025, 1, 15, 5, 30, 48),
      roomNumber: '５１５',
      bedNumber: '',
      residentName: '近藤 博',
      detectionType: '端坐位',
      status: IncidentStatus.confirmed,
      actions: [
        Action(
          id: 'a15',
          incidentId: '15',
          performedAt: DateTime(2025, 1, 15, 5, 35, 0),
          performedBy: '石川 麻衣',
          actionType: '訪室不要',
          notes: '朝の起床準備',
        ),
      ],
      videoId: 'video_015',
    ),
    Incident(
      id: '16',
      incidentId: '16',
      detectedAt: DateTime(2025, 1, 16, 12, 5, 20),
      roomNumber: '３７８',
      bedNumber: '',
      residentName: '青木 信夫',
      detectionType: '転倒',
      status: IncidentStatus.resolved,
      actions: [
        Action(
          id: 'a16',
          incidentId: '16',
          performedAt: DateTime(2025, 1, 16, 12, 10, 0),
          performedBy: '西村 恵美',
          actionType: '対応済み',
          notes: '医師による診察完了',
        ),
      ],
      videoId: 'video_016',
    ),
    Incident(
      id: '17',
      incidentId: '17',
      detectedAt: DateTime(2025, 1, 17, 19, 50, 5),
      roomNumber: '１６２',
      bedNumber: '',
      residentName: '坂本 春子',
      detectionType: '起床',
      status: IncidentStatus.detected,
      actions: [],
      videoId: 'video_017',
    ),
    Incident(
      id: '18',
      incidentId: '18',
      detectedAt: DateTime(2025, 1, 18, 4, 15, 38),
      roomNumber: '４９５',
      bedNumber: '',
      residentName: '川口 勝',
      detectionType: '離床',
      status: IncidentStatus.inProgress,
      actions: [
        Action(
          id: 'a18',
          incidentId: '18',
          performedAt: DateTime(2025, 1, 18, 4, 18, 0),
          performedBy: '福田 直樹',
          actionType: '対応中',
          notes: '確認のため向かっています',
        ),
      ],
      videoId: 'video_018',
    ),
    Incident(
      id: '19',
      incidentId: '19',
      detectedAt: DateTime(2025, 1, 19, 15, 25, 42),
      roomNumber: '２７１',
      bedNumber: '',
      residentName: '橋本 節子',
      detectionType: '端坐位',
      status: IncidentStatus.confirmed,
      actions: [
        Action(
          id: 'a19',
          incidentId: '19',
          performedAt: DateTime(2025, 1, 19, 15, 30, 0),
          performedBy: '山下 智子',
          actionType: '対応不要',
          notes: 'リハビリ中の姿勢',
        ),
      ],
      videoId: 'video_019',
    ),
    Incident(
      id: '20',
      incidentId: '20',
      detectedAt: DateTime(2025, 1, 20, 10, 40, 18),
      roomNumber: '３４５',
      bedNumber: '',
      residentName: '内田 良一',
      detectionType: '転倒',
      status: IncidentStatus.detected,
      actions: [],
      videoId: 'video_020',
    ),
    // 21-30件目
    Incident(
      id: '21',
      incidentId: '21',
      detectedAt: DateTime(2025, 1, 21, 6, 55, 25),
      roomNumber: '１９３',
      bedNumber: '',
      residentName: '池田 美代子',
      detectionType: '起床',
      status: IncidentStatus.resolved,
      actions: [
        Action(
          id: 'a21',
          incidentId: '21',
          performedAt: DateTime(2025, 1, 21, 7, 0, 0),
          performedBy: '原田 康夫',
          actionType: '対応済み',
          notes: '正常な起床を確認',
        ),
      ],
      videoId: 'video_021',
    ),
    Incident(
      id: '22',
      incidentId: '22',
      detectedAt: DateTime(2025, 1, 22, 21, 30, 52),
      roomNumber: '５２８',
      bedNumber: '',
      residentName: '三浦 正子',
      detectionType: '離床',
      status: IncidentStatus.confirmed,
      actions: [
        Action(
          id: 'a22',
          incidentId: '22',
          performedAt: DateTime(2025, 1, 22, 21, 35, 0),
          performedBy: '小川 亮',
          actionType: '誤検知',
          notes: 'センサー誤動作',
        ),
      ],
      videoId: 'video_022',
    ),
    Incident(
      id: '23',
      incidentId: '23',
      detectedAt: DateTime(2025, 1, 23, 14, 10, 8),
      roomNumber: '２４６',
      bedNumber: '',
      residentName: '菅原 茂',
      detectionType: '端坐位',
      status: IncidentStatus.detected,
      actions: [],
      videoId: 'video_023',
    ),
    Incident(
      id: '24',
      incidentId: '24',
      detectedAt: DateTime(2025, 1, 24, 23, 45, 33),
      roomNumber: '４１２',
      bedNumber: '',
      residentName: '竹内 幸江',
      detectionType: '転倒',
      status: IncidentStatus.inProgress,
      actions: [
        Action(
          id: 'a24',
          incidentId: '24',
          performedAt: DateTime(2025, 1, 24, 23, 47, 0),
          performedBy: '清水 裕子',
          actionType: '対応中',
          notes: '急行中',
        ),
      ],
      videoId: 'video_024',
    ),
    Incident(
      id: '25',
      incidentId: '25',
      detectedAt: DateTime(2025, 1, 25, 8, 20, 45),
      roomNumber: '３０９',
      bedNumber: '',
      residentName: '野村 秀雄',
      detectionType: '起床',
      status: IncidentStatus.confirmed,
      actions: [
        Action(
          id: 'a25',
          incidentId: '25',
          performedAt: DateTime(2025, 1, 25, 8, 25, 0),
          performedBy: '今井 美穂',
          actionType: '訪室不要',
          notes: '自力で起床可能',
        ),
      ],
      videoId: 'video_025',
    ),
    Incident(
      id: '26',
      incidentId: '26',
      detectedAt: DateTime(2025, 1, 26, 16, 35, 15),
      roomNumber: '１５４',
      bedNumber: '',
      residentName: '松井 勇',
      detectionType: '離床',
      status: IncidentStatus.resolved,
      actions: [
        Action(
          id: 'a26',
          incidentId: '26',
          performedAt: DateTime(2025, 1, 26, 16, 40, 0),
          performedBy: '上田 千恵',
          actionType: '対応済み',
          notes: 'リハビリスタッフが対応',
        ),
      ],
      videoId: 'video_026',
    ),
    Incident(
      id: '27',
      incidentId: '27',
      detectedAt: DateTime(2025, 1, 27, 3, 5, 28),
      roomNumber: '４６７',
      bedNumber: '',
      residentName: '大野 久美子',
      detectionType: '端坐位',
      status: IncidentStatus.detected,
      actions: [],
      videoId: 'video_027',
    ),
    Incident(
      id: '28',
      incidentId: '28',
      detectedAt: DateTime(2025, 1, 28, 11, 50, 37),
      roomNumber: '２１８',
      bedNumber: '',
      residentName: '中島 孝',
      detectionType: '転倒',
      status: IncidentStatus.confirmed,
      actions: [
        Action(
          id: 'a28',
          incidentId: '28',
          performedAt: DateTime(2025, 1, 28, 11, 55, 0),
          performedBy: '藤原 由美',
          actionType: '対応不要',
          notes: 'リハビリ訓練中',
        ),
      ],
      videoId: 'video_028',
    ),
    Incident(
      id: '29',
      incidentId: '29',
      detectedAt: DateTime(2025, 1, 29, 18, 15, 22),
      roomNumber: '５３９',
      bedNumber: '',
      residentName: '浜田 正',
      detectionType: '起床',
      status: IncidentStatus.inProgress,
      actions: [
        Action(
          id: 'a29',
          incidentId: '29',
          performedAt: DateTime(2025, 1, 29, 18, 18, 0),
          performedBy: '後藤 香織',
          actionType: '対応中',
          notes: '訪室中',
        ),
      ],
      videoId: 'video_029',
    ),
    Incident(
      id: '30',
      incidentId: '30',
      detectedAt: DateTime(2025, 1, 30, 13, 40, 10),
      roomNumber: '３８２',
      bedNumber: '',
      residentName: '新井 ひろ子',
      detectionType: '離床',
      status: IncidentStatus.detected,
      actions: [],
      videoId: 'video_030',
    ),
  ];

  @override
  Future<List<Incident>> fetchIncidents({
    int limit = 20,
    int offset = 0,
    String orderBy = 'detectedAt',
    bool descending = true,
  }) async {
    // ネットワーク遅延をシミュレート
    await Future.delayed(const Duration(milliseconds: 500));

    // ソート処理
    final sortedList = List<Incident>.from(_mockIncidents);
    sortedList.sort((a, b) {
      final comparison = descending
          ? b.detectedAt.compareTo(a.detectedAt)
          : a.detectedAt.compareTo(b.detectedAt);
      return comparison;
    });

    // ページネーション処理
    final start = offset;
    final end = (offset + limit).clamp(0, sortedList.length);

    if (start >= sortedList.length) {
      return [];
    }

    return sortedList.sublist(start, end);
  }

  @override
  Future<Incident> fetchIncidentById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      return _mockIncidents.firstWhere((incident) => incident.id == id);
    } catch (e) {
      throw Exception('Incident not found: $id');
    }
  }

  @override
  Future<List<Incident>> searchIncidents({
    DateTime? startDate,
    DateTime? endDate,
    String? roomNumber,
    String? bedNumber,
    String? residentName,
    String? performedBy,
    String? detectionType,
    IncidentStatus? status,
    int limit = 20,
    int offset = 0,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // フィルタリング
    var filtered = _mockIncidents.where((incident) {
      if (startDate != null && incident.detectedAt.isBefore(startDate)) {
        return false;
      }
      if (endDate != null && incident.detectedAt.isAfter(endDate)) {
        return false;
      }
      if (roomNumber != null &&
          roomNumber.isNotEmpty &&
          !incident.roomNumber.contains(roomNumber)) {
        return false;
      }
      if (residentName != null &&
          residentName.isNotEmpty &&
          !incident.residentName.contains(residentName)) {
        return false;
      }
      if (detectionType != null &&
          detectionType.isNotEmpty &&
          incident.detectionType != detectionType) {
        return false;
      }
      if (status != null && incident.status != status) {
        return false;
      }
      return true;
    }).toList();

    // ページネーション
    final start = offset;
    final end = (offset + limit).clamp(0, filtered.length);

    if (start >= filtered.length) {
      return [];
    }

    return filtered.sublist(start, end);
  }

  @override
  Future<int> countIncidents() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockIncidents.length;
  }

  @override
  Future<int> countSearchResults({
    DateTime? startDate,
    DateTime? endDate,
    String? roomNumber,
    String? bedNumber,
    String? residentName,
    String? performedBy,
    String? detectionType,
    IncidentStatus? status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    // フィルタリング
    var filtered = _mockIncidents.where((incident) {
      if (startDate != null && incident.detectedAt.isBefore(startDate)) {
        return false;
      }
      if (endDate != null && incident.detectedAt.isAfter(endDate)) {
        return false;
      }
      if (roomNumber != null &&
          roomNumber.isNotEmpty &&
          !incident.roomNumber.contains(roomNumber)) {
        return false;
      }
      if (residentName != null &&
          residentName.isNotEmpty &&
          !incident.residentName.contains(residentName)) {
        return false;
      }
      if (detectionType != null &&
          detectionType.isNotEmpty &&
          incident.detectionType != detectionType) {
        return false;
      }
      if (status != null && incident.status != status) {
        return false;
      }
      return true;
    });

    return filtered.length;
  }
}
