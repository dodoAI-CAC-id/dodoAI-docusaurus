---
id: phase3-domain-layer-completion
title: Phase 3 - Domain Layer 完了報告
---

![最終更新日](https://img.shields.io/static/v1?label=最終更新日&message=2025/10/31&color=green)

# Phase 3: Domain Layer - ビジネスロジック定義 完了報告

## 概要

Phase 3ではTDD（Test-Driven Development）アプローチに従い、履歴画面のドメイン層を実装しました。
すべてのエンティティとリポジトリインターフェースが完成し、外部依存のないピュアなDartコードとして実装されています。

## 実装内容

### 1. エンティティ実装（TDD - Red/Green フェーズ）

#### 1.1 Action（対応履歴）エンティティ

**ファイル**: `src/frontend/lib/features/history/domain/entities/action.dart`

**テストファイル**: `src/frontend/test/features/history/domain/entities/action_test.dart`

**プロパティ**:
- `id`: アクションID
- `incidentId`: 関連するインシデントID
- `performedAt`: 対応実施日時
- `performedBy`: 対応実施者
- `actionType`: 対応種別（確認、対応、完了、キャンセル、その他）
- `notes`: 備考・メモ（オプション）

**機能**:
- Equatableによる値の等価性比較
- copyWithメソッドによる不変性の保持
- 完全なテストカバレッジ

#### 1.2 Video（動画）エンティティ

**ファイル**: `src/frontend/lib/features/history/domain/entities/video.dart`

**テストファイル**: `src/frontend/test/features/history/domain/entities/video_test.dart`

**プロパティ**:
- `id`: 動画ID
- `incidentId`: 関連するインシデントID
- `fileName`: ファイル名
- `fileSize`: ファイルサイズ（バイト）
- `duration`: 動画の長さ（秒）
- `recordedAt`: 録画日時
- `url`: 動画URL
- `thumbnailUrl`: サムネイルURL（オプション）

**機能**:
- ファイルサイズの読みやすいフォーマット（`formattedFileSize`）
  - 例: 1024 → "1.00 KB", 1048576 → "1.00 MB"
- 動画の長さの読みやすいフォーマット（`formattedDuration`）
  - 例: 45 → "00:45", 185 → "03:05", 3725 → "1:02:05"
- Equatableによる値の等価性比較
- copyWithメソッドによる不変性の保持

#### 1.3 Incident（インシデント）エンティティ

**ファイル**: `src/frontend/lib/features/history/domain/entities/incident.dart`

**テストファイル**: `src/frontend/test/features/history/domain/entities/incident_test.dart`

**プロパティ**:
- `id`: インシデントID
- `incidentId`: インシデント番号（表示用）
- `detectedAt`: 検知日時
- `roomNumber`: 部屋番号
- `bedNumber`: ベッド番号
- `residentName`: 見守り対象者名
- `detectionType`: 異常検出動作（転倒検知、離床検知など）
- `status`: ステータス（`IncidentStatus` enum）
- `actions`: 対応履歴リスト（`List<Action>`）
- `videoId`: 関連動画ID（オプション）

**IncidentStatus enum**:
- `detected`: 検知済み
- `confirmed`: 確認済み
- `inProgress`: 対応中
- `resolved`: 解決済み

**機能**:
- 複数の対応履歴を保持
- Equatableによる値の等価性比較
- copyWithメソッドによる不変性の保持

### 2. リポジトリインターフェース定義

#### 2.1 IIncidentRepository

**ファイル**: `src/frontend/lib/features/history/domain/repositories/i_incident_repository.dart`

**メソッド**:
- `fetchIncidents()`: インシデント一覧を取得（ページネーション対応）
- `fetchIncidentById()`: IDでインシデントを取得
- `searchIncidents()`: 検索条件でインシデントを検索
- `countIncidents()`: インシデントの総件数を取得
- `countSearchResults()`: 検索結果の総件数を取得

**検索条件**:
- 発生日（開始日・終了日）
- 部屋番号
- ベッド番号
- 見守り対象者名
- 担当者
- 異常検出動作
- ステータス

#### 2.2 IVideoRepository

**ファイル**: `src/frontend/lib/features/history/domain/repositories/i_video_repository.dart`

**メソッド**:
- `fetchVideoById()`: IDで動画を取得
- `fetchVideoByIncidentId()`: インシデントIDで関連動画を取得
- `downloadVideo()`: 動画ファイルをダウンロード（進捗コールバック付き）
- `getStreamingUrl()`: ストリーミング用URLを取得
- `videoExists()`: 動画の存在確認

## ディレクトリ構造

```
src/frontend/lib/features/history/domain/
├── entities/
│   ├── action.dart           # 対応履歴エンティティ
│   ├── incident.dart         # インシデントエンティティ
│   └── video.dart            # 動画エンティティ
└── repositories/
    ├── i_incident_repository.dart   # インシデントリポジトリインターフェース
    └── i_video_repository.dart      # 動画リポジトリインターフェース

src/frontend/test/features/history/domain/
└── entities/
    ├── action_test.dart      # Actionエンティティのテスト
    ├── incident_test.dart    # Incidentエンティティのテスト
    └── video_test.dart       # Videoエンティティのテスト
```

## テストカバレッジ

### Action Entity Tests
- ✅ 基本的なプロパティの作成
- ✅ notesがnullの場合の処理
- ✅ 等価性比較
- ✅ copyWithによる不変性
- ✅ 異なるactionTypeの処理
- ✅ 複数のcopyWith操作での不変性保持

### Video Entity Tests
- ✅ 基本的なプロパティの作成
- ✅ 等価性比較
- ✅ copyWithによる不変性
- ✅ ファイルサイズのフォーマット（KB, MB, GB）
- ✅ 動画の長さのフォーマット（秒、分、時間）
- ✅ サムネイルURLの処理（オプション）
- ✅ 複数のcopyWith操作での不変性保持

### Incident Entity Tests
- ✅ 基本的なプロパティの作成
- ✅ 対応履歴リストを含む作成
- ✅ 等価性比較
- ✅ copyWithによる不変性
- ✅ videoIdの処理（オプション）
- ✅ IncidentStatus enumの検証

## TDDアプローチの適用

本フェーズでは、厳密なTDDアプローチを適用しました：

1. **Red（失敗するテスト）**: 各エンティティのテストを先に作成
2. **Green（最小実装）**: テストをパスする最小限のコードを実装
3. **Refactor（改善）**: コードの品質を向上（不要なコード削除、命名改善など）

このアプローチにより：
- バグの早期発見
- 設計の明確化
- リファクタリングの安全性確保
- ドキュメントとしてのテスト

## 技術的な特徴

### 1. Equatableパッケージの活用
- 値の等価性比較を自動化
- hashCodeの自動生成
- デバッグ時の可読性向上（`stringify: true`）

### 2. 不変性（Immutability）
- すべてのフィールドを`final`で宣言
- `copyWith`メソッドで変更が必要な場合に新しいインスタンスを生成
- 予期しない状態変更を防止

### 3. ドメイン駆動設計（DDD）の原則
- エンティティは外部依存を持たない
- ビジネスロジックをドメイン層に集約
- リポジトリインターフェースで外部システムを抽象化

### 4. 型安全性
- enum（`IncidentStatus`）でステータスを型安全に管理
- null安全性（`String?`）で明示的なオプショナル値

## 次のステップ（Phase 4）

Phase 4では、Infrastructure層を実装します：

1. **リポジトリ実装**
   - `IncidentRepositoryImpl`
   - `VideoRepositoryImpl`

2. **API統合**
   - Dioクライアント設定
   - エラーハンドリング
   - レスポンスマッピング

3. **DTOとマッピング**
   - `IncidentDTO`, `ActionDTO`, `VideoDTO`
   - DTO → Entity マッピング関数

4. **テスト**
   - Mockサーバーを使用したリポジトリテスト
   - エラーケースのテスト

## 成果物

- ✅ 3つのエンティティ（Incident, Action, Video）
- ✅ 2つのリポジトリインターフェース
- ✅ 完全なユニットテストスイート
- ✅ 外部依存のないピュアなDartコード
- ✅ TDDアプローチによる高品質な実装

## 変更履歴

| 日付 | 担当 | 変更内容 |
|------|------|---------|
| 2025/10/31 | Cline | Phase 3 完了 - Domain Layer実装 |
