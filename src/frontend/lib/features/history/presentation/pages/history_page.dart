import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/history/presentation/blocs/history/history_bloc.dart';
import 'package:frontend/features/history/presentation/blocs/history/history_event.dart';
import 'package:frontend/features/history/presentation/blocs/history/history_state.dart';
import 'package:frontend/features/history/presentation/organisms/history_table.dart';
import 'package:frontend/features/history/presentation/organisms/video_player_modal.dart';
import 'package:frontend/shared/presentation/components/molecules/search_form.dart';
import 'package:frontend/shared/domain/models/search_criteria.dart';
import 'package:frontend/features/history/domain/entities/incident.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/core/themes/app_typography.dart';
import 'package:frontend/core/utils/accessibility_utils.dart';

// キーボードショートカット用のIntentクラス
class _SearchFocusIntent extends Intent {
  const _SearchFocusIntent();
}

class _RefreshIntent extends Intent {
  const _RefreshIntent();
}

class _NextPageIntent extends Intent {
  const _NextPageIntent();
}

class _PreviousPageIntent extends Intent {
  const _PreviousPageIntent();
}

class _CloseModalIntent extends Intent {
  const _CloseModalIntent();
}

/// 履歴画面
///
/// 異常検知履歴の一覧表示・検索・動画再生機能を提供するメインページ。
/// HistoryBlocを使用して状態管理を行う。
/// キーボードショートカットとアクセシビリティ機能を含む。
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // 検索フォームの表示/非表示
  bool _isSearchVisible = false;

  // 動画プレーヤーモーダルの表示状態
  String? _playingVideoId;
  String? _playingVideoUrl;

  // フォーカスノード
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _pageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 初期データ取得
    context.read<HistoryBloc>().add(const HistoryInitialFetchRequested());
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _pageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        KeyboardShortcuts.searchFocus: const _SearchFocusIntent(),
        KeyboardShortcuts.refresh: const _RefreshIntent(),
        KeyboardShortcuts.nextPage: const _NextPageIntent(),
        KeyboardShortcuts.previousPage: const _PreviousPageIntent(),
        KeyboardShortcuts.closeModal: const _CloseModalIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _SearchFocusIntent: CallbackAction<_SearchFocusIntent>(
            onInvoke: (_) => _handleSearchFocus(),
          ),
          _RefreshIntent: CallbackAction<_RefreshIntent>(
            onInvoke: (_) => _handleRefresh(),
          ),
          _NextPageIntent: CallbackAction<_NextPageIntent>(
            onInvoke: (_) => _handleNextPage(),
          ),
          _PreviousPageIntent: CallbackAction<_PreviousPageIntent>(
            onInvoke: (_) => _handlePreviousPage(),
          ),
          _CloseModalIntent: CallbackAction<_CloseModalIntent>(
            onInvoke: (_) => _handleCloseModal(),
          ),
        },
        child: Focus(
          autofocus: true,
          focusNode: _pageFocusNode,
          child: Semantics(
            label: '異常検知履歴画面',
            child: Scaffold(
              backgroundColor: AppColors.background,
              appBar: _buildAppBar(),
              body: Column(
                children: [
                  // 検索フォーム（表示切替可能）
                  if (_isSearchVisible) _buildSearchForm(),

                  // メインコンテンツ（HistoryTable）
                  Expanded(
                    child: _buildContent(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// AppBar構築
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        '異常検知履歴',
        style: AppTypography.headlineMedium.copyWith(
          color: AppColors.onPrimary,
        ),
      ),
      backgroundColor: AppColors.primary,
      elevation: 2,
      actions: [
        // 検索ボタン
        Semantics(
          button: true,
          label: _isSearchVisible ? '検索を閉じる' : '検索を開く',
          hint: 'Ctrl+Fでも開けます',
          child: IconButton(
            icon: Icon(
              _isSearchVisible ? Icons.search_off : Icons.search,
              color: AppColors.onPrimary,
            ),
            onPressed: () {
              setState(() {
                _isSearchVisible = !_isSearchVisible;
              });
            },
            tooltip: _isSearchVisible ? '検索を閉じる (Ctrl+F)' : '検索を開く (Ctrl+F)',
          ),
        ),

        // リフレッシュボタン
        BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            return Semantics(
              button: true,
              label: 'データを再読み込み',
              hint: 'Ctrl+Rでも実行できます',
              child: IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: AppColors.onPrimary,
                ),
                onPressed: state.isLoading
                    ? null
                    : () {
                        context
                            .read<HistoryBloc>()
                            .add(const HistoryRefreshRequested());
                      },
                tooltip: 'リフレッシュ (Ctrl+R)',
              ),
            );
          },
        ),

        const SizedBox(width: 8),
      ],
    );
  }

  /// 検索フォーム構築
  Widget _buildSearchForm() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          return Focus(
            focusNode: _searchFocusNode,
            child: SearchForm(
              onSearch: _handleSearch,
              initialValues: _convertFiltersToSearchCriteria(state.searchFilters),
            ),
          );
        },
      ),
    );
  }

  /// メインコンテンツ構築
  Widget _buildContent() {
    return BlocConsumer<HistoryBloc, HistoryState>(
      listener: (context, state) {
        // エラー発生時にスナックバーを表示
        if (state.isFailure && state.errorMessage != null) {
          ScreenReaderAnnouncer.announceError(context, state.errorMessage!);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: '再試行',
                textColor: AppColors.onError,
                onPressed: () {
                  context.read<HistoryBloc>().add(
                        const HistoryRefreshRequested(),
                      );
                },
              ),
            ),
          );
        }

        // データ読み込み完了時のアナウンス
        if (state.isSuccess && !state.isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScreenReaderAnnouncer.announcePageLoaded(
              context,
              state.incidents.length,
            );
          });
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            // HistoryTable
            HistoryTable(
              incidents: state.incidents,
              isLoading: state.isLoading,
              error: state.isFailure ? state.errorMessage : null,
              currentPage: state.currentPage,
              totalPages: state.totalPages,
              pageSize: state.pageSize,
              onPageChanged: (page) {
                context.read<HistoryBloc>().add(
                      HistoryPageChanged(
                        page: page,
                        pageSize: state.pageSize,
                      ),
                    );
              },
              onPageSizeChanged: (pageSize) {
                context.read<HistoryBloc>().add(
                      HistoryPageSizeChanged(pageSize: pageSize),
                    );
              },
              onVideoPlay: _handleVideoPlay,
              onVideoDownload: _handleVideoDownload,
              onSort: (columnId, order) {
                final sortOrder = order == SortOrder.ascending
                    ? HistorySortOrder.ascending
                    : HistorySortOrder.descending;
                context.read<HistoryBloc>().add(
                      HistorySortChanged(
                        sortBy: columnId,
                        sortOrder: sortOrder,
                      ),
                    );
              },
              onSelectionChanged: _handleSelectionChanged,
            ),

            // 動画プレーヤーモーダル（オーバーレイ）
            if (_playingVideoId != null && _playingVideoUrl != null)
              _buildVideoPlayerOverlay(),
          ],
        );
      },
    );
  }

  /// 動画プレーヤーオーバーレイ構築
  Widget _buildVideoPlayerOverlay() {
    return Semantics(
      label: '動画プレーヤーモーダル、Escキーで閉じます',
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 800,
              maxHeight: 600,
            ),
            margin: const EdgeInsets.all(32),
            child: VideoPlayerModal(
              videoId: _playingVideoId!,
              videoUrl: _playingVideoUrl!,
              onClose: () {
                setState(() {
                  _playingVideoId = null;
                  _playingVideoUrl = null;
                });
                ScreenReaderAnnouncer.announce(context, '動画プレーヤーを閉じました');
              },
              onDownload: () {
                _handleVideoDownload(_playingVideoId!);
              },
              onError: (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error),
                    backgroundColor: AppColors.error,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// 検索実行ハンドラー
  void _handleSearch(SearchCriteria criteria) {
    context.read<HistoryBloc>().add(
          HistorySearchRequested(
            startDate: criteria.startDate,
            endDate: criteria.endDate,
            roomNumber: criteria.roomBedNumber?.split('/').first,
            bedNumber: criteria.roomBedNumber?.split('/').last,
            residentName: criteria.targetPersonName,
            performedBy: criteria.staffName,
            detectionType: criteria.detectionType,
            status: _mapActionTypeToStatus(criteria.actionType),
          ),
        );
  }

  /// 検索クリアハンドラー
  void _handleSearchClear() {
    context.read<HistoryBloc>().add(const HistorySearchCleared());
  }

  /// 動画再生ハンドラー
  void _handleVideoPlay(String videoId) {
    // TODO: 実際のAPIから動画URLを取得
    // 現在は仮のURLを使用
    setState(() {
      _playingVideoId = videoId;
      _playingVideoUrl = 'https://example.com/videos/$videoId.mp4';
    });
    ScreenReaderAnnouncer.announce(context, '動画プレーヤーを開きました');
  }

  /// 動画ダウンロードハンドラー
  void _handleVideoDownload(String videoId) {
    // TODO: 実際のダウンロード処理を実装
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('動画のダウンロードを開始しました: $videoId'),
        duration: const Duration(seconds: 2),
      ),
    );
    ScreenReaderAnnouncer.announceSuccess(
      context,
      '動画のダウンロードを開始しました',
    );
  }

  /// 選択変更ハンドラー
  void _handleSelectionChanged(List<String> selectedIds) {
    // TODO: 選択されたIDで何らかの操作を行う場合に実装
    debugPrint('Selected IDs: $selectedIds');
  }

  /// キーボードショートカット: 検索フォーカス
  void _handleSearchFocus() {
    setState(() {
      _isSearchVisible = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusHelper.requestFocus(context, _searchFocusNode);
      ScreenReaderAnnouncer.announce(context, '検索フォームを開きました');
    });
  }

  /// キーボードショートカット: リフレッシュ
  void _handleRefresh() {
    final state = context.read<HistoryBloc>().state;
    if (!state.isLoading) {
      context.read<HistoryBloc>().add(const HistoryRefreshRequested());
      ScreenReaderAnnouncer.announce(context, 'データを再読み込みしています');
    }
  }

  /// キーボードショートカット: 次のページ
  void _handleNextPage() {
    final state = context.read<HistoryBloc>().state;
    if (state.currentPage < state.totalPages && !state.isLoading) {
      context.read<HistoryBloc>().add(
            HistoryPageChanged(
              page: state.currentPage + 1,
              pageSize: state.pageSize,
            ),
          );
      ScreenReaderAnnouncer.announce(
        context,
        '次のページに移動しました。${AccessibilityUtils.paginationLabel(state.currentPage + 1, state.totalPages)}',
      );
    }
  }

  /// キーボードショートカット: 前のページ
  void _handlePreviousPage() {
    final state = context.read<HistoryBloc>().state;
    if (state.currentPage > 1 && !state.isLoading) {
      context.read<HistoryBloc>().add(
            HistoryPageChanged(
              page: state.currentPage - 1,
              pageSize: state.pageSize,
            ),
          );
      ScreenReaderAnnouncer.announce(
        context,
        '前のページに移動しました。${AccessibilityUtils.paginationLabel(state.currentPage - 1, state.totalPages)}',
      );
    }
  }

  /// キーボードショートカット: モーダルを閉じる
  void _handleCloseModal() {
    if (_playingVideoId != null) {
      setState(() {
        _playingVideoId = null;
        _playingVideoUrl = null;
      });
      ScreenReaderAnnouncer.announce(context, '動画プレーヤーを閉じました');
    }
  }

  /// HistoryBlocの検索フィルターをSearchCriteriaに変換
  SearchCriteria? _convertFiltersToSearchCriteria(
    Map<String, dynamic> filters,
  ) {
    if (filters.isEmpty) return null;

    return SearchCriteria(
      startDate: filters['startDate'] as DateTime?,
      endDate: filters['endDate'] as DateTime?,
      roomBedNumber: _combineRoomBed(
        filters['roomNumber'] as String?,
        filters['bedNumber'] as String?,
      ),
      targetPersonName: filters['residentName'] as String?,
      staffName: filters['performedBy'] as String?,
      actionType: _mapStatusToActionType(filters['status'] as IncidentStatus?),
      detectionType: filters['detectionType'] as String?,
    );
  }

  /// 部屋番号とベッド番号を結合
  String? _combineRoomBed(String? roomNumber, String? bedNumber) {
    if (roomNumber == null && bedNumber == null) return null;
    if (roomNumber != null && bedNumber != null) {
      return '$roomNumber/$bedNumber';
    }
    return roomNumber ?? bedNumber;
  }

  /// 操作タイプをIncidentStatusにマッピング
  IncidentStatus? _mapActionTypeToStatus(String? actionType) {
    if (actionType == null || actionType.isEmpty) return null;

    switch (actionType) {
      case '対応':
        return IncidentStatus.inProgress;
      case '完了':
        return IncidentStatus.resolved;
      case '訪室不要':
      case '対応不要':
      case '誤検知':
        return IncidentStatus.confirmed;
      default:
        return null;
    }
  }

  /// IncidentStatusを操作タイプにマッピング
  String? _mapStatusToActionType(IncidentStatus? status) {
    if (status == null) return null;

    switch (status) {
      case IncidentStatus.detected:
        return '';
      case IncidentStatus.confirmed:
        return '確認済み';
      case IncidentStatus.inProgress:
        return '対応';
      case IncidentStatus.resolved:
        return '完了';
    }
  }
}
