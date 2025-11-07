import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:frontend/widgetbook/stories/atoms/app_button.stories.dart';
import 'package:frontend/widgetbook/stories/atoms/app_text_field.stories.dart';
import 'package:frontend/widgetbook/stories/atoms/app_dropdown.stories.dart';
import 'package:frontend/widgetbook/stories/atoms/app_checkbox.stories.dart';
import 'package:frontend/widgetbook/stories/atoms/status_badge.stories.dart';
import 'package:frontend/widgetbook/stories/atoms/icon_button.stories.dart';
import 'package:frontend/widgetbook/stories/molecules/date_range_picker.stories.dart';
import 'package:frontend/widgetbook/stories/molecules/search_form.stories.dart';
import 'package:frontend/widgetbook/stories/molecules/table_header.stories.dart';
import 'package:frontend/widgetbook/stories/molecules/table_row.stories.dart';
import 'package:frontend/widgetbook/stories/molecules/pagination.stories.dart';
import 'package:frontend/widgetbook/stories/molecules/status_badge.stories.dart';
import 'package:frontend/widgetbook/stories/molecules/loading_indicator.stories.dart';
import 'package:frontend/widgetbook/stories/organisms/history_table.stories.dart';
import 'package:frontend/widgetbook/stories/organisms/video_player_modal.stories.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: [
        WidgetbookCategory(
          name: 'Atoms',
          children: [
            appButtonStories(),
            appTextFieldStories(),
            appDropdownStories(),
            appCheckboxStories(),
            statusBadgeStories(),
            iconButtonStories(),
          ],
        ),
        WidgetbookCategory(
          name: 'Molecules',
          children: [
            dateRangePickerStories(),
            searchFormStories(),
            tableHeaderStories(),
            tableRowStories(),
            paginationStories(),
            statusBadgeStoriesMolecules(),
            loadingIndicatorStories(),
          ],
        ),
        WidgetbookCategory(
          name: 'Organisms',
          children: [
            historyTableStories(),
            videoPlayerModalStories(),
          ],
        ),
      ],
    );
  }
}
