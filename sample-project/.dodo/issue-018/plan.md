# Issue-018: Alert Toggle (サーバ連携) 実装計画 – TDD (Red→Green→Refactor)

## 背景
- 現状、アラート切替（稼働中/停止中）操作時に:
  - 対象カードが消える
  - ご利用者一覧の件数が増殖する
  - room-006 のように roomId が表示される
- 原因は、単体取得APIがJOIN情報（roomNumber/personName）を返さず、一覧APIとスキーマが不整合なこと、ならびにアラート切替がサーバ未実装のため、再フェッチ時に整合が崩れること。

## 目的（Doneの定義）
- サーバ側でアラート稼働状態を保持および更新できること（DB/モデル/API）
- 一覧/詳細ともにroomNumber/personName/isAlertActiveを返し、UIが常に正しい情報で整合
- フロントのトグル後もカードは消えず、ボタンだけ切り替わり、件数は固定（異常検知5+ご利用者3）

## スコープ
- バックエンド（Go + PostgreSQL）
  - incidents.alert_active列の追加（デフォルトtrue）
  - モデル・クエリ・ハンドラ更新
  - 新規PATCH API: PATCH /api/v2/incidents/:id/alert（isActive: boolean）
- フロントエンド（Flutter）
  - RemoteDataSource.toggleAlertStatus をAPI連携へ
  - Repositoryのマッピング補強（isAlertActive、roomNumberフォールバック）
  - 既存BLoCの「成功後一覧再フェッチ」に統一（await fold維持）

## 非スコープ
- 認可/認証ロジックの本格導入
- 本番スキーマ移行対応（dev/PoC前提）
- 画像取得等の拡張

## フェーズ分割（TDD）

### Phase 0: 現状把握とベース準備
- 既存のseed（reset_view_screen_seed.sql）で8件（5+3）を維持
- API起動・疎通確認（curl）

### Phase 1: Red（バックエンド統合テスト）
- 追加ファイル: backend/test/incident_alert_toggle_test.go
- シナリオ:
  - PATCH /api/v2/incidents/incident-view-006/alert {isActive:false}
    - 200 OK
    - レスポンスJSONに isAlertActive=false, roomNumber/personName が存在
    - 直後の GET /api/v2/incidents で対象IDの isAlertActive=false を確認、件数8件維持
  - 再度 {isActive:true} → isAlertActive=true
  - 不正ID → 404
- まだ実装がないためテストは失敗（Red）

### Phase 2: Green（バックエンド実装）
- Migration: 00x_add_alert_active.sql
  - ALTER TABLE incidents ADD COLUMN alert_active boolean NOT NULL DEFAULT true;
- Model更新: internal/models/incident.go
  - Incident に IsAlertActive bool `json:"isAlertActive"` を追加
- GetAllIncidents:
  - SELECT句に i.alert_active を追加、Scan対応
- GetIncidentByID:
  - persons/rooms テーブルをJOINし、roomNumber/personName/alert_activeを返す形へ変更
- 新規エンドポイント:
  - PATCH /api/v2/incidents/:id/alert
    - 入力: { "isActive": boolean }
    - 更新: incidents.alert_active の更新、更新後にJOIN込みで返却
    - NotFound対応
- 統合テストをGreenに

### Phase 3: Red（フロントユニット/統合テスト）
- 追加/修正の主なテスト
  - view_screen_remote_datasource_test.dart:
    - toggleAlertStatus が PATCH /incidents/:id/alert を呼ぶこと（モックDioで検証）
  - view_screen_repository_test.dart:
    - isAlertActive がAPI値でマッピングされること
    - roomNumber欠落時のフォールバックがroomId生表示にならないこと（"-"など）
  - view_screen_bloc_test.dart:
    - ToggleAlertStatus 成功後、一覧再フェッチが走り、件数/表示が安定していること（await foldの非同期安全性も確認）
- まだ実装がない/不十分のため失敗（Red）

### Phase 4: Green（フロント実装）
- RemoteDataSource.toggleAlertStatus:
  - PATCH /api/v2/incidents/:id/alert を実装（{"isActive": isActive}）
- Repository._mapToIncidentItem:
  - isAlertActive = data['isAlertActive']（API準拠）
  - roomBedNumber = data['roomNumber'] ?? '-'（roomIdを露出しない）
- BLoCは成功時に一覧再フェッチ（既存修正済）を維持
- テストGreen

### Phase 5: Refactor/Hardening
- 取得結果のID重複排除（安全策）
- エラー/例外ハンドリング整理（レスポンス整形共通化）
- ドキュメント更新（この計画書、API仕様）

## API仕様（追加）
- PATCH /api/v2/incidents/:id/alert
  - Request: { "isActive": boolean }
  - Response: {
      "data": {
        "id": "...",
        "status": "...",
        "isAlertActive": true|false,
        "roomNumber": "...",
        "personName": "...",
        ...
      },
      "success": true
    }
  - 404: Incident not found

## DB変更
- テーブル: incidents
  - 追加列: alert_active boolean not null default true
- 影響範囲:
  - SELECT句（一覧/詳細）で alert_active を返す
  - JOINは一覧/詳細で同等の表示項目を返す

## 受入れ条件（Acceptance Criteria）
- UI:
  - アラート停止/稼働切替後もカードは消えない
  - ボタンラベルのみ切替（稼働中⇔停止中）
  - 異常検知5、ご利用者3（合計8）は常に維持
  - room-006 のようなID表記は出ない（roomNumber表示）
- API:
  - GET /incidents と GET /incidents/:id は roomNumber/personName/isAlertActive を返す
  - PATCH /incidents/:id/alert が機能し、直後のGETで反映される

## リスクと緩和策
- 既存データとalert_activeの初期値不整合 → MigrationでDEFAULT trueとし、リセットシードで再現性確保
- 詳細APIへのJOIN追加によるパフォーマンス影響 → 必要に応じインデックス確認、テーブルサイズはPoC規模
- フロント実装との差分 → ダートテストで検出、BLoCのawait fold統一で非同期安全性を担保

## 実行手順（参考）
- DBマイグレーション適用後、seedのリセット
  - cd sample-project
  - docker cp backend/migrations/reset_view_screen_seed.sql sample-project-db:/tmp/reset_view_screen_seed.sql
  - docker-compose exec -T db psql -U postgres -d apidb -f /tmp/reset_view_screen_seed.sql
- 動作確認（API）
  - curl -i -X PATCH 'http://localhost:8080/api/v2/incidents/incident-view-006/alert' -H 'Content-Type: application/json' -d '{"isActive": false}'
  - curl -s 'http://localhost:8080/api/v2/incidents' | jq

## タイムライン（目安）
- Phase1（Red/BE）: 0.5日
- Phase2（Green/BE）: 0.5〜1日
- Phase3（Red/FE）: 0.5日
- Phase4（Green/FE）: 0.5日
- Phase5（Refactor/整備）: 0.5日

## 変更ファイル一覧（予定）
- backend/migrations/00x_add_alert_active.sql（新規）
- backend/internal/models/incident.go（更新）
- backend/internal/handlers/incident.go（または相当のrouter/handler）（新規/更新）
- frontend/lib/features/view_screen/infrastructure/datasources/view_screen_remote_datasource.dart（更新）
- frontend/lib/features/view_screen/infrastructure/repositories/view_screen_repository.dart（更新）
- frontend/test/...（各ユニットテスト/統合テストの追加・更新）
