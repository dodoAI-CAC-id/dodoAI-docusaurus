import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/presentation/components/molecules/pagination.dart';

void main() {
  group('Pagination', () {
    testWidgets('displays current page and total pages', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Pagination(
              currentPage: 1,
              totalPages: 10,
              onPageChanged: (page) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('1'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('disables previous button on first page', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Pagination(
              currentPage: 1,
              totalPages: 10,
              onPageChanged: (page) {},
            ),
          ),
        ),
      );

      // Assert
      final previousButton = find.widgetWithIcon(IconButton, Icons.chevron_left).first;
      final iconButton = tester.widget<IconButton>(previousButton);
      expect(iconButton.onPressed, isNull);
    });

    testWidgets('disables next button on last page', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Pagination(
              currentPage: 10,
              totalPages: 10,
              onPageChanged: (page) {},
            ),
          ),
        ),
      );

      // Assert
      final nextButton = find.widgetWithIcon(IconButton, Icons.chevron_right).last;
      final iconButton = tester.widget<IconButton>(nextButton);
      expect(iconButton.onPressed, isNull);
    });

    testWidgets('triggers callback when page button is clicked', (WidgetTester tester) async {
      // Arrange
      int selectedPage = 1;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Pagination(
              currentPage: 1,
              totalPages: 10,
              onPageChanged: (page) {
                selectedPage = page;
              },
            ),
          ),
        ),
      );

      // Act - Click page 2
      await tester.tap(find.text('2'));
      await tester.pump();

      // Assert
      expect(selectedPage, 2);
    });

    testWidgets('triggers callback when next button is clicked', (WidgetTester tester) async {
      // Arrange
      int selectedPage = 1;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Pagination(
              currentPage: 2,
              totalPages: 10,
              onPageChanged: (page) {
                selectedPage = page;
              },
            ),
          ),
        ),
      );

      // Act
      final nextButton = find.widgetWithIcon(IconButton, Icons.chevron_right).last;
      await tester.tap(nextButton);
      await tester.pump();

      // Assert
      expect(selectedPage, 3);
    });

    testWidgets('triggers callback when previous button is clicked', (WidgetTester tester) async {
      // Arrange
      int selectedPage = 3;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Pagination(
              currentPage: 3,
              totalPages: 10,
              onPageChanged: (page) {
                selectedPage = page;
              },
            ),
          ),
        ),
      );

      // Act
      final previousButton = find.widgetWithIcon(IconButton, Icons.chevron_left).first;
      await tester.tap(previousButton);
      await tester.pump();

      // Assert
      expect(selectedPage, 2);
    });

    testWidgets('displays ellipsis for many pages', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Pagination(
              currentPage: 5,
              totalPages: 20,
              onPageChanged: (page) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('...'), findsWidgets);
    });

    testWidgets('highlights current page', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Pagination(
              currentPage: 5,
              totalPages: 10,
              onPageChanged: (page) {},
            ),
          ),
        ),
      );

      // Assert - Current page should be displayed
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('handles single page correctly', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Pagination(
              currentPage: 1,
              totalPages: 1,
              onPageChanged: (page) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('1'), findsOneWidget);
      final previousButton = find.widgetWithIcon(IconButton, Icons.chevron_left).first;
      final nextButton = find.widgetWithIcon(IconButton, Icons.chevron_right).last;
      
      final prevIconButton = tester.widget<IconButton>(previousButton);
      final nextIconButton = tester.widget<IconButton>(nextButton);
      
      expect(prevIconButton.onPressed, isNull);
      expect(nextIconButton.onPressed, isNull);
    });
  });
}
