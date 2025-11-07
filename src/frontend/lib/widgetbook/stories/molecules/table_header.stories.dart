import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:frontend/shared/presentation/components/molecules/table_header.dart';
import 'package:frontend/shared/domain/models/table_column.dart';

/// TableHeader stories for Widgetbook
WidgetbookComponent tableHeaderStories() {
  return WidgetbookComponent(
    name: 'TableHeader',
    useCases: [
      WidgetbookUseCase(
        name: 'Default',
        builder: (context) => _buildDefaultUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'With Selection',
        builder: (context) => _buildWithSelectionUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'With Sortable Columns',
        builder: (context) => _buildWithSortableColumnsUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'Interactive',
        builder: (context) => _buildInteractiveUseCase(context),
      ),
    ],
  );
}

Widget _buildDefaultUseCase(BuildContext context) {
  final columns = [
    const TableColumn(label: 'No', width: 60),
    const TableColumn(label: '日付', width: 100),
    const TableColumn(label: '発生時間', width: 100),
    const TableColumn(label: '部屋/ベッド番号', width: 120),
    const TableColumn(label: '見守り対象者名', width: 150),
    const TableColumn(label: '担当者', width: 100),
    const TableColumn(label: '操作', width: 100),
  ];

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: TableHeader(
      columns: columns,
      onSelectAll: (value) {
        debugPrint('Select all: $value');
      },
    ),
  );
}

Widget _buildWithSelectionUseCase(BuildContext context) {
  final columns = [
    const TableColumn(label: 'No', width: 60),
    const TableColumn(label: '日付', width: 100),
    const TableColumn(label: '発生時間', width: 100),
    const TableColumn(label: '部屋/ベッド番号', width: 120),
  ];

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: TableHeader(
      columns: columns,
      onSelectAll: (value) {
        debugPrint('Select all: $value');
      },
      isAllSelected: true,
    ),
  );
}

Widget _buildWithSortableColumnsUseCase(BuildContext context) {
  final columns = [
    const TableColumn(label: 'No', width: 60, sortable: true, key: 'no'),
    const TableColumn(label: '日付', width: 100, sortable: true, key: 'date'),
    const TableColumn(label: '発生時間', width: 100, sortable: true, key: 'time'),
    const TableColumn(label: '部屋/ベッド番号', width: 120, sortable: false),
    const TableColumn(label: '見守り対象者名', width: 150, sortable: false),
  ];

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: TableHeader(
      columns: columns,
      onSelectAll: (value) {
        debugPrint('Select all: $value');
      },
      onSort: (columnKey, ascending) {
        debugPrint('Sort by $columnKey, ascending: $ascending');
      },
      sortedColumnKey: 'date',
      sortAscending: false,
    ),
  );
}

Widget _buildInteractiveUseCase(BuildContext context) {
  return StatefulBuilder(
    builder: (context, setState) {
      bool isAllSelected = false;
      String? sortedColumn;
      bool sortAscending = true;

      final columns = [
        const TableColumn(label: 'No', width: 60, sortable: true, key: 'no'),
        const TableColumn(label: '日付', width: 100, sortable: true, key: 'date'),
        const TableColumn(label: '発生時間', width: 100, sortable: true, key: 'time'),
        const TableColumn(label: '部屋/ベッド番号', width: 120, sortable: false),
        const TableColumn(label: '見守り対象者名', width: 150, sortable: false),
        const TableColumn(label: '担当者', width: 100, sortable: true, key: 'staff'),
      ];

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: TableHeader(
                columns: columns,
                onSelectAll: (value) {
                  setState(() {
                    isAllSelected = value;
                  });
                },
                isAllSelected: isAllSelected,
                onSort: (columnKey, ascending) {
                  setState(() {
                    sortedColumn = columnKey;
                    sortAscending = ascending;
                  });
                },
                sortedColumnKey: sortedColumn,
                sortAscending: sortAscending,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Current State:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text('All Selected: $isAllSelected'),
            Text('Sorted Column: ${sortedColumn ?? "None"}'),
            Text('Sort Order: ${sortAscending ? "Ascending" : "Descending"}'),
          ],
        ),
      );
    },
  );
}
