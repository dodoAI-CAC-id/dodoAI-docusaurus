---
id: molecules-ui-component-library
title: Molecules UIコンポーネントライブラリ
---

# Molecules UIコンポーネントライブラリ

## 概要

Atomic Designに基づいて、複数のAtomsを組み合わせたUIコンポーネント（Molecules）を開発・管理します。
Flutter実装では、コンポーネントをWidgetBookに追加し、Unit Testの実装が必須です。

## Atomic Design - Molecules

Moleculesは、複数のAtomsを組み合わせて、より複雑な機能を持つコンポーネントです。

### 対象コンポーネント例

- **Search Box**: 入力フィールド + 検索ボタン
- **Form Field**: ラベル + 入力フィールド + エラーメッセージ
- **Card Header**: タイトル + アクションボタン
- **Navigation Item**: アイコン + テキストラベル
- **Alert**: アイコン + メッセージ + 閉じるボタン
- **Pagination**: 前へボタン + ページ番号 + 次へボタン
- **Rating**: 星アイコン × 5 + 評価テキスト
- **Tag**: ラベル + 削除ボタン

## 開発ガイドライン

### 1. コンポーネント設計原則

- **Atomsの組み合わせ**: 既存のAtomsコンポーネントを活用
- **機能的結合**: 関連する機能をまとめた意味のある単位
- **状態管理**: 内部状態を適切に管理
- **イベント処理**: 子コンポーネントからのイベントを統合

### 2. Flutter実装要件

#### WidgetBook統合
```dart
// WidgetBook登録例
@WidgetbookUseCase(name: 'Search Box', type: MoleculeSearchBox)
Widget searchBoxUseCase(BuildContext context) {
  return MoleculeSearchBox(
    placeholder: context.knobs.string(
      label: 'Placeholder', 
      initialValue: 'Search...'
    ),
    onSearch: (query) => print('Search: $query'),
    showClearButton: context.knobs.boolean(
      label: 'Show Clear Button', 
      initialValue: true
    ),
  );
}
```

#### Unit Test実装
```dart
// Unit Test例
group('MoleculeSearchBox', () {
  testWidgets('should display placeholder text', (WidgetTester tester) async {
    const placeholder = 'Search products...';
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MoleculeSearchBox(
            placeholder: placeholder,
            onSearch: (_) {},
          ),
        ),
      ),
    );
    
    expect(find.text(placeholder), findsOneWidget);
  });
  
  testWidgets('should call onSearch when search button is pressed', 
    (WidgetTester tester) async {
    String? searchQuery;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MoleculeSearchBox(
            onSearch: (query) => searchQuery = query,
          ),
        ),
      ),
    );
    
    await tester.enterText(find.byType(TextField), 'test query');
    await tester.tap(find.byIcon(Icons.search));
    
    expect(searchQuery, equals('test query'));
  });
  
  testWidgets('should clear input when clear button is pressed', 
    (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MoleculeSearchBox(
            onSearch: (_) {},
            showClearButton: true,
          ),
        ),
      ),
    );
    
    await tester.enterText(find.byType(TextField), 'test');
    await tester.tap(find.byIcon(Icons.clear));
    
    expect(find.text('test'), findsNothing);
  });
});
```

### 3. ディレクトリ構造

```
lib/
├── presentation/
│   ├── components/
│   │   ├── molecules/
│   │   │   ├── search_box/
│   │   │   │   ├── molecule_search_box.dart
│   │   │   │   └── molecule_search_box_test.dart
│   │   │   ├── form_field/
│   │   │   │   ├── molecule_form_field.dart
│   │   │   │   └── molecule_form_field_test.dart
│   │   │   └── ...
```

### 4. 実装パターン

#### 状態管理パターン
```dart
class MoleculeFormField extends StatefulWidget {
  final String label;
  final String? initialValue;
  final String? errorMessage;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  
  const MoleculeFormField({
    Key? key,
    required this.label,
    this.initialValue,
    this.errorMessage,
    this.onChanged,
    this.validator,
  }) : super(key: key);
  
  @override
  State<MoleculeFormField> createState() => _MoleculeFormFieldState();
}

class _MoleculeFormFieldState extends State<MoleculeFormField> {
  late TextEditingController _controller;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _errorMessage = widget.errorMessage;
  }
  
  void _validateInput(String value) {
    if (widget.validator != null) {
      setState(() {
        _errorMessage = widget.validator!(value);
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AtomLabel(text: widget.label),
        const SizedBox(height: 8),
        AtomInput(
          controller: _controller,
          onChanged: (value) {
            _validateInput(value);
            widget.onChanged?.call(value);
          },
          hasError: _errorMessage != null,
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 4),
          AtomErrorMessage(message: _errorMessage!),
        ],
      ],
    );
  }
}
```

### 5. 品質保証

#### 必須テスト項目
- **コンポーネント統合テスト**: Atomsとの適切な統合を確認
- **状態管理テスト**: 内部状態の変化が正しく処理されることを確認
- **イベント伝播テスト**: 子コンポーネントのイベントが適切に処理されることを確認
- **バリデーションテスト**: 入力検証が正しく動作することを確認

#### WidgetBook確認項目
- **インタラクション**: ユーザーインタラクションの動作確認
- **状態変化**: 各状態での表示確認
- **エラー状態**: エラー時の表示確認
- **レスポンシブ**: 異なる画面サイズでの動作確認

## 実装フロー

1. **要件定義**: 組み合わせるAtomsと機能要件の明確化
2. **設計**: コンポーネントAPIとプロパティの設計
3. **実装**: Flutterでのコンポーネント開発
4. **テスト**: Unit Testの作成・実行
5. **WidgetBook登録**: ストーリーブックへの登録
6. **統合テスト**: 他のコンポーネントとの統合確認
7. **ドキュメント**: 使用方法とAPIドキュメントの作成

## 重要な注意事項

- 既存のAtomsコンポーネントを最大限活用する
- 過度に複雑にならないよう適切な粒度を保つ
- すべてのMoleculesコンポーネントはUnit Testを実装する必要がある
- WidgetBookに登録して視覚的確認を可能にする
- パフォーマンスとメモリ使用量を考慮した実装を心がける
