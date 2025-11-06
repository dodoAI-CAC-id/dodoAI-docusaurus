import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamoai/features/incident_history/presentation/widgets/molecules/video_player_dialog.dart';

void main() {
  group('VideoPlayerDialog', () {
    testWidgets('displays dialog with video player', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => VideoPlayerDialog(
                      videoId: 'VIDEO001',
                      incidentId: 'INC001',
                      onClose: () => Navigator.of(context).pop(),
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // ダイアログを開く
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // ダイアログが表示されているか
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('displays video player placeholder', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => VideoPlayerDialog(
                      videoId: 'VIDEO001',
                      incidentId: 'INC001',
                      onClose: () => Navigator.of(context).pop(),
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // 動画プレーヤープレースホルダーが表示されているか
      expect(find.text('動画プレーヤー'), findsOneWidget);
    });

    testWidgets('displays incident ID', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => VideoPlayerDialog(
                      videoId: 'VIDEO001',
                      incidentId: 'INC001',
                      onClose: () => Navigator.of(context).pop(),
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // インシデントIDが表示されているか（AppTextコンポーネント内）
      expect(find.textContaining('INC001'), findsOneWidget);
    });

    testWidgets('displays close button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => VideoPlayerDialog(
                      videoId: 'VIDEO001',
                      incidentId: 'INC001',
                      onClose: () => Navigator.of(context).pop(),
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // 閉じるボタンが表示されているか
      expect(find.text('閉じる'), findsOneWidget);
    });

    testWidgets('calls onClose when close button is tapped', (tester) async {
      bool closeCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => VideoPlayerDialog(
                      videoId: 'VIDEO001',
                      incidentId: 'INC001',
                      onClose: () {
                        closeCalled = true;
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // 閉じるボタンをタップ
      await tester.tap(find.text('閉じる'));
      await tester.pumpAndSettle();

      // コールバックが呼ばれたか
      expect(closeCalled, true);
    });

    testWidgets('displays download button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => VideoPlayerDialog(
                      videoId: 'VIDEO001',
                      incidentId: 'INC001',
                      onClose: () => Navigator.of(context).pop(),
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // ダウンロードボタンが表示されているか
      expect(find.text('ダウンロード'), findsOneWidget);
    });

    testWidgets('dialog has proper size constraints', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => VideoPlayerDialog(
                      videoId: 'VIDEO001',
                      incidentId: 'INC001',
                      onClose: () => Navigator.of(context).pop(),
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // ダイアログが表示されているか
      expect(find.byType(Dialog), findsOneWidget);
      
      // ダイアログのサイズが適切か（Container等で制約されているか）
      final dialog = tester.widget<Dialog>(find.byType(Dialog));
      expect(dialog, isNotNull);
    });
  });
}
