---
id: phase2-molecules-plan
title: Phase2 Molecules実装計画
---

# Phase2: Molecules実装計画

## 目的
履歴画面で使用するMoleculesコンポーネントを実装し、Widgetbookで検証する。

## 実装対象コンポーネント

### 1. SearchForm（優先度：高）
**責務**: 検索条件入力フォーム全体を管理
**使用するAtoms**:
- AppTextField（部屋/ベッド番号、見守り対象者名、担当者）
- AppDropdown（操作、異常検出動作）
- DateRangePicker（後述）を内包

**Props**:
- onSearch: Function(SearchCriteria)
- initialValues: SearchCriteria?

### 2. DateRangePicker（優先度：高）
**責務**: 開始日と終了日の範囲選択
**使用するAtoms**:
- AppTextField（日付入力フィールド x 2）
- カレンダーアイコンボタン

**Props**:
- startDate: DateTime?
- endDate: DateTime?
- onStartDateChanged: Function(DateTime?)
- onEndDateChanged: Function(DateTime?)
- startLabel: String（デフォルト：'開始日'）
- endLabel: String（デフォルト：'終了日'）

### 3. TableHeader（優先度：高）
**責務**: テーブルのヘッダー行を表示
**使用するAtoms**:
- AppCheckbox（全選択用）
- Text（各カラムラベル）

**Props**:
- columns: List<TableColumn>
- onSelectAll: Function(bool)
- isAllSelected: bool

### 4. TableRow（優先度：高）
**責務**: テーブルのデータ行を表示
**使用するAtoms**:
- AppCheckbox（行選択用）
- StatusBadge（ステータス表示）
- AppIconButton（動画再生、ダウンロード、お気に入り、削除）

**Props**:
- data: IncidentData
- isSelected: bool
- onSelect: Function(bool)
- onPlayVideo: Function()
- onDownloadVideo: Function()
- onToggleFavorite: Function()
- onDelete: Function()

### 5. Pagination（優先度：中）
**責務**: ページネーション制御
**使用するAtoms**:
- AppButton（ページ番号ボタン、前へ/次へ）
- AppDropdown（表示件数選択）

**Props**:
- currentPage: int
- totalPages: int
- itemsPerPage: int
- totalItems: int
- onPageChanged: Function(int)
- onItemsPerPageChanged: Function(int)

### 6. AppHeader（優先度：中）
**責務**: アプリケーションヘッダー
**使用するAtoms**:
- AppButton（QRコード、ビュー、履歴、設定）
- ロゴ表示

**Props**:
- onQRCodeTap: Function()
- onViewTap: Function()
- onHistoryTap: Function()
- onSettingsTap: Function()
- currentRoute: String

### 7. ActionButtons（優先度：低）
**責務**: 検索とデータ削除のボタングループ
**使用するAtoms**:
- AppButton x 2（検索、データ削除）

**Props**:
- onSearch: Function()
- onDeleteData: Function()
- isSearchEnabled: bool
- isDeleteEnabled: bool

## 実装手順

### Step 1: DateRangePicker
1. ユニットテスト作成（TDD Red）
2. コンポーネント実装（TDD Green）
3. リファクタリング（TDD Refactor）
4. Widgetbookストーリー作成
5. 動作確認

### Step 2: SearchForm
1. ユニットテスト作成
2. コンポーネント実装
3. リファクタリング
4. Widgetbookストーリー作成
5. 動作確認

### Step 3: TableHeader & TableRow
1. TableHeaderのTDD実装
2. TableRowのTDD実装
3. Widgetbookストーリー作成
4. 動作確認

### Step 4: Pagination
1. ユニットテスト作成
2. コンポーネント実装
3. Widgetbookストーリー作成
4. 動作確認

### Step 5: AppHeader
1. ユニットテスト作成
2. コンポーネント実装
3. Widgetbookストーリー作成
4. 動作確認

### Step 6: ActionButtons
1. ユニットテスト作成
2. コンポーネント実装
3. Widgetbookストーリー作成
4. 動作確認

## ディレクトリ構造

```
src/frontend/
├── lib/
│   └── shared/
│       └── presentation/
│           └── components/
│               └── molecules/
│                   ├── date_range_picker.dart
│                   ├── search_form.dart
│                   ├── table_header.dart
│                   ├── table_row.dart
│                   ├── pagination.dart
│                   ├── app_header.dart
│                   └── action_buttons.dart
├── test/
│   └── shared/
│       └── presentation/
│           └── components/
│               └── molecules/
│                   ├── date_range_picker_test.dart
│                   ├── search_form_test.dart
│                   ├── table_header_test.dart
│                   ├── table_row_test.dart
│                   ├── pagination_test.dart
│                   ├── app_header_test.dart
│                   └── action_buttons_test.dart
└── lib/
    └── widgetbook/
        └── stories/
            └── molecules/
                ├── date_range_picker.stories.dart
                ├── search_form.stories.dart
                ├── table_header.stories.dart
                ├── table_row.stories.dart
                ├── pagination.stories.dart
                ├── app_header.stories.dart
                └── action_buttons.stories.dart
```

## 検証基準

各コンポーネントは以下を満たす必要があります：
1. ユニットテストが全てパス
2. Widgetbookで正常に表示
3. 各Propsが適切に機能
4. レスポンシブデザイン対応
5. アクセシビリティ対応

## 完了条件

- [ ] 全7つのMoleculesコンポーネントが実装済み
- [ ] 各コンポーネントのユニットテストが100%パス
- [ ] 各コンポーネントのWidgetbookストーリーが作成済み
- [ ] Widgetbookで全コンポーネントが正常表示
- [ ] 本ドキュメントの更新完了

## 備考

- Atomic Designの原則に従い、MoleculesはAtomsのみを使用する
- 各コンポーネントは独立してテスト可能であること
- 状態管理は親コンポーネントに委譲（Controlled Components）
- Material Design 3のガイドラインに準拠

## 変更履歴

| 日付 | 担当 | 変更内容 |
|------|------|----------|
| 2025/10/30 | AI | Phase2実装計画初版作成 |
