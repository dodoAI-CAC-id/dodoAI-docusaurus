import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:frontend/shared/presentation/components/molecules/table_row.dart';

/// TableRow stories for Widgetbook
WidgetbookComponent tableRowStories() {
  return WidgetbookComponent(
    name: 'TableRow',
    useCases: [
      WidgetbookUseCase(
        name: 'Default',
        builder: (context) => _buildDefaultUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'Checked',
        builder: (context) => _buildCheckedUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'With Empty Fields',
        builder: (context) => _buildEmptyFieldsUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'Multiple Rows',
        builder: (context) => _buildMultipleRowsUseCase(context),
      ),
    ],
  );
}

Widget _buildDefaultUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          columnWidths: const {
            0: FixedColumnWidth(50),
            1: FixedColumnWidth(80),
            2: FixedColumnWidth(100),
            3: FixedColumnWidth(90),
            4: FixedColumnWidth(100),
            5: FixedColumnWidth(120),
            6: FixedColumnWidth(100),
            7: FixedColumnWidth(100),
            8: FixedColumnWidth(100),
            9: FixedColumnWidth(150),
            10: FixedColumnWidth(100),
            11: FixedColumnWidth(120),
          },
          children: [
            HistoryTableRow(
              rowData: {
                'checkbox': false,
                'incidentId': '12345',
                'date': '2025/10/30',
                'time': '14:30:45',
                'roomBed': '101-A',
                'patientName': '山田太郎',
                'detectedAction': '起床',
                'staffName': '佐藤花子',
                'actionType': '対応',
                'startTime': '2025/10/30 14:31:00',
                'totalTime': '05:30',
              },
              onCheckboxChanged: (value) {
                debugPrint('Checkbox changed: $value');
              },
              onVideoPlay: () {
                debugPrint('Video play clicked');
              },
              onVideoDownload: () {
                debugPrint('Video download clicked');
              },
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildCheckedUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          columnWidths: const {
            0: FixedColumnWidth(50),
            1: FixedColumnWidth(80),
            2: FixedColumnWidth(100),
            3: FixedColumnWidth(90),
            4: FixedColumnWidth(100),
            5: FixedColumnWidth(120),
            6: FixedColumnWidth(100),
            7: FixedColumnWidth(100),
            8: FixedColumnWidth(100),
            9: FixedColumnWidth(150),
            10: FixedColumnWidth(100),
            11: FixedColumnWidth(120),
          },
          children: [
            HistoryTableRow(
              rowData: {
                'checkbox': true,
                'incidentId': '12346',
                'date': '2025/10/30',
                'time': '15:45:30',
                'roomBed': '102-B',
                'patientName': '鈴木一郎',
                'detectedAction': '転倒',
                'staffName': '田中次郎',
                'actionType': '完了',
                'startTime': '2025/10/30 15:46:00',
                'totalTime': '03:15',
              },
              onCheckboxChanged: (value) {
                debugPrint('Checkbox changed: $value');
              },
              onVideoPlay: () {
                debugPrint('Video play clicked');
              },
              onVideoDownload: () {
                debugPrint('Video download clicked');
              },
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildEmptyFieldsUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          columnWidths: const {
            0: FixedColumnWidth(50),
            1: FixedColumnWidth(80),
            2: FixedColumnWidth(100),
            3: FixedColumnWidth(90),
            4: FixedColumnWidth(100),
            5: FixedColumnWidth(120),
            6: FixedColumnWidth(100),
            7: FixedColumnWidth(100),
            8: FixedColumnWidth(100),
            9: FixedColumnWidth(150),
            10: FixedColumnWidth(100),
            11: FixedColumnWidth(120),
          },
          children: [
            HistoryTableRow(
              rowData: {
                'checkbox': false,
                'incidentId': '12347',
                'date': '2025/10/30',
                'time': '16:20:00',
                'roomBed': '',
                'patientName': '',
                'detectedAction': '',
                'staffName': '',
                'actionType': '',
                'startTime': '',
                'totalTime': '',
              },
              onCheckboxChanged: (value) {
                debugPrint('Checkbox changed: $value');
              },
              onVideoPlay: () {
                debugPrint('Video play clicked');
              },
              onVideoDownload: () {
                debugPrint('Video download clicked');
              },
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildMultipleRowsUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          columnWidths: const {
            0: FixedColumnWidth(50),
            1: FixedColumnWidth(80),
            2: FixedColumnWidth(100),
            3: FixedColumnWidth(90),
            4: FixedColumnWidth(100),
            5: FixedColumnWidth(120),
            6: FixedColumnWidth(100),
            7: FixedColumnWidth(100),
            8: FixedColumnWidth(100),
            9: FixedColumnWidth(150),
            10: FixedColumnWidth(100),
            11: FixedColumnWidth(120),
          },
          children: [
            HistoryTableRow(
              rowData: {
                'checkbox': false,
                'incidentId': '12345',
                'date': '2025/10/30',
                'time': '14:30:45',
                'roomBed': '101-A',
                'patientName': '山田太郎',
                'detectedAction': '起床',
                'staffName': '佐藤花子',
                'actionType': '対応',
                'startTime': '2025/10/30 14:31:00',
                'totalTime': '05:30',
              },
              onCheckboxChanged: (value) {},
              onVideoPlay: () {},
              onVideoDownload: () {},
            ),
            HistoryTableRow(
              rowData: {
                'checkbox': true,
                'incidentId': '12346',
                'date': '2025/10/30',
                'time': '15:45:30',
                'roomBed': '102-B',
                'patientName': '鈴木一郎',
                'detectedAction': '転倒',
                'staffName': '田中次郎',
                'actionType': '完了',
                'startTime': '2025/10/30 15:46:00',
                'totalTime': '03:15',
              },
              onCheckboxChanged: (value) {},
              onVideoPlay: () {},
              onVideoDownload: () {},
            ),
            HistoryTableRow(
              rowData: {
                'checkbox': false,
                'incidentId': '12347',
                'date': '2025/10/30',
                'time': '16:20:00',
                'roomBed': '103-C',
                'patientName': '高橋美咲',
                'detectedAction': '離床',
                'staffName': '伊藤三郎(SYSTEM)',
                'actionType': '誤検知',
                'startTime': '',
                'totalTime': '',
              },
              onCheckboxChanged: (value) {},
              onVideoPlay: () {},
              onVideoDownload: () {},
            ),
          ],
        ),
      ),
    ),
  );
}
