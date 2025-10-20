import 'package:flutter/material.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
              width: 48,
              child: AppCheckbox(
                value: isSelected,
                onChanged: onSelectionChanged,
              ),
            ),
            
            // 日時
            Expanded(
              flex: 2,
              child: AppText(
                text: _formatDateTime(incident.detectedAt),
                type: TextStyleType.body1,
              ),
            ),
            
            // 異常タイプ
            Expanded(
              flex: 1,
              child: AppText(
                text: incident.type,
                type: TextStyleType.body1,
              ),
            ),
            
            // 対象者名
            Expanded(
              flex: 2,
              child: AppText(
                text: incident.personName,
                type: TextStyleType.body1,
              ),
            ),
            
            // 部屋番号
            Expanded(
              flex: 1,
              child: AppText(
                text: incident.roomNumber,
                type: TextStyleType.body1,
              ),
            ),
            
            // ステータス
            Expanded(
              flex: 1,
              child: _buildStatusChip(incident.status),
            ),
            
            // アクションボタン
            SizedBox(
              width: 110,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
          ],
        ),
      ),
    );
  }

  /// 日時をフォーマット（yyyy/MM/dd HH:mm）
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}/'
        '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// ステータスチップを構築
  Widget _buildStatusChip(String status) {
    final statusInfo = _getStatusInfo(status);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: statusInfo['color'],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: AppText(
        text: statusInfo['text'],
        type: TextStyleType.body2,
        color: Colors.white,
        textAlign: TextAlign.center,
      ),
    );
  }

  /// ステータス情報を取得
  Map<String, dynamic> _getStatusInfo(String status) {
    switch (status) {
      case 'open':
        return {
          'text': '未対応',
          'color': Colors.red[400],
        };
      case 'resolved':
        return {
          'text': '対応済み',
          'color': Colors.green[400],
        };
      case 'monitoring':
        return {
          'text': '監視中',
          'color': Colors.orange[400],
        };
      default:
        return {
          'text': status,
          'color': Colors.grey[400],
        };
    }
  }
}
