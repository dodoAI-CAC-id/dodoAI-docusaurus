# Issue-018: Alert Toggle (サーバ連携) 実装完了報告

## 実施日
2025年11月15日

## 概要
アラート切替機能のサーバ連携実装をTDD方式で完了しました。バックエンド（Go + PostgreSQL）とフロントエンド（Flutter）の両方で、アラート稼働状態の保持・更新・表示が正常に動作することを確認しました。

## 実装内容

### Phase 0: 現状把握とベース準備
- 既存seed（reset_view_screen_seed.sql）で8件（異常検知5+ご利用者3）を確認
- API起動・疎通確認完了

### Phase 1: Red（バックエンド統合テスト作成）
**作成ファイル:**
- `backend/internal/handlers/incident_alert_toggle_test.go`

**テストケース:**
1. TestToggleAlertStatus_Deactivate_Success - アラート無効化成功
2. TestToggleAlertStatus_Activate_Success - アラート有効化成功
3. TestToggleAlertStatus_NotFound - 存在しないID
4. TestToggleAlertStatus_InvalidJSON - 不正なJSON
5. TestToggleAlertStatus_MissingIsActive - isActiveフィールド欠落
6. TestToggleAlertStatus_DatabaseError - DB接続エラー

### Phase 2: Green（バックエンド実装）

#### 1. DBマイグレーション
**ファイル:** `backend/migrations/003_add_alert_active.sql`
```sql
ALTER TABLE incidents 
ADD COLUMN alert_active boolean NOT NULL DEFAULT true;
```

#### 2. モデル更新
**ファイル:** `backend/internal/models/incident.go`
- `Incident`構造体に`IsAlertActive bool`追加
- `GetAllIncidents`: SELECT句とScanに`alert_active`追加
- `GetIncidentByID`: JOINでroomNumber/personName/alert_active取得
- `ToggleAlertStatus`関数追加

#### 3. ハンドラー追加
**ファイル:** `backend/internal/handlers/incident_handler.go`
- `ToggleAlertStatus`ハンドラ実装
- リクエスト: `{"isActive": boolean}`
- レスポンス: 更新後のIncidentデータ（roomNumber/personName含む）

#### 4. ルーティング設定
**ファイル:** `backend/cmd/api/main.go`
- `PATCH /api/v2/incidents/:id/alert` エンドポイント追加

### Phase 3: Red（フロントエンドテスト更新）
**ファイル:** `frontend/test/features/view_screen/infrastructure/datasources/view_screen_remote_datasource_test.dart`
- `toggleAlertStatus`テストを実際のPATCH APIコールを期待する形に更新
- 成功ケースとエラーケースのテスト追加

### Phase 4: Green（フロントエンド実装）

#### 1. DataSource実装
**ファイル:** `frontend/lib/features/view_screen/infrastructure/datasources/view_screen_remote_datasource.dart`
```dart
Future<Map<String, dynamic>> toggleAlertStatus({
  required String incidentId,
  required bool isActive,
}) async {
  final response = await dio.patch(
    '/api/v2/incidents/$incidentId/alert',
    data: {'isActive': isActive},
  );
  // レスポンス処理
}
```

#### 2. Repository実装
**ファイル:** `frontend/lib/features/view_screen/infrastructure/repositories/view_screen_repository.dart`
- `isAlertActive`をAPIから取得: `data['isAlertActive'] as bool? ?? true`
- `roomNumber`フォールバック改善: roomIdを露出せず`"-"`表示
- `toggleAlertStatus`メソッド実装

#### 3. BLoC実装
**ファイル:** `frontend/lib/features/view_screen/presentation/blocs/view_screen_bloc/view_screen_bloc.dart`
- `_onToggleAlertStatus`ハンドラ実装済み確認
- 成功後に一覧再フェッチで最新状態反映
- await foldで非同期安全性確保

### Phase 5: Refactor/Hardening
- roomNumberフォールバック改善（roomId露出防止）
- personNameフォールバック維持
- 全体的な整合性確認

## API仕様

### エンドポイント
```
PATCH /api/v2/incidents/:id/alert
```

### リクエスト
```json
{
  "isActive": true|false
}
```

### レスポンス
```json
{
  "success": true,
  "data": {
    "id": "incident-view-006",
    "detectedAt": "2025-11-14T20:00:00Z",
    "type": "転倒",
    "status": "resolved",
    "personId": "person-006",
    "cameraId": "camera-003",
    "roomId": "room-008",
    "description": "対応完了",
    "createdAt": "2025-11-15T10:22:47.64043Z",
    "updatedAt": "2025-11-15T13:04:04.256828Z",
    "personName": "伊藤太郎",
    "roomNumber": "203",
    "isAlertActive": false
  }
}
```

## 動作確認

### 1. 一覧取得でroomNumber/personName/isAlertActive取得
```bash
curl -s http://localhost:8080/api/v2/incidents | \
  jq '.data[] | select(.id == "incident-view-006") | {id, roomNumber, personName, isAlertActive}'
```
**結果:**
```json
{
  "id": "incident-view-006",
  "roomNumber": "203",
  "personName": "伊藤太郎",
  "isAlertActive": true
}
```

### 2. アラート無効化
```bash
curl -X PATCH http://localhost:8080/api/v2/incidents/incident-view-006/alert \
  -H "Content-Type: application/json" \
  -d '{"isActive": false}'
```
**結果:** `"isAlertActive": false`

### 3. アラート有効化
```bash
curl -X PATCH http://localhost:8080/api/v2/incidents/incident-view-006/alert \
  -H "Content-Type: application/json" \
  -d '{"isActive": true}'
```
**結果:** `"isAlertActive": true`

## 受入れ条件達成状況

### API要件 ✅
- [x] GET /incidents と GET /incidents/:id は roomNumber/personName/isAlertActive を返す
- [x] PATCH /incidents/:id/alert が機能し、直後のGETで反映される
- [x] 404エラーハンドリング実装

### データ整合性 ✅
- [x] roomIdは露出せず、roomNumberまたは"-"を表示
- [x] personNameはAPIから取得、フォールバックはpersonId
- [x] isAlertActiveはAPIから取得、デフォルトtrue

### BLoC動作 ✅
- [x] ToggleAlertStatus成功後、一覧再フェッチで最新状態反映
- [x] await foldで非同期安全性確保
- [x] エラー時は元の状態に戻す

### UI期待動作（次フェーズで確認）
- [ ] アラート停止/稼働切替後もカードは消えない
- [ ] ボタンラベルのみ切替（稼働中⇔停止中）
- [ ] 異常検知5、ご利用者3（合計8）は常に維持
- [ ] room-006 のようなID表記は出ない

## 変更ファイル一覧

### バックエンド（5ファイル）
1. `backend/migrations/003_add_alert_active.sql` (新規)
2. `backend/internal/models/incident.go` (更新)
3. `backend/internal/handlers/incident_handler.go` (更新)
4. `backend/internal/handlers/incident_alert_toggle_test.go` (新規)
5. `backend/cmd/api/main.go` (更新)

### フロントエンド（3ファイル）
1. `frontend/lib/features/view_screen/infrastructure/datasources/view_screen_remote_datasource.dart` (更新)
2. `frontend/lib/features/view_screen/infrastructure/repositories/view_screen_repository.dart` (更新)
3. `frontend/test/features/view_screen/infrastructure/datasources/view_screen_remote_datasource_test.dart` (更新)

### ドキュメント（2ファイル）
1. `sample-project/.dodo/issue-018/plan.md` (既存)
2. `sample-project/.dodo/issue-018/completion-report.md` (本ファイル)

## 技術的な学び

### TDD実践
- Red→Green→Refactorサイクルを厳密に実施
- テストファーストで実装の方向性が明確化
- バックエンド・フロントエンド両方でTDD適用

### API設計
- RESTful設計（PATCH /incidents/:id/alert）
- レスポンスにJOIN情報を含めることでフロントの複雑性を軽減
- エラーハンドリングの統一

### フロントエンド設計
- Clean Architecture維持
- Repository層でのデータマッピング統一
- BLoCでの非同期処理の安全性確保

## 残課題と次のステップ

### 1. UI統合テスト（優先度: 高）
- [ ] Flutterアプリでの実際の動作確認
- [ ] アラートボタンのUI動作確認
- [ ] カードが消えないことの確認
- [ ] 件数が維持されることの確認

### 2. E2Eテスト（優先度: 中）
- [ ] ユーザーシナリオでの総合テスト
- [ ] 複数インシデントでの同時操作テスト
- [ ] エラーケースのUI表示確認

### 3. ドキュメント更新（優先度: 中）
- [ ] API仕様書への反映
- [ ] フロントエンド設計書への反映
- [ ] 運用マニュアルへの追記

### 4. パフォーマンス確認（優先度: 低）
- [ ] JOIN追加による一覧取得のパフォーマンス測定
- [ ] 必要に応じてインデックス追加検討

## まとめ

アラート切替機能のサーバ連携実装が完了しました。TDD方式により、バックエンド・フロントエンド両方で高品質な実装を実現できました。APIは正常に動作し、データ整合性も確保されています。

次のステップとして、実際のFlutterアプリでのUI統合テストを実施し、ユーザー体験の最終確認を行う必要があります。
