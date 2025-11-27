---
id: history-frontend-backend-integration-completion-report
title: 履歴画面 Frontend-Backend統合 完了レポート
---

# 履歴画面 Frontend-Backend統合 完了レポート

## 実施日
2025年11月14日

## 概要
履歴画面のFrontendとBackEndをAPI仕様書（microservice.yaml v2.0.0）に基づいて統合しました。

## 実施内容

### 1. API仕様書とのアライメント

#### 1.1 エンドポイントの修正
従来の実装からAPI仕様書v2.0.0に準拠するよう、以下のエンドポイントを修正しました：

| 機能 | 修正前 | 修正後 |
|------|--------|--------|
| インシデント一覧取得 | `/api/incidents` | `/api/v2/incidents` |
| インシデント詳細取得 | `/api/incidents/{id}` | `/api/v2/incidents/{id}` |
| 検索 | `/api/incidents/search` (POST) | `/api/v2/incidents` (GET + クエリパラメータ) |
| 動画一覧取得 | `/api/incidents/{id}/video` | `/api/v2/incidents/{id}/videos` |
| 動画ファイル取得 | `/api/videos/{id}/download` | `/api/v2/videos/{id}/file` |

#### 1.2 ステータス値の修正
API仕様書のステータス定義に合わせて修正：

| ドメイン | API値（修正前） | API値（修正後） |
|----------|----------------|----------------|
| detected | detected | open |
| confirmed | confirmed | open |
| inProgress | in_progress | monitoring |
| resolved | resolved | resolved |

### 2. データモデルの修正

#### 2.1 IncidentDTO
API仕様書のIncidentスキーマに合わせて修正：
- フィールド名をキャメルケースに統一（`detected_at` → `detectedAt`）
- `type`フィールドを追加（異常検出動作）
- `personId`, `cameraId`, `roomId`, `detectionAreaId`を追加
- `notifications`, `videos`配列を追加
- actions配列から表示用データを抽出する処理を追加

#### 2.2 ActionDTO
API仕様書のActionスキーマおよび拡張フィールドに合わせて修正：
- 基本フィールド: `id`, `incidentId`, `staffId`, `actionType`, `progress`, `startAt`, `endAt`, `createdAt`, `note`
- 拡張フィールド（`/incidents/{id}/actions`レスポンス用）:
  - `roomBedNameOrNumber`: 部屋/ベッド名または番号
  - `personName`: 見守り対象者名
  - `incidentDetectionType`: 異常検出動作

#### 2.3 VideoDTO
API仕様書のIncidentVideoスキーマに合わせて修正：
- `fileUrl`, `thumbnailUrl`を追加
- `mosaic`フラグを追加
- `spanStart`, `spanEnd`（録画時間範囲）を追加
- duration計算を時間範囲から自動算出するように変更

### 3. リポジトリ実装の修正

#### 3.1 IncidentRepositoryImpl
- レスポンス形式の変更に対応（配列を直接返す）
- 検索機能をGETクエリパラメータ方式に変更
- カウント機能の暫定実装（API仕様書にcountエンドポイントがないため全件取得してカウント）

#### 3.2 VideoRepositoryImpl
- 動画一覧取得APIに対応
- ストリーミングURLの直接生成
- ダウンロード機能の修正

### 4. API仕様書との相違点と対応

#### 4.1 検索条件の制限
API仕様書の`/incidents` GETエンドポイントは以下のクエリパラメータのみサポート：
- `personId`: 対象者IDでフィルタ
- `from`: 開始日時
- `to`: 終了日時  
- `status`: ステータス

画面設計書で要求されている以下の条件は現在未対応：
- 部屋/ベッド番号
- 見守り対象者名（personIdではなく名前）
- 担当者（スタッフ名）
- 操作（actionType）
- 異常検出動作（detectionType）

**対応方針**: 
- フロントエンド側でフィルタリングを実装
- または、バックエンド側でAPIを拡張

#### 4.2 ページネーション
API仕様書にlimit/offsetパラメータの記載がないため、現在は全件取得しています。

**対応方針**: 
- バックエンド側でページネーション機能を追加
- または、フロントエンド側でクライアントサイドページネーションを実装

#### 4.3 カウント機能
API仕様書にカウント専用エンドポイントがないため、暫定的に全件取得してカウントしています。

**対応方針**: 
- バックエンド側で`/api/v2/incidents/count`エンドポイントを追加

## テスト項目

### 単体テスト
- [ ] IncidentDTO.fromJson - API仕様書のレスポンス形式でパース可能
- [ ] ActionDTO.fromJson - 拡張フィールドを含むパース可能
- [ ] VideoDTO.fromJson - API仕様書のレスポンス形式でパース可能
- [ ] IncidentRepositoryImpl - APIエンドポイント呼び出し
- [ ] VideoRepositoryImpl - APIエンドポイント呼び出し

### 統合テスト（実API接続）
- [ ] インシデント一覧取得
- [ ] インシデント詳細取得（画像含む）
- [ ] 検索機能（日付範囲、ステータス）
- [ ] 動画一覧取得
- [ ] 動画ダウンロード
- [ ] 動画ストリーミング再生

### E2Eテスト
- [ ] 履歴画面初期表示
- [ ] 検索条件入力と検索実行
- [ ] ページネーション操作
- [ ] 動画再生モーダル表示
- [ ] 動画ダウンロード実行

## 今後の作業

### 短期（次のイテレーション）
1. **バックエンドAPI拡張**
   - ページネーションパラメータ追加
   - カウントエンドポイント追加
   - 詳細検索条件対応

2. **フロントエンド機能実装**
   - クライアントサイドフィルタリング実装
   - エラーハンドリング強化
   - ローディング状態管理

3. **テスト実施**
   - モックサーバーでの単体テスト
   - 実APIとの統合テスト
   - E2Eテスト実施

### 中期
1. **パフォーマンス最適化**
   - 動画遅延読み込み
   - キャッシング戦略
   - バックグラウンドダウンロード

2. **UI/UX改善**
   - レスポンシブデザイン対応確認
   - アクセシビリティ向上
   - エラーメッセージの多言語対応

## 変更ファイル一覧

### データレイヤー
- `src/frontend/lib/features/history/data/repositories/incident_repository_impl.dart`
- `src/frontend/lib/features/history/data/repositories/video_repository_impl.dart`
- `src/frontend/lib/features/history/data/models/incident_dto.dart`
- `src/frontend/lib/features/history/data/models/action_dto.dart`
- `src/frontend/lib/features/history/data/models/video_dto.dart`

### ドメインレイヤー
変更なし（エンティティ定義は互換性を維持）

### プレゼンテーションレイヤー
変更なし（既存のBloc、Widget実装は引き続き使用可能）

## 参照ドキュメント
- API仕様書: `docusaurus/static/swagger/v2/microservice.yaml`
- 画面設計書: `docusaurus/docs/frontend/screen-design/history-screen.md`
- 実装計画: `docusaurus/docs/plan/issue-14/history-page-implementation-plan.md`

## 備考

### API仕様書の改善提案
1. ページネーション用のクエリパラメータ（limit, offset）の追加
2. カウントエンドポイントの追加
3. 詳細検索用のクエリパラメータ追加（roomNumber, staffId等）
4. レスポンス形式の統一（data wrapperの有無）

### セキュリティ考慮事項
- 動画ファイルへのアクセス制御
- 個人情報（見守り対象者名等）の適切な取り扱い
- エラーメッセージにおける情報漏洩防止

## 承認
- 実装者: [記入]
- レビュアー: [記入]
- 承認日: [記入]
