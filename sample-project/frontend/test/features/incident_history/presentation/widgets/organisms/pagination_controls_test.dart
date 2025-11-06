import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamoai/features/incident_history/presentation/widgets/organisms/pagination_controls.dart';

void main() {
  group('PaginationControls', () {
    testWidgets('displays current page and total pages', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginationControls(
              currentPage: 1,
              totalPages: 10,
              onPageChanged: (page) {},
            ),
          ),
        ),
      );

      expect(find.text('1 / 10'), findsOneWidget);
    });

    testWidgets('displays previous button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginationControls(
              currentPage: 2,
              totalPages: 10,
              onPageChanged: (page) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
    });

    testWidgets('displays next button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginationControls(
              currentPage: 2,
              totalPages: 10,
              onPageChanged: (page) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('disables previous button on first page', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginationControls(
              currentPage: 1,
              totalPages: 10,
              onPageChanged: (page) {},
            ),
          ),
        ),
      );

      final previousButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.chevron_left),
      );
      expect(previousButton.onPressed, isNull);
    });

    testWidgets('disables next button on last page', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginationControls(
              currentPage: 10,
              totalPages: 10,
              onPageChanged: (page) {},
            ),
          ),
        ),
      );

      final nextButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.chevron_right),
      );
      expect(nextButton.onPressed, isNull);
    });

    testWidgets('calls onPageChanged with previous page when previous button tapped',
        (tester) async {
      int? changedPage;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginationControls(
              currentPage: 5,
              totalPages: 10,
              onPageChanged: (page) {
                changedPage = page;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.widgetWithIcon(IconButton, Icons.chevron_left));
      await tester.pump();

      expect(changedPage, 4);
    });

    testWidgets('calls onPageChanged with next page when next button tapped',
        (tester) async {
      int? changedPage;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginationControls(
              currentPage: 5,
              totalPages: 10,
              onPageChanged: (page) {
                changedPage = page;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.widgetWithIcon(IconButton, Icons.chevron_right));
      await tester.pump();

      expect(changedPage, 6);
    });

    testWidgets('displays first page button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginationControls(
              currentPage: 5,
              totalPages: 10,
              onPageChanged: (page) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.first_page), findsOneWidget);
    });

    testWidgets('displays last page button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginationControls(
              currentPage: 5,
              totalPages: 10,
              onPageChanged: (page) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.last_page), findsOneWidget);
    });

    testWidgets('calls onPageChanged with 1 when first page button tapped',
        (tester) async {
      int? changedPage;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginationControls(
              currentPage: 5,
              totalPages: 10,
              onPageChanged: (page) {
                changedPage = page;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.widgetWithIcon(IconButton, Icons.first_page));
      await tester.pump();

      expect(changedPage, 1);
    });

    testWidgets('calls onPageChanged with totalPages when last page button tapped',
        (tester) async {
      int? changedPage;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginationControls(
              currentPage: 5,
              totalPages: 10,
              onPageChanged: (page) {
                changedPage = page;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.widgetWithIcon(IconButton, Icons.last_page));
      await tester.pump();

      expect(changedPage, 10);
    });

    testWidgets('disables first page button on first page', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginationControls(
              currentPage: 1,
              totalPages: 10,
              onPageChanged: (page) {},
            ),
          ),
        ),
      );

      final firstPageButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.first_page),
      );
      expect(firstPageButton.onPressed, isNull);
    });

    testWidgets('disables last page button on last page', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginationControls(
              currentPage: 10,
              totalPages: 10,
              onPageChanged: (page) {},
            ),
          ),
        ),
      );

      final lastPageButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.last_page),
      );
      expect(lastPageButton.onPressed, isNull);
    });

    testWidgets('displays total count when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginationControls(
              currentPage: 1,
              totalPages: 10,
              totalCount: 95,
              onPageChanged: (page) {},
            ),
          ),
        ),
      );

      expect(find.text('全 95 件'), findsOneWidget);
    });

    testWidgets('does not display total count when not provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginationControls(
              currentPage: 1,
              totalPages: 10,
              onPageChanged: (page) {},
            ),
          ),
        ),
      );

      expect(find.textContaining('全'), findsNothing);
    });
  });
}
