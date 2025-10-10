---
id: organism-ui-component-library
title: Organism UIコンポーネントライブラリ
---

# Organism UIコンポーネントライブラリ

## 概要

Atomic Designに基づいて、複数のMoleculesとAtomsを組み合わせた複雑なUIコンポーネント（Organisms）を開発・管理します。
Flutter実装では、コンポーネントをWidgetBookに追加し、Unit Testの実装が必須です。

## Atomic Design - Organisms

Organismsは、複数のMoleculesとAtomsを組み合わせて作成される、独立した機能を持つ複雑なコンポーネントです。

### 対象コンポーネント例

- **ヘッダー**: ロゴ + ナビゲーション + ユーザーメニュー
- **商品カード**: 画像 + タイトル + 価格 + アクションボタン
- **コメントセクション**: コメントリスト + 投稿フォーム
- **データテーブル**: ヘッダー + データ行 + ページネーション
- **ショッピングカート**: 商品リスト + 合計金額 + チェックアウトボタン
- **ユーザープロフィール**: アバター + ユーザー情報 + アクションボタン
- **記事カード**: サムネイル + タイトル + 要約 + メタ情報
- **フィルターパネル**: 検索フィールド + フィルターオプション + リセットボタン

## 開発ガイドライン

### 1. コンポーネント設計原則

- **機能的独立性**: 独立して動作する自己完結型の機能単位
- **再利用性**: 異なるページで再利用できる汎用性
- **データ駆動**: プロパティによる柔軟な表示制御
- **ビジネスロジック分離**: 表示ロジックとビジネスロジックの分離

### 2. Flutter実装要件

#### WidgetBook統合
```dart
// WidgetBook登録例
@WidgetbookUseCase(name: 'Product Card', type: OrganismProductCard)
Widget productCardUseCase(BuildContext context) {
  return OrganismProductCard(
    product: Product(
      id: '1',
      name: context.knobs.string(label: 'Product Name', initialValue: 'Sample Product'),
      price: context.knobs.double.slider(
        label: 'Price',
        initialValue: 99.99,
        min: 0,
        max: 999,
      ),
      imageUrl: 'https://example.com/product.jpg',
      rating: context.knobs.double.slider(
        label: 'Rating',
        initialValue: 4.5,
        min: 0,
        max: 5,
      ),
    ),
    onAddToCart: () => print('Added to cart'),
    onFavorite: () => print('Added to favorites'),
  );
}
```

#### Unit Test実装
```dart
// Unit Test例
group('OrganismProductCard', () {
  late Product testProduct;
  
  setUp(() {
    testProduct = Product(
      id: '1',
      name: 'Test Product',
      price: 29.99,
      imageUrl: 'https://example.com/test.jpg',
      rating: 4.2,
    );
  });
  
  testWidgets('should display product information correctly', 
    (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OrganismProductCard(
            product: testProduct,
            onAddToCart: () {},
            onFavorite: () {},
          ),
        ),
      ),
    );
    
    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('\$29.99'), findsOneWidget);
    expect(find.text('4.2'), findsOneWidget);
  });
  
  testWidgets('should call onAddToCart when add to cart button is pressed', 
    (WidgetTester tester) async {
    bool addToCartCalled = false;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OrganismProductCard(
            product: testProduct,
            onAddToCart: () => addToCartCalled = true,
            onFavorite: () {},
          ),
        ),
      ),
    );
    
    await tester.tap(find.text('Add to Cart'));
    expect(addToCartCalled, isTrue);
  });
  
  testWidgets('should handle favorite toggle correctly', 
    (WidgetTester tester) async {
    bool favoriteToggled = false;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OrganismProductCard(
            product: testProduct,
            onAddToCart: () {},
            onFavorite: () => favoriteToggled = true,
            isFavorite: false,
          ),
        ),
      ),
    );
    
    await tester.tap(find.byIcon(Icons.favorite_border));
    expect(favoriteToggled, isTrue);
  });
});
```

### 3. ディレクトリ構造

```
lib/
├── presentation/
│   ├── components/
│   │   ├── organisms/
│   │   │   ├── product_card/
│   │   │   │   ├── organism_product_card.dart
│   │   │   │   └── organism_product_card_test.dart
│   │   │   ├── header/
│   │   │   │   ├── organism_header.dart
│   │   │   │   └── organism_header_test.dart
│   │   │   └── ...
```

### 4. 実装パターン

#### 複雑な状態管理パターン
```dart
class OrganismShoppingCart extends StatefulWidget {
  final List<CartItem> items;
  final VoidCallback? onCheckout;
  final ValueChanged<CartItem>? onItemRemove;
  final ValueChanged<CartItem>? onItemQuantityChange;
  
  const OrganismShoppingCart({
    Key? key,
    required this.items,
    this.onCheckout,
    this.onItemRemove,
    this.onItemQuantityChange,
  }) : super(key: key);
  
  @override
  State<OrganismShoppingCart> createState() => _OrganismShoppingCartState();
}

class _OrganismShoppingCartState extends State<OrganismShoppingCart> {
  late List<CartItem> _items;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
  }
  
  @override
  void didUpdateWidget(OrganismShoppingCart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      setState(() {
        _items = List.from(widget.items);
      });
    }
  }
  
  double get _totalAmount {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }
  
  void _handleItemRemove(CartItem item) {
    setState(() {
      _items.remove(item);
    });
    widget.onItemRemove?.call(item);
  }
  
  void _handleQuantityChange(CartItem item, int newQuantity) {
    setState(() {
      final index = _items.indexOf(item);
      if (index != -1) {
        _items[index] = item.copyWith(quantity: newQuantity);
      }
    });
    widget.onItemQuantityChange?.call(item.copyWith(quantity: newQuantity));
  }
  
  Future<void> _handleCheckout() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      widget.onCheckout?.call();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AtomText(
              'Shopping Cart (${_items.length} items)',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return MoleculeCartItem(
                    item: item,
                    onRemove: () => _handleItemRemove(item),
                    onQuantityChange: (quantity) => 
                        _handleQuantityChange(item, quantity),
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AtomText(
                  'Total: \$${_totalAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                AtomButton(
                  text: 'Checkout',
                  onPressed: _items.isEmpty || _isLoading ? null : _handleCheckout,
                  isLoading: _isLoading,
                  variant: ButtonVariant.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### 5. 品質保証

#### 必須テスト項目
- **機能統合テスト**: 複数のコンポーネントが正しく連携することを確認
- **状態管理テスト**: 複雑な状態変更が正しく処理されることを確認
- **データフローテスト**: プロパティからUIへのデータ反映が正しいことを確認
- **エラーハンドリングテスト**: エラーシナリオでの動作を確認
- **パフォーマンステスト**: 大量データでの動作を確認

#### WidgetBook確認項目
- **データバリエーション**: 異なるデータパターンでの表示確認
- **状態遷移**: 各状態での表示と動作確認
- **レスポンシブ**: 異なる画面サイズでの表示確認
- **アクセシビリティ**: スクリーンリーダー対応確認

## 実装フロー

1. **要件分析**: 機能要件とUIコンポーネント構成を分析
2. **設計**: データモデルとコンポーネントAPIを設計
3. **プロトタイプ**: 基本機能を実装・テスト
4. **実装**: 機能実装を完了
5. **テスト**: 包括的なUnit Testを作成・実行
6. **WidgetBook登録**: ストーリーブックに登録
7. **統合テスト**: 他のコンポーネントとの統合を確認
8. **パフォーマンス最適化**: 必要に応じて最適化
9. **ドキュメント**: 詳細な使用方法とAPIドキュメントを作成

## 重要な注意事項

- 既存のMoleculesとAtomsコンポーネントを最大限活用する
- 単一責任原則に従い、過度な複雑さを避ける
- すべてのOrganismsコンポーネントはUnit Testを実装する必要がある
- WidgetBookに登録して視覚的確認を可能にする
- パフォーマンスとメモリ使用量を重視して実装する
- アクセシビリティガイドラインに準拠する
- 国際化（i18n）サポートを考慮する
