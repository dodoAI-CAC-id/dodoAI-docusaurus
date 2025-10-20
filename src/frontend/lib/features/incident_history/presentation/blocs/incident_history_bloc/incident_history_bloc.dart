import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamoai/features/incident_history/presentation/blocs/incident_history_bloc/incident_history_event.dart';
import 'package:mamoai/features/incident_history/presentation/blocs/incident_history_bloc/incident_history_state.dart';
import 'package:mamoai/features/incident_history/application/usecases/get_incidents_usecase.dart';
import 'package:mamoai/features/incident_history/application/usecases/get_video_usecase.dart';
import 'package:mamoai/features/incident_history/domain/entities/search_criteria.dart';

/// 異常イベント履歴画面のBLoC
class IncidentHistoryBloc
    extends Bloc<IncidentHistoryEvent, IncidentHistoryState> {
  final GetIncidentsUseCase getIncidentsUseCase;
  final GetVideoUseCase getVideoUseCase;

  // 現在の検索条件を保持
  SearchCriteria? _currentCriteria;

  IncidentHistoryBloc({
    required this.getIncidentsUseCase,
    required this.getVideoUseCase,
  }) : super(IncidentHistoryInitial()) {
    on<LoadIncidentsEvent>(_onLoadIncidents);
    on<SearchIncidentsEvent>(_onSearchIncidents);
    on<ChangePageEvent>(_onChangePage);
    on<PlayVideoEvent>(_onPlayVideo);
  }

  /// 初期表示イベントハンドラ
  Future<void> _onLoadIncidents(
    LoadIncidentsEvent event,
    Emitter<IncidentHistoryState> emit,
  ) async {
    emit(IncidentHistoryLoading());

    final result = await getIncidentsUseCase(const GetIncidentsParams());

    result.fold(
      (failure) => emit(IncidentHistoryError(failure.message)),
      (incidentListResult) => emit(IncidentHistoryLoaded(
        incidents: incidentListResult.incidents,
        paginationInfo: incidentListResult.paginationInfo,
      )),
    );
  }

  /// 検索実行イベントハンドラ
  Future<void> _onSearchIncidents(
    SearchIncidentsEvent event,
    Emitter<IncidentHistoryState> emit,
  ) async {
    emit(IncidentHistoryLoading());

    // 検索条件を作成
    _currentCriteria = SearchCriteria(
      personId: event.personId,
      personName: event.personName,
      roomNumber: event.roomNumber,
      status: event.status,
      fromDate: event.fromDate,
      toDate: event.toDate,
      page: 1,
      limit: 20,
    );

    final result = await getIncidentsUseCase(
      GetIncidentsParams(criteria: _currentCriteria),
    );

    result.fold(
      (failure) => emit(IncidentHistoryError(failure.message)),
      (incidentListResult) => emit(IncidentHistoryLoaded(
        incidents: incidentListResult.incidents,
        paginationInfo: incidentListResult.paginationInfo,
      )),
    );
  }

  /// ページ変更イベントハンドラ
  Future<void> _onChangePage(
    ChangePageEvent event,
    Emitter<IncidentHistoryState> emit,
  ) async {
    emit(IncidentHistoryLoading());

    // 現在の検索条件でページ番号のみ変更
    final criteria = _currentCriteria?.copyWith(page: event.pageNumber) ??
        SearchCriteria(
          page: event.pageNumber,
          limit: 20,
        );

    final result = await getIncidentsUseCase(
      GetIncidentsParams(criteria: criteria),
    );

    result.fold(
      (failure) => emit(IncidentHistoryError(failure.message)),
      (incidentListResult) => emit(IncidentHistoryLoaded(
        incidents: incidentListResult.incidents,
        paginationInfo: incidentListResult.paginationInfo,
      )),
    );
  }

  /// 動画再生イベントハンドラ
  Future<void> _onPlayVideo(
    PlayVideoEvent event,
    Emitter<IncidentHistoryState> emit,
  ) async {
    final result = await getVideoUseCase(
      GetVideoParams(videoId: event.videoId),
    );

    result.fold(
      (failure) => emit(IncidentHistoryError(failure.message)),
      (videoUrl) => emit(VideoPlayingState(videoUrl)),
    );
  }
}
