---
id: organism-ui-component-library
title: Organism UI Component Library
---

# Organism UI Component Library

## Overview

Develop and manage complex UI components (Organisms) that combine multiple Molecules and Atoms based on Atomic Design.
For Flutter implementation, components must be added to WidgetBook and Unit Tests are mandatory.

## Atomic Design - Organisms

Organisms are complex components with independent functionality created by combining multiple Molecules and Atoms.

### Target Component Examples

- **Header**: Logo + Navigation + User menu
- **Product Card**: Image + Title + Price + Action buttons
- **Comment Section**: Comment list + Post form
- **Data Table**: Header + Data rows + Pagination
- **Shopping Cart**: Product list + Total amount + Checkout button
- **User Profile**: Avatar + User information + Action buttons
- **Article Card**: Thumbnail + Title + Summary + Meta information
- **Filter Panel**: Search field + Filter options + Reset button

## Development Guidelines

### 1. Component Design Principles

- **Functional Independence**: Self-contained functional units that operate independently
- **Reusability**: Versatility to be reused across different pages
- **Data-Driven**: Flexible display control through properties
- **Business Logic Separation**: Separation of display logic and business logic

### 2. Flutter Implementation Requirements

#### WidgetBook Integration
```dart
// WidgetBook registration example
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

#### Unit Test Implementation
```dart
// Unit Test example
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

### 3. Directory Structure

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

### 4. Implementation Patterns

#### Complex State Management Pattern
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

### 5. Quality Assurance

#### Required Test Items
- **Functional Integration Test**: Verify multiple components work together correctly
- **State Management Test**: Verify complex state changes are handled correctly
- **Data Flow Test**: Verify data reflection from properties to UI is correct
- **Error Handling Test**: Verify behavior in error scenarios
- **Performance Test**: Verify behavior with large datasets

#### WidgetBook Verification Items
- **Data Variations**: Verify display with different data patterns
- **State Transitions**: Verify display and behavior in each state
- **Responsive**: Verify display on different screen sizes
- **Accessibility**: Verify screen reader compatibility

## Implementation Flow

1. **Requirements Analysis**: Analyze functional requirements and UI component composition
2. **Design**: Design data models and component APIs
3. **Prototype**: Implement and test basic functionality
4. **Implementation**: Complete functional implementation
5. **Testing**: Create and execute comprehensive Unit Tests
6. **WidgetBook Registration**: Register in storybook
7. **Integration Testing**: Verify integration with other components
8. **Performance Optimization**: Optimize as needed
9. **Documentation**: Create detailed usage and API documentation

## Important Notes

- Maximize utilization of existing Molecules and Atoms components
- Follow single responsibility principle and avoid excessive complexity
- All Organisms components must implement Unit Tests
- Register in WidgetBook to enable visual verification
- Implement with emphasis on performance and memory usage
- Comply with accessibility guidelines
- Consider internationalization (i18n) support
