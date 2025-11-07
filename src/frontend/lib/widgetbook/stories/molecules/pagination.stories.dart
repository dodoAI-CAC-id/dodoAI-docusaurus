import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:frontend/shared/presentation/components/molecules/pagination.dart';

/// Pagination stories for Widgetbook
WidgetbookComponent paginationStories() {
  return WidgetbookComponent(
    name: 'Pagination',
    useCases: [
      WidgetbookUseCase(
        name: 'Default (First Page)',
        builder: (context) => _buildDefaultUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'Middle Page',
        builder: (context) => _buildMiddlePageUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'Last Page',
        builder: (context) => _buildLastPageUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'Many Pages',
        builder: (context) => _buildManyPagesUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'Single Page',
        builder: (context) => _buildSinglePageUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'Interactive',
        builder: (context) => _buildInteractiveUseCase(context),
      ),
    ],
  );
}

Widget _buildDefaultUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Pagination(
        currentPage: 1,
        totalPages: 10,
        onPageChanged: (page) {
          debugPrint('Page changed to: $page');
        },
      ),
    ),
  );
}

Widget _buildMiddlePageUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Pagination(
        currentPage: 5,
        totalPages: 10,
        onPageChanged: (page) {
          debugPrint('Page changed to: $page');
        },
      ),
    ),
  );
}

Widget _buildLastPageUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Pagination(
        currentPage: 10,
        totalPages: 10,
        onPageChanged: (page) {
          debugPrint('Page changed to: $page');
        },
      ),
    ),
  );
}

Widget _buildManyPagesUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Pagination(
        currentPage: 15,
        totalPages: 50,
        onPageChanged: (page) {
          debugPrint('Page changed to: $page');
        },
      ),
    ),
  );
}

Widget _buildSinglePageUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Pagination(
        currentPage: 1,
        totalPages: 1,
        onPageChanged: (page) {
          debugPrint('Page changed to: $page');
        },
      ),
    ),
  );
}

Widget _buildInteractiveUseCase(BuildContext context) {
  return StatefulBuilder(
    builder: (context, setState) {
      int currentPage = 1;
      const int totalPages = 20;

      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Current Page: $currentPage / $totalPages',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Pagination(
                currentPage: currentPage,
                totalPages: totalPages,
                onPageChanged: (page) {
                  setState(() {
                    currentPage = page;
                  });
                  debugPrint('Page changed to: $page');
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
