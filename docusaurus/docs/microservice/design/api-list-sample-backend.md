---
id: api-list-sample-backend
title: API List - Sample Backend (実装ベース)
---

# API List (sample-project/backend 実装ベース)

このドキュメントは `sample-project/backend` のソースコードから自動生成されたAPI一覧です。

## 異常検知・通知システム API v2

### Incidents (異常イベント) APIs

| No. | Method | Endpoint | 説明 | Query Parameters | Request Body | 認証/権限 | 実装ファイル |
|-----|--------|----------|------|-----------------|--------------|-----------|-------------|
| 1 | GET | /api/v2/incidents | 異常イベント一覧取得 | personId, status, from, to | - | TBD | cmd/api/main.go:69, internal/handlers/incident_handler.go:21 |
| 2 | POST | /api/v2/incidents | 異常イベント新規登録 | - | IncidentCreate | TBD | cmd/api/main.go:70, internal/handlers/incident_handler.go:64 |
| 3 | GET | /api/v2/incidents/:id | 異常イベント詳細取得 | - | - | TBD | cmd/api/main.go:71, internal/handlers/incident_handler.go:99 |
| 4 | PATCH | /api/v2/incidents/:id | 異常イベント更新 | - | IncidentUpdate | TBD | cmd/api/main.go:72, internal/handlers/incident_handler.go:119 |
| 5 | PATCH | /api/v2/incidents/:id/alert | アラート状態切り替え | - | `{isActive: boolean}` | TBD | cmd/api/main.go:73, internal/handlers/incident_handler.go:147 |

### Incident Actions (対応履歴) APIs

| No. | Method | Endpoint | 説明 | Query Parameters | Request Body | 認証/権限 | 実装ファイル |
|-----|--------|----------|------|-----------------|--------------|-----------|-------------|
| 6 | GET | /api/v2/incidents/:id/actions | 異常イベントの対応履歴取得 | - | - | TBD | cmd/api/main.go:76, internal/handlers/action_handler.go:19 |
| 7 | POST | /api/v2/incidents/:id/actions | 対応履歴新規登録 | - | ActionCreate | TBD | cmd/api/main.go:77, internal/handlers/action_handler.go:32 |

### Incident Videos (異常動画) APIs

| No. | Method | Endpoint | 説明 | Query Parameters | Request Body | 認証/権限 | 実装ファイル |
|-----|--------|----------|------|-----------------|--------------|-----------|-------------|
| 8 | GET | /api/v2/incidents/:id/videos | 異常イベントの動画一覧取得 | - | - | TBD | cmd/api/main.go:80, internal/handlers/incident_video_handler.go:19 |
| 9 | GET | /api/v2/videos/:id/file | 動画ファイル取得（リダイレクト） | - | - | TBD | cmd/api/main.go:81, internal/handlers/incident_video_handler.go:32 |

### Notifications (通知) APIs

| No. | Method | Endpoint | 説明 | Query Parameters | Request Body | 認証/権限 | 実装ファイル |
|-----|--------|----------|------|-----------------|--------------|-----------|-------------|
| 10 | GET | /api/v2/notifications | 通知一覧取得 | staffId, incidentId, unreadOnly | - | TBD | cmd/api/main.go:84, internal/handlers/notification_handler.go:19 |
| 11 | POST | /api/v2/notifications | 通知新規作成 | - | NotificationCreate | TBD | cmd/api/main.go:85, internal/handlers/notification_handler.go:43 |
| 12 | POST | /api/v2/notifications/:id/mark-read | 通知を既読にする | - | `{staffId: string}` | TBD | cmd/api/main.go:86, internal/handlers/notification_handler.go:72 |
| 13 | POST | /api/v2/notifications/:id/escalate | 通知をエスカレーション | - | - | TBD | cmd/api/main.go:87, internal/handlers/notification_handler.go:100 |

### Persons (監視対象者) APIs

| No. | Method | Endpoint | 説明 | Query Parameters | Request Body | 認証/権限 | 実装ファイル |
|-----|--------|----------|------|-----------------|--------------|-----------|-------------|
| 14 | GET | /api/v2/persons | 監視対象者一覧取得 | - | - | TBD | cmd/api/main.go:90, internal/handlers/person_handler.go:19 |
| 15 | POST | /api/v2/persons | 監視対象者新規登録 | - | PersonCreate | TBD | cmd/api/main.go:91, internal/handlers/person_handler.go:48 |
| 16 | GET | /api/v2/persons/:id | 監視対象者詳細取得 | - | - | TBD | cmd/api/main.go:92, internal/handlers/person_handler.go:30 |
| 17 | PATCH | /api/v2/persons/:id | 監視対象者情報更新 | - | PersonUpdate | TBD | cmd/api/main.go:93, internal/handlers/person_handler.go:72 |
| 18 | DELETE | /api/v2/persons/:id | 監視対象者削除 | - | - | TBD | cmd/api/main.go:94, internal/handlers/person_handler.go:95 |

### Staffs (スタッフ) APIs

| No. | Method | Endpoint | 説明 | Query Parameters | Request Body | 認証/権限 | 実装ファイル |
|-----|--------|----------|------|-----------------|--------------|-----------|-------------|
| 19 | GET | /api/v2/staffs | スタッフ一覧取得 | - | - | TBD | cmd/api/main.go:97, internal/handlers/staff_handler.go:19 |
| 20 | GET | /api/v2/staffs/:id | スタッフ詳細取得 | - | - | TBD | cmd/api/main.go:98, internal/handlers/staff_handler.go:30 |
| 21 | GET | /api/v2/departments | 部署一覧取得 | - | - | TBD | cmd/api/main.go:99, internal/handlers/staff_handler.go:52 |

### Rooms (居室) APIs

| No. | Method | Endpoint | 説明 | Query Parameters | Request Body | 認証/権限 | 実装ファイル |
|-----|--------|----------|------|-----------------|--------------|-----------|-------------|
| 22 | GET | /api/v2/rooms | 居室一覧取得 | - | - | TBD | cmd/api/main.go:102, internal/handlers/room_handler.go:19 |
| 23 | GET | /api/v2/rooms/:id | 居室詳細取得 | - | - | TBD | cmd/api/main.go:103, internal/handlers/room_handler.go:30 |

### Camera Devices (カメラデバイス) APIs

| No. | Method | Endpoint | 説明 | Query Parameters | Request Body | 認証/権限 | 実装ファイル |
|-----|--------|----------|------|-----------------|--------------|-----------|-------------|
| 24 | GET | /api/v2/camera-devices | カメラデバイス一覧取得 | - | - | TBD | cmd/api/main.go:106, internal/handlers/room_handler.go:48 |
| 25 | GET | /api/v2/camera-devices/:id | カメラデバイス詳細取得 | - | - | TBD | cmd/api/main.go:107, internal/handlers/room_handler.go:59 |

### Detection Areas (検知エリア) APIs

| No. | Method | Endpoint | 説明 | Query Parameters | Request Body | 認証/権限 | 実装ファイル |
|-----|--------|----------|------|-----------------|--------------|-----------|-------------|
| 26 | GET | /api/v2/detection-areas | 検知エリア一覧取得 | cameraId | - | TBD | cmd/api/main.go:110, internal/handlers/room_handler.go:77 |

### Audit Logs (監査ログ) APIs

| No. | Method | Endpoint | 説明 | Query Parameters | Request Body | 認証/権限 | 実装ファイル |
|-----|--------|----------|------|-----------------|--------------|-----------|-------------|
| 27 | GET | /api/v2/audit-logs | 監査ログ一覧取得 | targetType, userId, operation, from, to | - | TBD | cmd/api/main.go:113, internal/handlers/audit_log_handler.go:20 |

### Configuration (システム設定) APIs

| No. | Method | Endpoint | 説明 | Query Parameters | Request Body | 認証/権限 | 実装ファイル |
|-----|--------|----------|------|-----------------|--------------|-----------|-------------|
| 28 | GET | /api/v2/configurations | システム設定取得 | - | - | TBD | cmd/api/main.go:116, internal/handlers/configuration_handler.go:19 |
| 29 | PATCH | /api/v2/configurations | システム設定更新 | - | ConfigurationUpdate | TBD | cmd/api/main.go:117, internal/handlers/configuration_handler.go:35 |

---

## Request/Response 型定義

### Request Bodies

| 型名 | 用途 | 主要フィールド |
|-----|------|--------------|
| IncidentCreate | 異常イベント作成 | detectedAt, type, personId, cameraId, roomId?, detectionAreaId?, description? |
| IncidentUpdate | 異常イベント更新 | status?, description?, detectionAreaId? |
| ActionCreate | 対応履歴作成 | staffId, actionType, startAt?, endAt?, notes? |
| NotificationCreate | 通知作成 | incidentId, sentToStaffIds[], notificationType, actionRequired |
| PersonCreate | 監視対象者作成 | name, age?, gender?, roomId?, medicalInfo? |
| PersonUpdate | 監視対象者更新 | name?, age?, gender?, roomId?, medicalInfo? |
| ConfigurationUpdate | システム設定更新 | aiSensitivity?, videoRetentionDays?, notificationEnabled? |

### Response Types

| 型名 | 説明 | 主要フィールド |
|-----|------|--------------|
| Incident | 異常イベント | id, detectedAt, type, status, personId, cameraId, roomId, personName, roomNumber, isAlertActive, notifications[], actions[], videos[] |
| Notification | 通知 | id, incidentId, sentToStaffIds[], notificationType, actionRequired, unreadByStaffIds[], escalated, createdAt |
| Action | 対応履歴 | id, incidentId, staffId, actionType, startAt, endAt, notes, staffName |
| Person | 監視対象者 | id, name, age, gender, roomId, medicalInfo, roomNumber |
| Staff | スタッフ | id, name, role, departmentId, email, phone, departmentName |
| Room | 居室 | id, roomNumber, floor, building, capacity, occupants[] |
| CameraDevice | カメラデバイス | id, deviceName, roomId, status, ipAddress, roomNumber |
| DetectionArea | 検知エリア | id, areaName, cameraId, coordinates, areaType |
| AuditLog | 監査ログ | id, targetType, targetId, operation, userId, changes, createdAt |
| Configuration | システム設定 | id, aiSensitivity, videoRetentionDays, notificationEnabled, updatedAt, updatedBy |

---

## エラーレスポンス

全APIで共通のエラーレスポンス形式を使用:

```json
{
  "error": {
    "message": "エラーメッセージ",
    "code": "ERROR_CODE" // optional
  }
}
```

### HTTPステータスコード

| コード | 説明 | 使用場面 |
|--------|------|----------|
| 200 | OK | 正常取得・更新 |
| 201 | Created | 新規作成成功 |
| 204 | No Content | 削除成功 |
| 400 | Bad Request | リクエスト不正（バリデーションエラー等） |
| 401 | Unauthorized | 認証エラー |
| 403 | Forbidden | 権限エラー |
| 404 | Not Found | リソース不存在 |
| 500 | Internal Server Error | サーバーエラー |

---

## 備考

- 認証/権限（Auth Required）: 現在の実装では認証ミドルウェアが未実装のため「TBD」としています
- CORS: 全エンドポイントでCORSが有効（全オリジン許可）
- APIバージョン: `/api/v2` プレフィックスを使用
- 実装ファイル: ルーティング定義とハンドラー実装の両方のファイル位置を記載

---

## 既存API一覧との仕様差分

既存の `api-list.md` はAPI一覧作成のガイドラインのみで、具体的なAPI仕様の記載がないため、仕様レベルでの直接的な差分はありません。

本ドキュメントは、ガイドラインに従って sample-project/backend の実装から抽出した具体的なAPI仕様を記載しています。

---

*生成日時: 2025/11/27*
*対象モジュール: sample-project/backend*
