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
- **dio** - HTTP Client
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
# デフォルト（Mockデータ使用）
flutter run -d chrome

# Remote API使用（バックエンドが起動している必要あり）
flutter run -d chrome --dart-define=USE_MOCK_DATA=false

# API Base URLを指定
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8080
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

## API連携設定

### Mock/Remote切り替え

ビュー画面機能は、Mock実装とRemote API実装の両方をサポートしています。

#### Mock使用（デフォルト）

```dart
// lib/main.dart または該当箇所
setupViewScreenDependencies(useMockData: true);
```

#### Remote API使用

```dart
// lib/main.dart または該当箇所
setupViewScreenDependencies(useMockData: false);
```

環境変数での制御も可能：

```bash
flutter run -d chrome --dart-define=USE_MOCK_DATA=false
```

### API Base URL設定

デフォルトは `http://localhost:8080` です。変更する場合：

```bash
flutter run -d chrome --dart-define=API_BASE_URL=https://api.example.com
```

または `lib/core/config/api_config.dart` を編集。

### バックエンド起動（ローカル開発）

```bash
cd sample-project
docker-compose up -d
```

## 現在の実装状況

### ビュー画面（Issue #18 - Mock実装）

**進捗:** 100%完了

**完了:**
- ✅ Domain層（100%）
- ✅ Application層（100%）
- ✅ Infrastructure層 - Mock（100%）
- ✅ Presentation層 - BLoC（100%）
- ✅ Presentation層 - Widgets（100%）
- ✅ Widgetbook登録（100%）
- ✅ テスト実装（100%）

**詳細:** `.dodo/issue/issue-18/implementation-progress.md`

### ビュー画面API結合（Issue #20 - Remote実装）

**進捗:** 80%完了

**完了:**
- ✅ Domain層 - APIマッピング（100%）
- ✅ Infrastructure層 - RemoteDataSource（100%）
- ✅ Infrastructure層 - Repository（100%）
- ✅ DI設定 - Mock/Remote切替（100%）
- ✅ 既存テスト確認（100%）
- ⏳ RemoteDataSource Unit Test（0%）
- ⏳ Repository Unit Test（0%）
- ⏳ ローカルAPI接続テスト（0%）

**詳細:** `.dodo/issue/issue-20/implementation-progress.md`

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

## API仕様マッピング

### ステータス変換

```dart
// API → UI
open → unhandled (未対応)
monitoring → in_progress (対応中)
resolved → no_detection (検知なし)

// UI → API
unhandled → open
in_progress → monitoring
no_detection → resolved
```

### 使用API

- `GET /api/v2/incidents` - 一覧取得
- `GET /api/v2/incidents/{incidentId}` - 詳細取得（画像含む）
- `POST /api/v2/incidents/{incidentId}/actions` - アクション登録

### 注意事項

1. OpenAPI仕様の誤記: `pictuers` → 実装では `pictures` を想定
2. アラート稼働/停止APIは未定義（UIのみ対応）
3. 通知情報取得: `/notifications?incidentId={id}` を使用

## 参考ドキュメント

- タスクファイル（Mock実装）: `.dodo/.cline-instruction-template/daiki/ViewScreen/18-view-screen-implementation.md`
- タスクファイル（API結合）: `.dodo/.cline-instruction-template/daiki.ichikawa/ViewScreen/20-view-screen-api-integration.md`
- 進捗サマリー（Mock）: `.dodo/issue/issue-18/implementation-progress.md`
- 進捗サマリー（API結合）: `.dodo/issue/issue-20/implementation-progress.md`
- 画面設計書: `docusaurus/docs/frontend/screen-design/view-screen.md`
- API仕様: `docusaurus/static/swagger/v2/microservice.yaml`
