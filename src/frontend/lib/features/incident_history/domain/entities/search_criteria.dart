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
        fromDate,
        toDate,
        page,
        limit,
      ];
}
