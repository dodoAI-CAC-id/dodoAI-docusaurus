---
id: phase6-organisms-implementation-plan
title: Phase 6 - Organisms Implementation Plan
---

![ステータス](https://img.shields.io/static/v1?label=ステータス&message=進行中&color=yellow)
![最終更新日](https://img.shields.io/static/v1?label=最終更新日&message=2025/10/31&color=blue)

# Phase 6: Presentation Layer - Organisms Implementation Plan

## 概要

Phase 6では、Atomic Designパターンに基づき、履歴画面の複合セクション（Organisms）を実装します。既存のMoleculesとAtomsを組み合わせて、ビジネスロジックを含む再利用可能なコンポーネントを構築します。

## 実装対象

### 1. HistoryTable Organism ✨

**目的**: 異常検知履歴の一覧表示

**使用するMolecules/Atoms**:
- `TableHeader` - テーブルヘッダー
- `HistoryTableRow` - テーブル行
- `Pagination` - ページネーション
- `LoadingIndicator` - ローディング表示
- `StatusBadge` - ステータスバッジ

**主要機能**:
- 履歴データの一覧表示
- ソート機能（列ヘッダークリック）
- チェックボックス選択（一括操作用）
- ページネーション
- ローディング状態表示
- エラー状態表示
- 空データ表示

**Props**:
```dart
class HistoryTable extends StatelessWidget {
  final List<Incident> incidents;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final Function(int page) onPageChanged;
  final Function(int pageSize) onPageSizeChanged;
  final Function(String videoId) onVideoPlay;
  final Function(String videoId) onVideoDownload;
  final Function(String columnId, SortOrder order) onSort;
  final Function(List<String> selectedIds) onSelectionChanged;
}
```

### 2. VideoPlayerModal Organism ✨

**目的**: 履歴動画の再生とダウンロード

**使用するMolecules/Atoms**:
- `AppButton` - 閉じる/ダウンロードボタン
- Flutter標準の`video_player` package

**主要機能**:
- 動画再生（play/pause/seek）
- 全画面表示切替
- ダウンロード機能
- エラーハンドリング
- ローディング表示

**Props**:
```dart
class VideoPlayerModal extends StatefulWidget {
  final String videoId;
  final String videoUrl;
  final Function() onClose;
  final Function() onDownload;
  final Function(String error)? onError;
}
```

### 3. SearchFormOrganism（オプション） 

**現状**: `SearchForm` moleculeが既に実装済み
**決定**: 
- SearchFormはそのまま使用
- 必要に応じてラッパーOrganismを作成
- 今回はmoleculeをそのまま使用

## 実装順序（TDD）

### Step 1: HistoryTable Organism

#### 1.1 テストファイル作成（RED）
```bash
test/features/history/presentation/organisms/history_table_test.dart
```

**テストケース**:
- ✅ 正常データ表示
- ✅ ローディング状態表示
- ✅ エラー状態表示
- ✅ 空データ表示
- ✅ ページネーション機能
- ✅ ページサイズ変更
- ✅ ソート機能
- ✅ チェックボックス選択
- ✅ 動画再生ボタン
- ✅ 動画ダウンロードボタン

#### 1.2 実装ファイル作成（GREEN）
```bash
lib/features/history/presentation/organisms/history_table.dart
```

#### 1.3 Widgetbookストーリー作成
```bash
lib/widgetbook/stories/organisms/history_table.stories.dart
```

### Step 2: VideoPlayerModal Organism

#### 2.1 テストファイル作成（RED）
```bash
test/features/history/presentation/organisms/video_player_modal_test.dart
```

**テストケース**:
- ✅ 初期状態表示
- ✅ 動画再生
- ✅ 一時停止
- ✅ シーク機能
- ✅ 全画面切替
- ✅ ダウンロードボタン
- ✅ 閉じるボタン
- ✅ エラーハンドリング
- ✅ ローディング表示

#### 2.2 実装ファイル作成（GREEN）
```bash
lib/features/history/presentation/organisms/video_player_modal.dart
```

#### 2.3 Widgetbookストーリー作成
```bash
lib/widgetbook/stories/organisms/video_player_modal.stories.dart
```

## ディレクトリ構造

```
src/frontend/
├── lib/
│   ├── features/
│   │   └── history/
│   │       └── presentation/
│   │           └── organisms/ (NEW)
│   │               ├── history_table.dart
│   │               └── video_player_modal.dart
│   └── widgetbook/
│       └── stories/
│           └── organisms/ (NEW)
│               ├── history_table.stories.dart
│               └── video_player_modal.stories.dart
└── test/
    └── features/
        └── history/
            └── presentation/
                └── organisms/ (NEW)
                    ├── history_table_test.dart
                    └── video_player_modal_test.dart
```

## 技術的考慮事項

### 1. データ変換

**Incident Entity → TableRow Data**:
```dart
Map<String, dynamic> _incidentToRowData(Incident incident) {
  return {
    'checkbox': false,
    'incidentId': incident.id,
    'date': _formatDate(incident.detectedAt),
    'time': _formatTime(incident.detectedAt),
    'roomBed': '${incident.roomNumber}/${incident.bedNumber}',
    'patientName': incident.residentName,
    'detectedAction': incident.detectionType,
    'staffName': incident.actions.isNotEmpty 
        ? incident.actions.first.performedBy 
        : '-',
    'actionType': incident.status,
    'startTime': incident.actions.isNotEmpty
        ? _formatTime(incident.actions.first.performedAt)
        : '-',
    'totalTime': _calculateTotalTime(incident.actions),
  };
}
```

### 2. ソート機能

```dart
enum SortOrder { ascending, descending, none }

void _handleSort(String columnId, SortOrder order) {
  List<Incident> sorted = List.from(incidents);
  
  switch (columnId) {
    case 'date':
      sorted.sort((a, b) => order == SortOrder.ascending
          ? a.detectedAt.compareTo(b.detectedAt)
          : b.detectedAt.compareTo(a.detectedAt));
      break;
    // ... other columns
  }
  
  onSort(columnId, order);
}
```

### 3. Video Player Package

**使用パッケージ**: `video_player: ^2.7.0`

```yaml
dependencies:
  video_player: ^2.7.0
  video_player_web: ^2.0.0  # Web対応
```

**初期化**:
```dart
late VideoPlayerController _controller;

@override
void initState() {
  super.initState();
  _controller = VideoPlayerController.network(widget.videoUrl)
    ..initialize().then((_) {
      setState(() {});
    });
}
```

### 4. レスポンシブ対応

```dart
// ブレークポイント
static const double tabletBreakpoint = 768.0;
static const double desktopBreakpoint = 1024.0;

// テーブルスクロール
Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < tabletBreakpoint) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _buildTable(),
        );
      }
      return _buildTable();
    },
  );
}
```

## テスト戦略

### Unit Tests

**HistoryTable**:
- Widget rendering tests
- Callback tests
- State management tests

**VideoPlayerModal**:
- Controller initialization tests
- Playback control tests
- Error handling tests

### Widget Tests

```dart
testWidgets('HistoryTable displays incidents correctly', (tester) async {
  final incidents = [
    Incident(
      id: '1',
      detectedAt: DateTime(2025, 1, 1, 10, 30),
      // ...
    ),
  ];

  await tester.pumpWidget(
    MaterialApp(
      home: HistoryTable(
        incidents: incidents,
        isLoading: false,
        // ...
      ),
    ),
  );

  expect(find.text('1'), findsOneWidget);
  expect(find.byType(HistoryTableRow), findsOneWidget);
});
```

## Widgetbook統合

### HistoryTable Stories

```dart
WidgetbookComponent(
  name: 'HistoryTable',
  useCases: [
    WidgetbookUseCase(
      name: 'With Data',
      builder: (_) => HistoryTable(
        incidents: _mockIncidents,
        isLoading: false,
        currentPage: 1,
        totalPages: 5,
        // ...
      ),
    ),
    WidgetbookUseCase(
      name: 'Loading',
      builder: (_) => HistoryTable(
        incidents: [],
        isLoading: true,
        // ...
      ),
    ),
    WidgetbookUseCase(
      name: 'Empty',
      builder: (_) => HistoryTable(
        incidents: [],
        isLoading: false,
        // ...
      ),
    ),
    WidgetbookUseCase(
      name: 'Error',
      builder: (_) => HistoryTable(
        incidents: [],
        isLoading: false,
        error: 'データの取得に失敗しました',
        // ...
      ),
    ),
  ],
);
```

## 品質基準

### コードカバレッジ
- **Target**: 80%以上
- **Critical Paths**: 100%

### Performance
- **初期描画**: < 100ms
- **ページ遷移**: < 50ms
- **ソート**: < 100ms

### Accessibility
- **セマンティクス**: すべてのインタラクティブ要素にラベル
- **キーボードナビゲーション**: 対応
- **スクリーンリーダー**: 対応

## リスクと対策

| リスク | 影響 | 対策 |
|-------|------|------|
| video_playerのWeb互換性 | 高 | video_player_webパッケージ使用 |
| 大量データのパフォーマンス | 中 | ページネーション、仮想スクロール検討 |
| レスポンシブ対応の複雑さ | 低 | LayoutBuilderで段階的対応 |

## 次のステップ

Phase 7では、BLoC（状態管理）の実装に進みます：
- HistoryBloc
- SearchBloc
- VideoPlayerBloc

## 変更履歴

| 日付 | 担当 | 変更内容 |
|------|------|---------|
| 2025/10/31 | Cline | Phase 6実装プラン作成 |
