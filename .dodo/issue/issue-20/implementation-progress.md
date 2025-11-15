# Issue #20: View画面API結合 - 実装進捗

## タスク概要
- **Goal**: View画面をAPI（docusaurus/static/swagger/v2/microservice.yaml）と結合
- **Issue**: #20
- **Complexity**: STANDARD (6点)
- **Estimated Duration**: 2-3 days
- **Started**: 2025/01/15

## 実装計画

### Phase 1: Infrastructure層の実装
- [x] view_screen_remote_datasource.dart作成
- [x] view_screen_repository.dart作成
- [ ] RemoteDataSourceのUnit Test作成
- [ ] RepositoryのUnit Test作成

### Phase 2: Domain層の更新
- [x] incident_status.dartにAPIマッピング追加
  - [x] fromApiStatus()メソッド
  - [x] toApiStatus()メソッド

### Phase 3: DI設定の更新
- [x] view_screen_injection.dartの更新
  - [x] Remote実装の登録
  - [x] Mock/Remote切替機能

### Phase 4: テスト・検証
- [ ] 既存BLoCテストの実行確認
- [ ] 既存Widgetテストの実行確認
- [ ] ローカル環境でのAPI接続テスト
- [ ] エラーハンドリングの確認

### Phase 5: ドキュメント更新
- [ ] sample-project/frontend/README.md更新
- [ ] 実装完了報告

## 実装詳細

### 新規作成ファイル
1. `lib/features/view_screen/infrastructure/datasources/view_screen_remote_datasource.dart`
2. `lib/features/view_screen/infrastructure/repositories/view_screen_repository.dart`
3. `test/features/view_screen/infrastructure/datasources/view_screen_remote_datasource_test.dart`
4. `test/features/view_screen/infrastructure/repositories/view_screen_repository_test.dart`

### 更新ファイル
1. `lib/features/view_screen/domain/entities/incident_status.dart`
2. `lib/features/view_screen/di/view_screen_injection.dart`
3. `sample-project/frontend/README.md`

## API仕様マッピング

### ステータス変換
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

### 使用API
- `GET /api/v2/incidents` - 一覧取得
- `GET /api/v2/incidents/{incidentId}` - 詳細取得（画像含む）
- `POST /api/v2/incidents/{incidentId}/actions` - アクション登録

## 注意事項・リスク
1. OpenAPI仕様の誤記: `pictuers` → `pictures`
2. ステータス値の差異対応が必要
3. アラート稼働/停止APIは未定義（UIのみ対応）
4. 通知情報取得のエンドポイント差異

## 進捗ログ

### 2025/01/15

#### 午後1:22 - タスク開始
- タスク指示ファイル生成完了
- 実装進捗ファイル作成
- Phase 1開始準備

#### 午後1:23 - Phase 2完了（Domain層更新）
- `incident_status.dart`にAPIマッピング機能追加
  - `toApiStatus()`: UI→API変換（unhandled→open, in_progress→monitoring, no_detection→resolved）
  - `fromApiStatus()`: API→UI変換

#### 午後1:23-1:24 - Phase 1完了（Infrastructure層実装）
- `view_screen_remote_datasource.dart`作成
  - dio使用のHTTPクライアント実装
  - GET /api/v2/incidents（一覧取得）
  - GET /api/v2/incidents/{id}（詳細取得）
  - POST /api/v2/incidents/{id}/actions（アクション登録）
  - エラーハンドリング実装
- `view_screen_repository.dart`作成
  - IViewScreenRepository実装
  - APIレスポンス→IncidentItemマッピング
  - Either<Failure, T>でラップ

#### 午後1:24 - Phase 3完了（DI設定更新）
- `view_screen_injection.dart`更新
  - Mock/Remote両方の実装を登録
  - `useMockData`パラメータで切替可能
  - Dio instanceの共有登録

#### 午後1:24 - テスト確認
- 既存テスト全てパス（36 tests passed）
  - Unit Tests: UseCase, Repository
  - Widget Tests: StatusBadge, IncidentItemCard
  - BLoC Tests: ViewScreenBloc
