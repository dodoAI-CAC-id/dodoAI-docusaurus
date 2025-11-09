---
id: incident-history-implementation-plan
title: 履歴画面実装プラン
---

![最終更新日](https://img.shields.io/static/v1?label=最終更新日&message=2025/10/21&color=blue)

# 履歴画面（Incident History Screen）実装プラン

## 📋 概要

### 目的
異常検知履歴の一覧表示・検索・動画視聴機能を提供するFlutter Web画面を開発する。

### 対象画面
- **画面名**: 履歴画面（History Screen）
- **設計書**: `/docusaurus/docs/frontend/screen-design/history-screen.md`
- **画面デザイン**: `/docusaurus/static/img/docs/frontend/history-screen.png`
- **API仕様**: `/docusaurus/static/swagger/v2/microservice.yaml`

### アーキテクチャ方針
- **Modular Onion Architecture**: レイヤー分離による保守性向上
- **Atomic Design**: UIコンポーネントの階層的管理
- **BLoC Pattern**: 状態管理の明確化
- **TDD (Test-Driven Development)**: テスト駆動開発の徹底

---

## 🏗️ アーキテクチャ構成

### Feature構成: `features/incident_history/`

```
features/
└── incident_history/
    ├── domain/                    # ドメイン層（ビジネスロジック）
    │   ├── entities/
    │   │   ├── incident.dart                 # 異常イベントエンティティ
    │   │   ├── incident_video.dart           # 動画エンティティ
    │   │   ├── search_criteria.dart          # 検索条件
    │   │   └── pagination_info.dart          # ページネーション情報
    │   └── repositories/
    │       ├── i_incident_repository.dart    # 異常イベントリポジトリインターフェース
    │       └── i_video_repository.dart       # 動画リポジトリインターフェース
    │
    ├── application/               # アプリケーション層（ユースケース）
    │   └── usecases/
    │       ├── get_incidents_usecase.dart    # 異常イベント一覧取得
    │       ├── search_incidents_usecase.dart # 異常イベント検索
    │       ├── get_video_usecase.dart        # 動画取得
    │       └── download_video_usecase.dart   # 動画ダウンロード
    │
    ├── infrastructure/            # インフラ層（データアクセス）
    │   ├── datasources/
    │   │   ├── incident_graphql_source.dart  # GraphQL/REST API呼び出し
    │   │   └── video_graphql_source.dart     # 動画API呼び出し
    │   └── repositories/
    │       ├── incident_repository_impl.dart # リポジトリ実装
    │       └── video_repository_impl.dart    # 動画リポジトリ実装
    │
    └── presentation/              # プレゼンテーション層（UI）
        ├── blocs/
        │   └── incident_history_bloc/
        │       ├── incident_history_bloc.dart   # BLoC本体
        │       ├── incident_history_event.dart  # イベント定義
        │       └── incident_history_state.dart  # 状態定義
        ├── pages/
        │   └── incident_history_page.dart       # 履歴画面ページ
        └── widgets/
            ├── organisms/
            │   ├── incident_list_table.dart     # 履歴テーブル全体
            │   ├── incident_search_bar.dart     # 検索バー全体
            │   └── pagination_controls.dart     # ページネーション
            └── molecules/
                ├── incident_list_row.dart       # 履歴行（1レコード）
                ├── video_player_dialog.dart     # 動画再生ダイアログ
                ├── date_range_picker.dart       # 期間選択
                └── search_criteria_input.dart   # 検索条件入力
```

---

## 🎨 Atomic Design構成

### 1. Atoms（基本UIパーツ）
**配置場所**: `shared/presentation/components/atoms/`

| コンポーネント | ファイル名 | 説明 |
|--------------|-----------|------|
| ボタン | `app_button.dart` | 汎用ボタン（検索、ダウンロードなど） |
| テキストフィールド | `app_text_field.dart` | 入力フィールド |
| チェックボックス | `app_checkbox.dart` | チェックボックス |
| 日付選択 | `app_date_picker.dart` | 日付選択ウィジェット |
| ドロップダウン | `app_dropdown.dart` | ドロップダウンメニュー |
| アイコンボタン | `app_icon_button.dart` | アイコン付きボタン |
| テキスト | `app_text.dart` | スタイル付きテキスト |

### 2. Molecules（複合UIパーツ）
**配置場所**: `features/incident_history/presentation/widgets/molecules/`

| コンポーネント | ファイル名 | 説明 |
|--------------|-----------|------|
| 履歴行 | `incident_list_row.dart` | 1レコード分の表示（チェックボックス、各項目、アイコン） |
| 動画プレイヤー | `video_player_dialog.dart` | 動画再生ダイアログ |
| 期間選択 | `date_range_picker.dart` | 開始日〜終了日の選択 |
| 検索条件入力 | `search_criteria_input.dart` | 検索条件フォーム |

### 3. Organisms（セクション）
**配置場所**: `features/incident_history/presentation/widgets/organisms/`

| コンポーネント | ファイル名 | 説明 |
|--------------|-----------|------|
| 履歴テーブル | `incident_list_table.dart` | 履歴一覧テーブル全体 |
| 検索バー | `incident_search_bar.dart` | 検索条件入力エリア全体 |
| ページネーション | `pagination_controls.dart` | ページ切り替えコントロール |

### 4. Page（画面）
**配置場所**: `features/incident_history/presentation/pages/`

| コンポーネント | ファイル名 | 説明 |
|--------------|-----------|------|
| 履歴画面 | `incident_history_page.dart` | 履歴画面全体の構成 |

---

## 🔄 状態管理（BLoC Pattern）

### Events（イベント定義）

```dart
abstract class IncidentHistoryEvent {}

// 初期表示
class LoadIncidentsEvent extends IncidentHistoryEvent {}

// 検索実行
class SearchIncidentsEvent extends IncidentHistoryEvent {
  final SearchCriteria criteria;
  SearchIncidentsEvent(this.criteria);
}

// ページ変更
class ChangePageEvent extends IncidentHistoryEvent {
  final int pageNumber;
  ChangePageEvent(this.pageNumber);
}

// 動画再生
class PlayVideoEvent extends IncidentHistoryEvent {
  final String videoId;
  PlayVideoEvent(this.videoId);
}

// 動画ダウンロード
class DownloadVideoEvent extends IncidentHistoryEvent {
  final String videoId;
  DownloadVideoEvent(this.videoId);
}
```

### States（状態定義）

```dart
abstract class IncidentHistoryState {}

// 初期状態
class IncidentHistoryInitial extends IncidentHistoryState {}

// ローディング中
class IncidentHistoryLoading extends IncidentHistoryState {}

// データ読み込み完了
class IncidentHistoryLoaded extends IncidentHistoryState {
  final List<Incident> incidents;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  
  IncidentHistoryLoaded({
    required this.incidents,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
  });
}

// エラー
class IncidentHistoryError extends IncidentHistoryState {
  final String message;
  IncidentHistoryError(this.message);
}

// 動画再生中
class VideoPlayingState extends IncidentHistoryState {
  final String videoUrl;
  VideoPlayingState(this.videoUrl);
}
```

### BLoC実装例

```dart
class IncidentHistoryBloc extends Bloc<IncidentHistoryEvent, IncidentHistoryState> {
  final GetIncidentsUseCase getIncidentsUseCase;
  final SearchIncidentsUseCase searchIncidentsUseCase;
  final GetVideoUseCase getVideoUseCase;

  IncidentHistoryBloc({
    required this.getIncidentsUseCase,
    required this.searchIncidentsUseCase,
    required this.getVideoUseCase,
  }) : super(IncidentHistoryInitial()) {
    on<LoadIncidentsEvent>(_onLoadIncidents);
    on<SearchIncidentsEvent>(_onSearchIncidents);
    on<ChangePageEvent>(_onChangePage);
    on<PlayVideoEvent>(_onPlayVideo);
  }

  Future<void> _onLoadIncidents(
    LoadIncidentsEvent event,
    Emitter<IncidentHistoryState> emit,
  ) async {
    emit(IncidentHistoryLoading());
    final result = await getIncidentsUseCase();
    result.fold(
      (failure) => emit(IncidentHistoryError(failure.message)),
      (data) => emit(IncidentHistoryLoaded(
        incidents: data.incidents,
        currentPage: 1,
        totalPages: data.totalPages,
        totalCount: data.totalCount,
      )),
    );
  }

  // 他のイベントハンドラも同様に実装
}
```

---

## 📡 API連携

### 使用するAPI（microservice.yaml参照）

#### 1. 異常イベント一覧取得
```
GET /incidents
Query Parameters:
  - personId: string (対象者IDでフィルタ)
  - from: datetime (開始日時)
  - to: datetime (終了日時)
  - status: string (open/resolved/monitoring)
  
Response: Incident[]
```

#### 2. 異常イベント詳細取得
```
GET /incidents/{incidentId}
Response: Incident
```

#### 3. 対応履歴取得
```
GET /incidents/{incidentId}/actions
Response: Action[]
```

#### 4. 動画ファイル取得
```
GET /videos/{videoId}/file
Response: video/mp4 (binary)
```

### Repository実装例

```dart
class IncidentRepositoryImpl implements IIncidentRepository {
  final IncidentGraphQLSource dataSource;

  IncidentRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, IncidentListResult>> getIncidents({
    String? personId,
    DateTime? from,
    DateTime? to,
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final result = await dataSource.queryIncidents(
        personId: personId,
        from: from,
        to: to,
        status: status,
        page: page,
        limit: limit,
      );
      
      if (result.hasException) {
        return Left(ServerFailure(result.exception.toString()));
      }
      
      final incidents = (result.data['incidents'] as List)
          .map((json) => Incident.fromJson(json))
          .toList();
          
      return Right(IncidentListResult(
        incidents: incidents,
        totalCount: result.data['totalCount'],
        totalPages: (result.data['totalCount'] / limit).ceil(),
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

---

## ✅ TDD実装順序

### Phase 1: Domain Layer（ドメイン層）

#### 1.1 Entity作成
- [ ] **テスト**: `test/features/incident_history/domain/entities/incident_test.dart`
- [ ] **実装**: `lib/features/incident_history/domain/entities/incident.dart`
- [ ] **テスト**: `test/features/incident_history/domain/entities/incident_video_test.dart`
- [ ] **実装**: `lib/features/incident_history/domain/entities/incident_video.dart`
- [ ] **テスト**: `test/features/incident_history/domain/entities/search_criteria_test.dart`
- [ ] **実装**: `lib/features/incident_history/domain/entities/search_criteria.dart`

#### 1.2 Repository Interface作成
- [ ] **テスト**: `test/features/incident_history/domain/repositories/i_incident_repository_test.dart`
- [ ] **実装**: `lib/features/incident_history/domain/repositories/i_incident_repository.dart`
- [ ] **テスト**: `test/features/incident_history/domain/repositories/i_video_repository_test.dart`
- [ ] **実装**: `lib/features/incident_history/domain/repositories/i_video_repository.dart`

### Phase 2: Application Layer（アプリケーション層）

#### 2.1 UseCase作成
- [ ] **テスト**: `test/features/incident_history/application/usecases/get_incidents_usecase_test.dart`
- [ ] **実装**: `lib/features/incident_history/application/usecases/get_incidents_usecase.dart`
- [ ] **テスト**: `test/features/incident_history/application/usecases/search_incidents_usecase_test.dart`
- [ ] **実装**: `lib/features/incident_history/application/usecases/search_incidents_usecase.dart`
- [ ] **テスト**: `test/features/incident_history/application/usecases/get_video_usecase_test.dart`
- [ ] **実装**: `lib/features/incident_history/application/usecases/get_video_usecase.dart`

### Phase 3: Infrastructure Layer（インフラ層）

#### 3.1 DataSource作成
- [ ] **テスト**: `test/features/incident_history/infrastructure/datasources/incident_graphql_source_test.dart`
- [ ] **実装**: `lib/features/incident_history/infrastructure/datasources/incident_graphql_source.dart`
- [ ] **テスト**: `test/features/incident_history/infrastructure/datasources/video_graphql_source_test.dart`
- [ ] **実装**: `lib/features/incident_history/infrastructure/datasources/video_graphql_source.dart`

#### 3.2 Repository Implementation作成
- [ ] **テスト**: `test/features/incident_history/infrastructure/repositories/incident_repository_impl_test.dart`
- [ ] **実装**: `lib/features/incident_history/infrastructure/repositories/incident_repository_impl.dart`
- [ ] **テスト**: `test/features/incident_history/infrastructure/repositories/video_repository_impl_test.dart`
- [ ] **実装**: `lib/features/incident_history/infrastructure/repositories/video_repository_impl.dart`

### Phase 4: Presentation Layer（プレゼンテーション層）

#### 4.1 BLoC作成
- [ ] **テスト**: `test/features/incident_history/presentation/blocs/incident_history_bloc_test.dart`
- [ ] **実装**: `lib/features/incident_history/presentation/blocs/incident_history_bloc/incident_history_bloc.dart`
- [ ] **実装**: `lib/features/incident_history/presentation/blocs/incident_history_bloc/incident_history_event.dart`
- [ ] **実装**: `lib/features/incident_history/presentation/blocs/incident_history_bloc/incident_history_state.dart`

#### 4.2 Atoms作成
- [ ] **テスト**: `test/shared/presentation/components/atoms/app_button_test.dart`
- [ ] **実装**: `lib/shared/presentation/components/atoms/app_button.dart`
- [ ] **Widgetbook登録**: `widgetbook/atoms/app_button_story.dart`
- [ ] **テスト**: `test/shared/presentation/components/atoms/app_text_field_test.dart`
- [ ] **実装**: `lib/shared/presentation/components/atoms/app_text_field.dart`
- [ ] **Widgetbook登録**: `widgetbook/atoms/app_text_field_story.dart`
- [ ] **テスト**: `test/shared/presentation/components/atoms/app_checkbox_test.dart`
- [ ] **実装**: `lib/shared/presentation/components/atoms/app_checkbox.dart`
- [ ] **Widgetbook登録**: `widgetbook/atoms/app_checkbox_story.dart`

#### 4.3 Molecules作成
- [ ] **テスト**: `test/features/incident_history/presentation/widgets/molecules/incident_list_row_test.dart`
- [ ] **実装**: `lib/features/incident_history/presentation/widgets/molecules/incident_list_row.dart`
- [ ] **Widgetbook登録**: `widgetbook/molecules/incident_list_row_story.dart`
- [ ] **テスト**: `test/features/incident_history/presentation/widgets/molecules/video_player_dialog_test.dart`
- [ ] **実装**: `lib/features/incident_history/presentation/widgets/molecules/video_player_dialog.dart`
- [ ] **Widgetbook登録**: `widgetbook/molecules/video_player_dialog_story.dart`
- [ ] **テスト**: `test/features/incident_history/presentation/widgets/molecules/date_range_picker_test.dart`
- [ ] **実装**: `lib/features/incident_history/presentation/widgets/molecules/date_range_picker.dart`
- [ ] **Widgetbook登録**: `widgetbook/molecules/date_range_picker_story.dart`

#### 4.4 Organisms作成
- [ ] **テスト**: `test/features/incident_history/presentation/widgets/organisms/incident_list_table_test.dart`
- [ ] **実装**: `lib/features/incident_history/presentation/widgets/organisms/incident_list_table.dart`
- [ ] **Widgetbook登録**: `widgetbook/organisms/incident_list_table_story.dart`
- [ ] **テスト**: `test/features/incident_history/presentation/widgets/organisms/incident_search_bar_test.dart`
- [ ] **実装**: `lib/features/incident_history/presentation/widgets/organisms/incident_search_bar.dart`
- [ ] **Widgetbook登録**: `widgetbook/organisms/incident_search_bar_story.dart`
- [ ] **テスト**: `test/features/incident_history/presentation/widgets/organisms/pagination_controls_test.dart`
- [ ] **実装**: `lib/features/incident_history/presentation/widgets/organisms/pagination_controls.dart`
- [ ] **Widgetbook登録**: `widgetbook/organisms/pagination_controls_story.dart`

#### 4.5 Page作成
- [ ] **テスト**: `test/features/incident_history/presentation/pages/incident_history_page_test.dart`
- [ ] **実装**: `lib/features/incident_history/presentation/pages/incident_history_page.dart`

### Phase 5: Integration & E2E Testing

#### 5.1 統合テスト
- [ ] **テスト**: `integration_test/features/incident_history/incident_history_integration_test.dart`

#### 5.2 E2Eテスト
- [ ] **テスト**: `integration_test/features/incident_history/incident_history_e2e_test.dart`

---

## 📚 Widgetbook登録

### Widgetbook構成

```dart
// widgetbook/main.dart
import 'package:widgetbook/widgetbook.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const HotReload());
}

class HotReload extends StatelessWidget {
  const HotReload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: [
        // Atoms
        WidgetbookCategory(
          name: 'Atoms',
          children: [
            WidgetbookComponent(
              name: 'AppButton',
              useCases: [
                WidgetbookUseCase(
                  name: 'Primary Button',
                  builder: (context) => AppButton(
                    text: '検索',
                    onPressed: () {},
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Secondary Button',
                  builder: (context) => AppButton(
                    text: 'キャンセル',
                    type: ButtonType.secondary,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'AppTextField',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => AppTextField(
                    label: '見守り対象者名',
                    hint: '名前を入力',
                  ),
                ),
              ],
            ),
          ],
        ),
        
        // Molecules
        WidgetbookCategory(
          name: 'Molecules',
          children: [
            WidgetbookComponent(
              name: 'IncidentListRow',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => IncidentListRow(
                    incident: Incident(
                      id: '001',
                      detectedAt: DateTime.now(),
                      type: '転倒',
                      personName: '山田太郎',
                      roomNumber: '101',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        
        // Organisms
        WidgetbookCategory(
          name: 'Organisms',
          children: [
            WidgetbookComponent(
              name: 'IncidentListTable',
              useCases: [
                WidgetbookUseCase(
                  name: 'With Data',
                  builder: (context) => IncidentListTable(
                    incidents: _mockIncidents,
                    onRowTap: (incident) {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
```

---

## 🎯 実装チェックリスト

### Domain Layer
- [ ] Incident Entity
- [ ] IncidentVideo Entity
- [ ] SearchCriteria Entity
- [ ] IIncidentRepository Interface
- [ ] IVideoRepository Interface

### Application Layer
- [ ] GetIncidentsUseCase
- [ ] SearchIncidentsUseCase
- [ ] GetVideoUseCase
- [ ] DownloadVideoUseCase

### Infrastructure Layer
- [ ] IncidentGraphQLSource
- [ ] VideoGraphQLSource
- [ ] IncidentRepositoryImpl
- [ ] VideoRepositoryImpl

### Presentation Layer - BLoC
- [ ] IncidentHistoryBloc
- [ ] IncidentHistoryEvent
- [ ] IncidentHistoryState

### Presentation Layer - UI Components
#### Atoms
- [ ] AppButton
- [ ] AppTextField
- [ ] AppCheckbox
- [ ] AppDatePicker
- [ ] AppDropdown

#### Molecules
- [ ] IncidentListRow
- [ ] VideoPlayerDialog
- [ ] DateRangePicker
- [ ] SearchCriteriaInput

#### Organisms
- [ ] IncidentListTable
- [ ] IncidentSearchBar
- [ ] PaginationControls

#### Page
- [ ] IncidentHistoryPage

### Testing
- [ ] Unit Tests (Domain)
- [ ] Unit Tests (Application)
- [ ] Unit Tests (Infrastructure)
- [ ] Widget Tests (Presentation)
- [ ] Integration Tests
- [ ] E2E Tests

### Widgetbook
- [ ] Atoms Stories
- [ ] Molecules Stories
- [ ] Organisms Stories

### Documentation
- [ ] 実装プラン作成（本ドキュメント）
- [ ] 完了レポート作成

---

## 📝 技術スタック

### フレームワーク・ライブラリ
- **Flutter**: 3.x
- **Dart**: 3.x
- **flutter_bloc**: ^8.x (状態管理)
- **dartz**: ^0.10.x (Either型)
- **get_it**: ^7.x (DI)
- **flutter_modular**: ^6.x (ルーティング・DI)
- **graphql_flutter**: ^5.x (GraphQL)
- **video_player**: ^2.x (動画再生)
- **widgetbook**: ^3.x (UIカタログ)

### テスト
- **flutter_test**: SDK標準
- **mockito**: ^5.x (モック)
- **bloc_test**: ^9.x (BLoCテスト)
- **integration_test**: SDK標準

---

## 🚀 開発フロー

### 1. 環境セットアップ
```bash
# 依存関係インストール
flutter pub get

# コード生成
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. TDD開発サイクル
1. **Red**: テストを書く（失敗する）
2. **Green**: 最小限の実装でテストを通す
3. **Refactor**: コードをリファクタリング
4. 繰り返し

### 3. Widgetbook確認
```bash
# Widgetbookを起動
flutter run -t widgetbook/main.dart -d chrome
```

### 4. テスト実行
```bash
# 全テスト実行
flutter test

# カバレッジ付き
flutter test --coverage

# 統合テスト
flutter test integration_test/
```

---

## 📊 進捗管理

### マイルストーン

| Phase | 内容 | 期間目安 | 完了 |
|-------|------|---------|------|
| Phase 1 | Domain Layer実装 | 2日 | ☐ |
| Phase 2 | Application Layer実装 | 2日 | ☐ |
| Phase 3 | Infrastructure Layer実装 | 3日 | ☐ |
| Phase 4 | Presentation Layer実装 | 5日 | ☐ |
| Phase 5 | Integration & E2E Testing | 2日 | ☐ |
| Phase 6 | Widgetbook整備 | 1日 | ☐ |
| Phase 7 | ドキュメント作成 | 1日 | ☐ |

**合計**: 約16日

---

## 🔍 レビューポイント

### コードレビュー観点
- [ ] Onion Architectureの依存関係が正しいか
- [ ] Atomic Designの階層が適切か
- [ ] BLoCパターンが正しく実装されているか
- [ ] テストカバレッジが十分か（目標: 80%以上）
- [ ] Widgetbookに全コンポーネントが登録されているか
- [ ] API仕様に準拠しているか
- [ ] エラーハンドリングが適切か
- [ ] パフォーマンスに問題がないか

---

## 📖 参考ドキュメント

### 内部ドキュメント
- [画面設計書](/frontend/design/screen-design)
- [API仕様書](/swagger/v2/microservice.yaml)
- [Onion Architecture Guide](/frontend/modular-onion-architecture/introduction-and-purpose)
- [Atomic Design Guide](/frontend/modular-onion-architecture/atomic-design-implementation-rules)

### 外部リソース
- [Flutter公式ドキュメント](https://flutter.dev/docs)
- [BLoC公式ドキュメント](https://bloclibrary.dev/)
- [Widgetbook公式ドキュメント](https://docs.widgetbook.io/)

---

## 📅 変更履歴

| 日付 | 担当 | 変更内容 |
|------|------|---------|
| 2025/10/21 | AI | 初版作成 |

---

## 📌 備考

- 本プランは画面設計書とAPI仕様書に基づいて作成されています
- 実装中に仕様変更が発生した場合は、本プランも更新してください
