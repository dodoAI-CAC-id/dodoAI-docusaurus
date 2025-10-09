---
id: pages-ui-component-library
title: Pages UIコンポーネントライブラリ
---

# Pages UIコンポーネントライブラリ

## 概要

Atomic Designに基づいて、複数のOrganisms、Molecules、Atomsを組み合わせた完全なページレベルのUIコンポーネント（Pages）を開発・管理します。
Flutter実装では、コンポーネントをWidgetBookに追加し、Unit Testの実装が必須です。

## Atomic Design - Pages

Pagesは完全なページや画面を構成する最高レベルのコンポーネントです。複数のOrganismsを組み合わせて、特定のユーザージャーニーとビジネス機能を実現します。

### 対象コンポーネント例

- **ホームページ**: ヘッダー + ヒーローセクション + 商品リスト + フッター
- **商品詳細ページ**: ヘッダー + 商品詳細 + レビューセクション + 関連商品
- **ログインページ**: ログインフォーム + ソーシャルログイン + パスワードリセット
- **ダッシュボードページ**: サイドバー + メインコンテンツ + 統計ウィジェット
- **プロフィールページ**: ユーザー情報 + 設定パネル + アクティビティ履歴
- **チェックアウトページ**: 注文確認 + 支払い方法 + 配送情報
- **検索結果ページ**: 検索フィルター + 結果リスト + ページネーション

## 開発ガイドライン

### 1. コンポーネント設計原則

- **ユーザージャーニー**: 特定のユーザータスクを完了
- **レイアウト管理**: 画面全体のレイアウトとナビゲーション
- **状態管理**: ページレベルの状態とデータフロー
- **ルーティング**: ページ遷移とパラメータ管理

### 2. Flutter実装要件

#### WidgetBook統合
```dart
// WidgetBook登録例
@WidgetbookUseCase(name: 'Product Detail Page', type: PageProductDetail)
Widget productDetailPageUseCase(BuildContext context) {
  return PageProductDetail(
    productId: context.knobs.string(
      label: 'Product ID', 
      initialValue: 'sample-product-123'
    ),
    initialData: Product(
      id: 'sample-product-123',
      name: context.knobs.string(
        label: 'Product Name', 
        initialValue: 'Sample Product'
      ),
      price: context.knobs.double.slider(
        label: 'Price',
        initialValue: 199.99,
        min: 0,
        max: 999,
      ),
      description: context.knobs.string(
        label: 'Description',
        initialValue: 'This is a sample product description...'
      ),
    ),
  );
}
```

#### Unit Test実装
```dart
// Unit Test例
group('PageProductDetail', () {
  late MockProductRepository mockRepository;
  late Product testProduct;
  
  setUp(() {
    mockRepository = MockProductRepository();
    testProduct = Product(
      id: 'test-product-1',
      name: 'Test Product',
      price: 99.99,
      description: 'Test description',
      imageUrls: ['https://example.com/image1.jpg'],
      rating: 4.5,
      reviewCount: 123,
    );
  });
  
  testWidgets('should display product information when loaded', 
    (WidgetTester tester) async {
    when(mockRepository.getProduct('test-product-1'))
        .thenAnswer((_) async => testProduct);
    
    await tester.pumpWidget(
      MaterialApp(
        home: PageProductDetail(
          productId: 'test-product-1',
          repository: mockRepository,
        ),
      ),
    );
    
    // 非同期操作を待機
    await tester.pumpAndSettle();
    
    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('\$99.99'), findsOneWidget);
    expect(find.text('Test description'), findsOneWidget);
  });
  
  testWidgets('should show loading state initially', 
    (WidgetTester tester) async {
    when(mockRepository.getProduct(any))
        .thenAnswer((_) async => Future.delayed(
          const Duration(seconds: 1), 
          () => testProduct
        ));
    
    await tester.pumpWidget(
      MaterialApp(
        home: PageProductDetail(
          productId: 'test-product-1',
          repository: mockRepository,
        ),
      ),
    );
    
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  
  testWidgets('should handle add to cart action', 
    (WidgetTester tester) async {
    when(mockRepository.getProduct('test-product-1'))
        .thenAnswer((_) async => testProduct);
    
    bool addToCartCalled = false;
    
    await tester.pumpWidget(
      MaterialApp(
        home: PageProductDetail(
          productId: 'test-product-1',
          repository: mockRepository,
          onAddToCart: (product) => addToCartCalled = true,
        ),
      ),
    );
    
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add to Cart'));
    
    expect(addToCartCalled, isTrue);
  });
  
  testWidgets('should navigate to reviews when review section is tapped', 
    (WidgetTester tester) async {
    when(mockRepository.getProduct('test-product-1'))
        .thenAnswer((_) async => testProduct);
    
    await tester.pumpWidget(
      MaterialApp(
        home: PageProductDetail(
          productId: 'test-product-1',
          repository: mockRepository,
        ),
      ),
    );
    
    await tester.pumpAndSettle();
    await tester.tap(find.text('View All Reviews'));
    
    // ナビゲーションが発生したことを確認
    expect(find.byType(PageProductReviews), findsOneWidget);
  });
});
```

### 3. ディレクトリ構造

```
lib/
├── presentation/
│   ├── pages/
│   │   ├── home/
│   │   │   ├── page_home.dart
│   │   │   └── page_home_test.dart
│   │   ├── product/
│   │   │   ├── page_product_detail.dart
│   │   │   ├── page_product_detail_test.dart
│   │   │   ├── page_product_list.dart
│   │   │   └── page_product_list_test.dart
│   │   ├── auth/
│   │   │   ├── page_login.dart
│   │   │   ├── page_login_test.dart
│   │   │   ├── page_register.dart
│   │   │   └── page_register_test.dart
│   │   └── ...
```

### 4. 実装パターン

#### ページレベル状態管理パターン
```dart
class PageProductDetail extends StatefulWidget {
  final String productId;
  final Product? initialData;
  final ProductRepository? repository;
  final ValueChanged<Product>? onAddToCart;
  
  const PageProductDetail({
    Key? key,
    required this.productId,
    this.initialData,
    this.repository,
    this.onAddToCart,
  }) : super(key: key);
  
  @override
  State<PageProductDetail> createState() => _PageProductDetailState();
}

class _PageProductDetailState extends State<PageProductDetail> {
  late final ProductRepository _repository;
  Product? _product;
  List<Review> _reviews = [];
  bool _isLoading = true;
  bool _isAddingToCart = false;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? GetIt.instance<ProductRepository>();
    _product = widget.initialData;
    _loadProductData();
  }
  
  Future<void> _loadProductData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      final futures = await Future.wait([
        if (_product == null) _repository.getProduct(widget.productId),
        _repository.getProductReviews(widget.productId, limit: 5),
      ]);
      
      setState(() {
        if (_product == null) _product = futures[0] as Product;
        _reviews = futures[1] as List<Review>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }
  
  Future<void> _handleAddToCart() async {
    if (_product == null) return;
    
    try {
      setState(() {
        _isAddingToCart = true;
      });
      
      await _repository.addToCart(_product!);
      widget.onAddToCart?.call(_product!);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('カートに追加されました')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('カートへの追加に失敗しました: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAddingToCart = false;
        });
      }
    }
  }
  
  void _navigateToReviews() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PageProductReviews(productId: widget.productId),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrganismAppBar(
        title: _product?.name ?? '商品詳細',
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareProduct(),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _product != null
          ? OrganismBottomActionBar(
              primaryAction: BottomAction(
                text: 'カートに追加',
                onPressed: _isAddingToCart ? null : _handleAddToCart,
                isLoading: _isAddingToCart,
              ),
              secondaryAction: BottomAction(
                text: '今すぐ購入',
                onPressed: () => _navigateToCheckout(),
                variant: ActionVariant.outline,
              ),
            )
          : null,
    );
  }
  
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_errorMessage != null) {
      return OrganismErrorState(
        message: _errorMessage!,
        onRetry: _loadProductData,
      );
    }
    
    if (_product == null) {
      return const OrganismEmptyState(
        message: '商品が見つかりません',
      );
    }
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrganismProductImageGallery(
            imageUrls: _product!.imageUrls,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrganismProductInfo(product: _product!),
                const SizedBox(height: 24),
                OrganismProductDescription(
                  description: _product!.description,
                ),
                const SizedBox(height: 24),
                OrganismReviewSummary(
                  reviews: _reviews,
                  totalReviews: _product!.reviewCount,
                  onViewAll: _navigateToReviews,
                ),
                const SizedBox(height: 24),
                OrganismRelatedProducts(
                  productId: _product!.id,
                  onProductTap: (product) => _navigateToProduct(product.id),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### 5. 品質保証

#### 必須テスト項目
- **ページ統合テスト**: すべてのコンポーネントが正しく連携することを確認
- **ナビゲーションテスト**: ページ遷移が正しく動作することを確認
- **データ読み込みテスト**: 非同期データ取得が正しく処理されることを確認
- **エラーハンドリングテスト**: 様々なエラー状態での動作確認
- **ユーザーインタラクションテスト**: 主要なユーザー操作の動作確認
- **状態管理テスト**: ページレベルの状態変化が正しく処理されることを確認

#### WidgetBook確認項目
- **データ状態**: ローディング、成功、エラー状態の表示確認
- **レスポンシブ**: 異なる画面サイズでの表示確認
- **アクセシビリティ**: スクリーンリーダー対応確認
- **パフォーマンス**: 大量データ操作の確認

## 実装フロー

1. **ユーザージャーニー分析**: ページの目的とユーザーフローの明確化
2. **ワイヤーフレーム**: ページレイアウトとコンポーネント構造の設計
3. **データモデル設計**: 必要なデータ構造とAPI設計
4. **プロトタイプ**: 基本的なページ構造の実装
5. **コンポーネント統合**: OrganismsとMoleculesの組み合わせ
6. **状態管理実装**: ページレベルの状態管理とデータフロー
7. **テスト**: 包括的なUnit Testの作成・実行
8. **WidgetBook登録**: ストーリーブックへの登録
9. **統合テスト**: 他のページとの連携確認
10. **パフォーマンス最適化**: 必要に応じた最適化
11. **ユーザビリティテスト**: 実際のユーザーフローでの確認
12. **ドキュメント**: 詳細仕様とAPIドキュメントの作成

## 重要な注意事項

- 既存のOrganisms、Molecules、Atomsコンポーネントを最大限活用する
- ページの責任範囲を明確にし、過度な複雑さを避ける
- すべてのPagesコンポーネントはUnit Testを実装する必要がある
- WidgetBookに登録して視覚的確認を可能にする
- パフォーマンスとメモリ使用量を考慮した実装を心がける
- アクセシビリティガイドラインに準拠する
- 国際化（i18n）対応を考慮する
- SEO対応を考慮する（Web版の場合）
- ユーザビリティとUX重視の設計を心がける
