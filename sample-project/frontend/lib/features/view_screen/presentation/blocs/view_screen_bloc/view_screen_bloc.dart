import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../application/usecases/get_incident_items_usecase.dart';
import '../../../application/usecases/update_incident_status_usecase.dart';
import '../../../domain/repositories/i_view_screen_repository.dart';
import 'view_screen_event.dart';
import 'view_screen_state.dart';

/// ビュー画面のBLoC
class ViewScreenBloc extends Bloc<ViewScreenEvent, ViewScreenState> {
  final GetIncidentItemsUseCase getIncidentItemsUseCase;
  final UpdateIncidentStatusUseCase updateIncidentStatusUseCase;
  final IViewScreenRepository repository;

  ViewScreenBloc({
    required this.getIncidentItemsUseCase,
    required this.updateIncidentStatusUseCase,
    required this.repository,
  }) : super(const ViewScreenInitial()) {
    on<LoadIncidentItems>(_onLoadIncidentItems);
    on<RefreshIncidentItems>(_onRefreshIncidentItems);
    on<UpdateIncidentStatus>(_onUpdateIncidentStatus);
    on<ToggleAlertStatus>(_onToggleAlertStatus);
  }

  /// インシデントアイテム一覧を読み込む
  Future<void> _onLoadIncidentItems(
    LoadIncidentItems event,
    Emitter<ViewScreenState> emit,
  ) async {
    emit(const ViewScreenLoading());

    final result = await getIncidentItemsUseCase();

    result.fold(
      (failure) => emit(ViewScreenError(message: failure.message)),
      (items) => emit(ViewScreenLoaded(items: items)),
    );
  }

  /// インシデントアイテム一覧を更新（リフレッシュ）
  Future<void> _onRefreshIncidentItems(
    RefreshIncidentItems event,
    Emitter<ViewScreenState> emit,
  ) async {
    // 現在の状態を保持しながらリフレッシュ
    final currentState = state;
    if (currentState is ViewScreenLoaded) {
      // 既存のデータを表示したままバックグラウンドで更新
      final result = await getIncidentItemsUseCase();

      result.fold(
        (failure) => emit(ViewScreenError(message: failure.message)),
        (items) => emit(ViewScreenLoaded(items: items)),
      );
    } else {
      // 初回読み込みと同じ処理
      add(const LoadIncidentItems());
    }
  }

  /// インシデントのステータスを更新
  Future<void> _onUpdateIncidentStatus(
    UpdateIncidentStatus event,
    Emitter<ViewScreenState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ViewScreenLoaded) return;

    // 更新中状態に遷移
    emit(ViewScreenUpdating(
      items: currentState.items,
      updatingItemId: event.incidentId,
    ));

    final params = UpdateStatusParams(
      id: event.incidentId,
      newStatus: event.newStatus,
      actionType: event.actionType,
    );

    final result = await updateIncidentStatusUseCase(params);

    result.fold(
      (failure) {
        // エラー時は元の状態に戻す
        emit(ViewScreenLoaded(items: currentState.items));
        emit(ViewScreenError(message: failure.message));
        // エラー表示後、再度読み込み状態に戻す
        emit(ViewScreenLoaded(items: currentState.items));
      },
      (updatedItem) {
        // 更新されたアイテムでリストを更新
        final updatedItems = currentState.items.map((item) {
          return item.id == updatedItem.id ? updatedItem : item;
        }).toList();

        emit(ViewScreenLoaded(items: updatedItems));
      },
    );
  }

  /// アラートの稼働状態を切り替え
  Future<void> _onToggleAlertStatus(
    ToggleAlertStatus event,
    Emitter<ViewScreenState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ViewScreenLoaded) return;

    // 更新中状態に遷移
    emit(ViewScreenUpdating(
      items: currentState.items,
      updatingItemId: event.incidentId,
    ));

    final result = await repository.toggleAlertStatus(
      id: event.incidentId,
      isActive: event.isActive,
    );

    result.fold(
      (failure) {
        // エラー時は元の状態に戻す
        emit(ViewScreenLoaded(items: currentState.items));
        emit(ViewScreenError(message: failure.message));
        emit(ViewScreenLoaded(items: currentState.items));
      },
      (updatedItem) {
        // 更新されたアイテムでリストを更新
        final updatedItems = currentState.items.map((item) {
          return item.id == updatedItem.id ? updatedItem : item;
        }).toList();

        emit(ViewScreenLoaded(items: updatedItems));
      },
    );
  }
}
