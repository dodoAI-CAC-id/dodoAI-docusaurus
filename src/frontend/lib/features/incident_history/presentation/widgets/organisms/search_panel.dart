import 'package:flutter/material.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_button.dart';
import 'package:mamoai/features/incident_history/presentation/widgets/molecules/search_criteria_input.dart';

/// 検索パネルのOrganismコンポーネント
/// SearchCriteriaInputと検索/クリアボタンを組み合わせたパネル
class SearchPanel extends StatelessWidget {
  final String? personName;
  final String? incidentType;
  final String? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<String?> onPersonNameChanged;
  final ValueChanged<String?> onIncidentTypeChanged;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<DateTime?> onStartDateChanged;
  final ValueChanged<DateTime?> onEndDateChanged;
  final VoidCallback onSearch;
  final VoidCallback onClear;

  const SearchPanel({
    Key? key,
    required this.personName,
    required this.incidentType,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.onPersonNameChanged,
    required this.onIncidentTypeChanged,
    required this.onStatusChanged,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onSearch,
    required this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 検索条件入力
            SearchCriteriaInput(
              personName: personName,
              incidentType: incidentType,
              status: status,
              startDate: startDate,
              endDate: endDate,
              onPersonNameChanged: onPersonNameChanged,
              onIncidentTypeChanged: onIncidentTypeChanged,
              onStatusChanged: onStatusChanged,
              onStartDateChanged: onStartDateChanged,
              onEndDateChanged: onEndDateChanged,
            ),
            const SizedBox(height: 16),

            // ボタン
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  text: 'クリア',
                  type: ButtonType.secondary,
                  onPressed: onClear,
                ),
                const SizedBox(width: 16),
                AppButton(
                  text: '検索',
                  icon: Icons.search,
                  onPressed: onSearch,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
