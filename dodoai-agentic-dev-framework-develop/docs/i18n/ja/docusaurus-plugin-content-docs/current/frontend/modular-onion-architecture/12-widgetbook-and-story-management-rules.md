---
id: widgetbook-and-story-management-rules
title: Widgetbookとストーリー管理ルール
---

# 12. Widgetbookとストーリー管理ルール

Atomic Designを採用したUIコンポーネントの品質と一貫性を維持するため、コンポーネントストーリー管理ツールを導入します。この章では、各レベルコンポーネントのストーリー（使用例）を定義するルールを説明し、設計と実装の乖離を防ぎます。

## フレームワーク別ツール選択

* **Flutter**: コンポーネントストーリー管理とビジュアルテストに**Widgetbook**を使用
* **React**: コンポーネントストーリー管理とビジュアルテストに**Storybook**を使用
* **その他のフレームワーク**: コンポーネント分離とビジュアルテストをサポートする適切なストーリー管理ツールを選択

## 12.1 Widgetbookとは（Flutter例）

* FlutterアプリケーションのStorybook相当
* 各コンポーネントの「状態」と「バリエーション」を視覚的に確認
* UIレビュー、リグレッションテスト、デザイナーとの合意形成に有用

## 12.2 ストーリーファイル構造例

```
lib/
└── widgetbook/
    ├── main.dart                  # エントリーポイント
    └── stories/
        ├── atoms/
        │   ├── app_button.stories.dart
        │   └── spacing.stories.dart
        ├── molecules/
        └── organisms/
```

## 12.3 ストーリー定義ルール

* Atom/Molecule/Organism毎に1ファイル
* WidgetbookUseCaseで複数の状態（enabled/disabledなど）を定義

```dart
final appButtonStory = WidgetbookComponent(
  name: 'AppButton',
  useCases: [
    WidgetbookUseCase(name: 'default', builder: (_) => AppButton(label: 'Click Me')),
    WidgetbookUseCase(name: 'disabled', builder: (_) => AppButton(label: 'Click Me', disabled: true)),
  ],
);
```

## 12.4 開発フローへの統合

* Component追加時にストーリーを同時作成
* デザイナーとストーリー内容をレビュー
* CI にWidgetbookビルドを含める（オプション）
* 変更発生時は対応するストーリーを必ず更新

この包括的なドキュメントは、Flutterアプリケーションでのモジュラーオニオンアーキテクチャ実装の基盤を確立し、開発チーム全体での一貫性、保守性、スケーラビリティを確保します。
