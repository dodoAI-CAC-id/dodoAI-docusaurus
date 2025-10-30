# 見守りシステム マイクロサービスAPI

Go言語とPostgreSQLを使用した介護施設向け異常検知・通知・現場対応システムのREST APIサービスです。

## 技術スタック

- **言語**: Go 1.21+
- **フレームワーク**: Gin (HTTPウェブフレームワーク)
- **データベース**: PostgreSQL 15
- **コンテナ**: Docker & Docker Compose

## 主な機能

### マイクロサービスAPI
- 異常イベント管理（検知、記録、更新）
- 通知システム（スタッフへの通知、既読管理、エスカレーション）
- 対応アクション管理（現場対応の記録、進捗管理）
- 対象者・スタッフ・居室管理
- カメラデバイス・検知エリア管理
- 動画管理（異常検知時の録画）
- 監査ログ（全API操作の自動記録）
- システム設定管理

## プロジェクト構成

```
sample-project/
├── cmd/
│   └── api/
│       └── main.go              # エントリーポイント
├── internal/
│   ├── database/
│   │   └── postgres.go          # DB接続管理
│   ├── handlers/                # HTTPハンドラー
│   │   ├── incident_handler.go
│   │   ├── notification_handler.go
│   │   ├── action_handler.go
│   │   ├── person_handler.go
│   │   ├── staff_handler.go
│   │   ├── room_handler.go
│   │   ├── incident_video_handler.go
│   │   ├── audit_log_handler.go
│   │   └── configuration_handler.go
│   ├── models/                  # データモデル
│   │   ├── incident.go
│   │   ├── notification.go
│   │   ├── action.go
│   │   ├── person.go
│   │   ├── staff.go
│   │   ├── room.go
│   │   ├── incident_video.go
│   │   └── audit_log.go
│   ├── middleware/
│   │   └── audit.go             # 監査ログミドルウェア
│   └── utils/
│       └── response.go          # 共通レスポンス処理
├── migrations/
│   └── 001_create_base_tables.sql  # DBスキーマ
├── docker/
│   ├── Dockerfile
│   └── init.sql
├── docker-compose.yml
├── go.mod
├── .env.example
└── README.md
```

## 前提条件

- Docker Desktop インストール済み
- Docker Compose v2.x インストール済み

## セットアップ

### 1. 環境変数の設定

```bash
cp .env.example .env
```

### 2. Docker Composeでビルド・起動

```bash
# イメージのビルド
docker-compose build

# コンテナの起動
docker-compose up -d

# ログの確認
docker-compose logs -f
```

### 3. 動作確認

```bash
# スタッフ一覧取得
curl http://localhost:8080/api/v2/staffs

# 異常イベント一覧取得
curl http://localhost:8080/api/v2/incidents
```

## API エンドポイント

### ベースURL
```
http://localhost:8080/api/v2
```

### エンドポイント一覧

#### 異常イベント (Incidents)

**一覧取得**
```bash
GET /api/v2/incidents?personId={personId}&status={status}&from={timestamp}&to={timestamp}
```

**作成**
```bash
POST /api/v2/incidents
Content-Type: application/json

{
  "detectedAt": "2025-10-29T10:00:00Z",
  "type": "fall",
  "personId": "person-uuid",
  "cameraId": "camera-uuid",
  "roomId": "room-uuid",
  "detectionAreaId": "area-uuid",
  "description": "転倒の可能性"
}
```

**詳細取得**
```bash
GET /api/v2/incidents/{id}
```

**更新**
```bash
PATCH /api/v2/incidents/{id}
Content-Type: application/json

{
  "status": "resolved",
  "description": "対応完了"
}
```

#### 通知 (Notifications)

**一覧取得**
```bash
GET /api/v2/notifications?staffId={staffId}&incidentId={incidentId}&unreadOnly=true
```

**作成**
```bash
POST /api/v2/notifications
Content-Type: application/json

{
  "incidentId": "incident-uuid",
  "sentToStaffIds": ["staff-uuid-1", "staff-uuid-2"],
  "notificationType": "urgent",
  "actionRequired": true
}
```

**既読マーク**
```bash
POST /api/v2/notifications/{id}/mark-read
Content-Type: application/json

{
  "staffId": "staff-uuid"
}
```

**エスカレーション**
```bash
POST /api/v2/notifications/{id}/escalate
```

#### 対応アクション (Actions)

**異常ごとの対応履歴取得**
```bash
GET /api/v2/incidents/{incidentId}/actions
```

**対応登録**
```bash
POST /api/v2/incidents/{incidentId}/actions
Content-Type: application/json

{
  "staffId": "staff-uuid",
  "actionType": "start",
  "note": "現場確認中"
}
```

#### 対象者 (Persons)

```bash
GET /api/v2/persons
POST /api/v2/persons
GET /api/v2/persons/{id}
PATCH /api/v2/persons/{id}
DELETE /api/v2/persons/{id}
```

#### スタッフ (Staffs)

```bash
GET /api/v2/staffs
GET /api/v2/staffs/{id}
GET /api/v2/departments
```

#### 居室 (Rooms)

```bash
GET /api/v2/rooms
GET /api/v2/rooms/{id}
```

#### カメラデバイス (Camera Devices)

```bash
GET /api/v2/camera-devices
GET /api/v2/camera-devices/{id}
```

#### 検知エリア (Detection Areas)

```bash
GET /api/v2/detection-areas?cameraId={cameraId}
```

#### 動画 (Videos)

```bash
GET /api/v2/incidents/{incidentId}/videos
GET /api/v2/videos/{videoId}/file
```

#### 監査ログ (Audit Logs)

```bash
GET /api/v2/audit-logs?targetType={type}&userId={userId}&operation={operation}&from={timestamp}&to={timestamp}
```

#### システム設定 (Configuration)

```bash
GET /api/v2/configurations
PATCH /api/v2/configurations
```

## データベーススキーマ

システムは以下の11のエンティティで構成されています：

1. **departments** - 部署
2. **staffs** - スタッフ
3. **rooms** - 居室
4. **persons** - 対象者
5. **camera_devices** - カメラデバイス
6. **detection_areas** - 検知エリア
7. **incidents** - 異常イベント
8. **notifications** - 通知
9. **notification_histories** - 通知履歴
10. **actions** - 対応アクション
11. **incident_videos** - 異常動画
12. **audit_logs** - 監査ログ
13. **configurations** - システム設定

詳細は `migrations/001_create_base_tables.sql` を参照してください。

## 開発コマンド

### コンテナの起動
```bash
docker-compose up -d
```

### コンテナの停止
```bash
docker-compose down
```

### ログの確認
```bash
# 全サービスのログ
docker-compose logs -f

# APIサービスのみ
docker-compose logs -f api

# DBサービスのみ
docker-compose logs -f db
```

### データベースへの接続
```bash
docker-compose exec db psql -U postgres -d apidb
```

### コードの変更後（リビルド）
```bash
docker-compose up -d --build api
```

### コンテナの完全削除（ボリューム含む）
```bash
docker-compose down -v
```

## テスト例

### 基本フロー

```bash
# 1. 異常イベント作成
curl -X POST http://localhost:8080/api/v2/incidents \
  -H "Content-Type: application/json" \
  -d '{
    "detectedAt": "2025-10-29T10:00:00Z",
    "type": "fall",
    "personId": "person-uuid",
    "cameraId": "camera-uuid"
  }'

# 2. 通知一覧確認
curl http://localhost:8080/api/v2/notifications?unreadOnly=true

# 3. 対応アクション登録
curl -X POST http://localhost:8080/api/v2/incidents/{incident-id}/actions \
  -H "Content-Type: application/json" \
  -d '{
    "staffId": "staff-uuid",
    "actionType": "start",
    "note": "現場に向かっています"
  }'

# 4. 通知を既読にする
curl -X POST http://localhost:8080/api/v2/notifications/{notification-id}/mark-read \
  -H "Content-Type: application/json" \
  -d '{
    "staffId": "staff-uuid"
  }'
```

## トラブルシューティング

### ポート競合エラー
ポート8080または5432が既に使用されている場合、`.env`ファイルでポート番号を変更してください。

### データベース接続エラー
```bash
# DBコンテナの状態確認
docker-compose ps

# DBコンテナのログ確認
docker-compose logs db

# DBコンテナの再起動
docker-compose restart db
```

### データのリセット
```bash
# ボリュームを含めて完全削除
docker-compose down -v

# 再度起動（初期データが再投入される）
docker-compose up -d
```

## 環境変数

| 変数名 | 説明 | デフォルト値 |
|--------|------|-------------|
| DB_HOST | データベースホスト | db |
| DB_PORT | データベースポート（コンテナ内部） | 5432 |
| DB_USER | データベースユーザー | postgres |
| DB_PASSWORD | データベースパスワード | postgres |
| DB_NAME | データベース名 | apidb |
| DB_SSLMODE | SSL接続モード | disable |
| API_PORT | APIサーバーポート | 8080 |
| GIN_MODE | Ginの実行モード | release |

**注意:** ホストマシンからPostgreSQLに接続する場合は、ポート15432を使用してください。

## アーキテクチャの特徴

### 監査ログ
- 全APIリクエストは自動的に `audit_logs` テーブルに記録されます
- 操作者、操作内容、対象リソース、タイムスタンプを記録

### 自動通知
- 異常イベント作成時に、該当する役割のスタッフへ自動的に通知が作成されます
- 通知の既読管理とエスカレーション機能をサポート

### リレーション管理
- PostgreSQLの外部キー制約を活用した整合性保証
- 適切なインデックスによるパフォーマンス最適化

## ライセンス

MIT License

## 作成者

AI Assistant
