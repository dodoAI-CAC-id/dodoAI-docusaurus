import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/presentation/components/molecules/table_row.dart';

void main() {
  group('HistoryTableRow', () {
    testWidgets('displays all row data correctly', (WidgetTester tester) async {
      // Arrange
      final rowData = {
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
      };

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
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
                    rowData: rowData,
                    onCheckboxChanged: (value) {},
                    onVideoPlay: () {},
                    onVideoDownload: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('12345'), findsOneWidget);
      expect(find.text('2025/10/30'), findsOneWidget);
      expect(find.text('14:30:45'), findsOneWidget);
      expect(find.text('101-A'), findsOneWidget);
      expect(find.text('山田太郎'), findsOneWidget);
      expect(find.text('起床'), findsOneWidget);
      expect(find.text('佐藤花子'), findsOneWidget);
      expect(find.text('対応'), findsOneWidget);
      expect(find.text('2025/10/30 14:31:00'), findsOneWidget);
      expect(find.text('05:30'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('handles checkbox state changes', (WidgetTester tester) async {
      // Arrange
      bool checkboxValue = false;
      final rowData = {
        'checkbox': false,
        'incidentId': '12345',
        'date': '2025/10/30',
        'time': '14:30:45',
        'roomBed': '',
        'patientName': '',
        'detectedAction': '',
        'staffName': '',
        'actionType': '',
        'startTime': '',
        'totalTime': '',
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Table(
                    children: [
                      HistoryTableRow(
                        rowData: {...rowData, 'checkbox': checkboxValue},
                        onCheckboxChanged: (value) {
                          setState(() {
                            checkboxValue = value ?? false;
                          });
                        },
                        onVideoPlay: () {},
                        onVideoDownload: () {},
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Assert
      expect(checkboxValue, true);
    });

    testWidgets('handles empty optional fields', (WidgetTester tester) async {
      // Arrange
      final rowData = {
        'checkbox': false,
        'incidentId': '12345',
        'date': '2025/10/30',
        'time': '14:30:45',
        'roomBed': '',
        'patientName': '',
        'detectedAction': '',
        'staffName': '',
        'actionType': '',
        'startTime': '',
        'totalTime': '',
      };

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                children: [
                  HistoryTableRow(
                    rowData: rowData,
                    onCheckboxChanged: (value) {},
                    onVideoPlay: () {},
                    onVideoDownload: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Assert - should render without errors
      expect(find.text('12345'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('triggers video play callback', (WidgetTester tester) async {
      // Arrange
      bool videoPlayTriggered = false;
      final rowData = {
        'checkbox': false,
        'incidentId': '12345',
        'date': '2025/10/30',
        'time': '14:30:45',
        'roomBed': '',
        'patientName': '',
        'detectedAction': '',
        'staffName': '',
        'actionType': '',
        'startTime': '',
        'totalTime': '',
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                children: [
                  HistoryTableRow(
                    rowData: rowData,
                    onCheckboxChanged: (value) {},
                    onVideoPlay: () {
                      videoPlayTriggered = true;
                    },
                    onVideoDownload: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Act
      final playButton = find.byIcon(Icons.play_circle_outline);
      await tester.tap(playButton);
      await tester.pump();

      // Assert
      expect(videoPlayTriggered, true);
    });

    testWidgets('triggers video download callback', (WidgetTester tester) async {
      // Arrange
      bool videoDownloadTriggered = false;
      final rowData = {
        'checkbox': false,
        'incidentId': '12345',
        'date': '2025/10/30',
        'time': '14:30:45',
        'roomBed': '',
        'patientName': '',
        'detectedAction': '',
        'staffName': '',
        'actionType': '',
        'startTime': '',
        'totalTime': '',
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                children: [
                  HistoryTableRow(
                    rowData: rowData,
                    onCheckboxChanged: (value) {},
                    onVideoPlay: () {},
                    onVideoDownload: () {
                      videoDownloadTriggered = true;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Act
      final downloadButton = find.byIcon(Icons.download);
      await tester.tap(downloadButton);
      await tester.pump();

      // Assert
      expect(videoDownloadTriggered, true);
    });
  });
}
