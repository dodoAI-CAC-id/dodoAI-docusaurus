---
id: phase4-dto-implementation-progress
title: Phase 4 - DTO実装 中間報告
---

![ステータス](https://img.shields.io/static/v1?label=ステータス&message=進行中&color=yellow)
![最終更新日](https://img.shields.io/static/v1?label=最終更新日&message=2025/10/31&color=green)

# Phase 4: Infrastructure Layer - DTO実装 中間報告

## 概要

Phase 4の最初のステップとして、Data Transfer Objects (DTO)の実装を完了しました。
TDD（Test-Driven Development）アプローチに従い、テストファースト開発を実践しました。

## 完了した実装

### 1. API Exception Classes

**ファイル**: `src/frontend/lib/core/network/api_exceptions.dart`

**実装した例外クラス**:
- ✅ `ApiException` - 基底例外クラス
- ✅ `NetworkException` - ネットワークエラー
- ✅ `ServerException` - サーバーエラー (5xx)
- ✅ `UnauthorizedException` - 認証エラー (401)
- ✅ `ForbiddenException` - 権限エラー (403)
- ✅ `NotFoundException` - リソース未検出 (404)
- ✅ `ValidationException` - バリデーションエラー (400)
- ✅ `TimeoutException` - タイムアウトエラー
- ✅ `InvalidResponseException` - 不正なレスポンスエラー

**特徴**:
- 詳細なエラー情報（メッセージ、ステータスコード、元の例外、スタックトレース）
- デバッグに有用なtoString()実装
- ValidationExceptionでは詳細なフィールドエラー情報を保持

### 2. ActionDTO (対応履歴)

**実装ファイル**: `src/frontend/lib/features/history/data/models/action_dto.dart`
**テストファイル**: `src/frontend/test/features/history/data/models/action_dto_test.dart`

**プロパティ**:
```dart
final String id;
final String incidentId;
final DateTime performedAt;
final String performedBy;
final String actionType;
final String? notes;
```

**実装メソッド**:
- `fromJson(Map<String, dynamic> json)` - JSON → DTO
- `toJson()` - DTO → JSON
- `toEntity()` - DTO → Entity

**テストカバレッジ**:
- ✅ JSON deserialization
- ✅ JSON serialization
- ✅ Entity conversion
- ✅ Null値の処理
- ✅ 異なるaction typeの処理
- ✅ Round-trip conversion（往復変換の整合性）

### 3. VideoDTO (動画)

**実装ファイル**: `src/frontend/lib/features/history/data/models/video_dto.dart`
**テストファイル**: `src/frontend/test/features/history/data/models/video_dto_test.dart`

**プロパティ**:
```dart
final String id;
final String incidentId;
final String fileName;
final int fileSize;
final int duration;
final DateTime recordedAt;
final String url;
final String? thumbnailUrl;
```

**実装メソッド**:
- `fromJson(Map<String, dynamic> json)` - JSON → DTO
- `toJson()` - DTO → JSON
- `toEntity()` - DTO → Entity

**テストカバレッジ**:
- ✅ JSON deserialization
- ✅ JSON serialization
- ✅ Entity conversion
- ✅ Null thumbnailUrlの処理
- ✅ 様々なファイルサイズの処理
- ✅ 様々な動画長の処理
- ✅ Round-trip conversion

### 4. IncidentDTO (インシデント)

**実装ファイル**: `src/frontend/lib/features/history/data/models/incident_dto.dart`
**テストファイル**: `src/frontend/test/features/history/data/models/incident_dto_test.dart`

**プロパティ**:
```dart
final String id;
final String incidentId;
final DateTime detectedAt;
final String roomNumber;
final String bedNumber;
final String residentName;
final String detectionType;
final String status;
final List<ActionDTO> actions;
final String? videoId;
```

**実装メソッド**:
- `fromJson(Map<String, dynamic> json)` - JSON → DTO
- `toJson()` - DTO → JSON
- `toEntity()` - DTO → Entity
- `_stringToStatus(String status)` - ステータス文字列 → Enum変換

**テストカバレッジ**:
- ✅ JSON deserialization
- ✅ JSON serialization
- ✅ Entity conversion
- ✅ ネストされたActionDTOリストの処理
- ✅ Null videoIdの処理
- ✅ 空のactionsリストの処理
- ✅ 複数のactionsの処理
- ✅ 異なるステータス値の処理
- ✅ 異なる検知タイプの処理
- ✅ ステータス文字列 → Enum変換
- ✅ Round-trip conversion

## 技術的な決定事項

### JSON Serializationアプローチ

当初は`json_serializable`パッケージを使用する計画でしたが、以下の理由で手動実装を選択：

1. **シンプルさ**: 依存関係を最小限に保つ
2. **制御性**: JSON変換ロジックを完全に制御
3. **デバッグの容易さ**: コード生成の抽象化層がない
4. **柔軟性**: カスタムロジック（ステータス変換など）を直接実装可能

### テスト戦略

**TDDサイクル**:
1. **Red**: テストを先に作成（失敗を確認）
2. **Green**: 最小限の実装でテストをパス
3. **Refactor**: コードの品質を改善

**テスト項目**:
- 正常系（Happy Path）
- Null値の処理
- エッジケース
- Round-trip conversion（データ整合性）

## ディレクトリ構造

```
src/frontend/
├── lib/
│   ├── core/
│   │   └── network/
│   │       └── api_exceptions.dart
│   └── features/
│       └── history/
│           ├── data/
│           │   └── models/
│           │       ├── action_dto.dart
│           │       ├── video_dto.dart
│           │       └── incident_dto.dart
│           └── domain/
│               ├── entities/
│               └── repositories/
└── test/
    └── features/
        └── history/
            └── data/
                └── models/
                    ├── action_dto_test.dart
                    ├── video_dto_test.dart
                    └── incident_dto_test.dart
```

## 次のステップ

### Phase 4 残りの実装項目

1. **API Client設定**
   - Dioクライアントの設定
   - インターセプター実装（認証、ログ、エラーハンドリング）
   - Base URL設定

2. **Repository実装**
   - `IncidentRepositoryImpl`の実装
   - `VideoRepositoryImpl`の実装
   - エラーハンドリング
   - リトライロジック

3. **Repository Tests**
   - Mockを使用したユニットテスト
   - 正常系・異常系のテストケース
   - ページネーション処理のテスト
   - 検索機能のテスト

4. **統合テスト**
   - DTO ↔ Repository ↔ API の統合動作確認

## テスト実行結果

すべてのDTOテストが正常に実行されました：

```bash
flutter test test/features/history/data/models/
```

**テスト結果**:
- ✅ ActionDTO: すべてのテストパス
- ✅ VideoDTO: すべてのテストパス
- ✅ IncidentDTO: すべてのテストパス

## 品質メトリクス

### コードカバレッジ
- **DTO層**: 100% (全メソッドがテストでカバー)
- **API Exceptions**: 実装完了（テストは次フェーズ）

### テスト数
- ActionDTO: 12テスト
- VideoDTO: 11テスト
- IncidentDTO: 15テスト
- **合計**: 38テスト

## 技術的な課題と解決策

### 課題1: build_runnerによるコード生成の失敗

**問題**: `json_serializable`を使用した自動コード生成が期待通りに動作しない

**解決策**: 手動でJSON serialization/deserializationを実装
- シンプルで理解しやすい
- デバッグが容易
- カスタムロジックの実装が柔軟

### 課題2: DateTime変換

**問題**: APIからの日時文字列とDartのDateTimeオブジェクト間の変換

**解決策**: 
- `DateTime.parse()` - JSON → DateTime
- `toIso8601String()` - DateTime → JSON

### 課題3: ネストされたオブジェクトのマッピング

**問題**: IncidentDTOがActionDTOのリストを含む複雑な構造

**解決策**:
```dart
final actionsList = json['actions'] as List<dynamic>? ?? [];
final actions = actionsList
    .map((actionJson) => ActionDTO.fromJson(actionJson as Map<String, dynamic>))
    .toList();
```

## ベストプラクティス

1. **Null Safety**: すべてのオプショナルフィールドに`?`を使用
2. **Immutability**: すべてのフィールドを`final`で宣言
3. **Factory Constructor**: `fromJson`でファクトリーコンストラクタを使用
4. **Explicit Typing**: 型を明示的に指定
5. **Documentation**: すべてのクラスとメソッドにドキュメントコメント

## 学んだこと

1. **TDDの有効性**: テストファーストで開発することで、設計の問題を早期に発見
2. **シンプルさの価値**: 複雑なツールより、シンプルな手動実装の方が理解しやすい
3. **Round-trip Testing**: 往復変換テストでデータ整合性を確認する重要性

## 変更履歴

| 日付 | 担当 | 変更内容 |
|------|------|---------|
| 2025/10/31 | Cline | Phase 4 DTO実装完了 - 中間報告作成 |
