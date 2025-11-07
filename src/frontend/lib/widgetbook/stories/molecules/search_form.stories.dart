import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:frontend/shared/presentation/components/molecules/search_form.dart';
import 'package:frontend/shared/domain/models/search_criteria.dart';

/// SearchForm stories for Widgetbook
WidgetbookComponent searchFormStories() {
  return WidgetbookComponent(
    name: 'SearchForm',
    useCases: [
      WidgetbookUseCase(
        name: 'Default',
        builder: (context) => _buildDefaultUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'With Initial Values',
        builder: (context) => _buildWithInitialValuesUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'Narrow Screen',
        builder: (context) => _buildNarrowScreenUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'Wide Screen',
        builder: (context) => _buildWideScreenUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'Interactive',
        builder: (context) => _buildInteractiveUseCase(context),
      ),
    ],
  );
}

Widget _buildDefaultUseCase(BuildContext context) {
  return SearchForm(
    onSearch: (criteria) {
      debugPrint('Search criteria: $criteria');
    },
  );
}

Widget _buildWithInitialValuesUseCase(BuildContext context) {
  final initialValues = SearchCriteria(
    startDate: DateTime(2025, 1, 1),
    endDate: DateTime(2025, 1, 31),
    roomBedNumber: 'TW02-02',
    targetPersonName: '田中太郎',
    staffName: 'Admin',
    actionType: '対応',
    detectionType: '起床',
  );

  return SearchForm(
    initialValues: initialValues,
    onSearch: (criteria) {
      debugPrint('Search criteria: $criteria');
    },
  );
}

Widget _buildNarrowScreenUseCase(BuildContext context) {
  return SizedBox(
    width: 400,
    child: SearchForm(
      onSearch: (criteria) {
        debugPrint('Search criteria: $criteria');
      },
    ),
  );
}

Widget _buildWideScreenUseCase(BuildContext context) {
  return SizedBox(
    width: 1200,
    child: SearchForm(
      initialValues: SearchCriteria(
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 1, 31),
      ),
      onSearch: (criteria) {
        debugPrint('Search criteria: $criteria');
      },
    ),
  );
}

Widget _buildInteractiveUseCase(BuildContext context) {
  return StatefulBuilder(
    builder: (context, setState) {
      SearchCriteria? lastSearchCriteria;

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchForm(
              onSearch: (criteria) {
                setState(() {
                  lastSearchCriteria = criteria;
                });
              },
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Last Search Criteria:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            if (lastSearchCriteria != null) ...[
              _buildCriteriaRow(
                context,
                '開始日',
                lastSearchCriteria!.startDate?.toString() ?? 'Not set',
              ),
              _buildCriteriaRow(
                context,
                '終了日',
                lastSearchCriteria!.endDate?.toString() ?? 'Not set',
              ),
              _buildCriteriaRow(
                context,
                '部屋/ベッド番号',
                lastSearchCriteria!.roomBedNumber ?? 'Not set',
              ),
              _buildCriteriaRow(
                context,
                '見守り対象者名',
                lastSearchCriteria!.targetPersonName ?? 'Not set',
              ),
              _buildCriteriaRow(
                context,
                '担当者',
                lastSearchCriteria!.staffName ?? 'Not set',
              ),
              _buildCriteriaRow(
                context,
                '操作',
                lastSearchCriteria!.actionType ?? 'Not set',
              ),
              _buildCriteriaRow(
                context,
                '異常検出動作',
                lastSearchCriteria!.detectionType ?? 'Not set',
              ),
            ] else
              Text(
                'No search performed yet',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
          ],
        ),
      );
    },
  );
}

Widget _buildCriteriaRow(BuildContext context, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            '$label:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    ),
  );
}
