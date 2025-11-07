import 'package:equatable/equatable.dart';
import 'package:frontend/features/history/domain/entities/incident.dart';
import 'package:frontend/features/history/presentation/organisms/history_table.dart';

/// HistoryBlocのイベント基底クラス
abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

/// 初期データ取得イベント
/// 
/// 履歴画面の初期表示時に最新20件のデータを取得します。
class HistoryInitialFetchRequested extends HistoryEvent {
  const HistoryInitialFetchRequested();
}

/// ページ変更イベント
/// 
/// ページネーションでページを変更する際に使用します。
class HistoryPageChanged extends HistoryEvent {
  final int page;
  final int pageSize;

  const HistoryPageChanged({
    required this.page,
    required this.pageSize,
  });

  @override
  List<Object?> get props => [page, pageSize];
}

/// ページサイズ変更イベント
/// 
/// 1ページあたりの表示件数（20/50/100件）を変更する際に使用します。
/// ページサイズ変更時は1ページ目に戻ります。
class HistoryPageSizeChanged extends HistoryEvent {
  final int pageSize;

  const HistoryPageSizeChanged({required this.pageSize});

  @override
  List<Object?> get props => [pageSize];
}

/// ソート順の列挙型
enum HistorySortOrder {
  ascending,
  descending,
}

/// 検索実行イベント
/// 
/// 検索フォームから検索条件を指定してデータを検索します。
class HistorySearchRequested extends HistoryEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? roomNumber;
  final String? bedNumber;
  final String? residentName;
  final String? performedBy;
  final String? detectionType;
  final IncidentStatus? status;

  const HistorySearchRequested({
    this.startDate,
    this.endDate,
    this.roomNumber,
    this.bedNumber,
    this.residentName,
    this.performedBy,
    this.detectionType,
    this.status,
  });

  @override
  List<Object?> get props => [
        startDate,
        endDate,
        roomNumber,
        bedNumber,
        residentName,
        performedBy,
        detectionType,
        status,
      ];
}

/// 検索条件クリアイベント
/// 
/// 検索条件をクリアして初期データを再取得します。
class HistorySearchCleared extends HistoryEvent {
  const HistorySearchCleared();
}

/// リフレッシュイベント
/// 
/// 現在の表示状態（検索中 or 通常表示）を保持したまま
/// データを再取得します。
class HistoryRefreshRequested extends HistoryEvent {
  const HistoryRefreshRequested();
}

/// ソート変更イベント
/// 
/// テーブルの列ソートを変更する際に使用します。
class HistorySortChanged extends HistoryEvent {
  final String sortBy;
  final HistorySortOrder sortOrder;

  const HistorySortChanged({
    required this.sortBy,
    required this.sortOrder,
  });

  @override
  List<Object?> get props => [sortBy, sortOrder];
}
