---
id: atoms-ui-component-library
title: Atoms UIコンポーネントライブラリ
---

# Atoms UIコンポーネントライブラリ

## 概要

Atomic Designに基づいて、最小単位のUIコンポーネント（Atoms）を開発・管理します。
Flutter実装では、コンポーネントをWidgetBookに追加し、Unit Testの実装が必須です。

## Atomic Design - Atoms

Atomsは、これ以上小さな要素に分解できない最も基本的なUIコンポーネントです。

### 対象コンポーネント例

- **Button**: 基本ボタンコンポーネント
- **Input**: テキスト入力フィールド
- **Label**: テキストラベル
- **Icon**: アイコンコンポーネント
- **Image**: 画像表示コンポーネント
- **Divider**: 区切り線
- **Checkbox**: チェックボックス
- **Radio Button**: ラジオボタン
- **Switch**: スイッチ/トグル

## 開発ガイドライン

### 1. コンポーネント設計原則

- **単一責任**: 各コンポーネントは一つの機能のみを持つ
- **再利用性**: 様々なコンテキストで再利用できる汎用的な設計
- **一貫性**: デザインシステムに準拠したスタイリング
- **アクセシビリティ**: 適切なセマンティクスとアクセシビリティサポート

### 2. Flutter実装要件

#### WidgetBook統合
```dart
// WidgetBook登録例
@WidgetbookUseCase(name: 'Primary Button', type: AtomButton)
Widget primaryButtonUseCase(BuildContext context) {
  return AtomButton(
    text: context.knobs.string(label: 'Text', initialValue: 'Button'),
    onPressed: () {},
    variant: ButtonVariant.primary,
  );
}
```

#### Unit Test実装
```dart
// Unit Test例
group('AtomButton', () {
  testWidgets('should display text correctly', (WidgetTester tester) async {
    const buttonText = 'Test Button';
    
    await tester.pumpWidget(
      MaterialApp(
        home: AtomButton(
          text: buttonText,
          onPressed: () {},
        ),
      ),
    );
    
    expect(find.text(buttonText), findsOneWidget);
  });
  
  testWidgets('should call onPressed when tapped', (WidgetTester tester) async {
    bool wasPressed = false;
    
    await tester.pumpWidget(
      MaterialApp(
        home: AtomButton(
          text: 'Test',
          onPressed: () => wasPressed = true,
        ),
      ),
    );
    
    await tester.tap(find.byType(AtomButton));
    expect(wasPressed, isTrue);
  });
});
```

### 3. ディレクトリ構造

```
lib/
├── presentation/
│   ├── components/
│   │   ├── atoms/
│   │   │   ├── button/
│   │   │   │   ├── atom_button.dart
│   │   │   │   └── atom_button_test.dart
│   │   │   ├── input/
│   │   │   │   ├── atom_input.dart
│   │   │   │   └── atom_input_test.dart
│   │   │   └── ...
```

### 4. 品質保証

#### 必須テスト項目
- **表示テスト**: コンポーネントが正しく描画されることを確認
- **インタラクションテスト**: ユーザーインタラクションが正しく動作することを確認
- **プロパティテスト**: 各プロパティが正しく反映されることを確認
- **エラーハンドリングテスト**: 不正な値での動作を確認

#### WidgetBook確認項目
- **全バリエーション**: すべてのスタイルバリエーションの表示確認
- **レスポンシブ**: 異なる画面サイズでの表示確認
- **状態変化**: 有効/無効、選択/非選択などの状態確認

## 実装フロー

1. **設計**: デザインシステムに基づいたコンポーネント仕様の定義
2. **実装**: Flutterでのコンポーネント開発
3. **テスト**: Unit Testの作成・実行
4. **WidgetBook登録**: ストーリーブックへの登録
5. **レビュー**: コードレビューと品質確認
6. **ドキュメント**: 使用方法とAPIドキュメントの作成

## 重要な注意事項

- すべてのAtomsコンポーネントはUnit Testを実装する必要がある
- WidgetBookに登録して視覚的確認を可能にする
- デザインシステムとの一貫性を常に確認する
- パフォーマンスを考慮した実装を心がける
