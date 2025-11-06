# フロントエンド・バックエンド統合ガイド

## 概要

このガイドでは、Flutter フロントエンドと Go バックエンド API の統合方法を説明します。

## 実装内容

### バックエンド拡張

#### 1. Incident モデルの拡張

以下のフィールドを追加しました：

```go
// 表示用フィールド（JOINで取得）
PersonName      *string         `json:"personName,omitempty"`
RoomNumber      *string         `json:"roomNumber,omitempty"`

// 対応情報（actionsテーブルから集計）
AssignedTo             *string    `json:"assignedTo,omitempty"`
ActionType             *string    `json:"actionType,omitempty"`
ResponseStartedAt      *time.Time `json:"responseStartedAt,omitempty"`
ResponseCompletedAt    *time.Time `json:"responseCompletedAt,omitempty"`
```

#### 2. SQL クエリの最適化

LATERAL JOIN を使用して、関連データを効率的に取得：

- `persons` テーブルから対象者名
- `rooms` テーブルから部屋番号
- `actions` + `staffs` テーブルから担当者と対応情報

### フロントエンド統合

#### 1. API 設定

`lib/core/config/api_config.dart` を作成：

```dart
class ApiConfig {
  static const String baseUrl = 'http://localhost:8080';
  static String get apiBaseUrl {
    const envBaseUrl = String.fromEnvironment('API_BASE_URL');
    return envBaseUrl.isEmpty ? baseUrl : envBaseUrl;
  }
}
```

#### 2. データソースの更新

- Dio の baseURL 設定
- エラーハンドリングの強化
- レスポンス形式 `{data: [...], success: true}` のサポート
- ロギングインターセプターの追加

## セットアップ手順

### 1. バックエンドの起動

```bash
cd sample-project
docker-compose up -d
```

### 2. API 動作確認

```bash
# 異常イベント一覧取得
curl http://localhost:8080/api/v2/incidents

# テストデータ作成
curl -X POST http://localhost:8080/api/v2/incidents \
  -H "Content-Type: application/json" \
  -d '{
    "detectedAt": "2025-11-06T14:04:09Z",
    "type": "転倒",
    "personId": "person-001",
    "cameraId": "camera-001",
    "roomId": "room-001",
    "description": "ベッド周辺で転倒を検知"
  }'

# 対応アクション追加
curl -X POST http://localhost:8080/api/v2/incidents/{incident-id}/actions \
  -H "Content-Type: application/json" \
  -d '{
    "staffId": "staff-001",
    "actionType": "start",
    "note": "現場に向かっています"
  }'
```

### 3. フロントエンドの起動

```bash
cd sample-project/frontend

# 依存パッケージのインストール
flutter pub get

# Web 開発サーバー起動
flutter run -d chrome

# または環境変数でAPI URLを指定
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8080
```

## API レスポンス例

### GET /api/v2/incidents

```json
{
  "data": [
    {
      "id": "2861dbfb-dac6-4b2b-be18-bd0b6e18a243",
      "detectedAt": "2025-11-06T14:04:09Z",
      "type": "転倒",
      "status": "open",
      "personId": "person-001",
      "cameraId": "camera-001",
      "roomId": "room-001",
      "description": "ベッド周辺で転倒を検知",
      "createdAt": "2025-11-06T07:18:18.541302Z",
      "updatedAt": "2025-11-06T07:18:18.541302Z",
      "personName": "山田太郎",
      "roomNumber": "101",
      "assignedTo": "山田太郎",
      "actionType": "start",
      "responseStartedAt": "2025-11-06T07:18:25.599456Z"
    }
  ],
  "success": true
}
```

## データマッピング

### バックエンド → フロントエンド

| バックエンドフィールド | フロントエンドフィールド | 説明 |
|-------------------|-------------------|------|
| `personName` | `personName` | 見守り対象者名 |
| `roomNumber` | `roomNumber` | 部屋番号 |
| `assignedTo` | `assignedTo` | 担当者名 |
| `actionType` | `actionType` | 操作タイプ |
| `responseStartedAt` | `responseStartedAt` | 対応開始時刻 |
| `responseCompletedAt` | `responseCompletedAt` | 対応完了時刻 |

## トラブルシューティング

### CORS エラー

バックエンドの `main.go` で CORS が設定済みです：

```go
router.Use(func(c *gin.Context) {
    c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
    c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT, DELETE")
    // ...
})
```

### 接続タイムアウト

`api_config.dart` でタイムアウト設定を調整：

```dart
static const Duration connectTimeout = Duration(seconds: 10);
static const Duration receiveTimeout = Duration(seconds: 10);
```

### データが表示されない

1. バックエンドが起動しているか確認
2. テストデータが作成されているか確認
3. ブラウザの開発者ツールでネットワークリクエストを確認
4. Dio のログを確認（コンソールに `[Dio]` で出力）

## 次のステップ

### 推奨される改善

1. **認証・認可の追加**
   - JWT トークンの実装
   - ユーザーロールベースのアクセス制御

2. **ページネーションの実装**
   - バックエンド: LIMIT/OFFSET のサポート
   - フロントエンド: 無限スクロールまたはページャー

3. **リアルタイム更新**
   - WebSocket または Server-Sent Events
   - 新しい異常イベントの自動通知

4. **エラーハンドリングの強化**
   - ユーザーフレンドリーなエラーメッセージ
   - リトライロジック
   - オフライン対応

5. **パフォーマンス最適化**
   - データベースインデックスの見直し
   - キャッシング戦略
   - 画像・動画の遅延読み込み

## 参考資料

- [Flutter Dio パッケージ](https://pub.dev/packages/dio)
- [Gin Web Framework](https://gin-gonic.com/)
- [PostgreSQL LATERAL JOIN](https://www.postgresql.org/docs/current/queries-table-expressions.html#QUERIES-LATERAL)
