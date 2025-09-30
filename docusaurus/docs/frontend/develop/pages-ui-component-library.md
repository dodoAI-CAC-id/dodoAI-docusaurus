---
id: pages-ui-component-library
title: Pages UI Component Library
---

# Pages UI Component Library

## Overview

Develop and manage complete page-level UI components (Pages) that combine multiple Organisms, Molecules, and Atoms based on Atomic Design.
For Flutter implementation, components must be added to WidgetBook and Unit Tests are mandatory.

## Atomic Design - Pages

Pages are the highest-level components that constitute complete pages or screens. They combine multiple Organisms to realize specific user journeys and business functions.

### Target Component Examples

- **Home Page**: Header + Hero section + Product list + Footer
- **Product Detail Page**: Header + Product details + Review section + Related products
- **Login Page**: Login form + Social login + Password reset
- **Dashboard Page**: Sidebar + Main content + Statistics widgets
- **Profile Page**: User information + Settings panel + Activity history
- **Checkout Page**: Order confirmation + Payment method + Shipping information
- **Search Results Page**: Search filters + Results list + Pagination

## Development Guidelines

### 1. Component Design Principles

- **User Journey**: Complete specific user tasks
- **Layout Management**: Overall screen layout and navigation
- **State Management**: Page-level state and data flow
- **Routing**: Page transitions and parameter management

### 2. Flutter Implementation Requirements

#### WidgetBook Integration
```dart
// WidgetBook registration example
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

#### Unit Test Implementation
```dart
// Unit Test Example
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
    
    // Wait for async operations
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
    
    // Verify navigation occurred
    expect(find.byType(PageProductReviews), findsOneWidget);
  });
});
```

### 3. Directory Structure

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

### 4. Implementation Patterns

#### Page-level State Management Pattern
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
          const SnackBar(content: Text('Added to cart successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add to cart: $e')),
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
        title: _product?.name ?? 'Product Detail',
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
                text: 'Add to Cart',
                onPressed: _isAddingToCart ? null : _handleAddToCart,
                isLoading: _isAddingToCart,
              ),
              secondaryAction: BottomAction(
                text: 'Buy Now',
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
        message: 'Product not found',
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

### 5. Quality Assurance

#### Required Test Items
- **Page integration test**: All components work together correctly
- **Navigation test**: Page transitions work correctly
- **Data loading test**: Asynchronous data retrieval is processed correctly
- **Error handling test**: Behavior verification in various error states
- **User interaction test**: Main user operation behavior verification
- **State management test**: Page-level state changes are processed correctly

#### WidgetBook Verification Items
- **Data states**: Loading, success, error state display verification
- **Responsive**: Display verification on different screen sizes
- **Accessibility**: Screen reader support verification
- **Performance**: Large data operation verification

## Implementation Flow

1. **User journey analysis**: Clarification of page purpose and user flow
2. **Wireframe**: Page layout and component structure design
3. **Data model design**: Required data structure and API design
4. **Prototype**: Basic page structure implementation
5. **Component integration**: Combination of Organisms and Molecules
6. **State management implementation**: Page-level state management and data flow
7. **Testing**: Comprehensive Unit Test creation and execution
8. **WidgetBook registration**: Storybook registration
9. **Integration testing**: Coordination verification with other pages
10. **Performance Optimization**: Optimization as needed
11. **Usability testing**: Verification with actual user flow
12. **Documentation**: Detailed specification and API documentation creation

## Important Notes

- Maximize utilization of existing Organisms, Molecules, and Atoms components
- Clarify page responsibility scope and avoid excessive complexity
- All Pages components must implement Unit Tests
- Register in WidgetBook to enable visual verification
- Implement with performance and memory usage considerations in mind
- Comply with Accessibility guidelines
- Consider internationalization (i18n) support
- Consider SEO support (for web version)
- Focus on usability and UX-oriented design
