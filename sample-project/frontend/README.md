# MamoAI Frontend

Flutter/Dartで構築された見守りシステムのフロントエンドアプリケーション。

## アーキテクチャ

Clean Architecture + Modular Onion Architectureに基づいた設計。

### レイヤー構成

```
lib/
├── core/                      # 共通機能
│   ├── config/               # 設定
│   └── error/                # エラーハンドリング
├── features/                  # 機能別モジュール
│   ├── incident_history/     # 履歴画面
│   └── view_screen/          # ビュー画面（NEW）
│       ├── domain/           # ドメイン層
│       ├── application/      # アプリケーション層
│       ├── infrastructure/   # インフラ層
│       └── presentation/     # プレゼンテーション層
└── shared/                    # 共通UIコンポーネント
```

## 技術スタック

- **Flutter/Dart** - UIフレームワーク
- **flutter_bloc** - 状態管理
- **equatable** - Value Object
- **dartz** - Either型・関数型プログラミング
- **get_it** - 依存性注入
- **Widgetbook** - コンポーネントカタログ
- **mockito** - モック・テスト

## セットアップ

### 依存関係のインストール

```bash
cd sample-project/frontend
flutter pub get
```

### 開発サーバー起動

```bash
flutter run -d chrome
```

### Widgetbook起動

```bash
flutter run -d chrome -t widgetbook/main.dart
```

## テスト

### 全テスト実行

```bash
flutter test
```

### カバレッジ付きテスト

```bash
flutter test --coverage
```

### テスト構成

- **Widget Tests** - UIコンポーネントのテスト
- **Unit Tests** - UseCase/Repositoryのテスト
- **BLoC Tests** - 状態管理のテスト
- **Widgetbook Stories** - コンポーネントカタログ

## 開発ワークフロー

### Widgetbookファースト開発

1. **既存コンポーネント確認** - `shared/`の共通コンポーネントを確認
2. **新規コンポーネント作成** - 必要に応じて新規作成
3. **Widgetbook登録** - `widgetbook/`にストーリー追加
4. **Widgetbookで確認** - 視覚的に動作確認
5. **ページ構築** - 登録済みコンポーネントを組み合わせ

### TDDアプローチ

1. **Red** - 失敗するテストを書く
2. **Green** - テストが通る最小限の実装
3. **Refactor** - コードを改善

## 現在の実装状況

### ビュー画面（Issue #18）

**進捗:** 約65%完了

**完了:**
- ✅ Domain層（100%）
- ✅ Application層（100%）
- ✅ Infrastructure層（100%）
- ✅ Presentation層 - BLoC（100%）
- ✅ Presentation層 - Widgets（一部）
- ✅ Widgetbook登録（一部）
- ✅ テスト実装（主要テスト）

**詳細:** `.dodo/issue/issue-18/implementation-progress.md`

## ディレクトリ構造

```
sample-project/frontend/
├── lib/
│   ├── core/
│   ├── features/
│   │   ├── incident_history/
│   │   └── view_screen/
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   └── repositories/
│   │       ├── application/
│   │       │   └── usecases/
│   │       ├── infrastructure/
│   │       │   ├── datasources/
│   │       │   └── repositories/
│   │       └── presentation/
│   │           ├── blocs/
│   │           ├── pages/
│   │           └── widgets/
│   └── shared/
├── test/
│   └── features/
│       └── view_screen/
├── widgetbook/
│   ├── atoms/
│   ├── molecules/
│   └── organisms/
└── pubspec.yaml
```

## コーディング規約

- **Clean Architecture** - レイヤー間の依存関係を守る
- **Widgetbook First** - 新規コンポーネントは必ずWidgetbook登録
- **TDD** - テストファースト開発
- **Equatable** - Value Objectには必ず実装
- **Either型** - エラーハンドリングにはdartz使用

## 参考ドキュメント

- タスクファイル: `.dodo/.cline-instruction-template/daiki/ViewScreen/18-view-screen-implementation.md`
- 進捗サマリー: `.dodo/issue/issue-18/implementation-progress.md`
- 画面設計書: `docusaurus/docs/frontend/screen-design/view-screen.md`
- API仕様: `docusaurus/static/swagger/v2/microservice.yaml`
