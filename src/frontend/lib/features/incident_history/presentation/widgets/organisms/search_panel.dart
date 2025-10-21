import 'package:flutter/material.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_text_field.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_dropdown.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_button.dart';

/// 検索パネル（フィルタUI）
class SearchPanel extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? roomNumber;
  final String? personName;
  final String? assignedTo;
  final String? actionType;
  final String? incidentType;
  final ValueChanged<DateTime?> onStartDateChanged;
  final ValueChanged<DateTime?> onEndDateChanged;
  final ValueChanged<String?> onRoomNumberChanged;
  final ValueChanged<String?> onPersonNameChanged;
  final ValueChanged<String?> onAssignedToChanged;
  final ValueChanged<String?> onActionTypeChanged;
  final ValueChanged<String?> onIncidentTypeChanged;
  final VoidCallback onSearch;
  final VoidCallback? onClear;

  const SearchPanel({
    Key? key,
    this.startDate,
    this.endDate,
    this.roomNumber,
    this.personName,
    this.assignedTo,
    this.actionType,
    this.incidentType,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onRoomNumberChanged,
    required this.onPersonNameChanged,
    required this.onAssignedToChanged,
    required this.onActionTypeChanged,
    required this.onIncidentTypeChanged,
    required this.onSearch,
    this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // 開始日
            SizedBox(
              width: 180,
              child: _DateField(
                label: '開始日',
                date: startDate,
                onDateChanged: onStartDateChanged,
              ),
            ),
            const SizedBox(width: 16),
            
            // 終了日
            SizedBox(
              width: 180,
              child: _DateField(
                label: '終了日',
                date: endDate,
                onDateChanged: onEndDateChanged,
              ),
            ),
            const SizedBox(width: 16),
            
            // 部屋/ベッド番号
            SizedBox(
              width: 180,
              child: AppTextField(
                label: '部屋/ベッド番号',
                hint: roomNumber,
                onChanged: onRoomNumberChanged,
              ),
            ),
            const SizedBox(width: 16),
            
            // 見守り対象者名
            SizedBox(
              width: 180,
              child: AppTextField(
                label: '見守り対象者名',
                hint: personName,
                onChanged: onPersonNameChanged,
              ),
            ),
            const SizedBox(width: 16),
            
            // 担当者
            SizedBox(
              width: 180,
              child: AppTextField(
                label: '担当者',
                hint: assignedTo,
                onChanged: onAssignedToChanged,
              ),
            ),
            const SizedBox(width: 16),
            
            // 操作
            SizedBox(
              width: 180,
              child: AppDropdown<String>(
                label: '操作',
                value: actionType,
                items: const [
                  DropdownMenuItem(value: '', child: Text('ブランク')),
                  DropdownMenuItem(value: '対応', child: Text('対応')),
                  DropdownMenuItem(value: '完了', child: Text('完了')),
                  DropdownMenuItem(value: '訪室不要', child: Text('訪室不要')),
                  DropdownMenuItem(value: '対応不要', child: Text('対応不要')),
                  DropdownMenuItem(value: '誤検知', child: Text('誤検知')),
                ],
                onChanged: onActionTypeChanged,
              ),
            ),
            const SizedBox(width: 16),
            
            // 異常検出動作
            SizedBox(
              width: 180,
              child: AppDropdown<String>(
                label: '異常検出動作',
                value: incidentType,
                items: const [
                  DropdownMenuItem(value: '', child: Text('ブランク')),
                  DropdownMenuItem(value: '起床', child: Text('起床')),
                  DropdownMenuItem(value: '端坐位', child: Text('端坐位')),
                  DropdownMenuItem(value: '転倒', child: Text('転倒')),
                  DropdownMenuItem(value: '離床', child: Text('離床')),
                ],
                onChanged: onIncidentTypeChanged,
              ),
            ),
            const SizedBox(width: 24),
            
            // 検索ボタン
            AppButton(
              text: '検索',
              onPressed: onSearch,
              type: ButtonType.primary,
            ),
          ],
        ),
      ),
    );
  }
}

/// 日付入力フィールド
class _DateField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final ValueChanged<DateTime?> onDateChanged;

  const _DateField({
    Key? key,
    required this.label,
    required this.date,
    required this.onDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    date != null
                        ? '${date!.year}/${date!.month.toString().padLeft(2, '0')}/${date!.day.toString().padLeft(2, '0')}'
                        : 'yyyy/mm/dd',
                    style: TextStyle(
                      fontSize: 14,
                      color: date != null ? Colors.black : Colors.grey[500],
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('ja', 'JP'),
    );
    if (picked != null) {
      onDateChanged(picked);
    }
  }
}
