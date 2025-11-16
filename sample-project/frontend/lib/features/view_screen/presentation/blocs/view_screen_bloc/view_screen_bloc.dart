import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../application/usecases/get_incident_items_usecase.dart';
import '../../../application/usecases/update_incident_status_usecase.dart';
import '../../../domain/entities/incident_status.dart';
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
    on<SimulateIncidentDetected>(_onSimulateIncidentDetected);
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

    await result.fold<Future<void>>(
      (failure) async {
        // エラー時は元の状態に戻す
        emit(ViewScreenLoaded(items: currentState.items));
        emit(ViewScreenError(message: failure.message));
        // エラー表示後、再度読み込み状態に戻す
        emit(ViewScreenLoaded(items: currentState.items));
      },
      (updatedItem) async {
        // 更新成功後、一覧を再フェッチして最新状態を反映
        final refreshResult = await getIncidentItemsUseCase();
        
        await refreshResult.fold<Future<void>>(
          (failure) async {
            // 再フェッチ失敗時は元の状態に戻す
            emit(ViewScreenLoaded(items: currentState.items));
            emit(ViewScreenError(message: failure.message));
            emit(ViewScreenLoaded(items: currentState.items));
          },
          (freshItems) async {
            // 最新の一覧で状態を更新
            emit(ViewScreenLoaded(items: freshItems));
          },
        );
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

    await result.fold<Future<void>>(
      (failure) async {
        // エラー時は元の状態に戻す
        emit(ViewScreenLoaded(items: currentState.items));
        emit(ViewScreenError(message: failure.message));
        emit(ViewScreenLoaded(items: currentState.items));
      },
      (updatedItem) async {
        // 更新成功後、一覧を再フェッチして最新状態を反映
        final refreshResult = await getIncidentItemsUseCase();
        
        await refreshResult.fold<Future<void>>(
          (failure) async {
            // 再フェッチ失敗時は元の状態に戻す
            emit(ViewScreenLoaded(items: currentState.items));
            emit(ViewScreenError(message: failure.message));
            emit(ViewScreenLoaded(items: currentState.items));
          },
          (freshItems) async {
            // 最新の一覧で状態を更新
            emit(ViewScreenLoaded(items: freshItems));
          },
        );
      },
    );
  }

  /// 異常検知をシミュレーション（開発用）
  Future<void> _onSimulateIncidentDetected(
    SimulateIncidentDetected event,
    Emitter<ViewScreenState> emit,
  ) async {
    await _handleDetected(event.incidentId, event.cameraId, emit);
  }

  /// 異常検知処理の共通ハンドラ（シミュレーション＋将来のPush受信で共用）
  Future<void> _handleDetected(
    String incidentId,
    String cameraId,
    Emitter<ViewScreenState> emit,
  ) async {
    final current = state;
    if (current is! ViewScreenLoaded) {
      add(const LoadIncidentItems());
      return;
    }

    // ターゲット選定（incidentId + cameraId で検証）
    final targetIndex = current.items.indexWhere(
      (x) => x.id == incidentId && x.cameraId == cameraId,
    );

    if (targetIndex == -1) {
      // 対象が見つからない場合はログ出力して終了
      print('[SimulateDetection] Incident not found: '
            'incidentId=$incidentId, cameraId=$cameraId');
      emit(ViewScreenLoaded(items: current.items));
      emit(ViewScreenError(
        message: 'インシデントが見つかりません (ID: $incidentId, Camera: $cameraId)',
      ));
      emit(ViewScreenLoaded(items: current.items));
      return;
    }

    final target = current.items[targetIndex];

    // 冪等性: 既に open/inProgress の場合はDB更新をスキップ
    if (target.status == IncidentStatus.unhandled ||
        target.status == IncidentStatus.inProgress) {
      // UI通知とハイライトのみ実施
      emit(ViewScreenLoaded(
        items: current.items,
        highlightedItemId: target.id,
      ));

      // 3秒後に解除
      Timer(const Duration(seconds: 3), () {
        final s = state;
        if (s is ViewScreenLoaded && s.highlightedItemId == target.id) {
          emit(ViewScreenLoaded(items: s.items, highlightedItemId: null));
        }
      });

      // ログ出力
      print('[SimulateDetection] Already active: '
            'incidentId=$incidentId, cameraId=$cameraId, status=${target.status}');
      return;
    }

    // 更新中状態
    emit(ViewScreenUpdating(
      items: current.items,
      updatingItemId: target.id,
    ));

    // ステータス更新（resolved → open）
    print('[SimulateDetection] Updating status: '
          'incidentId=$incidentId, cameraId=$cameraId, '
          'from=${target.status} to=open');

    final params = UpdateStatusParams(
      id: target.id,
      newStatus: IncidentStatus.unhandled,
      actionType: 'detected_camera',
    );

    final result = await updateIncidentStatusUseCase(params);

    await result.fold<Future<void>>(
      (failure) async {
        emit(ViewScreenLoaded(items: current.items));
        emit(ViewScreenError(message: failure.message));
        emit(ViewScreenLoaded(items: current.items));
      },
      (updated) async {
        // 一覧再フェッチ
        final refreshResult = await getIncidentItemsUseCase();

        await refreshResult.fold<Future<void>>(
          (failure) async {
            emit(ViewScreenLoaded(items: current.items));
            emit(ViewScreenError(message: failure.message));
            emit(ViewScreenLoaded(items: current.items));
          },
          (freshItems) async {
            // ハイライト付与
            emit(ViewScreenLoaded(
              items: freshItems,
              highlightedItemId: target.id,
            ));

            // 3秒後に解除
            Timer(const Duration(seconds: 3), () {
              final s = state;
              if (s is ViewScreenLoaded && s.highlightedItemId == target.id) {
                emit(ViewScreenLoaded(items: s.items, highlightedItemId: null));
              }
            });
          },
        );
      },
    );
  }
}
