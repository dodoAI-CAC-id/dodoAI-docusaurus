import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mamoai/features/incident_history/domain/entities/incident.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_checkbox.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_icon_button.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_text.dart';

/// 履歴テーブルの1行を表示するMoleculeコンポーネント
class IncidentListRow extends StatelessWidget {
  final Incident incident;
  final bool isSelected;
  final ValueChanged<bool?> onSelectionChanged;
  final VoidCallback onPlayVideo;
  final VoidCallback onDownloadVideo;

  const IncidentListRow({
    Key? key,
    required this.incident,
    required this.isSelected,
    required this.onSelectionChanged,
    required this.onPlayVideo,
    required this.onDownloadVideo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelectionChanged(!isSelected),
      hoverColor: Colors.grey[100],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!),
          ),
          color: isSelected ? Colors.blue[50] : null,
        ),
        child: Row(
          children: [
            // チェックボックス
            SizedBox(
              width: 60,
              child: AppCheckbox(
                value: isSelected,
                onChanged: onSelectionChanged,
              ),
            ),
            const SizedBox(width: 16),
            
            // No（履歴番号）
            SizedBox(
              width: 60,
              child: AppText(
                text: incident.historyNumber?.toString() ?? '-',
                type: TextStyleType.body1,
              ),
            ),
            const SizedBox(width: 16),
            
            // 日付
            SizedBox(
              width: 120,
              child: AppText(
                text: _formatDate(incident.detectedAt),
                type: TextStyleType.body1,
              ),
            ),
            const SizedBox(width: 16),
            
            // 発生時間
            SizedBox(
              width: 100,
              child: AppText(
                text: _formatTime(incident.detectedAt),
                type: TextStyleType.body1,
              ),
            ),
            const SizedBox(width: 16),
            
            // 部屋/ベッド番号
            SizedBox(
              width: 110,
              child: AppText(
                text: incident.roomNumber,
                type: TextStyleType.body1,
              ),
            ),
            const SizedBox(width: 16),
            
            // 見守り対象者名
            SizedBox(
              width: 130,
              child: AppText(
                text: incident.personName,
                type: TextStyleType.body1,
              ),
            ),
            const SizedBox(width: 16),
            
            // 異常検出動作
            SizedBox(
              width: 120,
              child: AppText(
                text: incident.type,
                type: TextStyleType.body1,
              ),
            ),
            const SizedBox(width: 16),
            
            // 担当者
            SizedBox(
              width: 110,
              child: AppText(
                text: incident.assignedTo ?? '-',
                type: TextStyleType.body1,
              ),
            ),
            const SizedBox(width: 16),
            
            // 操作
            SizedBox(
              width: 100,
              child: AppText(
                text: incident.actionType ?? '-',
                type: TextStyleType.body1,
              ),
            ),
            const SizedBox(width: 16),
            
            // 対応開始時間
            SizedBox(
              width: 140,
              child: AppText(
                text: incident.responseStartedAt != null
                    ? _formatDateTime(incident.responseStartedAt!)
                    : '-',
                type: TextStyleType.body1,
              ),
            ),
            const SizedBox(width: 16),
            
            // 対応合計時間
            SizedBox(
              width: 120,
              child: AppText(
                text: _calculateDuration(
                  incident.responseStartedAt,
                  incident.responseCompletedAt,
                ),
                type: TextStyleType.body1,
              ),
            ),
            const SizedBox(width: 16),
            
            // エビデンス動画（再生・ダウンロードボタン）
            SizedBox(
              width: 140,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppIconButton(
                    icon: Icons.play_circle,
                    tooltip: '再生',
                    size: 20.0,
                    onPressed: incident.videoId != null ? onPlayVideo : null,
                  ),
                  const SizedBox(width: 8),
                  AppIconButton(
                    icon: Icons.download,
                    tooltip: 'ダウンロード',
                    size: 20.0,
                    onPressed: incident.videoId != null ? onDownloadVideo : null,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            
            // アクション（星型・ゴミ箱ボタン）
            SizedBox(
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppIconButton(
                    icon: Icons.star_border,
                    tooltip: 'お気に入り',
                    size: 20.0,
                    onPressed: () {
                      // TODO: お気に入り機能実装
                    },
                  ),
                  const SizedBox(width: 8),
                  AppIconButton(
                    icon: Icons.delete_outline,
                    tooltip: '削除',
                    size: 20.0,
                    onPressed: () {
                      // TODO: 削除機能実装
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 日付をフォーマット（yyyy/MM/dd）
  String _formatDate(DateTime dateTime) {
    return DateFormat('yyyy/MM/dd').format(dateTime);
  }

  /// 時間をフォーマット（HH:mm:ss）
  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  /// 日時をフォーマット（yyyy/MM/dd HH:mm:ss）
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy/MM/dd HH:mm:ss').format(dateTime);
  }

  /// 対応合計時間を計算（mm:ss形式）
  String _calculateDuration(DateTime? start, DateTime? end) {
    if (start == null) return '-';
    
    final endTime = end ?? DateTime.now();
    final duration = endTime.difference(start);
    
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
