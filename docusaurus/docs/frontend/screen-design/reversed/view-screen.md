---
id: view-screen-detected-list
slug: /view-screen-detected-list
title: 異常検知一覧（未対応/対応中） 設計書
---

![最終更新日](https://img.shields.io/static/v1?label=最終更新日&message=2025/11/30&color=blue)

# ビュー画面設計書（リバース生成）

## 1. 画面概要

- 目的：見守り対象者の異常検知（未対応/対応中）の状況を一覧で把握し、迅速な対応・状態更新を行う
- 主な機能：
  - 異常検知一覧（未対応/対応中）の表示
  - 詳細表示（モーダル）
  - 対応系アクション（対応開始/訪室不要/誤検知/戻す/完了）
  - 引き下げリフレッシュ（一覧再取得）
- 利用対象ユーザー：介護現場スタッフ/監視オペレーター

Traceability（実装参照元）
- 画面/イベント実装: sample-project/frontend/lib/features/view_screen/presentation/pages/view_screen_page.dart
- UIカード構成: sample-project/frontend/lib/features/view_screen/presentation/widgets/molecules/incident_item_card.dart
- ドメイン: sample-project/frontend/lib/features/view_screen/domain/entities/incident_item.dart, incident_status.dart
- 状態管理: sample-project/frontend/lib/features/view_screen/presentation/blocs/view_screen_bloc/（event/state/bloc）
- 取得・更新API: sample-project/frontend/lib/features/view_screen/infrastructure/datasources/view_screen_remote_datasource.dart

---

## 2. 画面レイアウト

![画面イメージ](/img/docs/frontend/view-screen-2.png)

> 画面モックは未定。Figma等の確定後に更新。

- レイアウト概略
  - 上部 AppHeader（本ドキュメント範囲外のため詳細割愛）
  - メイン：縦スクロール領域
    - セクション: 「異常検知一覧」（未対応/対応中）
  - カードグリッドはレスポンシブ（minCardWidth=240px, 最大5列）
    - 実装: view_screen_page.dart の _buildGridView（LayoutBuilder, clamp 1..5）

---

## 3. 一覧表示（セクション仕様）

| No. | セクション名     | ページネーション | 既定ソート                                                                 | 表示件数 | 備考 |
| --- | ---------------- | ---------------- | -------------------------------------------------------------------------- | -------- | ---- |
| 1   | 異常検知一覧     | なし             | ステータス（未対応 → 対応中）、同一ステータスは検知日時（detectedAt）降順 | 全件     | ViewScreenLoaded.detectedItems ロジック |

- 抽出条件: IncidentStatus.isDetected（未対応/対応中）
  - 実装: view_screen_state.dart の detectedItems ゲッター

---

## 4. 画面項目定義

### 4.1 カード要素（異常検知一覧）

| No. | 画面項目名           | 種別   | 入出力 | 取得元/API                     | パラメータ/キー                                        | 編集/表示仕様                                   | 長さ | 初期値 | 必須 | 備考 |
| --- | -------------------- | ------ | ------ | ------------------------------ | ------------------------------------------------------ | ----------------------------------------------- | ---- | ------ | ---- | ---- |
| 1   | 部屋/ベッド番号      | text   | 出力   | GET /api/v2/incidents          | roomBedNumber                                          | 太字（ヘッダ左上）                              | -    | -      | ○    | - |
| 2   | 見守り対象者名       | text   | 出力   | GET /api/v2/incidents          | personName                                             | 小さめ/灰色                                     | -    | -      | ○    | 1行省略 |
| 3   | カメラID             | text   | 出力   | GET /api/v2/incidents          | cameraId                                               | 小さめ/灰色、長文はellipsis                     | -    | -      | ○    | - |
| 4   | ステータスバッジ     | label  | 出力   | GET /api/v2/incidents          | status（IncidentStatus）                               | 色: 未対応=黄, 対応中=緑                         | -    | -      | ○    | StatusBadge |
| 5   | 異常姿勢             | text   | 出力   | GET /api/v2/incidents          | detectionType                                          | 小さなチップ表示                                | -    | -      | ○    | 例: 起床/転倒など |
| 6   | 検知画像（2枚まで）  | image  | 出力   | GET `/api/v2/incidents/:id`    | pictureAtDetection / pictureBeforeDetection            | 左右切替ボタンで index=0/1（実装はアイコン代替） | -    | -      | -    | データ有無により表示（UIはサンプル実装） |
| 7   | 検知日時（任意）     | text   | 出力   | GET /api/v2/incidents          | detectedAt                                             | 詳細モーダル内に表示                            | -    | -      | -    | item.detectedAt != null の時 |
| 8   | 強調表示（任意）     | state  | 出力   | 画面内ロジック                 | highlightedItemId                                      | 一時的にカード背景を強調                         | -    | -      | -    | 検知時のハイライト用途 |

Traceability:
- 要素構成: incident_item_card.dart（ヘッダ/姿勢チップ/画像領域/フッタボタン）
- エンティティ定義: incident_item.dart
- 強調表示: view_screen_state.dart（highlightedItemId）

### 4.2 「MORE」リンク
- 本セクションでは未実装

### 4.3 作成/追加ボタン
- 本セクションでは未実装

---

## 5. 画面イベント一覧（対象範囲限定）

| No. | イベント名           | トリガー                        | 概要                                              | 正常時遷移先 | 通信 |
| --- | -------------------- | ------------------------------- | ------------------------------------------------- | ------------ | ---- |
| 1   | 初期表示             | 画面遷移時（initState）        | インシデント一覧取得し表示                        | -            | あり |
| 2   | プルダウン更新       | RefreshIndicator                | 一覧を再取得して反映                              | -            | あり |
| 3   | 詳細表示（モーダル） | カード押下（onTap）             | 選択アイテムの詳細情報をダイアログ表示            | -（モーダル）| なし |
| 4   | 対応開始             | ボタン押下（未対応カード）     | ステータス 未対応→対応中、アクション記録           | -            | あり |
| 5   | 訪室不要             | ボタン押下（未対応/対応中）    | ステータス→検知なし、アクション記録               | -            | あり |
| 6   | 誤検知               | ボタン押下（未対応/対応中）    | ステータス→検知なし、アクション記録               | -            | あり |
| 7   | 戻す                 | ボタン押下（対応中）           | ステータス→未対応                                  | -            | あり |
| 8   | 完了                 | ボタン押下（対応中）           | ステータス→検知なし、アクション記録               | -            | あり |

Traceability:
- イベント定義: view_screen_event.dart
- ハンドリング: view_screen_bloc.dart（`on<...>`）、view_screen_page.dart（_handleXxx）
- ハンドリング: view_screen_bloc.dart（`on<...>`）、view_screen_page.dart（_handleXxx）
- ハンドリング: view_screen_bloc.dart（`on<...>`）、view_screen_page.dart（_handleXxx）
- ハンドリング: view_screen_bloc.dart（`on<...>`）、view_screen_page.dart（_handleXxx）

---

## 6. イベント詳細（処理フロー）

### 6.1 初期表示
1. 前提/バリデーション：ログイン/権限チェックは画面レイヤでは未実装（BFF/Interceptor等で担保想定）
2. 処理：
   1. BLoCに LoadIncidentItems を dispatch（initState）
   2. UseCase → Repository → RemoteDataSource.getIncidents()
      - GET /api/v2/incidents
      - レスポンス形式は `{ data: [...] }` または 直配列 を許容
   3. 成功：ViewScreenLoaded(items) → detectedItems で抽出（未対応/対応中）して表示
   4. 失敗：ViewScreenError を発行し SnackBar（赤）表示＋「再読み込み」導線

エラーメッセージ（例）
| ID               | 文言（仮）                 | 対応方針（仮）         |
| ---------------- | -------------------------- | ---------------------- |
| list.load.error  | リストの取得に失敗しました | リトライ/問い合わせ誘導 |

Traceability: view_screen_page.dart（initState, BlocConsumer）, view_screen_remote_datasource.dart（getIncidents）

### 6.2 詳細表示（モーダル）
1. 前提：対象ID必須（item.id）
2. 処理：onTap → AlertDialog で項目表示（roomBedNumber, personName, detectionType, status.displayName, detectedAt）
Traceability: view_screen_page.dart（_showIncidentDetail）

### 6.3 対応系アクション（開始/訪室不要/誤検知/戻す/完了）
1. 前提：対象ID必須
2. 処理：
   - UIで確認ダイアログ → UpdateIncidentStatus を dispatch
   - UseCase → Repository → RemoteDataSource.updateIncidentStatus
     1) PATCH `/api/v2/incidents/:id` body: `{ status: open|monitoring|resolved }`
     2) POST `/api/v2/incidents/:id/actions` body: `{ actionType: start|complete|revert, staffId: current_user, note: 差異時のみ }`
     3) 成功後、GET /api/v2/incidents で再フェッチし反映
3. エラー：SnackBar表示し現状態にロールバック
Traceability: view_screen_page.dart（_handleXxx）, view_screen_bloc.dart（_onUpdateIncidentStatus）, view_screen_remote_datasource.dart（updateIncidentStatus）

### 6.4 プルダウン更新
1. 前提：なし
2. 処理：RefreshIncidentItems を dispatch → GET /api/v2/incidents → 反映
Traceability: view_screen_page.dart（RefreshIndicator）, view_screen_bloc.dart（_onRefreshIncidentItems）

---

## 7. 非機能・UI/UX補足（任意）

- ローディング：中央に CircularProgressIndicator
- 空状態：Text「データがありません」（灰色）
- アクセシビリティ：ボタンラベルは日本語明示、色コントラストは濃色系ボタン/灰色背景で判読性確保
- レスポンシブ：minCardWidth=240px, 列数=1..5（画面幅依存）
- パフォーマンス：一覧は一括取得後、UI側で抽出/ソート。画像はサムネイル/遅延取得方針（詳細API活用）を今後検討

---

## 8. パラメータ/用語集（任意）

| キー/用語              | 説明 |
| ---------------------- | ---- |
| roomBedNumber          | 部屋/ベッド番号 |
| personName             | 見守り対象者名 |
| cameraId               | カメラID |
| detectionType          | 異常姿勢（起床/端坐位/転倒/離床/臥床 等） |
| status                 | IncidentStatus（未対応/対応中/検知なし） |
| detectedAt             | 検知日時 |
| pictureAtDetection     | 検知時画像（base64） |
| pictureBeforeDetection | 検知直前画像（base64） |

---

## 9. 変更履歴（任意）

| 日付       | 担当  | 変更内容   |
| ---------- | ----- | ---------- |
| 2025/11/30 | AI+Ichikawa | 初版作成   |

---

補足（API仕様出典）:
- GET /api/v2/incidents
- GET `/api/v2/incidents/:id`
- PATCH `/api/v2/incidents/:id`（status）
- POST `/api/v2/incidents/:id/actions`（actionType: start/complete/revert）

## 10. 差分比較（元: frontend/screen-design/view-screen.md と本書）

以下は主要な差分の早見表（差分の要旨を先頭に記載）。

| セクション | 差分の要旨 | 元設計書（view-screen.md） | 本書（reversed/view-screen.md） | 影響/対応 |
|---|---|---|---|---|
| 3. 一覧表示（セクション仕様） | 元は未定義、本書は仕様明確 | 該当なし | あり（未対応→対応中、検知日時降順） | 本書の仕様を採用 or 元へ追記 |
| 3. 一覧表示（抽出条件） | 本書のみ抽出条件あり | 記載なし | `IncidentStatus.isDetected` | 一覧の抽出ロジック要統一 |
| 3. 一覧表示（API） | v1系→v2系へ変更 | `GET /incidents/{incidentId}` 等 | `GET /api/v2/incidents`、`GET /api/v2/incidents/:id` | BFF/フロントの呼出し先整理 |
| 4. 画面項目定義（詳細API） | 詳細取得エンドポイント差 | `GET /incidents/{incidentId}/notifications` | `GET /api/v2/incidents/:id` | API統一（v2推奨） |
| 4. 画面項目定義（画像） | 取得元/UI操作が異なる | 通知API＋「画像選択」 | 詳細API2枚（検知時/直前）切替 | 体験どちらに寄せるか要決定 |
| 4. 画面項目定義（キー/フィールド） | 命名差（マッピング要） | `roomId`/`personId`/`notificationType` | `roomBedNumber`/`personName`/`cameraId`/`detectionType`/`detectedAt` | DTO/BFFでマッピング整備 |
| 4. 画面項目定義（ステータス表現） | 日本語→英語ドメイン | 未対応/対応中/検知なし | `open`/`monitoring`/`resolved` | 推奨: 未対応↔`open` 等の対応表 |
| 4. 画面項目定義（ステータスUI） | 本書はUI具体化 | 記述中心（バッジ明記なし） | ステータスバッジ（未対応=黄/対応中=緑） | バッジ仕様の反映可 |
| 5. 画面イベント一覧 / 6. イベント詳細 | 含有イベント差 | 初期/異常検知/対応中/完了＋アラート/再通知 | 初期/引き下げ更新/詳細/対応系（開始/訪室不要/誤検知/戻す/完了） | アラート/再通知は本書へ追記候補 |
| 4. 画面項目定義（他画面遷移/共通） | 元のみ記述 | QR/ビュー/履歴/設定あり | 記載なし | 本書の対象外として整理 |
| 7. 非機能・UI/UX補足 | 観点の違い | リアルタイム/アラート音/エラー表示 | ローディング/空状態/アクセシビリティ/性能 | 要件を統合 |
| 1. 画面概要（Traceability） | 本書のみ実装参照明記 | コード参照なし | BLoC/UseCase/Repository/DS/RemoteDataSource | 実装追跡は本書が容易 |

上表は主要差分の早見表。必要に応じて行追加で拡張可能。
