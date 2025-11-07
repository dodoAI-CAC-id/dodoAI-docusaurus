import 'package:flutter/material.dart';
import 'package:frontend/shared/domain/models/table_column.dart';
import 'package:frontend/shared/presentation/components/atoms/app_checkbox.dart';

/// テーブルヘッダー行コンポーネント
/// 
/// テーブルのヘッダー行を表示するMoleculeコンポーネント。
/// 全選択チェックボックス、カラムラベル、ソート機能を提供する。
class TableHeader extends StatelessWidget {
  /// テーブルカラムのリスト
  final List<TableColumn> columns;

  /// 全選択チェックボックスの状態変更時のコールバック
  final ValueChanged<bool> onSelectAll;

  /// 全選択チェックボックスの状態
  final bool isAllSelected;

  /// ソート時のコールバック（カラムキー、昇順/降順）
  final void Function(String columnKey, bool ascending)? onSort;

  /// 現在ソート中のカラムキー
  final String? sortedColumnKey;

  /// ソート順（true: 昇順、false: 降順）
  final bool sortAscending;

  const TableHeader({
    super.key,
    required this.columns,
    required this.onSelectAll,
    this.isAllSelected = false,
    this.onSort,
    this.sortedColumnKey,
    this.sortAscending = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[400]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // 全選択チェックボックス
          SizedBox(
            width: 60,
            child: Center(
              child: AppCheckbox(
                value: isAllSelected,
                onChanged: onSelectAll,
              ),
            ),
          ),
          // カラムヘッダー
          ...columns.map((column) => _buildColumnHeader(context, column)),
        ],
      ),
    );
  }

  /// カラムヘッダーを構築
  Widget _buildColumnHeader(BuildContext context, TableColumn column) {
    final isSorted = sortedColumnKey == column.key;
    final canSort = column.sortable && column.key != null && onSort != null;

    Widget headerContent = Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            column.label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            overflow: TextOverflow.ellipsis,
          ),
          if (canSort) ...[
            const SizedBox(width: 4),
            Icon(
              isSorted
                  ? (sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                  : Icons.arrow_upward,
              size: 16,
              color: isSorted ? Theme.of(context).colorScheme.primary : Colors.grey,
            ),
          ],
        ],
      ),
    );

    return SizedBox(
      width: column.width,
      child: canSort
          ? InkWell(
              onTap: () {
                if (column.key != null) {
                  // 同じカラムをタップした場合は昇順/降順を切り替え
                  final newAscending = isSorted ? !sortAscending : true;
                  onSort?.call(column.key!, newAscending);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: headerContent,
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: headerContent,
            ),
    );
  }
}
