# Goal
docusaurus/docs/frontend/screen-design/view-screen.md の画面設計に従い、フロントエンド（ビュー画面）を構築する。データはモックで構わない。

**Widgetbook開発要件:**
- 可能な場合は、Widgetbookにある既存UIコンポーネントを使用して構築する
- 存在しないUIである場合は、新規にコンポーネントを作成し、Widgetbookに登録した上で、それを使ってページを構築する

# Completion Criteria
- ✅ ビュー画面が画面設計書通りに表示される
- ✅ 各ステータスの状態遷移が正常に動作する（未対応→対応中→検知なし）
- ✅ モックデータで全機能が動作確認できる
- ✅ 全テストがパスする（Widget Tests + Unit Tests + BLoC Tests + Widgetbookストーリー）
- ✅ Clean Architectureの原則に従っている
- ✅ Widgetbookに全コンポーネントが登録されている
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
- Widgetbook (コンポーネント開発・カタログ)
- qr_flutter (QRコード表示)

## Widgetbook Development Workflow

### Step 1: 既存コンポーネントのWidgetbook登録
既存の共通コンポーネント（`lib/shared/presentation/components/`）をWidgetbookに登録:
- Atoms: app_button, app_text, app_text_field, app_checkbox, app_dropdown, app_icon_button
- Organisms: app_header

### Step 2: 新規コンポーネント作成とWidgetbook登録
ビュー画面固有の新規コンポーネントを作成し、必ずWidgetbookに登録:
- Atoms: status_badge（ステータス表示バッジ）
- Molecules: incident_item_card（アイテムカード）, action_buttons（操作ボタン群）, detection_images（検知画像表示）
- Organisms: incident_list_section（異常検知一覧）, person_list_section（ご利用者一覧）

### Step 3: ページ構築
Widgetbookに登録済みのコンポーネントを組み合わせて`view_screen_page.dart`を構築

### Widgetbookコマンド
```bash
# Widgetbook起動（開発中に随時確認）
cd sample-project/frontend
flutter run -d chrome -t widgetbook/main.dart

# ビルド
flutter build web -t widgetbook/main.dart
```

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
│   │   └── mock_incident_datasource.dart
│   └── repositories/
│       └── mock_view_screen_repository.dart
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
        ├── molecules/
        │   ├── incident_item_card.dart
        │   ├── action_buttons.dart
        │   └── detection_images.dart
        └── organisms/
            ├── incident_list_section.dart
            └── person_list_section.dart
```

## Widgetbook Structure
```
widgetbook/
├── atoms/
│   ├── app_button.widgetbook.dart       # 既存コンポーネント登録
│   ├── app_text.widgetbook.dart
│   ├── app_text_field.widgetbook.dart
│   ├── app_checkbox.widgetbook.dart
│   ├── app_dropdown.widgetbook.dart
│   ├── app_icon_button.widgetbook.dart
│   └── status_badge.widgetbook.dart     # 新規コンポーネント登録
├── molecules/
│   ├── incident_item_card.widgetbook.dart
│   ├── action_buttons.widgetbook.dart
│   └── detection_images.widgetbook.dart
├── organisms/
│   ├── app_header.widgetbook.dart       # 既存コンポーネント登録
│   ├── incident_list_section.widgetbook.dart
│   └── person_list_section.widgetbook.dart
└── main.dart                             # Widgetbookエントリーポイント
```

# Testing

## Test Strategy References (MANDATORY)
- **Testing Strategy:** `docusaurus/docs/19.Test/testing-strategy.md`
- **8-Layer Test Pyramid:** `docusaurus/docs/1.DevOps/dev-process/01-foundation/8-layer-test-pyramid.md`
- **Frontend Test Guide:** `docusaurus/docs/3.frontend/4.test/`

## Required Test Layers

### 1. Widgetbookストーリー（視覚的確認）
各コンポーネントでWidgetbookストーリーを作成:
- 各状態のバリエーション表示
- インタラクティブなプロパティ変更
- 視覚的リグレッションテストの基盤

### 2. Widget Tests（自動テスト）
- Atoms: status_badge_test.dart
- Molecules: incident_item_card_test.dart, action_buttons_test.dart, detection_images_test.dart
- Organisms: incident_list_section_test.dart, person_list_section_test.dart
- Pages: view_screen_page_test.dart

### 3. Unit Tests（ロジックテスト）
- UseCase: get_incident_items_usecase_test.dart
- UseCase: update_incident_status_usecase_test.dart
- Repository: mock_view_screen_repository_test.dart

### 4. BLoC Tests（状態管理テスト）
- view_screen_bloc_test.dart（全イベント・状態遷移）

## Test Execution
```bash
# 全テスト実行
cd sample-project/frontend
flutter test

# カバレッジ
flutter test --coverage

# Widgetbook起動（視覚的確認）
flutter run -d chrome -t widgetbook/main.dart
```

## Test Results Storage
- Frontend Tests: `sample-project/frontend/test/`
- Coverage Reports: `sample-project/frontend/coverage/`
- Manual Test Results: `.dodo/issue/issue-18/`

# Development Process

**Required:** `docusaurus/docs/1.DevOps/dev-process/`

## Complexity Assessment
- Reference: `docusaurus/docs/1.DevOps/dev-process/02-core-process/complexity-based-approach-selection.md`
- Assessment Result: **STANDARD**
- Execute Iterations: **Iteration 1-4**

### Complexity Breakdown (Total: 7 points)
1. 新規ドメインロジック: 1点（Incidentエンティティは既存、ステータス管理のみ）
2. アーキテクチャ影響: 2点（複数レイヤー必要だが既存パターン踏襲）
3. API変更: 1点（既存API使用、新規エンドポイント不要）
4. データベース変更: 0点（モックデータのみ）
5. テストスコープ: 3点（Widget + Unit + BLoC + Widgetbookストーリー）

## Checkpoint-Gated Iteration
- Reference: `docusaurus/docs/1.DevOps/dev-process/02-core-process/checkpoint-gated-iteration.md`
- Checkpoint Details: `docusaurus/docs/1.DevOps/dev-process/03-iteration-checkpoints/`

## Local Development
### Frontend Development
```bash
cd sample-project/frontend

# 依存関係インストール
flutter pub get

# 開発サーバー起動
flutter run -d chrome

# Widgetbook起動
flutter run -d chrome -t widgetbook/main.dart
```

### Mock Data
モックデータは `infrastructure/datasources/mock_incident_datasource.dart` で定義

# Development Rules

- No long CLI commands (causes Cline to freeze)
- TDD strictly required when errors occur
- Always update work plan: `.dodo/issue/issue-18/`
- Strictly follow Clean Architecture + Modular Onion Architecture
- **Widgetbook First:** 新規コンポーネントは必ずWidgetbookに登録してから使用

# Documentation Updates

**Docusaurus Rules:** `.clinerules/09-docusaurus-updates.md`
- Write in English (unless requested otherwise)
- Location: `docusaurus/docs/`
- Lint before commit: `cd docusaurus/docs && npm run lint:md`
- Fix errors manually (no auto-fix)

## Documents to Update
- `sample-project/frontend/README.md` - 新機能（ビュー画面）の説明追加
- `docusaurus/docs/frontend/` - 新画面のアーキテクチャ図・コンポーネント一覧（該当があれば）

# Prohibited Rules

- ❌ DO NOT update env files
- ❌ DO NOT use `npm run lint:md:fix` (breaks MDX)
- ❌ DO NOT skip Widgetbook registration for new components
- ❌ DO NOT implement real API connections (mock only for this task)
