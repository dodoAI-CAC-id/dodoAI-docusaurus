import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/history/domain/entities/incident.dart';
import 'package:frontend/features/history/domain/repositories/i_incident_repository.dart';
import 'package:frontend/features/history/presentation/blocs/history/history_event.dart';
import 'package:frontend/features/history/presentation/blocs/history/history_state.dart';
import 'package:frontend/features/history/presentation/organisms/history_table.dart';

/// 履歴画面の状態管理を行うBLoC
/// 
/// HistoryBlocは以下の責務を持ちます：
/// - インシデントデータの取得・検索
/// - ページネーション管理
/// - ソート管理
/// - 検索条件の管理
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final IIncidentRepository _incidentRepository;

  HistoryBloc({
    required IIncidentRepository incidentRepository,
  })  : _incidentRepository = incidentRepository,
        super(const HistoryState()) {
    // イベントハンドラーの登録
    on<HistoryInitialFetchRequested>(_onInitialFetchRequested);
    on<HistoryPageChanged>(_onPageChanged);
    on<HistoryPageSizeChanged>(_onPageSizeChanged);
    on<HistorySearchRequested>(_onSearchRequested);
    on<HistorySearchCleared>(_onSearchCleared);
    on<HistoryRefreshRequested>(_onRefreshRequested);
    on<HistorySortChanged>(_onSortChanged);
  }

  /// 初期データ取得イベントハンドラー
  /// 
  /// 履歴画面の初期表示時に最新20件のデータを取得します。
  Future<void> _onInitialFetchRequested(
    HistoryInitialFetchRequested event,
    Emitter<HistoryState> emit,
  ) async {
    emit(state.copyWith(status: HistoryStatus.loading));

    try {
      final incidents = await _incidentRepository.fetchIncidents(
        limit: state.pageSize,
        offset: 0,
        orderBy: state.sortBy,
        descending: state.sortOrder == SortOrder.descending,
      );

      final totalCount = await _incidentRepository.countIncidents();

      emit(state.copyWith(
        status: HistoryStatus.success,
        incidents: incidents,
        currentPage: 1,
        totalCount: totalCount,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HistoryStatus.failure,
        errorMessage: 'データの取得に失敗しました: ${e.toString()}',
      ));
    }
  }

  /// ページ変更イベントハンドラー
  /// 
  /// ページネーションでページを変更する際に実行されます。
  /// 検索中の場合は検索条件を保持してデータを取得します。
  Future<void> _onPageChanged(
    HistoryPageChanged event,
    Emitter<HistoryState> emit,
  ) async {
    emit(state.copyWith(status: HistoryStatus.loading));

    try {
      final offset = (event.page - 1) * event.pageSize;

      List<Incident> incidents;
      int totalCount;

      if (state.isSearching) {
        // 検索モード：検索条件を使用してデータ取得
        incidents = await _incidentRepository.searchIncidents(
          startDate: state.searchFilters['startDate'],
          endDate: state.searchFilters['endDate'],
          roomNumber: state.searchFilters['roomNumber'],
          bedNumber: state.searchFilters['bedNumber'],
          residentName: state.searchFilters['residentName'],
          performedBy: state.searchFilters['performedBy'],
          detectionType: state.searchFilters['detectionType'],
          status: state.searchFilters['status'],
          limit: event.pageSize,
          offset: offset,
        );

        totalCount = await _incidentRepository.countSearchResults(
          startDate: state.searchFilters['startDate'],
          endDate: state.searchFilters['endDate'],
          roomNumber: state.searchFilters['roomNumber'],
          bedNumber: state.searchFilters['bedNumber'],
          residentName: state.searchFilters['residentName'],
          performedBy: state.searchFilters['performedBy'],
          detectionType: state.searchFilters['detectionType'],
          status: state.searchFilters['status'],
        );
      } else {
        // 通常モード：全データから取得
        incidents = await _incidentRepository.fetchIncidents(
          limit: event.pageSize,
          offset: offset,
          orderBy: state.sortBy,
          descending: state.sortOrder == SortOrder.descending,
        );

        totalCount = await _incidentRepository.countIncidents();
      }

      emit(state.copyWith(
        status: HistoryStatus.success,
        incidents: incidents,
        currentPage: event.page,
        pageSize: event.pageSize,
        totalCount: totalCount,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HistoryStatus.failure,
        errorMessage: 'ページの取得に失敗しました: ${e.toString()}',
      ));
    }
  }

  /// ページサイズ変更イベントハンドラー
  /// 
  /// 1ページあたりの表示件数（20/50/100件）を変更します。
  /// ページサイズ変更時は1ページ目に戻ります。
  Future<void> _onPageSizeChanged(
    HistoryPageSizeChanged event,
    Emitter<HistoryState> emit,
  ) async {
    // ページサイズ変更時は1ページ目に戻す
    add(HistoryPageChanged(page: 1, pageSize: event.pageSize));
  }

  /// 検索実行イベントハンドラー
  /// 
  /// 検索フォームから検索条件を指定してデータを検索します。
  /// 検索実行時は1ページ目に戻ります。
  Future<void> _onSearchRequested(
    HistorySearchRequested event,
    Emitter<HistoryState> emit,
  ) async {
    emit(state.copyWith(status: HistoryStatus.loading));

    try {
      final searchFilters = {
        'startDate': event.startDate,
        'endDate': event.endDate,
        'roomNumber': event.roomNumber,
        'bedNumber': event.bedNumber,
        'residentName': event.residentName,
        'performedBy': event.performedBy,
        'detectionType': event.detectionType,
        'status': event.status,
      };

      final incidents = await _incidentRepository.searchIncidents(
        startDate: event.startDate,
        endDate: event.endDate,
        roomNumber: event.roomNumber,
        bedNumber: event.bedNumber,
        residentName: event.residentName,
        performedBy: event.performedBy,
        detectionType: event.detectionType,
        status: event.status,
        limit: state.pageSize,
        offset: 0,
      );

      final totalCount = await _incidentRepository.countSearchResults(
        startDate: event.startDate,
        endDate: event.endDate,
        roomNumber: event.roomNumber,
        bedNumber: event.bedNumber,
        residentName: event.residentName,
        performedBy: event.performedBy,
        detectionType: event.detectionType,
        status: event.status,
      );

      emit(state.copyWith(
        status: HistoryStatus.success,
        incidents: incidents,
        currentPage: 1,
        totalCount: totalCount,
        searchFilters: searchFilters,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HistoryStatus.failure,
        errorMessage: '検索に失敗しました: ${e.toString()}',
      ));
    }
  }

  /// 検索条件クリアイベントハンドラー
  /// 
  /// 検索条件をクリアして初期データを再取得します。
  Future<void> _onSearchCleared(
    HistorySearchCleared event,
    Emitter<HistoryState> emit,
  ) async {
    emit(state.copyWith(
      searchFilters: {},
    ));

    // 検索クリア後は初期データを再取得
    add(const HistoryInitialFetchRequested());
  }

  /// リフレッシュイベントハンドラー
  /// 
  /// 現在の表示状態（検索中 or 通常表示）を保持したまま
  /// データを再取得します。
  Future<void> _onRefreshRequested(
    HistoryRefreshRequested event,
    Emitter<HistoryState> emit,
  ) async {
    if (state.isSearching) {
      // 検索中の場合は検索を再実行
      final filters = state.searchFilters;
      add(HistorySearchRequested(
        startDate: filters['startDate'],
        endDate: filters['endDate'],
        roomNumber: filters['roomNumber'],
        bedNumber: filters['bedNumber'],
        residentName: filters['residentName'],
        performedBy: filters['performedBy'],
        detectionType: filters['detectionType'],
        status: filters['status'],
      ));
    } else {
      // 通常データの場合は現在のページを再取得
      add(HistoryPageChanged(
        page: state.currentPage,
        pageSize: state.pageSize,
      ));
    }
  }

  /// ソート変更イベントハンドラー
  /// 
  /// テーブルの列ソートを変更します。
  /// ソート変更後は1ページ目から再取得します。
  Future<void> _onSortChanged(
    HistorySortChanged event,
    Emitter<HistoryState> emit,
  ) async {
    // HistorySortOrderをSortOrderに変換
    final sortOrder = event.sortOrder == HistorySortOrder.ascending
        ? SortOrder.ascending
        : SortOrder.descending;
    
    emit(state.copyWith(
      sortBy: event.sortBy,
      sortOrder: sortOrder,
    ));

    // ソート変更後は1ページ目から再取得
    if (state.isSearching) {
      // 検索中の場合は検索を再実行
      final filters = state.searchFilters;
      add(HistorySearchRequested(
        startDate: filters['startDate'],
        endDate: filters['endDate'],
        roomNumber: filters['roomNumber'],
        bedNumber: filters['bedNumber'],
        residentName: filters['residentName'],
        performedBy: filters['performedBy'],
        detectionType: filters['detectionType'],
        status: filters['status'],
      ));
    } else {
      // 通常データの場合は初期取得を再実行
      add(const HistoryInitialFetchRequested());
    }
  }
}
