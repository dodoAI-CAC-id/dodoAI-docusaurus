import 'package:equatable/equatable.dart';
import 'dart:math' as math;

/// ページネーション情報エンティティ
class PaginationInfo extends Equatable {
  /// 現在のページ番号
  final int currentPage;

  /// 総ページ数
  final int totalPages;

  /// 総件数
  final int totalCount;

  /// 1ページあたりの件数
  final int limit;

  /// 次のページが存在するか
  final bool hasNextPage;

  /// 前のページが存在するか
  final bool hasPreviousPage;

  const PaginationInfo({
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.limit,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  /// 総件数から自動計算してPaginationInfoを生成
  factory PaginationInfo.fromTotalCount({
    required int totalCount,
    required int limit,
    required int currentPage,
  }) {
    final totalPages = totalCount > 0 ? (totalCount / limit).ceil() : 0;
    final hasNextPage = currentPage < totalPages;
    final hasPreviousPage = currentPage > 1;

    return PaginationInfo(
      currentPage: currentPage,
      totalPages: totalPages,
      totalCount: totalCount,
      limit: limit,
      hasNextPage: hasNextPage,
      hasPreviousPage: hasPreviousPage,
    );
  }

  /// JSONからPaginationInfoを生成
  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
      totalCount: json['totalCount'] as int,
      limit: json['limit'] as int,
      hasNextPage: json['hasNextPage'] as bool,
      hasPreviousPage: json['hasPreviousPage'] as bool,
    );
  }

  /// PaginationInfoをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalCount': totalCount,
      'limit': limit,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
    };
  }

  /// 開始インデックスを取得（0始まり）
  int get startIndex => (currentPage - 1) * limit;

  /// 終了インデックスを取得（0始まり）
  int get endIndex => math.min(startIndex + limit, totalCount) - 1;

  /// 現在のページの開始番号を取得（1始まり）
  int get startNumber => totalCount > 0 ? startIndex + 1 : 0;

  /// 現在のページの終了番号を取得（1始まり）
  int get endNumber => math.min(startIndex + limit, totalCount);

  @override
  List<Object?> get props => [
        currentPage,
        totalPages,
        totalCount,
        limit,
        hasNextPage,
        hasPreviousPage,
      ];
}
