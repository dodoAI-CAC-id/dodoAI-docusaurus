# Widgetbook - UIコンポーネントカタログ

## 概要

このWidgetbookは、プロジェクトで使用するUIコンポーネントを視覚的に確認・テストするためのカタログです。

## 起動方法

### 開発環境で起動

```bash
cd src/frontend
flutter run -t widgetbook/main.dart -d chrome
```

または、ポート指定で起動：

```bash
flutter run -t widgetbook/main.dart -d chrome --web-port=8080
```

### ビルド

```bash
flutter build web -t widgetbook/main.dart
```

## 構成

### Atoms（基本UIパーツ）

- **AppButton**: 汎用ボタンコンポーネント
  - Primary（プライマリ）
  - Secondary（セカンダリ）
  - Danger（危険）
  - Loading（ローディング状態）
  - Disabled（無効状態）

- **AppTextField**: テキスト入力フィールド
  - Default（デフォルト）
  - With Prefix Icon（プレフィックスアイコン付き）
  - With Suffix Icon（サフィックスアイコン付き）
  - With Error（エラー表示）
  - Disabled（無効状態）
  - Multiline（複数行）

- **AppCheckbox**: チェックボックス（予定）
- **AppDropdown**: ドロップダウンメニュー（予定）
- **AppDatePicker**: 日付選択（予定）
- **AppIconButton**: アイコンボタン（予定）
- **AppText**: スタイル付きテキスト（予定）

### Molecules（複合UIパーツ）

- **IncidentListRow**: 履歴行（予定）
- **DateRangePicker**: 期間選択（予定）
- **SearchCriteriaInput**: 検索条件入力（予定）
- **VideoPlayerDialog**: 動画再生ダイアログ（予定）

### Organisms（セクション）

- **IncidentSearchBar**: 検索バー（予定）
- **IncidentListTable**: 履歴テーブル（予定）
- **PaginationControls**: ページネーション（予定）

## 使い方

### 1. コンポーネントの確認

左サイドバーから確認したいコンポーネントを選択します。

### 2. テーマの切り替え

上部のテーマセレクターで Light/Dark テーマを切り替えられます。

### 3. デバイスフレームの切り替え

デバイスフレームアドオンで、異なるデバイスでの表示を確認できます：
- iPhone 13
- Samsung Galaxy S20
- MacBook Pro

## 新しいコンポーネントの追加方法

### 1. コンポーネントを実装

```dart
// lib/shared/presentation/components/atoms/new_component.dart
class NewComponent extends StatelessWidget {
  // 実装
}
```

### 2. Widgetbookに登録

```dart
// widgetbook/main.dart
WidgetbookComponent(
  name: 'NewComponent',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => NewComponent(),
    ),
  ],
),
```

### 3. 動作確認

Widgetbookを起動して、新しいコンポーネントが表示されることを確認します。

## トラブルシューティング

### Widgetbookが起動しない

```bash
# 依存関係を再インストール
flutter pub get

# キャッシュをクリア
flutter clean
flutter pub get
```

### コンポーネントが表示されない

- インポートパスが正しいか確認
- コンポーネントが正しくエクスポートされているか確認
- Widgetbookの登録コードが正しいか確認

## 参考リンク

- [Widgetbook公式ドキュメント](https://docs.widgetbook.io/)
- [Flutter公式ドキュメント](https://flutter.dev/docs)
- [Atomic Design](https://bradfrost.com/blog/post/atomic-web-design/)
