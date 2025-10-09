---
id: atomic-design-implementation-rules
title: Atomic Design実装ルール
---

# 04. Atomic Design実装ルール

Atomic Designは、UIコンポーネントを階層的に分割・管理する手法であり、再利用性とデザイン一貫性を確保するための重要なパターンです。

## 4.1 概念と階層定義

| 階層 | 説明 | 配置パス例 |
|-----------|-------------|------------------------|
| Atom | 基本的なUIパーツ（ボタン、テキストなど） | `shared/presentation/components/atoms/` |
| Molecule | 複数のAtomから構成される複合パーツ | `shared/presentation/components/molecules/` |
| Organism | Moleculeを組み合わせたセクション | `shared/presentation/components/organisms/` |
| Template | レイアウトフレームワーク | `shared/presentation/templates/` |
| Page | アプリ全体の画面単位 | `features/{feature}/presentation/pages/` |

## 4.2 命名と構造ルール

* コンポーネント名には明確性のためのプレフィックスを追加：例：`AppButton`、`UserCard`、`SearchBar`
* ファイル名とクラス名を一致させる
* 常に共通デザイン（`AppColors`、`AppTypography`）を使用

## 4.3 ディレクトリ構造（例）

```
shared/
└── presentation/
    └── components/
        ├── atoms/
        │   ├── app_button.dart
        │   └── spacing.dart
        ├── molecules/
        │   └── labeled_input.dart
        ├── organisms/
        │   └── user_profile_card.dart
        └── templates/
            └── base_page_layout.dart
```

さらに、Atomic Designは`features/{feature}/presentation/widgets/`でも採用でき、ローカルな再利用性を確保できます。

## 4.4 運用ポリシー

* 再利用を意図したWidgetは`shared`に配置
* 最小単位から順に切り出し、命名の一貫性を保つ
* Storybook（Widgetbook）との統合は必須
