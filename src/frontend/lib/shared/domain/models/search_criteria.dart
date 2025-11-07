/// 検索条件を表すモデルクラス
class SearchCriteria {
  /// 開始日
  final DateTime? startDate;

  /// 終了日
  final DateTime? endDate;

  /// 部屋/ベッド番号
  final String? roomBedNumber;

  /// 見守り対象者名
  final String? targetPersonName;

  /// 担当者名（スタッフ名）
  final String? staffName;

  /// 操作（対応時の押下ボタン名）
  final String? actionType;

  /// 異常検出動作（異常検出された姿勢）
  final String? detectionType;

  const SearchCriteria({
    this.startDate,
    this.endDate,
    this.roomBedNumber,
    this.targetPersonName,
    this.staffName,
    this.actionType,
    this.detectionType,
  });

  /// 空の検索条件を作成
  factory SearchCriteria.empty() {
    return const SearchCriteria();
  }

  /// 検索条件をコピーして新しいインスタンスを作成
  SearchCriteria copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? roomBedNumber,
    String? targetPersonName,
    String? staffName,
    String? actionType,
    String? detectionType,
    bool clearStartDate = false,
    bool clearEndDate = false,
    bool clearRoomBedNumber = false,
    bool clearTargetPersonName = false,
    bool clearStaffName = false,
    bool clearActionType = false,
    bool clearDetectionType = false,
  }) {
    return SearchCriteria(
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      roomBedNumber: clearRoomBedNumber ? null : (roomBedNumber ?? this.roomBedNumber),
      targetPersonName: clearTargetPersonName ? null : (targetPersonName ?? this.targetPersonName),
      staffName: clearStaffName ? null : (staffName ?? this.staffName),
      actionType: clearActionType ? null : (actionType ?? this.actionType),
      detectionType: clearDetectionType ? null : (detectionType ?? this.detectionType),
    );
  }

  /// 全ての検索条件が空かどうかを判定
  bool get isEmpty {
    return startDate == null &&
        endDate == null &&
        (roomBedNumber == null || roomBedNumber!.isEmpty) &&
        (targetPersonName == null || targetPersonName!.isEmpty) &&
        (staffName == null || staffName!.isEmpty) &&
        (actionType == null || actionType!.isEmpty) &&
        (detectionType == null || detectionType!.isEmpty);
  }

  /// 少なくとも1つの検索条件が設定されているかを判定
  bool get isNotEmpty => !isEmpty;

  @override
  String toString() {
    return 'SearchCriteria('
        'startDate: $startDate, '
        'endDate: $endDate, '
        'roomBedNumber: $roomBedNumber, '
        'targetPersonName: $targetPersonName, '
        'staffName: $staffName, '
        'actionType: $actionType, '
        'detectionType: $detectionType'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchCriteria &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.roomBedNumber == roomBedNumber &&
        other.targetPersonName == targetPersonName &&
        other.staffName == staffName &&
        other.actionType == actionType &&
        other.detectionType == detectionType;
  }

  @override
  int get hashCode {
    return startDate.hashCode ^
        endDate.hashCode ^
        roomBedNumber.hashCode ^
        targetPersonName.hashCode ^
        staffName.hashCode ^
        actionType.hashCode ^
        detectionType.hashCode;
  }
}
