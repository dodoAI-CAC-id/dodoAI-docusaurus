import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:frontend/shared/presentation/components/molecules/loading_indicator.dart';

/// LoadingIndicator stories for Widgetbook
WidgetbookComponent loadingIndicatorStories() {
  return WidgetbookComponent(
    name: 'LoadingIndicator',
    useCases: [
      WidgetbookUseCase(
        name: 'Default',
        builder: (context) => _buildDefaultUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'With Message',
        builder: (context) => _buildWithMessageUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'Large Size',
        builder: (context) => _buildLargeSizeUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'Small Size',
        builder: (context) => _buildSmallSizeUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'Overlay Mode',
        builder: (context) => _buildOverlayModeUseCase(context),
      ),
      WidgetbookUseCase(
        name: 'In Card',
        builder: (context) => _buildInCardUseCase(context),
      ),
    ],
  );
}

Widget _buildDefaultUseCase(BuildContext context) {
  return const Scaffold(
    body: LoadingIndicator(),
  );
}

Widget _buildWithMessageUseCase(BuildContext context) {
  return const Scaffold(
    body: LoadingIndicator(
      message: '読み込み中...',
    ),
  );
}

Widget _buildLargeSizeUseCase(BuildContext context) {
  return const Scaffold(
    body: LoadingIndicator(
      size: 60.0,
      message: 'Loading...',
    ),
  );
}

Widget _buildSmallSizeUseCase(BuildContext context) {
  return const Scaffold(
    body: LoadingIndicator(
      size: 24.0,
      message: 'Loading...',
    ),
  );
}

Widget _buildOverlayModeUseCase(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        // Background content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'This is the content behind the overlay',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Button'),
              ),
            ],
          ),
        ),
        // Loading overlay
        const LoadingIndicator(
          overlay: true,
          message: '処理中...',
        ),
      ],
    ),
  );
}

Widget _buildInCardUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Card(
        elevation: 4,
        child: Container(
          width: 300,
          height: 200,
          padding: const EdgeInsets.all(24.0),
          child: const LoadingIndicator(
            message: 'データを取得中...',
          ),
        ),
      ),
    ),
  );
}
