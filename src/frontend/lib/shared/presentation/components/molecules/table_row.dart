import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/core/themes/app_typography.dart';

/// 履歴テーブルの行コンポーネント
/// 
/// 異常検知履歴の1行分のデータを表示します。
class HistoryTableRow extends TableRow {
  HistoryTableRow({
    required Map<String, dynamic> rowData,
    required ValueChanged<bool?> onCheckboxChanged,
    required VoidCallback onVideoPlay,
    required VoidCallback onVideoDownload,
  }) : super(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.border,
                width: 1.0,
              ),
            ),
          ),
          children: [
            // チェックボックス
            _buildCell(
              child: Checkbox(
                value: rowData['checkbox'] as bool? ?? false,
                onChanged: onCheckboxChanged,
                activeColor: AppColors.primary,
              ),
              padding: const EdgeInsets.all(8.0),
            ),
            // 履歴番号
            _buildCell(
              child: Text(
                rowData['incidentId']?.toString() ?? '',
                style: AppTypography.bodyMedium,
              ),
            ),
            // 日付
            _buildCell(
              child: Text(
                rowData['date']?.toString() ?? '',
                style: AppTypography.bodyMedium,
              ),
            ),
            // 発生時間
            _buildCell(
              child: Text(
                rowData['time']?.toString() ?? '',
                style: AppTypography.bodyMedium,
              ),
            ),
            // 部屋/ベッド番号
            _buildCell(
              child: Text(
                rowData['roomBed']?.toString() ?? '',
                style: AppTypography.bodyMedium,
              ),
            ),
            // 見守り対象者名
            _buildCell(
              child: Text(
                rowData['patientName']?.toString() ?? '',
                style: AppTypography.bodyMedium,
              ),
            ),
            // 異常検出動作
            _buildCell(
              child: Text(
                rowData['detectedAction']?.toString() ?? '',
                style: AppTypography.bodyMedium,
              ),
            ),
            // 担当者
            _buildCell(
              child: Text(
                rowData['staffName']?.toString() ?? '',
                style: AppTypography.bodyMedium,
              ),
            ),
            // 操作
            _buildCell(
              child: Text(
                rowData['actionType']?.toString() ?? '',
                style: AppTypography.bodyMedium,
              ),
            ),
            // 対応開始時間
            _buildCell(
              child: Text(
                rowData['startTime']?.toString() ?? '',
                style: AppTypography.bodyMedium,
              ),
            ),
            // 対応合計時間
            _buildCell(
              child: Text(
                rowData['totalTime']?.toString() ?? '',
                style: AppTypography.bodyMedium,
              ),
            ),
            // 動画操作
            _buildCell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.play_circle_outline,
                      color: AppColors.primary,
                    ),
                    onPressed: onVideoPlay,
                    tooltip: '動画再生',
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(
                      Icons.download,
                      color: AppColors.primary,
                    ),
                    onPressed: onVideoDownload,
                    tooltip: '動画ダウンロード',
                  ),
                ],
              ),
            ),
          ],
        );

  static Widget _buildCell({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 12.0,
      vertical: 16.0,
    ),
  }) {
    return Padding(
      padding: padding,
      child: child,
    );
  }
}
