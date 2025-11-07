import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:frontend/shared/presentation/components/molecules/date_range_picker.dart';

/// DateRangePicker stories for Widgetbook
WidgetbookComponent dateRangePickerStories() {
  return WidgetbookComponent(
    name: 'DateRangePicker',
    useCases: [
      WidgetbookUseCase(
        name: 'Default',
        builder: (context) => _buildDefaultUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'With Initial Dates',
        builder: (context) => _buildWithDatesUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'Custom Labels',
        builder: (context) => _buildCustomLabelsUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'Invalid Range (Error)',
        builder: (context) => _buildInvalidRangeUseCase(context),
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
  return DateRangePicker(
    onStartDateChanged: (date) {
      debugPrint('Start date changed: $date');
    },
    onEndDateChanged: (date) {
      debugPrint('End date changed: $date');
    },
  );
}

Widget _buildWithDatesUseCase(BuildContext context) {
  return DateRangePicker(
    startDate: DateTime(2025, 1, 1),
    endDate: DateTime(2025, 1, 31),
    onStartDateChanged: (date) {
      debugPrint('Start date changed: $date');
    },
    onEndDateChanged: (date) {
      debugPrint('End date changed: $date');
    },
  );
}

Widget _buildCustomLabelsUseCase(BuildContext context) {
  return DateRangePicker(
    startLabel: 'From',
    endLabel: 'To',
    onStartDateChanged: (date) {
      debugPrint('Start date changed: $date');
    },
    onEndDateChanged: (date) {
      debugPrint('End date changed: $date');
    },
  );
}

Widget _buildInvalidRangeUseCase(BuildContext context) {
  return DateRangePicker(
    startDate: DateTime(2025, 1, 31),
    endDate: DateTime(2025, 1, 1), // Invalid: end before start
    onStartDateChanged: (date) {
      debugPrint('Start date changed: $date');
    },
    onEndDateChanged: (date) {
      debugPrint('End date changed: $date');
    },
  );
}

Widget _buildNarrowScreenUseCase(BuildContext context) {
  return SizedBox(
    width: 300,
    child: DateRangePicker(
      startDate: DateTime(2025, 1, 1),
      endDate: DateTime(2025, 1, 31),
      onStartDateChanged: (date) {
        debugPrint('Start date changed: $date');
      },
      onEndDateChanged: (date) {
        debugPrint('End date changed: $date');
      },
    ),
  );
}

Widget _buildWideScreenUseCase(BuildContext context) {
  return SizedBox(
    width: 800,
    child: DateRangePicker(
      startDate: DateTime(2025, 1, 1),
      endDate: DateTime(2025, 1, 31),
      onStartDateChanged: (date) {
        debugPrint('Start date changed: $date');
      },
      onEndDateChanged: (date) {
        debugPrint('End date changed: $date');
      },
    ),
  );
}

Widget _buildInteractiveUseCase(BuildContext context) {
  return StatefulBuilder(
    builder: (context, setState) {
      DateTime? startDate;
      DateTime? endDate;

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DateRangePicker(
              startDate: startDate,
              endDate: endDate,
              onStartDateChanged: (date) {
                setState(() {
                  startDate = date;
                });
              },
              onEndDateChanged: (date) {
                setState(() {
                  endDate = date;
                });
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Selected Range:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Start: ${startDate?.toString() ?? "Not selected"}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'End: ${endDate?.toString() ?? "Not selected"}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    },
  );
}
