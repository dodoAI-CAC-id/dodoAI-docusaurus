# Goal
View画面（sample-project/frontend/lib/features/view_screen）を、画面設計書（docusaurus/docs/frontend/screen-design/view-screen.md）の設計に従い、API（仕様: docusaurus/static/swagger/v2/microservice.yaml）と結合する。実行はローカルで行う。

# Completion Criteria
- ✅ ビュー画面がAPI連携で正常に動作する（一覧取得・詳細取得・ステータス更新）
- ✅ 画面設計書通りの状態遷移が実現される（未対応→対応中→検知なし）
- ✅ 全テスト（Unit Tests + Widget Tests + BLoC Tests + RemoteDataSource Tests）がパスする
- ✅ Clean Architectureの原則に従っている
- ✅ 互換性を維持している（破壊的変更なし）
- Must satisfy the following specifications:
  - docusaurus/docs/frontend/screen-design/view-screen.md
  - docusaurus/static/swagger/v2/microservice.yaml (incidents API)

# Frontend

- Code: `sample-project/frontend/lib/`
- Tests: `sample-project/frontend/test/`
- Widgetbook: `sample-project/frontend/widgetbook/`
- Documentation: `sample-project/frontend/README.md`

## Architecture
- Must strictly follow Clean Architecture + Modular Onion Architecture
- Layers: Domain / Application / Infrastructure / Presentation

## Key Technologies
- Flutter + Dart
- flutter_bloc (状態管理)
- equatable (Value Object)
- dartz (Either型・エラーハンドリング)
- get_it (DI)
- dio (HTTP Client)

## Feature Structure
```
lib/features/view_screen/
├── domain/
│   ├── entities/
│   │   ├── incident_item.dart           # アイテム表示用エンティティ
│   │   └── incident_status.dart         # ステータス定義（未対応/対応中/検知なし）
│   └── repositories/
│       └── i_view_screen_repository.dart
├── application/
│   └── usecases/
│       ├── get_incident_items_usecase.dart
│       └── update_incident_status_usecase.dart
├── infrastructure/
│   ├── datasources/
│   │   ├── mock_incident_datasource.dart      # 既存（保持）
│   │   └── view_screen_remote_datasource.dart # 新規作成
│   └── repositories/
│       ├── mock_view_screen_repository.dart   # 既存（保持）
│       └── view_screen_repository.dart        # 新規作成
└── presentation/
    ├── blocs/
    │   └── view_screen_bloc/
    │       ├── view_screen_bloc.dart
    │       ├── view_screen_event.dart
    │       └── view_screen_state.dart
    ├── pages/
    │   └── view_screen_page.dart
    └── widgets/
        ├── atoms/
        │   └── status_badge.dart
        └── molecules/
            └── incident_item_card.dart
```

## API Integration Requirements

### 新規作成ファイル
1. **view_screen_remote_datasource.dart**
   - 参考実装: `lib/features/incident_history/infrastructure/datasources/incident_remote_datasource.dart`
   - 使用技術: dio
   - 実装API:
     - `GET /api/v2/incidents` - 一覧取得
     - `GET /api/v2/incidents/{incidentId}` - 詳細取得（画像含む）
     - `POST /api/v2/incidents/{incidentId}/actions` - アクション登録
   - エラーハンドリング: DioException → Exception変換

2. **view_screen_repository.dart**
   - IViewScreenRepositoryインターフェース実装
   - RemoteDataSourceを使用
   - Either<Failure, T>でラップ

### 更新ファイル
1. **di/view_screen_injection.dart**
   - Mock/Remote両方を登録
   - 環境変数やフラグで切り替え可能にする
   - 例: `USE_MOCK_DATA`環境変数でMock/Remote選択

2. **domain/entities/incident_status.dart**
   - APIステータス（open/resolved/monitoring）とUIステータス（unhandled/in_progress/no_detection）のマッピングヘルパー追加
   - `fromApiStatus(String apiStatus)` メソッド追加
   - `toApiStatus()` メソッド追加

### API仕様とのマッピング

#### ステータスマッピング
```dart
// API → UI
open → unhandled
monitoring → in_progress
resolved → no_detection

// UI → API
unhandled → open
in_progress → monitoring
no_detection → resolved
```

#### アクションタイプ
画面設計書のactionTypeをそのままPOST /incidents/{incidentId}/actionsのbodyに使用:
- start_response (対応開始)
- revert (戻す)
- complete (完了)
- no_visit_needed (訪室不要)
- false_detection (誤検知)

#### 画像取得
- GET /incidents/{incidentId}のレスポンスに`pictures`オブジェクトが含まれる
- `pictureAtDetection`: 検知時画像（base64）
- `pictureBeforeDetection`: 検知直前画像（base64）

### 注意事項・リスク
1. **OpenAPI仕様の誤記**: `pictuers`と記載されているが、実装では`pictures`を想定
2. **ステータス値の差異**: API（open/resolved/monitoring）とUI（unhandled/in_progress/no_detection）の変換が必要
3. **アラート稼働/停止API**: OpenAPIに未定義のため、UIのみの実装またはモック対応
4. **通知情報取得**: 設計書では`GET /incidents/{incidentId}/notifications`だが、OpenAPIでは`GET /notifications?incidentId={id}`を使用

## Local Development
```bash
cd sample-project/frontend

# 依存関係インストール
flutter pub get

# 開発サーバー起動
flutter run -d chrome

# 環境変数でMock/Remote切り替え（例）
flutter run -d chrome --dart-define=USE_MOCK_DATA=false
```

### API接続設定
- BaseURL: `lib/core/config/api_config.dart`で定義済み
- デフォルト: `http://localhost:8080`
- 環境変数: `API_BASE_URL`で上書き可能

### バックエンド起動（ローカルテスト用）
```bash
cd sample-project
docker-compose up -d
```

# Testing

## Test Strategy References (MANDATORY)
- **Testing Strategy:** `docusaurus/docs/19.Test/testing-strategy.md`
- **8-Layer Test Pyramid:** `docusaurus/docs/1.DevOps/dev-process/01-foundation/8-layer-test-pyramid.md`
- **Frontend Test Guide:** `docusaurus/docs/3.frontend/4.test/`

## Required Test Layers

### 1. Unit Tests（新規追加）
- **view_screen_remote_datasource_test.dart**
  - HTTP成功/失敗ケース
  - レスポンス形式のバリエーション（配列直接/data wrappedなど）
  - DioExceptionハンドリング
  - タイムアウト処理

- **view_screen_repository_test.dart**
  - Either<Failure, T>の正常系/異常系
  - DataSourceからRepositoryへのエラー伝播

### 2. BLoC Tests（既存継続）
- **view_screen_bloc_test.dart**
  - 既存テストを維持
  - Remote接続時の動作確認（Mockを使用）

### 3. Widget Tests（既存継続）
- **incident_item_card_test.dart**
- **status_badge_test.dart**
- **view_screen_page_test.dart**（必要に応じて）

## Test Execution
```bash
# 全テスト実行
cd sample-project/frontend
flutter test

# カバレッジ
flutter test --coverage

# 特定ファイルのみ
flutter test test/features/view_screen/infrastructure/datasources/view_screen_remote_datasource_test.dart
```

## Test Results Storage
- Frontend Tests: `sample-project/frontend/test/`
- Coverage Reports: `sample-project/frontend/coverage/`
- Manual Test Results: `.dodo/issue/issue-20/`

# Development Process

**Required:** `docusaurus/docs/1.DevOps/dev-process/`

## Complexity Assessment
- Reference: `docusaurus/docs/1.DevOps/dev-process/02-core-process/complexity-based-approach-selection.md`
- Assessment Result: **STANDARD**
- Execute Iterations: **Iteration 1-4**

### Complexity Breakdown (Total: 6 points)
1. 新規ドメインロジック: 2点（APIステータスマッピング、アクション種別整合）
2. アーキテクチャ影響: 2点（Infrastructure層追加、DI切替）
3. API変更: 0点（既存API使用）
4. データベース変更: 0点（フロント連携のみ）
5. テストスコープ: 2点（Unit + Widget + BLoC + RemoteDataSource）

## Checkpoint-Gated Iteration
- Reference: `docusaurus/docs/1.DevOps/dev-process/02-core-process/checkpoint-gated-iteration.md`
- Checkpoint Details: `docusaurus/docs/1.DevOps/dev-process/03-iteration-checkpoints/`

## Local Development Targets
- Frontend: `sample-project/frontend/`
- Backend: `sample-project/backend/`（参照のみ）

## Database
- ローカル開発: docker-composeでPostgreSQL起動
- シードデータ: `sample-project/backend/migrations/seed_test_data.sql`

# Development Rules

- No long CLI commands (causes Cline to freeze)
- TDD strictly required when errors occur
- Always update work plan: `.dodo/issue/issue-20/`
- Strictly follow Clean Architecture + Modular Onion Architecture
- **API First**: OpenAPI仕様を優先し、設計書との差異は明示的に対応

# Documentation Updates

**Docusaurus Rules:** `.clinerules/09-docusaurus-updates.md`
- Write in English (unless requested otherwise)
- Location: `docusaurus/docs/`
- Lint before commit: `cd docusaurus/docs && npm run lint:md`
- Fix errors manually (no auto-fix)

## Documents to Update
- `sample-project/frontend/README.md` - API連携の説明追加（環境変数、DI切替方法）
- `.dodo/issue/issue-20/implementation-progress.md` - 実装進捗記録

# Prohibited Rules

- ❌ DO NOT update env files
- ❌ DO NOT use `npm run lint:md:fix` (breaks MDX)
- ❌ DO NOT modify backend API implementation
- ❌ DO NOT change existing Mock implementation (keep for testing)
- ❌ DO NOT break existing tests
