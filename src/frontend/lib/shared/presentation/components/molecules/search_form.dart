import 'package:flutter/material.dart';
import 'package:frontend/shared/domain/models/search_criteria.dart';
import 'package:frontend/shared/presentation/components/molecules/date_range_picker.dart';
import 'package:frontend/shared/presentation/components/atoms/app_text_field.dart';
import 'package:frontend/shared/presentation/components/atoms/app_dropdown.dart';
import 'package:frontend/shared/presentation/components/atoms/app_button.dart';

/// 検索フォームコンポーネント
/// 
/// 複数の検索条件を入力し、検索を実行するためのMoleculeコンポーネント。
/// DateRangePicker、AppTextField、AppDropdown、AppButtonを組み合わせて構成される。
class SearchForm extends StatefulWidget {
  /// 検索実行時のコールバック
  final ValueChanged<SearchCriteria> onSearch;

  /// 初期値
  final SearchCriteria? initialValues;

  /// レスポンシブレイアウトの閾値（ピクセル）
  static const double responsiveBreakpoint = 900.0;

  const SearchForm({
    super.key,
    required this.onSearch,
    this.initialValues,
  });

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  String _roomBedNumber = '';
  String _targetPersonName = '';
  String _staffName = '';

  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedActionType;
  String? _selectedDetectionType;

  // 操作の選択肢
  final List<DropdownOption> _actionTypeOptions = [
    const DropdownOption(value: '', label: ''),
    const DropdownOption(value: '対応', label: '対応'),
    const DropdownOption(value: '完了', label: '完了'),
    const DropdownOption(value: '訪室不要', label: '訪室不要'),
    const DropdownOption(value: '対応不要', label: '対応不要'),
    const DropdownOption(value: '誤検知', label: '誤検知'),
  ];

  // 異常検出動作の選択肢
  final List<DropdownOption> _detectionTypeOptions = [
    const DropdownOption(value: '', label: ''),
    const DropdownOption(value: '起床', label: '起床'),
    const DropdownOption(value: '端坐位', label: '端坐位'),
    const DropdownOption(value: '転倒', label: '転倒'),
    const DropdownOption(value: '離床', label: '離床'),
  ];

  @override
  void initState() {
    super.initState();
    
    final initial = widget.initialValues;
    _startDate = initial?.startDate;
    _endDate = initial?.endDate;
    _selectedActionType = initial?.actionType;
    _selectedDetectionType = initial?.detectionType;
    _roomBedNumber = initial?.roomBedNumber ?? '';
    _targetPersonName = initial?.targetPersonName ?? '';
    _staffName = initial?.staffName ?? '';
  }

  void _handleSearch() {
    final criteria = SearchCriteria(
      startDate: _startDate,
      endDate: _endDate,
      roomBedNumber: _roomBedNumber.isEmpty ? null : _roomBedNumber,
      targetPersonName: _targetPersonName.isEmpty ? null : _targetPersonName,
      staffName: _staffName.isEmpty ? null : _staffName,
      actionType: _selectedActionType?.isEmpty ?? true ? null : _selectedActionType,
      detectionType: _selectedDetectionType?.isEmpty ?? true ? null : _selectedDetectionType,
    );
    widget.onSearch(criteria);
  }

  void _handleClear() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectedActionType = null;
      _selectedDetectionType = null;
      _roomBedNumber = '';
      _targetPersonName = '';
      _staffName = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth >= SearchForm.responsiveBreakpoint;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 日付範囲選択
              DateRangePicker(
                startDate: _startDate,
                endDate: _endDate,
                onStartDateChanged: (date) {
                  setState(() {
                    _startDate = date;
                  });
                },
                onEndDateChanged: (date) {
                  setState(() {
                    _endDate = date;
                  });
                },
              ),
              const SizedBox(height: 16),

              // テキストフィールド群（レスポンシブレイアウト）
              if (isWideScreen)
                _buildWideTextFields()
              else
                _buildNarrowTextFields(),

              const SizedBox(height: 16),

              // ドロップダウン群（レスポンシブレイアウト）
              if (isWideScreen)
                _buildWideDropdowns()
              else
                _buildNarrowDropdowns(),

              const SizedBox(height: 24),

              // ボタン群
              _buildButtons(),
            ],
          ),
        );
      },
    );
  }

  /// 広い画面用のテキストフィールドレイアウト（横並び）
  Widget _buildWideTextFields() {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            value: _roomBedNumber,
            onChanged: (value) {
              setState(() {
                _roomBedNumber = value;
              });
            },
            label: '部屋/ベッド番号',
            placeholder: '例: TW02-01',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AppTextField(
            value: _targetPersonName,
            onChanged: (value) {
              setState(() {
                _targetPersonName = value;
              });
            },
            label: '見守り対象者名',
            placeholder: '例: 田中太郎',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AppTextField(
            value: _staffName,
            onChanged: (value) {
              setState(() {
                _staffName = value;
              });
            },
            label: '担当者',
            placeholder: '例: Admin',
          ),
        ),
      ],
    );
  }

  /// 狭い画面用のテキストフィールドレイアウト（縦並び）
  Widget _buildNarrowTextFields() {
    return Column(
      children: [
        AppTextField(
          value: _roomBedNumber,
          onChanged: (value) {
            setState(() {
              _roomBedNumber = value;
            });
          },
          label: '部屋/ベッド番号',
          placeholder: '例: TW02-01',
        ),
        const SizedBox(height: 16),
        AppTextField(
          value: _targetPersonName,
          onChanged: (value) {
            setState(() {
              _targetPersonName = value;
            });
          },
          label: '見守り対象者名',
          placeholder: '例: 田中太郎',
        ),
        const SizedBox(height: 16),
        AppTextField(
          value: _staffName,
          onChanged: (value) {
            setState(() {
              _staffName = value;
            });
          },
          label: '担当者',
          placeholder: '例: Admin',
        ),
      ],
    );
  }

  /// 広い画面用のドロップダウンレイアウト（横並び）
  Widget _buildWideDropdowns() {
    return Row(
      children: [
        Expanded(
          child: AppDropdown(
            value: _selectedActionType,
            options: _actionTypeOptions,
            label: '操作',
            placeholder: '選択してください',
            onChanged: (value) {
              setState(() {
                _selectedActionType = value;
              });
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AppDropdown(
            value: _selectedDetectionType,
            options: _detectionTypeOptions,
            label: '異常検出動作',
            placeholder: '選択してください',
            onChanged: (value) {
              setState(() {
                _selectedDetectionType = value;
              });
            },
          ),
        ),
        const Expanded(child: SizedBox()), // 3列目を空にして左寄せ
      ],
    );
  }

  /// 狭い画面用のドロップダウンレイアウト（縦並び）
  Widget _buildNarrowDropdowns() {
    return Column(
      children: [
        AppDropdown(
          value: _selectedActionType,
          options: _actionTypeOptions,
          label: '操作',
          placeholder: '選択してください',
          onChanged: (value) {
            setState(() {
              _selectedActionType = value;
            });
          },
        ),
        const SizedBox(height: 16),
        AppDropdown(
          value: _selectedDetectionType,
          options: _detectionTypeOptions,
          label: '異常検出動作',
          placeholder: '選択してください',
          onChanged: (value) {
            setState(() {
              _selectedDetectionType = value;
            });
          },
        ),
      ],
    );
  }

  /// ボタン群（検索とクリア）
  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppButton(
          label: '検索',
          onPressed: _handleSearch,
          variant: ButtonVariant.primary,
        ),
        const SizedBox(width: 16),
        AppButton(
          label: 'クリア',
          onPressed: _handleClear,
          variant: ButtonVariant.secondary,
        ),
      ],
    );
  }
}
