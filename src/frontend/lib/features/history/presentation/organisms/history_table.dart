import 'package:flutter/material.dart';
import 'package:frontend/features/history/domain/entities/incident.dart';
import 'package:frontend/shared/presentation/components/molecules/table_header.dart';
import 'package:frontend/shared/presentation/components/molecules/table_row.dart';
import 'package:frontend/shared/presentation/components/molecules/pagination.dart';
import 'package:frontend/shared/presentation/components/molecules/loading_indicator.dart';
import 'package:frontend/shared/domain/models/table_column.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/core/themes/app_typography.dart';
import 'package:frontend/core/utils/accessibility_utils.dart';
import 'package:intl/intl.dart';

/// ソート順の列挙型
enum SortOrder { ascending, descending, none }

/// 履歴テーブル Organism
/// 
/// 異常検知履歴の一覧を表示する複合コンポーネント。
/// テーブルヘッダー、データ行、ページネーションを組み合わせて構成される。
class HistoryTable extends StatefulWidget {
  /// 表示するインシデントのリスト
  final List<Incident> incidents;

  /// ローディング状態
  final bool isLoading;

  /// エラーメッセージ（あれば表示）
  final String? error;

  /// 現在のページ番号（1始まり）
  final int currentPage;

  /// 総ページ数
  final int totalPages;

  /// ページサイズ（1ページあたりの表示件数）
  final int pageSize;

  /// ページ変更時のコールバック
  final Function(int page) onPageChanged;

  /// ページサイズ変更時のコールバック
  final Function(int pageSize) onPageSizeChanged;

  /// 動画再生ボタン押下時のコールバック
  final Function(String videoId) onVideoPlay;

  /// 動画ダウンロードボタン押下時のコールバック
  final Function(String videoId) onVideoDownload;

  /// ソート実行時のコールバック
  final Function(String columnId, SortOrder order) onSort;

  /// チェックボックス選択変更時のコールバック
  final Function(List<String> selectedIds) onSelectionChanged;

  /// レスポンシブブレークポイント（ピクセル）
  static const double responsiveBreakpoint = 768.0;

  const HistoryTable({
    super.key,
    required this.incidents,
    required this.isLoading,
    this.error,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.onPageChanged,
    required this.onPageSizeChanged,
    required this.onVideoPlay,
    required this.onVideoDownload,
    required this.onSort,
    required this.onSelectionChanged,
  });

  @override
  State<HistoryTable> createState() => _HistoryTableState();
}

class _HistoryTableState extends State<HistoryTable> {
  // 選択されたインシデントIDのセット
  final Set<String> _selectedIds = {};

  // ソート状態
  String? _sortedColumnKey;
  bool _sortAscending = true;

  // 日付フォーマッター
  final DateFormat _dateFormatter = DateFormat('yyyy/MM/dd');
  final DateFormat _timeFormatter = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // テーブル部分（レスポンシブ対応）
        Expanded(
          child: _buildContent(),
        ),
        
        // ページネーション
        if (!widget.isLoading && widget.error == null && widget.incidents.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Pagination(
              currentPage: widget.currentPage,
              totalPages: widget.totalPages,
              onPageChanged: widget.onPageChanged,
            ),
          ),
      ],
    );
  }

  /// コンテンツの表示（状態に応じて切り替え）
  Widget _buildContent() {
    if (widget.isLoading) {
      return const Center(child: LoadingIndicator());
    }

    if (widget.error != null) {
      return _buildErrorState();
    }

    if (widget.incidents.isEmpty) {
      return _buildEmptyState();
    }

    return _buildTable();
  }

  /// エラー状態の表示
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            widget.error!,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  /// 空状態の表示
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'データがありません',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// テーブルの表示（レスポンシブ対応）
  Widget _buildTable() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 画面幅が狭い場合は横スクロール可能にする
        if (constraints.maxWidth < HistoryTable.responsiveBreakpoint) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1200, // テーブルの最小幅
              child: _buildTableContent(),
            ),
          );
        }
        return SingleChildScrollView(
          child: _buildTableContent(),
        );
      },
    );
  }

  /// テーブル本体の構築（最適化版）
  Widget _buildTableContent() {
    final columns = _getTableColumns();
    
    // パフォーマンス最適化：ListView.builder を使用して仮想スクロール実装
    return Semantics(
      label: 'データテーブル、${widget.incidents.length}件の履歴',
      child: Column(
        children: [
          // ヘッダー（固定）
          _buildTableHeader(columns),
          
          // データ行（仮想スクロール）
          Expanded(
            child: ListView.builder(
              itemCount: widget.incidents.length,
              itemBuilder: (context, index) {
                return _buildOptimizedDataRow(widget.incidents[index], index);
              },
              // キャッシュ範囲を設定してパフォーマンス向上
              cacheExtent: 500,
            ),
          ),
        ],
      ),
    );
  }

  /// テーブルヘッダーの構築（固定ヘッダー）
  Widget _buildTableHeader(List<TableColumn> columns) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // チェックボックス列
          SizedBox(
            width: 60,
            child: Semantics(
              label: 'すべて選択',
              child: Checkbox(
                value: _selectedIds.length == widget.incidents.length && 
                       widget.incidents.isNotEmpty,
                onChanged: (selected) {
                  setState(() {
                    if (selected == true) {
                      _selectedIds.addAll(widget.incidents.map((i) => i.id));
                    } else {
                      _selectedIds.clear();
                    }
                  });
                  widget.onSelectionChanged(_selectedIds.toList());
                },
              ),
            ),
          ),
          ...columns.asMap().entries.map((entry) {
            return _buildOptimizedHeaderCell(entry.value, entry.key);
          }).toList(),
        ],
      ),
    );
  }

  /// 最適化されたヘッダーセル
  Widget _buildOptimizedHeaderCell(TableColumn column, int index) {
    final isSorted = _sortedColumnKey == column.key;
    final canSort = column.sortable && column.key != null;
    
    final widthMap = {
      0: 100.0, // 履歴番号
      1: 120.0, // 日付
      2: 80.0,  // 発生時間
      3: 120.0, // 部屋/ベッド
      4: 150.0, // 見守り対象者名
      5: 150.0, // 異常検出動作
      6: 100.0, // 担当者
      7: 100.0, // 操作
      8: 100.0, // 対応開始
      9: 100.0, // 対応時間
      10: 150.0, // 動画
    };

    return SizedBox(
      width: widthMap[index],
      child: InkWell(
        onTap: canSort
            ? () {
                setState(() {
                  if (isSorted) {
                    _sortAscending = !_sortAscending;
                  } else {
                    _sortedColumnKey = column.key;
                    _sortAscending = true;
                  }
                });
                final sortOrder = _sortAscending 
                    ? SortOrder.ascending 
                    : SortOrder.descending;
                widget.onSort(column.key!, sortOrder);
              }
            : null,
        child: Semantics(
          button: canSort,
          label: canSort
              ? '${column.label}でソート、'
                '現在${isSorted ? (_sortAscending ? "昇順" : "降順") : "未ソート"}'
              : column.label,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    column.label,
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (canSort) ...[
                  const SizedBox(width: 4),
                  Icon(
                    isSorted
                        ? (_sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                        : Icons.arrow_upward,
                    size: 16,
                    color: isSorted ? AppColors.primary : Colors.grey,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 最適化されたデータ行の構築
  Widget _buildOptimizedDataRow(Incident incident, int index) {
    final isSelected = _selectedIds.contains(incident.id);
    final rowData = _incidentToRowData(incident, isSelected);

    // セマンティックラベルを生成
    final semanticLabel = AccessibilityUtils.tableRowLabel(
      incidentId: incident.incidentId,
      date: _dateFormatter.format(incident.detectedAt),
      time: _timeFormatter.format(incident.detectedAt),
      roomBed: '${incident.roomNumber}/${incident.bedNumber}',
      patientName: incident.residentName,
      detectedAction: incident.detectionType,
      status: _getStatusLabel(incident.status),
    );

    return Semantics(
      label: semanticLabel,
      child: Container(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.white : Colors.grey[50],
          border: Border(
            bottom: BorderSide(color: AppColors.border, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            // チェックボックス
            SizedBox(
              width: 60,
              child: Checkbox(
                value: isSelected,
                onChanged: (selected) {
                  setState(() {
                    if (selected == true) {
                      _selectedIds.add(incident.id);
                    } else {
                      _selectedIds.remove(incident.id);
                    }
                  });
                  widget.onSelectionChanged(_selectedIds.toList());
                },
              ),
            ),
            // データセル
            _buildDataCell(rowData['incidentId'], 100),
            _buildDataCell(rowData['date'], 120),
            _buildDataCell(rowData['time'], 80),
            _buildDataCell(rowData['roomBed'], 120),
            _buildDataCell(rowData['patientName'], 150),
            _buildDataCell(rowData['detectedAction'], 150),
            _buildDataCell(rowData['staffName'], 100),
            _buildDataCell(rowData['actionType'], 100),
            _buildDataCell(rowData['startTime'], 100),
            _buildDataCell(rowData['totalTime'], 100),
            _buildVideoActionCell(incident.videoId ?? '', incident.incidentId, 150),
          ],
        ),
      ),
    );
  }

  /// データセルの構築
  Widget _buildDataCell(String value, double width) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          value,
          style: AppTypography.bodyMedium,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  /// 動画操作セルの構築
  Widget _buildVideoActionCell(String videoId, String incidentId, double width) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Semantics(
              button: true,
              label: AccessibilityUtils.videoPlayLabel(incidentId),
              child: IconButton(
                icon: const Icon(Icons.play_circle_outline),
                onPressed: () => widget.onVideoPlay(videoId),
                tooltip: '動画再生',
                iconSize: 24,
              ),
            ),
            Semantics(
              button: true,
              label: AccessibilityUtils.videoDownloadLabel(incidentId),
              child: IconButton(
                icon: const Icon(Icons.download),
                onPressed: () => widget.onVideoDownload(videoId),
                tooltip: '動画ダウンロード',
                iconSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }


  /// テーブルカラム定義を取得
  List<TableColumn> _getTableColumns() {
    return [
      const TableColumn(label: '履歴番号', width: 100, sortable: true, key: 'incidentId'),
      const TableColumn(label: '日付', width: 120, sortable: true, key: 'date'),
      const TableColumn(label: '発生時間', width: 80, sortable: true, key: 'time'),
      const TableColumn(label: '部屋/ベッド', width: 120, sortable: true, key: 'roomBed'),
      const TableColumn(label: '見守り対象者', width: 150, sortable: true, key: 'patientName'),
      const TableColumn(label: '異常検出動作', width: 150, sortable: true, key: 'detectedAction'),
      const TableColumn(label: '担当者', width: 100, sortable: false),
      const TableColumn(label: '操作', width: 100, sortable: true, key: 'actionType'),
      const TableColumn(label: '対応開始', width: 100, sortable: false),
      const TableColumn(label: '対応時間', width: 100, sortable: false),
      const TableColumn(label: '動画', width: 120, sortable: false),
    ];
  }


  /// Incident エンティティを行データに変換
  Map<String, dynamic> _incidentToRowData(Incident incident, bool isSelected) {
    return {
      'checkbox': isSelected,
      'incidentId': incident.incidentId,
      'date': _dateFormatter.format(incident.detectedAt),
      'time': _timeFormatter.format(incident.detectedAt),
      'roomBed': '${incident.roomNumber}/${incident.bedNumber}',
      'patientName': incident.residentName,
      'detectedAction': incident.detectionType,
      'staffName': incident.actions.isNotEmpty ? incident.actions.first.performedBy : '-',
      'actionType': _getStatusLabel(incident.status),
      'startTime': incident.actions.isNotEmpty
          ? _timeFormatter.format(incident.actions.first.performedAt)
          : '-',
      'totalTime': _calculateTotalTime(incident.actions),
    };
  }

  /// ステータスのラベルを取得
  String _getStatusLabel(IncidentStatus status) {
    switch (status) {
      case IncidentStatus.detected:
        return '検知済み';
      case IncidentStatus.confirmed:
        return '確認済み';
      case IncidentStatus.inProgress:
        return '対応中';
      case IncidentStatus.resolved:
        return '解決済み';
    }
  }

  /// 対応合計時間を計算
  String _calculateTotalTime(List<dynamic> actions) {
    if (actions.isEmpty) {
      return '-';
    }

    // 最初の対応から最後の対応までの時間を計算
    final firstAction = actions.first;
    final lastAction = actions.last;
    
    if (firstAction.performedAt is! DateTime || lastAction.performedAt is! DateTime) {
      return '-';
    }

    final duration = lastAction.performedAt.difference(firstAction.performedAt);
    final minutes = duration.inMinutes;
    
    if (minutes < 1) {
      return '< 1分';
    }
    
    if (minutes < 60) {
      return '$minutes分';
    }
    
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    
    if (remainingMinutes == 0) {
      return '$hours時間';
    }
    
    return '$hours時間$remainingMinutes分';
  }
}
