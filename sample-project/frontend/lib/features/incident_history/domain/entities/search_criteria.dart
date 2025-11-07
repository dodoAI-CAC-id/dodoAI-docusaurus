import 'package:equatable/equatable.dart';

/// 検索条件エンティティ
class SearchCriteria extends Equatable {
  /// 見守り対象者ID
  final String? personId;

  /// 見守り対象者名
  final String? personName;

  /// 部屋番号
  final String? roomNumber;

  /// ステータス（open, resolved, monitoring）
  final String? status;

  /// 担当者
  final String? assignedTo;

  /// 操作タイプ（対応、完了、訪室不要、対応不要、誤検知）
  final String? actionType;

  /// 異常検出動作（起床、端坐位、転倒、離床）
  final String? incidentType;

  /// 検索開始日
  final DateTime? fromDate;

  /// 検索終了日
  final DateTime? toDate;

  /// ページ番号
  final int page;

  /// 1ページあたりの件数
  final int limit;

  const SearchCriteria({
    this.personId,
    this.personName,
    this.roomNumber,
    this.status,
    this.assignedTo,
    this.actionType,
    this.incidentType,
    this.fromDate,
    this.toDate,
    required this.page,
    required this.limit,
  });

  /// JSONからSearchCriteriaを生成
  factory SearchCriteria.fromJson(Map<String, dynamic> json) {
    return SearchCriteria(
      personId: json['personId'] as String?,
      personName: json['personName'] as String?,
      roomNumber: json['roomNumber'] as String?,
      status: json['status'] as String?,
      assignedTo: json['assignedTo'] as String?,
      actionType: json['actionType'] as String?,
      incidentType: json['incidentType'] as String?,
      fromDate: json['fromDate'] != null
          ? DateTime.parse(json['fromDate'] as String)
          : null,
      toDate: json['toDate'] != null
          ? DateTime.parse(json['toDate'] as String)
          : null,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
    );
  }

  /// SearchCriteriaをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'personId': personId,
      'personName': personName,
      'roomNumber': roomNumber,
      'status': status,
      'assignedTo': assignedTo,
      'actionType': actionType,
      'incidentType': incidentType,
      'fromDate': fromDate?.toIso8601String(),
      'toDate': toDate?.toIso8601String(),
      'page': page,
      'limit': limit,
    };
  }

  /// クエリパラメータに変換（nullを除外）
  Map<String, String> toQueryParameters() {
    final params = <String, String>{};

    if (personId != null) params['personId'] = personId!;
    if (personName != null) params['personName'] = personName!;
    if (roomNumber != null) params['roomNumber'] = roomNumber!;
    if (status != null) params['status'] = status!;
    if (assignedTo != null) params['assignedTo'] = assignedTo!;
    if (actionType != null) params['actionType'] = actionType!;
    if (incidentType != null) params['incidentType'] = incidentType!;
    if (fromDate != null) params['fromDate'] = fromDate!.toIso8601String();
    if (toDate != null) params['toDate'] = toDate!.toIso8601String();
    params['page'] = page.toString();
    params['limit'] = limit.toString();

    return params;
  }

  /// 値を更新したコピーを作成
  SearchCriteria copyWith({
    String? personId,
    String? personName,
    String? roomNumber,
    String? status,
    String? assignedTo,
    String? actionType,
    String? incidentType,
    DateTime? fromDate,
    DateTime? toDate,
    int? page,
    int? limit,
  }) {
    return SearchCriteria(
      personId: personId ?? this.personId,
      personName: personName ?? this.personName,
      roomNumber: roomNumber ?? this.roomNumber,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      actionType: actionType ?? this.actionType,
      incidentType: incidentType ?? this.incidentType,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  @override
  List<Object?> get props => [
        personId,
        personName,
        roomNumber,
        status,
        assignedTo,
        actionType,
        incidentType,
        fromDate,
        toDate,
        page,
        limit,
      ];
}
