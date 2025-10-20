import 'package:flutter/material.dart';
import 'package:mamoai/features/incident_history/domain/entities/incident.dart';
import 'package:mamoai/features/incident_history/presentation/widgets/molecules/incident_list_row.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_text.dart';

/// インシデント一覧テーブルのOrganismコンポーネント
/// IncidentListRowを複数組み合わせたテーブル
class IncidentListTable extends StatelessWidget {
  final List<Incident> incidents;
  final Set<String> selectedIncidentIds;
  final Function(String id, bool selected) onSelectionChanged;
  final Function(String id) onPlayVideo;
  final Function(String id) onDownloadVideo;

  const IncidentListTable({
    Key? key,
    required this.incidents,
    required this.selectedIncidentIds,
    required this.onSelectionChanged,
    required this.onPlayVideo,
    required this.onDownloadVideo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (incidents.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: AppText(
            text: 'データがありません',
            type: TextStyleType.body1,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ヘッダー
            _buildHeader(),
            // インシデント行
            ...incidents.map((incident) => IncidentListRow(
                  incident: incident,
                  isSelected: selectedIncidentIds.contains(incident.id),
                  onSelectionChanged: (selected) {
                    onSelectionChanged(incident.id, selected ?? false);
                  },
                  onPlayVideo: () => onPlayVideo(incident.id),
                  onDownloadVideo: () => onDownloadVideo(incident.id),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border(
          bottom: BorderSide(color: Colors.grey[400]!, width: 2),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          // 全選択チェックボックス
          SizedBox(
            width: 48,
            child: Checkbox(
              value: selectedIncidentIds.length == incidents.length &&
                  incidents.isNotEmpty,
              tristate: selectedIncidentIds.isNotEmpty &&
                  selectedIncidentIds.length < incidents.length,
              onChanged: (value) {
                // 全選択/全解除の処理は親コンポーネントで実装
              },
            ),
          ),
          const SizedBox(width: 16),
          // ヘッダーラベル
          _buildHeaderCell('検知日時', 150),
          _buildHeaderCell('異常タイプ', 100),
          _buildHeaderCell('見守り対象者', 120),
          _buildHeaderCell('部屋番号', 80),
          _buildHeaderCell('ステータス', 100),
          _buildHeaderCell('操作', 120),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String label, double width) {
    return SizedBox(
      width: width,
      child: AppText(
        text: label,
        type: TextStyleType.body1,
        textAlign: TextAlign.left,
      ),
    );
  }
}
