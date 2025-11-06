import 'package:flutter/material.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_text_field.dart';

/// 期間選択（開始日〜終了日）を行うMoleculeコンポーネント
class DateRangePicker extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTime?> onStartDateChanged;
  final ValueChanged<DateTime?> onEndDateChanged;

  const DateRangePicker({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 開始日
        Expanded(
          child: AppTextField(
            label: '開始日',
            hint: 'yyyy/mm/dd',
            controller: TextEditingController(
              text: startDate != null ? _formatDate(startDate!) : '',
            ),
            readOnly: true,
            suffixIcon: const Icon(Icons.calendar_today),
            onTap: () => _selectStartDate(context),
          ),
        ),
        const SizedBox(width: 16),
        
        // 終了日
        Expanded(
          child: AppTextField(
            label: '終了日',
            hint: 'yyyy/mm/dd',
            controller: TextEditingController(
              text: endDate != null ? _formatDate(endDate!) : '',
            ),
            readOnly: true,
            suffixIcon: const Icon(Icons.calendar_today),
            onTap: () => _selectEndDate(context),
          ),
        ),
      ],
    );
  }

  /// 開始日を選択
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      onStartDateChanged(picked);
    }
  }

  /// 終了日を選択
  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? startDate ?? DateTime.now(),
      firstDate: startDate ?? DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      onEndDateChanged(picked);
    }
  }

  /// 日付をフォーマット（yyyy/MM/dd）
  String _formatDate(DateTime date) {
    return '${date.year}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
