import 'package:equatable/equatable.dart';
import 'package:frontend/features/history/domain/entities/incident.dart';
import 'package:frontend/features/history/presentation/organisms/history_table.dart';

/// HistoryBlocの状態ステータス
enum HistoryStatus {
  /// 初期状態
  initial,

  /// データ読み込み中
  loading,

  /// データ読み込み成功
  success,

  /// データ読み込み失敗
  failure,
}

/// HistoryBlocの状態クラス
/// 
/// 履歴画面の表示に必要な全ての状態を保持します。
class HistoryState extends Equatable {
  /// 現在の状態ステータス
  final HistoryStatus status;

  /// インシデントのリスト
  final List<Incident> incidents;

  /// 現在のページ番号（1始まり）
  final int currentPage;

  /// 1ページあたりの表示件数
  final int pageSize;

  /// データの総件数
  final int totalCount;

  /// エラーメッセージ（エラー時のみ）
  final String? errorMessage;

  /// 検索条件のマップ
  final Map<String, dynamic> searchFilters;

  /// ソート対象の列ID
  final String sortBy;

  /// ソート順序
  final SortOrder sortOrder;

  const HistoryState({
    this.status = HistoryStatus.initial,
    this.incidents = const [],
    this.currentPage = 1,
    this.pageSize = 20,
    this.totalCount = 0,
    this.errorMessage,
    this.searchFilters = const {},
    this.sortBy = 'detectedAt',
    this.sortOrder = SortOrder.descending,
  });

  // === 計算プロパティ ===

  /// 総ページ数を計算
  int get totalPages {
    if (totalCount == 0) return 1;
    return (totalCount / pageSize).ceil();
  }

  /// データが存在するか
  bool get hasData => incidents.isNotEmpty;

  /// ローディング中か
  bool get isLoading => status == HistoryStatus.loading;

  /// 成功状態か
  bool get isSuccess => status == HistoryStatus.success;

  /// 失敗状態か
  bool get isFailure => status == HistoryStatus.failure;

  /// エラーが存在するか
  bool get hasError => errorMessage != null;

  /// 検索中か（検索条件が設定されているか）
  bool get isSearching => searchFilters.isNotEmpty;

  /// 初期状態か
  bool get isInitial => status == HistoryStatus.initial;

  /// データ表示可能か
  bool get canShowData => (isSuccess || isFailure) && hasData;

  // === メソッド ===

  /// 状態をコピーして新しい状態を作成
  HistoryState copyWith({
    HistoryStatus? status,
    List<Incident>? incidents,
    int? currentPage,
    int? pageSize,
    int? totalCount,
    String? errorMessage,
    Map<String, dynamic>? searchFilters,
    String? sortBy,
    SortOrder? sortOrder,
  }) {
    return HistoryState(
      status: status ?? this.status,
      incidents: incidents ?? this.incidents,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      errorMessage: errorMessage,
      searchFilters: searchFilters ?? this.searchFilters,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object?> get props => [
        status,
        incidents,
        currentPage,
        pageSize,
        totalCount,
        errorMessage,
        searchFilters,
        sortBy,
        sortOrder,
      ];

  @override
  String toString() {
    return 'HistoryState('
        'status: $status, '
        'incidents: ${incidents.length}, '
        'page: $currentPage/$totalPages, '
        'pageSize: $pageSize, '
        'totalCount: $totalCount, '
        'isSearching: $isSearching, '
        'sortBy: $sortBy, '
        'sortOrder: $sortOrder, '
        'errorMessage: $errorMessage'
        ')';
  }
}
