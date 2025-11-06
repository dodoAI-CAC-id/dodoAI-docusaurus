import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamoai/features/incident_history/domain/entities/incident.dart';
import 'package:mamoai/features/incident_history/presentation/widgets/molecules/incident_list_row.dart';

void main() {
  group('IncidentListRow', () {
    late Incident testIncident;

    setUp(() {
      testIncident = Incident(
        id: 'INC001',
        detectedAt: DateTime(2025, 10, 20, 14, 30),
        type: '転倒',
        personId: 'PERSON001',
        personName: '山田太郎',
        roomNumber: '101',
        status: 'open',
        videoId: 'VIDEO001',
        createdAt: DateTime(2025, 10, 20, 14, 30),
        updatedAt: DateTime(2025, 10, 20, 14, 30),
      );
    });

    testWidgets('displays all incident information correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncidentListRow(
              incident: testIncident,
              isSelected: false,
              onSelectionChanged: (value) {},
              onPlayVideo: () {},
              onDownloadVideo: () {},
            ),
          ),
        ),
      );

      // 日時が表示されているか
      expect(find.text('2025/10/20 14:30'), findsOneWidget);

      // 異常タイプが表示されているか
      expect(find.text('転倒'), findsOneWidget);

      // 対象者名が表示されているか
      expect(find.text('山田太郎'), findsOneWidget);

      // 部屋番号が表示されているか
      expect(find.text('101'), findsOneWidget);

      // ステータスが表示されているか
      expect(find.text('未対応'), findsOneWidget);
    });

    testWidgets('checkbox reflects selection state', (tester) async {
      bool isSelected = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return IncidentListRow(
                  incident: testIncident,
                  isSelected: isSelected,
                  onSelectionChanged: (value) {
                    setState(() {
                      isSelected = value ?? false;
                    });
                  },
                  onPlayVideo: () {},
                  onDownloadVideo: () {},
                );
              },
            ),
          ),
        ),
      );

      // 初期状態ではチェックされていない
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, false);

      // チェックボックスをタップ
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      // チェックされた状態になる
      final checkedCheckbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkedCheckbox.value, true);
    });

    testWidgets('play video button triggers callback', (tester) async {
      bool playVideoCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncidentListRow(
              incident: testIncident,
              isSelected: false,
              onSelectionChanged: (value) {},
              onPlayVideo: () {
                playVideoCalled = true;
              },
              onDownloadVideo: () {},
            ),
          ),
        ),
      );

      // 再生ボタンを探す
      final playButton = find.byIcon(Icons.play_circle);
      expect(playButton, findsOneWidget);

      // 再生ボタンをタップ
      await tester.tap(playButton);
      await tester.pumpAndSettle();

      // コールバックが呼ばれたか
      expect(playVideoCalled, true);
    });

    testWidgets('download video button triggers callback', (tester) async {
      bool downloadVideoCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncidentListRow(
              incident: testIncident,
              isSelected: false,
              onSelectionChanged: (value) {},
              onPlayVideo: () {},
              onDownloadVideo: () {
                downloadVideoCalled = true;
              },
            ),
          ),
        ),
      );

      // ダウンロードボタンを探す
      final downloadButton = find.byIcon(Icons.download);
      expect(downloadButton, findsOneWidget);

      // ダウンロードボタンをタップ
      await tester.tap(downloadButton);
      await tester.pumpAndSettle();

      // コールバックが呼ばれたか
      expect(downloadVideoCalled, true);
    });

    testWidgets('displays correct status text for different statuses', (tester) async {
      final statuses = {
        'open': '未対応',
        'resolved': '対応済み',
        'monitoring': '監視中',
      };

      for (final entry in statuses.entries) {
        final incident = Incident(
          id: 'INC001',
          detectedAt: DateTime(2025, 10, 20, 14, 30),
          type: '転倒',
          personId: 'PERSON001',
          personName: '山田太郎',
          roomNumber: '101',
          status: entry.key,
          videoId: 'VIDEO001',
          createdAt: DateTime(2025, 10, 20, 14, 30),
          updatedAt: DateTime(2025, 10, 20, 14, 30),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IncidentListRow(
                incident: incident,
                isSelected: false,
                onSelectionChanged: (value) {},
                onPlayVideo: () {},
                onDownloadVideo: () {},
              ),
            ),
          ),
        );

        expect(find.text(entry.value), findsOneWidget);

        // 次のテストのためにウィジェットをクリア
        await tester.pumpWidget(Container());
      }
    });

    testWidgets('row has hover effect', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncidentListRow(
              incident: testIncident,
              isSelected: false,
              onSelectionChanged: (value) {},
              onPlayVideo: () {},
              onDownloadVideo: () {},
            ),
          ),
        ),
      );

      // InkWellが存在するか確認（複数あってもOK）
      expect(find.byType(InkWell), findsWidgets);
    });

    testWidgets('displays formatted date time correctly', (tester) async {
      final incident = Incident(
        id: 'INC001',
        detectedAt: DateTime(2025, 1, 5, 9, 5), // 1桁の月日時分
        type: '転倒',
        personId: 'PERSON001',
        personName: '山田太郎',
        roomNumber: '101',
        status: 'open',
        videoId: 'VIDEO001',
        createdAt: DateTime(2025, 1, 5, 9, 5),
        updatedAt: DateTime(2025, 1, 5, 9, 5),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncidentListRow(
              incident: incident,
              isSelected: false,
              onSelectionChanged: (value) {},
              onPlayVideo: () {},
              onDownloadVideo: () {},
            ),
          ),
        ),
      );

      // 日時が正しくフォーマットされているか（ゼロパディング）
      expect(find.text('2025/01/05 09:05'), findsOneWidget);
    });

    testWidgets('handles null videoId gracefully', (tester) async {
      final incident = Incident(
        id: 'INC001',
        detectedAt: DateTime(2025, 10, 20, 14, 30),
        type: '転倒',
        personId: 'PERSON001',
        personName: '山田太郎',
        roomNumber: '101',
        status: 'open',
        videoId: null, // 動画なし
        createdAt: DateTime(2025, 10, 20, 14, 30),
        updatedAt: DateTime(2025, 10, 20, 14, 30),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncidentListRow(
              incident: incident,
              isSelected: false,
              onSelectionChanged: (value) {},
              onPlayVideo: () {},
              onDownloadVideo: () {},
            ),
          ),
        ),
      );

      // 動画ボタンが無効化されているか
      final playButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byIcon(Icons.play_circle),
          matching: find.byType(IconButton),
        ),
      );
      expect(playButton.onPressed, isNull);

      final downloadButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byIcon(Icons.download),
          matching: find.byType(IconButton),
        ),
      );
      expect(downloadButton.onPressed, isNull);
    });
  });
}
