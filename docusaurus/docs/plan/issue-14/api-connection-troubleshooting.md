---
id: api-connection-troubleshooting
title: API接続トラブルシューティングガイド
---

# API接続トラブルシューティングガイド

## 修正内容

### 1. Frontend API設定の修正

**ファイル**: `src/frontend/lib/core/config/api_config.dart`

**修正内容**:
- ポート番号: `localhost:3000` → `localhost:8080`
- APIバージョン: `/api/v1` → `/api/v2`

```dart
// 修正後
static const String _devBaseUrl = 'http://localhost:8080';
static String get apiVersion => '/api/v2';
```

## BackEnd起動確認

### 1. BackEndの起動

```bash
cd mamoAI-backend

# Docker Composeで起動
docker-compose up -d

# ログ確認
docker-compose logs -f
```

### 2. 起動確認

**ヘルスチェック**:
```bash
# APIサーバーが起動しているか確認
curl http://localhost:8080/api/v2/staffs
```

**期待されるレスポンス**:
```json
[
  {
    "id": "staff-uuid",
    "name": "山田太郎",
    "departmentId": "dept-uuid",
    "departmentName": "介護部",
    "role": "care"
  }
]
```

### 3. データベース確認

```bash
# データベースコンテナに接続
docker-compose exec db psql -U postgres -d apidb

# テーブル確認
\dt

# データ確認
SELECT * FROM staffs LIMIT 5;
SELECT * FROM incidents LIMIT 5;
```

## Frontend起動確認

### 1. Frontendの起動

```bash
cd src/frontend

# 依存関係のインストール（初回のみ）
flutter pub get

# 起動
flutter run -d chrome
```

### 2. 接続テスト

Flutterアプリが起動したら、以下を確認：

1. **コンソールログ確認**:
   - `[API Request] GET /api/v2/incidents` のようなログが表示されるか
   - エラーメッセージの内容を確認

2. **ネットワークタブ確認**:
   - ブラウザの開発者ツール → ネットワークタブ
   - `http://localhost:8080/api/v2/incidents` へのリクエストを確認
   - ステータスコード確認（200: 成功、404: エンドポイント不在、500: サーバーエラー）

## よくあるエラーと対処法

### エラー1: Connection refused / Connection error

**原因**: BackEndが起動していない

**対処法**:
```bash
cd mamoAI-backend
docker-compose up -d
docker-compose logs -f
```

### エラー2: 404 Not Found

**原因**: エンドポイントのパスが間違っている

**確認事項**:
- APIバージョンが `/api/v2` になっているか
- エンドポイントパスが正しいか

**BackEndのエンドポイント一覧**:
```
GET  /api/v2/incidents
GET  /api/v2/incidents/:id
POST /api/v2/incidents
GET  /api/v2/incidents/:id/actions
GET  /api/v2/incidents/:id/videos
GET  /api/v2/videos/:id/file
GET  /api/v2/staffs
GET  /api/v2/persons
GET  /api/v2/rooms
```

### エラー3: CORS Error

**原因**: CORSポリシーの問題

**確認事項**:
- BackEndの `main.go` でCORSが有効になっているか確認済み
- ブラウザのコンソールでCORSエラーメッセージを確認

**対処法** (BackEnd側で対応済み):
```go
// mamoAI-backend/cmd/api/main.go
router.Use(func(c *gin.Context) {
    c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
    c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT, DELETE")
    // ...
})
```

### エラー4: Empty Response / Parsing Error

**原因**: データベースにデータが存在しない、またはレスポンス形式が不正

**確認事項**:
```bash
# データベースのデータ確認
cd mamoAI-backend
docker-compose exec db psql -U postgres -d apidb

# incidents テーブルのデータ確認
SELECT * FROM incidents;

# staffs テーブルのデータ確認
SELECT * FROM staffs;
```

**データがない場合**:
```bash
# docker-compose.ymlに初期データ投入スクリプトが含まれているか確認
# または手動でサンプルデータを投入

# コンテナの再起動（初期データ再投入）
docker-compose down -v
docker-compose up -d
```

### エラー5: Timeout Error

**原因**: APIレスポンスが遅い、またはネットワーク問題

**対処法**:
1. タイムアウト時間を延長:
```dart
// src/frontend/lib/core/network/api_client.dart
final options = BaseOptions(
  connectTimeout: const Duration(seconds: 60), // 延長
  receiveTimeout: const Duration(seconds: 60), // 延長
);
```

2. BackEndのパフォーマンス確認:
```bash
# ログでレスポンス時間を確認
docker-compose logs -f api
```

## デバッグ手順

### 1. BackEnd単体テスト

```bash
# curlでAPIを直接テスト
curl -v http://localhost:8080/api/v2/incidents

# レスポンスヘッダーとボディを確認
curl -i http://localhost:8080/api/v2/incidents
```

### 2. Frontend デバッグモード

```dart
// src/frontend/lib/main.dart
// モックデータで動作確認
const bool USE_MOCK_DATA = true; // モックに切り替え

// 実APIで確認
const bool USE_MOCK_DATA = false; // 実APIに切り替え
```

### 3. ログ確認

**BackEnd**:
```bash
cd mamoAI-backend
docker-compose logs -f api
```

**Frontend**:
- ブラウザ: F12 → コンソールタブ
- ターミナル: `flutter run -d chrome` のログ

## チェックリスト

実装後、以下を確認してください：

- [ ] BackEndが起動している（`docker-compose ps`）
- [ ] データベースにデータが存在する
- [ ] curlでAPIが応答する（`curl http://localhost:8080/api/v2/incidents`）
- [ ] Frontend設定が正しい（ポート: 8080、バージョン: v2）
- [ ] USE_MOCK_DATA = false になっている
- [ ] ブラウザのコンソールでAPIリクエストログが表示される
- [ ] CORSエラーが発生していない
- [ ] データが画面に表示される

## 追加情報

### BackEnd環境変数

`.env`ファイルの設定:
```env
DB_HOST=db
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=apidb
DB_SSLMODE=disable
API_PORT=8080
GIN_MODE=debug
```

### Frontend環境

Flutter環境の確認:
```bash
flutter doctor
flutter --version
```

### ポート使用状況確認

```bash
# Windowsでポート確認
netstat -ano | findstr :8080
netstat -ano | findstr :5432

# ポートが使用中の場合、プロセスを終了するか別ポートを使用
```

## サポート

問題が解決しない場合：

1. BackEndのログを全て確認: `docker-compose logs -f`
2. Frontendのコンソールログを全て確認
3. ブラウザのネットワークタブでリクエスト/レスポンスを確認
4. 上記の情報をまとめて報告

## 参照

- BackEnd README: `mamoAI-backend/README.md`
- API仕様書: `docusaurus/static/swagger/v2/microservice.yaml`
- Frontend統合レポート: `docusaurus/docs/plan/issue-14/history-frontend-backend-integration-completion-report.md`
