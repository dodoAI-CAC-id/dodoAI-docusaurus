---
id: phase4-infrastructure-layer-plan
title: Phase 4 - Infrastructure Layer 実装計画
---

![ステータス](https://img.shields.io/static/v1?label=ステータス&message=実装中&color=yellow)
![最終更新日](https://img.shields.io/static/v1?label=最終更新日&message=2025/10/31&color=green)

# Phase 4: Infrastructure Layer - データソース統合 実装計画

## 概要

Phase 4では、TDD（Test-Driven Development）アプローチに従い、履歴画面のInfrastructure層を実装します。
Domain層で定義したリポジトリインターフェースの実装、API通信、DTOマッピングを行います。

## 目標

1. **API通信基盤の構築**
   - Dioクライアントの設定
   - インターセプターによる共通処理
   - エラーハンドリング

2. **DTOの実装**
   - API ResponseをマッピングするDTO
   - JSON serialization/deserialization
   - Entity変換機能

3. **リポジトリ実装**
   - IIncidentRepositoryの実装
   - IVideoRepositoryの実装
   - エラーハンドリングとリトライロジック

4. **テストの実装**
   - Repository層のユニットテスト
   - Mock APIを使用した統合テスト
   - エラーケースのテスト

## 実装項目

### 1. API Client設定

#### 1.1 Dioクライアントの設定

**ファイル**: `src/frontend/lib/core/network/api_client.dart`

**機能**:
- Base URLの設定
- タイムアウト設定
- HTTPヘッダーの設定
- インターセプターの追加

**インターセプター**:
- ログインターセプター（リクエスト/レスポンスのログ出力）
- 認証インターセプター（JWT tokenの自動付与）
- エラーインターセプター（エラーレスポンスの統一処理）

#### 1.2 エラーハンドリング

**ファイル**: `src/frontend/lib/core/network/api_exceptions.dart`

**例外クラス**:
- `NetworkException`: ネットワークエラー
- `ServerException`: サーバーエラー（5xx）
- `UnauthorizedException`: 認証エラー（401）
- `ForbiddenException`: 権限エラー（403）
- `NotFoundException`: リソース未検出（404）
- `ValidationException`: バリデーションエラー（400）

### 2. DTO実装

#### 2.1 ActionDTO

**ファイル**: `src/frontend/lib/features/history/data/models/action_dto.dart`

**テストファイル**: `src/frontend/test/features/history/data/models/action_dto_test.dart`

**機能**:
- JSON serialization (`toJson`)
- JSON deserialization (`fromJson`)
- Entity変換 (`toEntity`)

**JSONフォーマット**:
```json
{
  "id": "action_001",
  "incident_id": "incident_001",
  "performed_at": "2025-10-31T10:30:00Z",
  "performed_by": "山田太郎",
  "action_type": "confirmed",
  "notes": "対応完了"
}
```

#### 2.2 VideoDTO

**ファイル**: `src/frontend/lib/features/history/data/models/video_dto.dart`

**テストファイル**: `src/frontend/test/features/history/data/models/video_dto_test.dart`

**機能**:
- JSON serialization (`toJson`)
- JSON deserialization (`fromJson`)
- Entity変換 (`toEntity`)

**JSONフォーマット**:
```json
{
  "id": "video_001",
  "incident_id": "incident_001",
  "file_name": "incident_001_20251031.mp4",
  "file_size": 10485760,
  "duration": 185,
  "recorded_at": "2025-10-31T09:15:00Z",
  "url": "https://api.example.com/videos/video_001",
  "thumbnail_url": "https://api.example.com/thumbnails/video_001"
}
```

#### 2.3 IncidentDTO

**ファイル**: `src/frontend/lib/features/history/data/models/incident_dto.dart`

**テストファイル**: `src/frontend/test/features/history/data/models/incident_dto_test.dart`

**機能**:
- JSON serialization (`toJson`)
- JSON deserialization (`fromJson`)
- Entity変換 (`toEntity`)
- ネストされたActionDTOリストの処理

**JSONフォーマット**:
```json
{
  "id": "incident_001",
  "incident_id": "INC-20251031-001",
  "detected_at": "2025-10-31T09:15:00Z",
  "room_number": "101",
  "bed_number": "A",
  "resident_name": "田中花子",
  "detection_type": "転倒検知",
  "status": "detected",
  "actions": [...],
  "video_id": "video_001"
}
```

### 3. リポジトリ実装

#### 3.1 IncidentRepositoryImpl

**ファイル**: `src/frontend/lib/features/history/data/repositories/incident_repository_impl.dart`

**テストファイル**: `src/frontend/test/features/history/data/repositories/incident_repository_impl_test.dart`

**実装メソッド**:

```dart
class IncidentRepositoryImpl implements IIncidentRepository {
  final Dio _dio;
  
  IncidentRepositoryImpl(this._dio);
  
  @override
  Future<List<Incident>> fetchIncidents({
    required int page,
    required int pageSize,
  }) async {
    // GET /api/incidents?page={page}&page_size={pageSize}
  }
  
  @override
  Future<Incident> fetchIncidentById(String id) async {
    // GET /api/incidents/{id}
  }
  
  @override
  Future<List<Incident>> searchIncidents({
    required SearchCriteria criteria,
    required int page,
    required int pageSize,
  }) async {
    // POST /api/incidents/search
  }
  
  @override
  Future<int> countIncidents() async {
    // GET /api/incidents/count
  }
  
  @override
  Future<int> countSearchResults(SearchCriteria criteria) async {
    // POST /api/incidents/search/count
  }
}
```

**エラーハンドリング**:
- DioExceptionのキャッチと適切な例外への変換
- リトライロジック（ネットワークエラー時）
- タイムアウト処理

#### 3.2 VideoRepositoryImpl

**ファイル**: `src/frontend/lib/features/history/data/repositories/video_repository_impl.dart`

**テストファイル**: `src/frontend/test/features/history/data/repositories/video_repository_impl_test.dart`

**実装メソッド**:

```dart
class VideoRepositoryImpl implements IVideoRepository {
  final Dio _dio;
  
  VideoRepositoryImpl(this._dio);
  
  @override
  Future<Video> fetchVideoById(String id) async {
    // GET /api/videos/{id}
  }
  
  @override
  Future<Video?> fetchVideoByIncidentId(String incidentId) async {
    // GET /api/incidents/{incidentId}/video
  }
  
  @override
  Future<void> downloadVideo(
    String videoId,
    String savePath, {
    void Function(int, int)? onProgress,
  }) async {
    // GET /api/videos/{videoId}/download
    // 進捗コールバック付き
  }
  
  @override
  Future<String> getStreamingUrl(String videoId) async {
    // GET /api/videos/{videoId}/streaming-url
  }
  
  @override
  Future<bool> videoExists(String videoId) async {
    // HEAD /api/videos/{videoId}
  }
}
```

### 4. テスト戦略

#### 4.1 DTOテスト（TDD - Red Phase）

**テスト項目**:
- ✅ JSON → DTO変換（fromJson）
- ✅ DTO → JSON変換（toJson）
- ✅ DTO → Entity変換（toEntity）
- ✅ 不正なJSONのハンドリング
- ✅ 必須フィールドの検証
- ✅ オプショナルフィールドの処理（null値）
- ✅ ネストされたオブジェクトの処理

#### 4.2 Repositoryテスト（TDD - Red Phase）

**テスト項目**:
- ✅ 正常系: API成功時の処理
- ✅ 異常系: ネットワークエラー
- ✅ 異常系: サーバーエラー（5xx）
- ✅ 異常系: 認証エラー（401）
- ✅ 異常系: 権限エラー（403）
- ✅ 異常系: リソース未検出（404）
- ✅ 異常系: バリデーションエラー（400）
- ✅ ページネーション処理
- ✅ 検索クエリの構築
- ✅ タイムアウト処理

**Mockライブラリ**:
- `mockito`: Dioクライアントのモック
- `http_mock_adapter`: HTTPレスポンスのモック

## ディレクトリ構造

```
src/frontend/lib/
├── core/
│   └── network/
│       ├── api_client.dart          # Dioクライアント設定
│       ├── api_exceptions.dart      # カスタム例外クラス
│       └── interceptors/
│           ├── auth_interceptor.dart
│           ├── error_interceptor.dart
│           └── logging_interceptor.dart
└── features/
    └── history/
        ├── data/
        │   ├── models/
        │   │   ├── action_dto.dart
        │   │   ├── incident_dto.dart
        │   │   └── video_dto.dart
        │   └── repositories/
        │       ├── incident_repository_impl.dart
        │       └── video_repository_impl.dart
        └── domain/
            ├── entities/
            └── repositories/

src/frontend/test/
└── features/
    └── history/
        └── data/
            ├── models/
            │   ├── action_dto_test.dart
            │   ├── incident_dto_test.dart
            │   └── video_dto_test.dart
            └── repositories/
                ├── incident_repository_impl_test.dart
                └── video_repository_impl_test.dart
```

## 依存パッケージ

### pubspec.yaml追加項目

```yaml
dependencies:
  dio: ^5.4.0              # HTTP client
  json_annotation: ^4.8.1  # JSON serialization annotations
  
dev_dependencies:
  json_serializable: ^6.7.1  # JSON code generation
  build_runner: ^2.4.7       # Code generation runner
  mockito: ^5.4.4            # Mocking framework
  http_mock_adapter: ^0.6.1  # HTTP mock adapter for Dio
```

## API仕様（参照）

### エンドポイント一覧

| メソッド | エンドポイント | 説明 |
|---------|--------------|------|
| GET | `/api/incidents` | インシデント一覧取得 |
| GET | `/api/incidents/{id}` | インシデント詳細取得 |
| POST | `/api/incidents/search` | インシデント検索 |
| GET | `/api/incidents/count` | インシデント総件数取得 |
| POST | `/api/incidents/search/count` | 検索結果件数取得 |
| GET | `/api/videos/{id}` | 動画情報取得 |
| GET | `/api/incidents/{id}/video` | インシデントの動画取得 |
| GET | `/api/videos/{id}/download` | 動画ダウンロード |
| GET | `/api/videos/{id}/streaming-url` | ストリーミングURL取得 |
| HEAD | `/api/videos/{id}` | 動画存在確認 |

### レスポンス形式

#### 成功レスポンス
```json
{
  "status": "success",
  "data": { ... }
}
```

#### ページネーションレスポンス
```json
{
  "status": "success",
  "data": [...],
  "pagination": {
    "page": 1,
    "page_size": 20,
    "total_count": 100,
    "total_pages": 5
  }
}
```

#### エラーレスポンス
```json
{
  "status": "error",
  "message": "エラーメッセージ",
  "code": "ERROR_CODE"
}
```

## 実装順序（TDD Cycle）

### ステップ1: DTOの実装
1. ActionDTO
   - ❌ Red: テスト作成
   - ✅ Green: 最小実装
   - ♻️ Refactor: 改善

2. VideoDTO
   - ❌ Red: テスト作成
   - ✅ Green: 最小実装
   - ♻️ Refactor: 改善

3. IncidentDTO
   - ❌ Red: テスト作成
   - ✅ Green: 最小実装
   - ♻️ Refactor: 改善

### ステップ2: API Clientの設定
1. API Exceptions
   - ❌ Red: テスト作成
   - ✅ Green: 最小実装
   - ♻️ Refactor: 改善

2. API Client
   - ❌ Red: テスト作成
   - ✅ Green: 最小実装
   - ♻️ Refactor: 改善

### ステップ3: Repositoryの実装
1. IncidentRepositoryImpl
   - ❌ Red: テスト作成（全メソッド）
   - ✅ Green: 最小実装
   - ♻️ Refactor: 改善

2. VideoRepositoryImpl
   - ❌ Red: テスト作成（全メソッド）
   - ✅ Green: 最小実装
   - ♻️ Refactor: 改善

## 品質基準

### コードカバレッジ目標
- **DTO**: 100% (すべてのメソッドとエラーケース)
- **Repository**: 90%以上 (主要なパスとエラーケース)
- **全体**: 85%以上

### パフォーマンス目標
- API応答時間: 通常操作 < 500ms
- 検索処理: < 1秒
- 動画ダウンロード: 進捗フィードバック付き

### エラー処理
- すべてのAPI呼び出しでエラーハンドリング
- ユーザーフレンドリーなエラーメッセージ
- ログ出力による診断サポート

## 技術的な注意点

### 1. JSON Serialization
- `json_serializable`パッケージを使用
- `build_runner`でコード生成
- DTOクラスに`@JsonSerializable()`アノテーション

### 2. Null Safety
- すべてのフィールドでnull安全性を考慮
- オプショナルフィールドは`?`で明示
- API仕様とDTOの整合性を確保

### 3. エラーハンドリング
- DioExceptionを適切なドメイン例外に変換
- スタックトレースの保持
- デバッグ情報の記録

### 4. テストのベストプラクティス
- Arrange-Act-Assert パターン
- 各テストは独立性を保つ
- モックは最小限に（実装の詳細に依存しない）
- エッジケースとエラーケースを網羅

## 成果物

Phase 4完了時の成果物:
- ✅ 3つのDTO（ActionDTO, VideoDTO, IncidentDTO）
- ✅ DTOのテストスイート
- ✅ API Client設定とインターセプター
- ✅ カスタム例外クラス
- ✅ 2つのRepository実装
- ✅ Repositoryのテストスイート
- ✅ 高いテストカバレッジ（85%以上）

## 次のステップ（Phase 5）

Phase 5では、Presentation層（BLoC）を実装します:
- HistoryBloc実装
- イベント・ステート定義
- ビジネスロジックの統合
- BLoCテスト

## 参考資料

- [Dio Documentation](https://pub.dev/packages/dio)
- [json_serializable](https://pub.dev/packages/json_serializable)
- [Mockito](https://pub.dev/packages/mockito)
- [Flutter Clean Architecture](https://resocoder.com/flutter-clean-architecture-tdd/)

## 変更履歴

| 日付 | 担当 | 変更内容 |
|------|------|---------|
| 2025/10/31 | Cline | Phase 4 計画書作成 |
