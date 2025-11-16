# Issue-022: 異常検知発生シミュレーションドライバ実装計画

## 背景
画面設計書の「6.2 異常検知の発生（→異常検知ステータス"未対応"への遷移）」機能をシミュレートするため、フロントエンド完結のドライバを実装する。将来的な本番Push連携（SSE/WebSocket）への拡張を見据えた設計とする。

## 目的（Doneの定義）
- UIボタン押下で異常検知を疑似発火できること
- 対象アイテムが「異常検知一覧」へ再配置されること
- カード背景色が黄色にハイライトされること（数秒間）
- ポップアップ通知とアラート音が再生されること
- 履歴（actions）が記録されること
- 本番Push連携時に共通ハンドラを再利用できる設計であること

## スコープ
- フロントエンド（Flutter）のみ
  - BLoC: シミュレーションイベント＋共通ハンドラ追加
  - UI: 検知シミュレーションボタン追加
  - 通知: SnackBar/ダイアログ表示
  - サウンド: アラート音再生（audioplayers）
  - ハイライト: 一時的な背景色変更（黄色）
- バックエンド: 変更なし（既存APIを利用）

## 非スコープ
- SSE/WebSocket実装（将来拡張として残す）
- バックエンドの疑似検知API
- 多端末同期・リアルタイム受信

## アーキテクチャ設計

### 共通ハンドラパターン
```
┌─────────────────────────────────────┐
│  SimulateIncidentDetected (今回)    │
│  IncidentDetectedReceived (将来)    │
└──────────────┬──────────────────────┘
               │
               ▼
      ┌────────────────────┐
      │ _handleDetected()  │ ← 共通ハンドラ
      │  (共通処理)         │
      └────────────────────┘
               │
               ├─ updateIncidentStatus (resolved → open)
               ├─ 一覧再フェッチ
               ├─ highlightedItemId設定
               ├─ SnackBar表示
               ├─ アラート音再生
               └─ 3秒後にハイライト解除
```

## フェーズ分割

### Phase 1: BLoC拡張（共通ハンドラ実装）
**目的**: 異常検知処理の共通ロジックを実装

**変更ファイル**:
- `frontend/lib/features/view_screen/presentation/blocs/view_screen_bloc/view_screen_event.dart`
  - `SimulateIncidentDetected` イベント追加
- `frontend/lib/features/view_screen/presentation/blocs/view_screen_bloc/view_screen_state.dart`
  - `ViewScreenLoaded` に `highlightedItemId` フィールド追加
- `frontend/lib/features/view_screen/presentation/blocs/view_screen_bloc/view_screen_bloc.dart`
  - `_handleDetected()` 共通ハンドラ実装
  - `_onSimulateIncidentDetected()` ハンドラ追加

**処理フロー**:
1. 対象インシデント選定（指定ID or resolvedの先頭）
2. `updateIncidentStatus(id, IncidentStatus.open, 'detected')`
   - **この呼び出しで以下のDB更新が実行されます**:
     - `incidents.status` を 'open' に更新（PATCH /api/v2/incidents/:id）
     - `actions` テーブルに新規レコード追加（POST /api/v2/incidents/:id/actions）
       - action_type: 'detected'
       - progress: 'in_progress'
       - start_at: 現在時刻
     - `incidents.updated_at` が自動更新
3. 成功後、一覧再フェッチ（GET /api/v2/incidents）
4. `highlightedItemId` 設定
5. 3秒後にタイマーでハイライト解除

**DB更新の詳細**:
- フロントエンドは既存の `updateIncidentStatus` UseCase/Repository を利用
- バックエンドの既存API（PATCH + POST）が以下を実行:
  ```sql
  -- incidents テーブル更新
  UPDATE incidents 
  SET status = 'open', updated_at = NOW() 
  WHERE id = :incident_id;
  
  -- actions テーブル追加
  INSERT INTO actions (incident_id, action_type, progress, start_at, created_at)
  VALUES (:incident_id, 'detected', 'in_progress', NOW(), NOW());
  ```

### Phase 2: UI拡張（ボタン＋ハイライト）
**目的**: カード単位（カメラ単位）でシミュレーションを発火できるUI

**変更ファイル**:
- `frontend/lib/features/view_screen/domain/entities/incident_item.dart`
  - `cameraId` フィールド追加
- `frontend/lib/features/view_screen/infrastructure/repositories/view_screen_repository.dart`
  - API の `camera_id` を `IncidentItem.cameraId` にマッピング
- `frontend/lib/features/view_screen/presentation/widgets/molecules/incident_item_card.dart`
  - `isHighlighted` プロパティ追加
  - 背景色を `Colors.yellow.shade100` に変更
  - カード右上に開発用シミュレーションボタン追加（kDebugMode時のみ表示）

**UI配置**:
```dart
// incident_item_card.dart
Stack(
  children: [
    // 既存カード本体
    Container(
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.yellow.shade100 : Colors.white,
        // ...
      ),
      // ...
    ),
    // 開発用シミュレーションボタン（カード右上）
    if (kDebugMode)
      Positioned(
        top: 4,
        right: 4,
        child: IconButton(
          icon: const Icon(Icons.videocam_outlined, size: 18),
          tooltip: 'このカメラで検知をシミュレーション',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            context.read<ViewScreenBloc>().add(
              SimulateIncidentDetected(
                incidentId: item.id,
                cameraId: item.cameraId,
              ),
            );
          },
        ),
      ),
  ],
)
```

### Phase 3: 通知＋サウンド
**目的**: ユーザーへの視覚・聴覚フィードバック

**変更ファイル**:
- `frontend/pubspec.yaml`
  - `audioplayers: ^5.0.0` 追加
  - `assets: - assets/sounds/alert.mp3` 追加
- `frontend/assets/sounds/alert.mp3` (新規作成)
- `frontend/lib/features/view_screen/presentation/pages/view_screen_page.dart`
  - BlocListener で成功時に SnackBar 表示
  - AudioPlayer でサウンド再生

**通知実装**:
```dart
BlocListener<ViewScreenBloc, ViewScreenState>(
  listener: (context, state) {
    if (state is ViewScreenLoaded && state.highlightedItemId != null) {
      // SnackBar表示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('異常検知を受信しました')),
      );
      // サウンド再生
      final player = AudioPlayer();
      player.play(AssetSource('sounds/alert.mp3'));
    }
  },
)
```

### Phase 4: テスト
**目的**: 動作保証とリグレッション防止

**テストケース**:
1. `SimulateIncidentDetected` → `updateIncidentStatus` 呼び出し確認
2. 成功後に一覧再フェッチ確認
3. `highlightedItemId` 設定→解除のタイミング確認
4. 既存テストの影響確認（Equatable props調整）

**変更ファイル**:
- `frontend/test/features/view_screen/presentation/blocs/view_screen_bloc_test.dart`
  - シミュレーション経路のテスト追加

### Phase 5: 将来拡張の準備
**目的**: SSE/WebSocket連携への拡張ポイント明示

**拡張ポイント**:
```dart
// 将来追加するイベント（今回は実装しない）
class IncidentDetectedReceived extends ViewScreenEvent {
  final String incidentId;
  final Map<String, dynamic> metadata;
  const IncidentDetectedReceived({
    required this.incidentId,
    required this.metadata,
  });
}

// 同じ共通ハンドラを呼び出す
Future<void> _onIncidentDetectedReceived(
  IncidentDetectedReceived event,
  Emitter<ViewScreenState> emit,
) async {
  await _handleDetected(event.incidentId, emit);
}
```

## 実装詳細

### BLoCイベント定義
```dart
// view_screen_event.dart
class SimulateIncidentDetected extends ViewScreenEvent {
  final String incidentId;  // 対象インシデントID（必須）
  final String cameraId;    // 対象カメラID（必須）
  
  const SimulateIncidentDetected({
    required this.incidentId,
    required this.cameraId,
  });
  
  @override
  List<Object?> get props => [incidentId, cameraId];
}
```

### BLoC状態拡張
```dart
// view_screen_state.dart
class ViewScreenLoaded extends ViewScreenState {
  final List<IncidentItem> items;
  final String? highlightedItemId; // 追加
  
  const ViewScreenLoaded({
    required this.items,
    this.highlightedItemId,
  });
  
  @override
  List<Object?> get props => [items, highlightedItemId];
}
```

### 共通ハンドラ実装
```dart
// view_screen_bloc.dart
Future<void> _handleDetected(
  String incidentId,
  String cameraId,
  Emitter<ViewScreenState> emit,
) async {
  final current = state;
  if (current is! ViewScreenLoaded) {
    add(const LoadIncidentItems());
    return;
  }

  // ターゲット選定（incidentId + cameraId で検証）
  final target = current.items.firstWhere(
    (x) => x.id == incidentId && x.cameraId == cameraId,
    orElse: () => throw Exception(
      'Incident not found: id=$incidentId, cameraId=$cameraId'
    ),
  );
  
  // 冪等性: 既に open/monitoring の場合はDB更新をスキップ
  if (target.status == IncidentStatus.open || 
      target.status == IncidentStatus.inProgress) {
    // UI通知とハイライトのみ実施
    emit(ViewScreenLoaded(
      items: current.items,
      highlightedItemId: target.id,
    ));
    
    // 3秒後に解除
    Future.delayed(const Duration(seconds: 3), () {
      final s = state;
      if (s is ViewScreenLoaded && s.highlightedItemId == target.id) {
        emit(ViewScreenLoaded(items: s.items, highlightedItemId: null));
      }
    });
    
    // ログ出力
    print('[SimulateDetection] Already active: '
          'incidentId=$incidentId, cameraId=$cameraId, status=${target.status}');
    return;
  }

  // 更新中状態
  emit(ViewScreenUpdating(
    items: current.items,
    updatingItemId: target.id,
  ));

  // ステータス更新（resolved → open）
  // ログ出力
  print('[SimulateDetection] Updating status: '
        'incidentId=$incidentId, cameraId=$cameraId, '
        'from=${target.status} to=open');
  
  final result = await repository.updateIncidentStatus(
    id: target.id,
    newStatus: IncidentStatus.open,
    actionType: 'detected_camera', // カメラ由来を示す
  );

  await result.fold<Future<void>>(
    (failure) async {
      emit(ViewScreenLoaded(items: current.items));
      emit(ViewScreenError(message: failure.message));
      emit(ViewScreenLoaded(items: current.items));
    },
    (updated) async {
      // 一覧再フェッチ
      final refreshResult = await getIncidentItemsUseCase();
      
      await refreshResult.fold<Future<void>>(
        (failure) async {
          emit(ViewScreenLoaded(items: current.items));
          emit(ViewScreenError(message: failure.message));
          emit(ViewScreenLoaded(items: current.items));
        },
        (freshItems) async {
          // ハイライト付与
          emit(ViewScreenLoaded(
            items: freshItems,
            highlightedItemId: target.id,
          ));
          
          // 3秒後に解除
          Future.delayed(const Duration(seconds: 3), () {
            final s = state;
            if (s is ViewScreenLoaded && s.highlightedItemId == target.id) {
              emit(ViewScreenLoaded(
                items: s.items,
                highlightedItemId: null,
              ));
            }
          });
        },
      );
    },
  );
}

Future<void> _onSimulateIncidentDetected(
  SimulateIncidentDetected event,
  Emitter<ViewScreenState> emit,
) async {
  await _handleDetected(event.incidentId, event.cameraId, emit);
}
```

### IncidentItem拡張
```dart
// incident_item.dart
class IncidentItem extends Equatable {
  final String id;
  final String cameraId;  // 追加
  final IncidentStatus status;
  final String type;
  final DateTime detectedAt;
  final String personName;
  final String roomNumber;
  final bool isAlertActive;

  const IncidentItem({
    required this.id,
    required this.cameraId,  // 追加
    required this.status,
    required this.type,
    required this.detectedAt,
    required this.personName,
    required this.roomNumber,
    required this.isAlertActive,
  });

  @override
  List<Object?> get props => [
        id,
        cameraId,  // 追加
        status,
        type,
        detectedAt,
        personName,
        roomNumber,
        isAlertActive,
      ];
}
```

### カードハイライト実装
```dart
// incident_item_card.dart
class IncidentItemCard extends StatelessWidget {
  final IncidentItem item;
  final bool isHighlighted; // 追加
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isHighlighted 
            ? Colors.yellow.shade100 
            : Colors.white,
        // ...
      ),
      // ...
    );
  }
}
```

## 受入れ条件（Acceptance Criteria）
- [ ] **カード単位のボタン配置**:
  - [ ] 各カード右上に開発用シミュレーションボタンが表示される（kDebugMode時のみ）
  - [ ] ボタン押下で該当カードの incidentId + cameraId が BLoC に渡される
- [ ] **cameraId のデータフロー**:
  - [ ] API の `camera_id` が IncidentItem.cameraId にマッピングされる
  - [ ] BLoC イベントで incidentId + cameraId を受け取る
- [ ] **冪等性**:
  - [ ] 既に open/monitoring のカードに対してはDB更新をスキップ
  - [ ] UI通知とハイライトのみ実施（ログ出力あり）
- [ ] **ステータス遷移（resolved → open）**:
  - [ ] 対象インシデントが resolved → open に更新される
  - [ ] `incidents.status` が 'open' に更新される
  - [ ] `incidents.updated_at` が更新される
  - [ ] `actions` テーブルに新規レコードが追加される（action_type='detected_camera'）
- [ ] **UI反映**:
  - [ ] 一覧が再フェッチされ、「異常検知一覧」に再配置される
  - [ ] 対象カード背景が3秒間黄色にハイライトされる
  - [ ] SnackBarで「異常検知を受信しました（カメラID: xxx）」と表示される
  - [ ] アラート音が再生される
- [ ] **ログ出力**:
  - [ ] シミュレーション実行時に incidentId/cameraId/status をログ出力
- [ ] 既存テストが全てパスする

## リスクと緩和策
- **Equatable比較の影響**: highlightedItemId追加により既存テストが失敗する可能性
  - 緩和策: props順序を調整、テストを追随修正
- **サウンド再生の制約**: Web版はユーザー操作起点が必要
  - 緩和策: ボタン押下起点なので問題なし。将来Push受信時は視覚通知を優先
- **タイマーのメモリリーク**: BLoC破棄時にタイマーが残る可能性
  - 緩和策: state比較で対象IDが一致する場合のみ解除

## 変更ファイル一覧（予定）
### 新規作成
- `frontend/assets/sounds/alert.mp3`

### 更新
- `frontend/pubspec.yaml`
- `frontend/lib/features/view_screen/domain/entities/incident_item.dart` ← cameraId追加
- `frontend/lib/features/view_screen/infrastructure/repositories/view_screen_repository.dart` ← camera_id マッピング
- `frontend/lib/features/view_screen/presentation/blocs/view_screen_bloc/view_screen_event.dart`
- `frontend/lib/features/view_screen/presentation/blocs/view_screen_bloc/view_screen_state.dart`
- `frontend/lib/features/view_screen/presentation/blocs/view_screen_bloc/view_screen_bloc.dart`
- `frontend/lib/features/view_screen/presentation/widgets/molecules/incident_item_card.dart` ← カード右上にボタン追加
- `frontend/test/features/view_screen/presentation/blocs/view_screen_bloc_test.dart`
- 既存テスト全般（IncidentItem の props 変更に追随）

## タイムライン（目安）
- Phase 1（BLoC拡張）: 0.5日
- Phase 2（UI拡張）: 0.5日
- Phase 3（通知＋サウンド）: 0.5日
- Phase 4（テスト）: 0.5日
- Phase 5（ドキュメント）: 0.5日

## 将来拡張（本番Push連携）
本実装完了後、以下の手順でSSE/WebSocket連携へ拡張可能：

1. **SSE/WebSocket Adapter追加**
   - `ViewScreenNotificationService` 実装
   - `/api/v2/stream/incidents` を購読

2. **BLoCイベント追加**
   - `IncidentDetectedReceived` イベント追加
   - 同じ `_handleDetected()` を呼び出す

3. **バックエンド拡張**
   - SSEエンドポイント実装
   - 疑似検知API（開発用）追加

4. **置換不要な部分**
   - UI（ボタン・ハイライト・通知）
   - 共通ハンドラ（`_handleDetected`）
   - テスト（シミュレーション経路は開発用として残す）
