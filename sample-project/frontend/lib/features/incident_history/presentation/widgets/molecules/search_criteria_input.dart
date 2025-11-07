import 'package:flutter/material.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_text_field.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_dropdown.dart';
import 'package:mamoai/features/incident_history/presentation/widgets/molecules/date_range_picker.dart';

/// 検索条件入力フォームのMoleculeコンポーネント
class SearchCriteriaInput extends StatelessWidget {
  final String? personName;
  final String? incidentType;
  final String? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<String> onPersonNameChanged;
  final ValueChanged<String?> onIncidentTypeChanged;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<DateTime?> onStartDateChanged;
  final ValueChanged<DateTime?> onEndDateChanged;

  const SearchCriteriaInput({
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 見守り対象者名
        AppTextField(
          label: '見守り対象者名',
          hint: '例: 山田太郎',
          controller: TextEditingController(text: personName ?? ''),
          onChanged: onPersonNameChanged,
        ),
        const SizedBox(height: 16),

        // 異常タイプと ステータス（横並び）
        Row(
          children: [
            // 異常タイプ
            Expanded(
              child: AppDropdown<String>(
                label: '異常タイプ',
                hint: '選択してください',
                value: incidentType,
                items: const [
                  DropdownMenuItem(value: '転倒', child: Text('転倒')),
                  DropdownMenuItem(value: '徘徊', child: Text('徘徊')),
                  DropdownMenuItem(value: '離床', child: Text('離床')),
                ],
                onChanged: onIncidentTypeChanged,
              ),
            ),
            const SizedBox(width: 16),

            // ステータス
            Expanded(
              child: AppDropdown<String>(
                label: 'ステータス',
                hint: '選択してください',
                value: status,
                items: const [
                  DropdownMenuItem(value: 'open', child: Text('未対応')),
                  DropdownMenuItem(value: 'resolved', child: Text('対応済み')),
                  DropdownMenuItem(value: 'monitoring', child: Text('監視中')),
                ],
                onChanged: onStatusChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 期間選択
        DateRangePicker(
          startDate: startDate,
          endDate: endDate,
          onStartDateChanged: onStartDateChanged,
          onEndDateChanged: onEndDateChanged,
        ),
      ],
    );
  }
}
