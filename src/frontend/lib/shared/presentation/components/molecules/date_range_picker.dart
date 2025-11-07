import 'package:flutter/material.dart';
import 'package:frontend/core/utils/date_formatter.dart';

/// 日付範囲選択コンポーネント
/// 
/// 開始日と終了日を選択するためのMoleculeコンポーネント。
/// レスポンシブデザインに対応し、画面幅に応じて縦並び/横並びを切り替える。
class DateRangePicker extends StatelessWidget {
  /// 開始日
  final DateTime? startDate;

  /// 終了日
  final DateTime? endDate;

  /// 開始日変更時のコールバック
  final ValueChanged<DateTime?> onStartDateChanged;

  /// 終了日変更時のコールバック
  final ValueChanged<DateTime?> onEndDateChanged;

  /// 開始日のラベル（デフォルト：'開始日'）
  final String startLabel;

  /// 終了日のラベル（デフォルト：'終了日'）
  final String endLabel;

  /// レスポンシブレイアウトの閾値（ピクセル）
  static const double _responsiveBreakpoint = 600.0;

  const DateRangePicker({
    super.key,
    this.startDate,
    this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    this.startLabel = '開始日',
    this.endLabel = '終了日',
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth >= _responsiveBreakpoint;

        if (isWideScreen) {
          return _buildWideLayout(context);
        } else {
          return _buildNarrowLayout(context);
        }
      },
    );
  }

  /// 広い画面用のレイアウト（横並び）
  Widget _buildWideLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildDateField(
            context: context,
            label: startLabel,
            date: startDate,
            onDateChanged: onStartDateChanged,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDateField(
            context: context,
            label: endLabel,
            date: endDate,
            onDateChanged: onEndDateChanged,
          ),
        ),
      ],
    );
  }

  /// 狭い画面用のレイアウト（縦並び）
  Widget _buildNarrowLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDateField(
          context: context,
          label: startLabel,
          date: startDate,
          onDateChanged: onStartDateChanged,
        ),
        const SizedBox(height: 16),
        _buildDateField(
          context: context,
          label: endLabel,
          date: endDate,
          onDateChanged: onEndDateChanged,
        ),
        if (_hasDateRangeError()) ...[
          const SizedBox(height: 8),
          _buildErrorMessage(),
        ],
      ],
    );
  }

  /// 日付入力フィールドを構築
  Widget _buildDateField({
    required BuildContext context,
    required String label,
    required DateTime? date,
    required ValueChanged<DateTime?> onDateChanged,
  }) {
    final dateText = date != null ? DateFormatter.formatDate(date) : '';

    return TextField(
      controller: TextEditingController(text: dateText),
      decoration: InputDecoration(
        labelText: label,
        hintText: 'yyyy/mm/dd',
        border: const OutlineInputBorder(),
        suffixIcon: date != null
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => onDateChanged(null),
              )
            : const Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () => _showDatePicker(context, date, onDateChanged),
    );
  }

  /// 日付選択ダイアログを表示
  Future<void> _showDatePicker(
    BuildContext context,
    DateTime? initialDate,
    ValueChanged<DateTime?> onDateChanged,
  ) async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      onDateChanged(selectedDate);
    }
  }

  /// 日付範囲にエラーがあるかチェック
  bool _hasDateRangeError() {
    if (startDate == null || endDate == null) {
      return false;
    }
    return endDate!.isBefore(startDate!);
  }

  /// エラーメッセージを構築
  Widget _buildErrorMessage() {
    return const Text(
      '終了日は開始日以降の日付を選択してください',
      style: TextStyle(
        color: Colors.red,
        fontSize: 12,
      ),
    );
  }
}
