---
id: sequence-diagram
title: Sequence Diagram
---

# Sequence Diagram

Epic 1: 異常検知および通知
(FR-01, FR-02, FR-04, FR-03, FR-06, FR-27)

シナリオコンテキスト
カメラ映像からAIが異常を検知し、速やかにモザイク画像付きで通知。配信ルール(部署・時間帯)や既読/未読制御、エスカレーションも反映。

```mermaid
sequenceDiagram
    participant CameraDevice as カメラデバイス（外部）
    participant AIController as AI Controller<br>（AIサーバ/Go）
    participant AIInference as AI推論サービス<br>（AI Docker/Python+ONNX）
    participant AppAPI as アプリAPIサーバ<br>（Go）
    participant APIGateway as API Gateway<br>（Go/gRPC-Gateway）
    participant MobileApp as モバイルアプリ<br>（Flutter）
    participant WebApp as Webアプリ<br>（Flutter）
    participant PushSvc as Push通知サービス<br>（Socket）
    participant Staff as スタッフ端末

    CameraDevice->>AIController: 動画ストリーム送信
    AIController->>AIInference: 推論要求(映像データ)
    AIInference-->>AIController: 検知結果(異常種別,対象者)
    AIController->>AppAPI: 異常イベントPOST({異常内容, モザイク画像})
    AppAPI->>APIGateway: 通知要求API(gRPC/REST)
    APIGateway->>PushSvc: Push APIリクエスト（配信ルールを自動判別, FR-27）
    PushSvc-->>MobileApp: プッシュ通知
    APIGateway-->>WebApp: Web通知反映（必要時）
    MobileApp-->>Staff: 通知受信・画像表示
    AppAPI->>AppAPI: 異常履歴・既読/未読・通知状態DB記録（FR-04,FR-06）

    %% ルーティングとエラー(既読未読・リトライ)
    APIGateway-->>AppAPI: 通知失敗時の再送要求
    AppAPI--x APIGateway: 通知配信失敗時/DB保存エラー時アラート生成(監査記録)
    AIInference--x AIController: 推論異常時リトライ・警告返却
```

---

Epic 2: 異常対応アクション管理・可視化
(FR-10, FR-11, FR-29)

シナリオコンテキスト
通知後、現場スタッフによる自己対応登録、進捗・完了・再監視切替やダッシュボードで全体進捗可視化。重複対応や対応漏れ防止ルールあり。

```mermaid
sequenceDiagram
    participant Staff as スタッフ端末/ユーザー
    participant MobileApp as モバイルアプリ<br>（Flutter）
    participant APIGateway as API Gateway
    participant AppAPI as アプリAPIサーバ
    participant DB as DB/履歴ストレージ

    Staff->>MobileApp: 「対応中」登録/完了ボタン操作
    MobileApp->>APIGateway: SetAction(案件ID, ユーザーID, 対応中/完了)
    APIGateway->>AppAPI: 案件対応API(gRPC)
    AppAPI->>DB: アクション履歴記録（重複/同時実行制御,FR-10,FR-11）
    AppAPI-->>APIGateway: 進捗更新event
    APIGateway-->>MobileApp: 案件進捗event通知
    Staff->>MobileApp: ダッシュボード表示要求
    MobileApp->>APIGateway: ListStatus()
    APIGateway->>AppAPI: ListStatus
    AppAPI->>DB: 進捗DB参照
    DB-->>AppAPI: 状況返却
    AppAPI-->>MobileApp: ダッシュボード進捗返却（FR-29）

    %% エラー・排他
    AppAPI--x AppAPI: 二重/無効な対応時は409（排他制御）・画面警告返却
```

---

Epic 3: 履歴・証跡管理
(FR-05, FR-06, FR-12, FR-07, FR-18)

シナリオコンテキスト
異常通知・対応・動画履歴をすべてDBに保存。モザイク動画, 高度検索, 履歴ダウンロード、監査証跡ログも全操作で残す。

```mermaid
sequenceDiagram
    participant Staff as スタッフ端末/ユーザー
    participant WebApp as Webアプリ
    participant APIGateway as API Gateway
    participant AppAPI as アプリAPIサーバ
    participant DB as DB/動画ストレージ
    participant AuditSvc as 監査ログサービス

    AppAPI->>DB: 異常イベント履歴/通知情報/サムネイル/対応履歴保存（FR-05,FR-06,FR-12）
    AppAPI->>AuditSvc: 監査記録(操作種別,操作者,時刻)（FR-18）

    Staff->>WebApp: 履歴/動画検索
    WebApp->>APIGateway: GetHistory(検索条件,FR-07)
    APIGateway->>AppAPI: GetHistory
    AppAPI->>DB: 検索
    DB-->>AppAPI: 履歴/動画メタデータ（モザイク値含む）
    AppAPI-->>WebApp: 検索結果データ
    WebApp->>APIGateway: 動画ストリームリクエスト
    APIGateway->>AppAPI: 動画取得API
    AppAPI->>DB: 動画取得（モザイク済み, FR-06）

    %% モザイク/監査
    AppAPI->>AuditSvc: 履歴ダウンロード/再生も操作記録
    AppAPI->>AIController: モザイクAPI(必要時)

    %% エラー
    AppAPI--x AppAPI: 検索失敗/未許可アクセス時はエラー返却、同時に監査
```

---

Epic 4: システム設定・管理
(FR-08, FR-22, FR-20, FR-26)

シナリオコンテキスト
AI検知パラメータ・動画保存期間・通知タイムアウト、カメラ別監視ON/OFF・検知エリア等を管理者がWeb/モバイルから更新。認証エラーや履歴も記録。

```mermaid
sequenceDiagram
    participant Admin as 管理者端末(Web/Mobile)
    participant APIGateway as API Gateway
    participant AppAPI as アプリAPIサーバ
    participant DB as DB/Configストレージ
    participant AuditSvc as 監査ログサービス
    participant AIController as AI Controller

    Admin->>APIGateway: ログイン/認証(QR/JWT,FR-08)
    APIGateway->>AppAPI: 認証API
    AppAPI-->>APIGateway: 成功/失敗返却

    Admin->>APIGateway: 設定/保存期間/通知ルール変更(各FR)
    APIGateway->>AppAPI: UpdateConfig/UpdateArea
    AppAPI->>DB: 設定データ保存・変更（FR-20,FR-22,FR-26）
    AppAPI->>AIController: AI設定即時反映
    AppAPI->>AuditSvc: 設定操作監査記録

    %% エラー/競合
    AppAPI--x AuditSvc: 設定新旧値や失敗理由も記録
    AppAPI--x Admin: 権限違反/入力不正・競合エラー返却
```

---

Epic 5: 対象者管理
(FR-16)

シナリオコンテキスト
現場管理者/スタッフが見守り対象者（患者等）の情報登録・編集・削除、および異常/対応履歴と柔軟な情報紐付・取得が可能。

```mermaid
sequenceDiagram
    participant Staff as スタッフ/管理者端末
    participant WebApp as Webアプリ
    participant APIGateway as API Gateway
    participant AppAPI as アプリAPIサーバ
    participant DB as DB/対象者情報/履歴
    participant AuditSvc as 監査ログサービス

    Staff->>WebApp: 対象者情報登録/編集/削除(入力画面,FR-16)
    WebApp->>APIGateway: UpsertPersonInfo
    APIGateway->>AppAPI: UpsertPersonInfo
    AppAPI->>DB: インサート/更新/削除
    AppAPI->>AuditSvc: 証跡記録

    AppAPI->>DB: 異常/対応履歴へ対象者ID紐付
    Staff->>WebApp: 履歴参照時に対象者情報照会
    WebApp->>AppAPI: GetPersonInfo
    AppAPI->>DB: 対象者+履歴情報返却

    AppAPI--x AuditSvc: 権限/不正/二重エラーも証跡
    AppAPI--x Staff: 入力/排他/権限エラー返却
```

