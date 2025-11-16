# Issue-022: 異常検知シミュレーションドライバ実装進捗

## 実装完了日
2025-11-16

## 実装概要
カード単位（カメラ単位）で異常検知をシミュレートできる開発用ドライバを実装しました。

## 実装内容

### Phase 0: IncidentItem に cameraId を必須化 ✅
- `incident_item.dart`: cameraId を optional から required に変更
- コンストラクタ、copyWith、props を更新

### Phase 1: Repository で camera_id マッピング ✅
- `view_screen_repository.dart`: API の camera_id/cameraId を必須フィールドとしてマッピング
- フォールバック値 'unknown-camera' を設定
- `mock_incident_datasource.dart`: 既に cameraId が設定済みであることを確認

### Phase 2: BLoC 完全実装 ✅
#### Event
- `SimulateIncidentDetected` イベント追加（incidentId + cameraId 必須）

#### State
- `ViewScreenLoaded` に `highlightedItemId` フィールド追加

#### Bloc
- `_handleDetected()` 共通ハンドラ実装
  - incidentId + cameraId で対象を検証
  - 冪等性対応（既に open/inProgress の場合はDB更新スキップ）
  - resolved → open への更新（actionType: 'detected_camera'）
  - 一覧再フェッチ
  - 3秒間のハイライト表示
  - ログ出力（incidentId/cameraId/status）
- `_onSimulateIncidentDetected()` ハンドラ追加

### Phase 3: カードUI 完全実装 ✅
#### incident_item_card.dart
- `isHighlighted` プロパティ追加
- 背景色を黄色（Colors.yellow.shade100）に変更
- kDebugMode 時のみ表示される開発用ボタン追加
  - 位置: カード右上
  - アイコン: Icons.videocam_outlined
  - 色: オレンジ（Colors.orange.shade700）
  - 動作: SimulateIncidentDetected イベントを dispatch

#### view_screen_page.dart
- highlightedItemId を State から取得
- カードに isHighlighted を渡す

### Phase 4: 通知 ✅（サウンドは任意のためスキップ）
- SnackBar 通知は既存実装で対応済み
- BLoC の ViewScreenError で通知表示
- サウンド再生は計画書で任意としたためスキップ

## 動作確認項目

### 基本動作
- [x] kDebugMode 時にカード右上にシミュレーションボタンが表示される
- [x] ボタン押下で SimulateIncidentDetected イベントが発火する
- [x] incidentId + cameraId が BLoC に正しく渡される

### ステータス遷移
- [x] resolved → open への更新が実行される
- [x] DB 更新（incidents.status, incidents.updated_at）
- [x] actions テーブルに新規レコード追加（action_type='detected_camera'）

### 冪等性
- [x] 既に open/inProgress のカードに対してはDB更新をスキップ
- [x] UI通知とハイライトのみ実施
- [x] ログ出力あり

### UI反映
- [x] 一覧が再フェッチされ、「異常検知一覧」に再配置される
- [x] 対象カード背景が3秒間黄色にハイライトされる
- [x] SnackBar でエラー通知が表示される（エラー時）

### ログ出力
- [x] シミュレーション実行時に incidentId/cameraId/status をログ出力
- [x] 冪等性スキップ時のログ出力
- [x] ステータス更新時のログ出力

## 変更ファイル一覧

### Domain
- `frontend/lib/features/view_screen/domain/entities/incident_item.dart`

### Infrastructure
- `frontend/lib/features/view_screen/infrastructure/repositories/view_screen_repository.dart`

### Presentation - BLoC
- `frontend/lib/features/view_screen/presentation/blocs/view_screen_bloc/view_screen_event.dart`
- `frontend/lib/features/view_screen/presentation/blocs/view_screen_bloc/view_screen_state.dart`
- `frontend/lib/features/view_screen/presentation/blocs/view_screen_bloc/view_screen_bloc.dart`

### Presentation - UI
- `frontend/lib/features/view_screen/presentation/widgets/molecules/incident_item_card.dart`
- `frontend/lib/features/view_screen/presentation/pages/view_screen_page.dart`

## 未実装項目

### Phase 4: サウンド再生（任意）
- audioplayers パッケージ追加
- assets/sounds/alert.mp3 追加
- AudioPlayer でサウンド再生
- 理由: 計画書で任意としたため、SnackBar 通知で十分と判断

### Phase 5: テスト更新
- BLoC テストの更新（SimulateIncidentDetected 経路）
- カードテストの更新（isHighlighted プロパティ）
- 既存テストの影響確認（IncidentItem の props 変更）

## 将来拡張（本番Push連携）

本実装は将来の SSE/WebSocket 連携を見据えた設計になっています。

### 拡張手順
1. **SSE/WebSocket Adapter追加**
   - ViewScreenNotificationService 実装
   - /api/v2/stream/incidents を購読

2. **BLoCイベント追加**
   ```dart
   class IncidentDetectedReceived extends ViewScreenEvent {
     final String incidentId;
     final String cameraId;
     final Map<String, dynamic> metadata;
   }
   ```

3. **同じ共通ハンドラを呼び出す**
   ```dart
   Future<void> _onIncidentDetectedReceived(
     IncidentDetectedReceived event,
     Emitter<ViewScreenState> emit,
   ) async {
     await _handleDetected(event.incidentId, event.cameraId, emit);
   }
   ```

### 置換不要な部分
- UI（ボタン・ハイライト・通知）
- 共通ハンドラ（`_handleDetected`）
- テスト（シミュレーション経路は開発用として残す）

## 備考

### 開発用ボタンの表示制御
- kDebugMode で制御しているため、リリースビルドでは自動的に非表示
- 本番環境への影響なし

### ログ出力
- print() を使用しているため、本番環境では適切なロギングライブラリへの置換を推奨

### 冪等性の実装
- 既に open/inProgress の場合はDB更新をスキップ
- これにより、連続クリックや重複イベントに対して安全

### ハイライトのタイマー管理
- Timer を使用して3秒後に自動解除
- state 比較で対象IDが一致する場合のみ解除（安全性確保）
