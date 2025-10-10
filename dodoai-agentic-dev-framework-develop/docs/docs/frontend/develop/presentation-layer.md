---
id: presentation-layer
title: Presentation Layer
---

# Presentation Layer

## Overview

The Presentation Layer is responsible for state management with BLoC and UI reflection. It handles user interface display and user interaction processing, serving as a bridge to the Application Layer. This layer implements state management using the BLoC pattern and UI implementation with Flutter widgets.

## Flutter Implementation

### Directory Structure
```
lib/
├── features/
│   └── [feature_name]/
│       └── presentation/
│           ├── bloc/
│           ├── pages/
│           ├── widgets/
│           └── utils/
└── pages/
    ├── home/
    ├── product/
    └── profile/
```

### Implementation Guidelines

#### 1. BLoC（Business Logic Component）

Implement state management and business logic separation using the BLoC pattern.

```dart
// features/product/presentation/bloc/product_list_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../application/usecases/get_product_list_usecase.dart';
import '../../domain/entities/product.dart';
import '../../../../core/errors/failures.dart';

part 'product_list_bloc.freezed.dart';
part 'product_list_event.dart';
part 'product_list_state.dart';

@injectable
class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final GetProductListUseCase _getProductListUseCase;
  
  ProductListBloc(this._getProductListUseCase) 
      : super(const ProductListState.initial()) {
    on<ProductListEvent>((event, emit) async {
      await event.when(
        loadProducts: () => _onLoadProducts(emit),
        loadMoreProducts: () => _onLoadMoreProducts(emit),
        searchProducts: (query) => _onSearchProducts(emit, query),
        filterProducts: (category) => _onFilterProducts(emit, category),
        refreshProducts: () => _onRefreshProducts(emit),
      );
    });
  }
  
  Future<void> _onLoadProducts(Emitter<ProductListState> emit) async {
    emit(const ProductListState.loading());
    
    final result = await _getProductListUseCase(
      const GetProductListParams(page: 1, limit: 20),
    );
    
    result.fold(
      (failure) => emit(ProductListState.error(failure.message)),
      (products) => emit(ProductListState.loaded(
        products: products,
        hasReachedMax: products.length < 20,
        currentPage: 1,
      )),
    );
  }
  
  Future<void> _onLoadMoreProducts(Emitter<ProductListState> emit) async {
    final currentState = state;
    if (currentState is! _Loaded || currentState.hasReachedMax) return;
    
    emit(currentState.copyWith(isLoadingMore: true));
    
    final result = await _getProductListUseCase(
      GetProductListParams(
        page: currentState.currentPage + 1,
        limit: 20,
      ),
    );
    
    result.fold(
      (failure) => emit(currentState.copyWith(
        isLoadingMore: false,
        errorMessage: failure.message,
      )),
      (newProducts) => emit(currentState.copyWith(
        products: [...currentState.products, ...newProducts],
        hasReachedMax: newProducts.length < 20,
        currentPage: currentState.currentPage + 1,
        isLoadingMore: false,
        errorMessage: null,
      )),
    );
  }
}
```

#### 2. Events

```dart
// part of product_list_bloc.dart
@freezed
class ProductListEvent with _$ProductListEvent {
  const factory ProductListEvent.loadProducts() = _LoadProducts;
  const factory ProductListEvent.loadMoreProducts() = _LoadMoreProducts;
  const factory ProductListEvent.searchProducts(String query) = _SearchProducts;
  const factory ProductListEvent.filterProducts(String category) = _FilterProducts;
  const factory ProductListEvent.refreshProducts() = _RefreshProducts;
}
```

#### 3. States

```dart
// part of product_list_bloc.dart
@freezed
class ProductListState with _$ProductListState {
  const factory ProductListState.initial() = _Initial;
  
  const factory ProductListState.loading() = _Loading;
  
  const factory ProductListState.loaded({
    required List<Product> products,
    required bool hasReachedMax,
    required int currentPage,
    @Default(false) bool isLoadingMore,
    String? searchQuery,
    String? category,
    String? errorMessage,
  }) = _Loaded;
  
  const factory ProductListState.error(String message) = _Error;
}
```

#### 4. Pages

```dart
// features/product/presentation/pages/product_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../bloc/product_list_bloc.dart';
import '../widgets/product_list_view.dart';
import '../widgets/product_search_bar.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<ProductListBloc>()
        ..add(const ProductListEvent.loadProducts()),
      child: const ProductListView(),
    );
  }
}

class ProductListView extends StatelessWidget {
  const ProductListView({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProductSearchBar(
              onSearch: (query) {
                context.read<ProductListBloc>().add(
                  ProductListEvent.searchProducts(query),
                );
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<ProductListBloc, ProductListState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(
              child: Text('Welcome! Tap to load products.'),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loaded: (
              products,
              hasReachedMax,
              currentPage,
              isLoadingMore,
              searchQuery,
              category,
              errorMessage,
            ) => ProductListContent(
              products: products,
              hasReachedMax: hasReachedMax,
              isLoadingMore: isLoadingMore,
              errorMessage: errorMessage,
              onLoadMore: () {
                context.read<ProductListBloc>().add(
                  const ProductListEvent.loadMoreProducts(),
                );
              },
              onRefresh: () {
                context.read<ProductListBloc>().add(
                  const ProductListEvent.refreshProducts(),
                );
              },
            ),
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: $message',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductListBloc>().add(
                        const ProductListEvent.loadProducts(),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
```

#### 5. Widgets

```dart
// features/product/presentation/widgets/product_card.dart
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  
  const ProductCard({
    Key? key,
    required this.product,
    this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(product.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.formattedPrice,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${product.reviewCount})',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Testing Strategy

### BLoC Tests

```dart
// test/features/product/presentation/bloc/product_list_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:myapp/features/product/application/usecases/get_product_list_usecase.dart';
import 'package:myapp/features/product/domain/entities/product.dart';
import 'package:myapp/features/product/presentation/bloc/product_list_bloc.dart';
import 'package:myapp/core/errors/failures.dart';

@GenerateMocks([GetProductListUseCase])
import 'product_list_bloc_test.mocks.dart';

void main() {
  late ProductListBloc bloc;
  late MockGetProductListUseCase mockGetProductListUseCase;
  
  setUp(() {
    mockGetProductListUseCase = MockGetProductListUseCase();
    bloc = ProductListBloc(mockGetProductListUseCase);
  });
  
  tearDown(() {
    bloc.close();
  });
  
  const testProducts = [
    Product(
      id: '1',
      name: 'Product 1',
      description: 'Description 1',
      price: 99.99,
      imageUrl: 'image1.jpg',
      isAvailable: true,
    ),
  ];
  
  group('ProductListBloc', () {
    test('initial state is ProductListState.initial', () {
      expect(bloc.state, const ProductListState.initial());
    });
    
    blocTest<ProductListBloc, ProductListState>(
      'emits [loading, loaded] when loadProducts is added and succeeds',
      build: () {
        when(mockGetProductListUseCase(any))
            .thenAnswer((_) async => const Right(testProducts));
        return bloc;
      },
      act: (bloc) => bloc.add(const ProductListEvent.loadProducts()),
      expect: () => [
        const ProductListState.loading(),
        ProductListState.loaded(
          products: testProducts,
          hasReachedMax: true,
          currentPage: 1,
        ),
      ],
    );
    
    blocTest<ProductListBloc, ProductListState>(
      'emits [loading, error] when loadProducts is added and fails',
      build: () {
        when(mockGetProductListUseCase(any))
            .thenAnswer((_) async => const Left(Failure.server(message: 'Server error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const ProductListEvent.loadProducts()),
      expect: () => [
        const ProductListState.loading(),
        const ProductListState.error('Server error'),
      ],
    );
  });
}
```

### Widget Tests

```dart
// test/features/product/presentation/widgets/product_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/features/product/domain/entities/product.dart';
import 'package:myapp/features/product/presentation/widgets/product_card.dart';

void main() {
  const testProduct = Product(
    id: '1',
    name: 'Test Product',
    description: 'Test Description',
    price: 99.99,
    imageUrl: 'https://example.com/image.jpg',
    isAvailable: true,
    rating: 4.5,
    reviewCount: 123,
  );
  
  group('ProductCard', () {
    testWidgets('should display product information', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(product: testProduct),
          ),
        ),
      );
      
      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('\$99.99'), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
      expect(find.text('(123)'), findsOneWidget);
    });
    
    testWidgets('should call onTap when tapped', (tester) async {
      bool wasTapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(
              product: testProduct,
              onTap: () => wasTapped = true,
            ),
          ),
        ),
      );
      
      await tester.tap(find.byType(ProductCard));
      expect(wasTapped, true);
    });
  });
}
```

## Design Principles

### 1. Single Responsibility Principle
- Each BLoC is responsible only for state management of specific functional areas
- Widgets only handle display and user interactions
- Pages are only responsible for screen-level composition

### 2. Dependency Inversion
- Depends on Application Layer use cases
- Does not depend on Infrastructure Layer implementation details
- Loose coupling through dependency injection

### 3. State Immutability
- State objects are immutable
- State changes are realized by creating new objects
- Type safety using Freezed

### 4. Testability
- All BLoCs are unit testable
- UI behavior verification through widget testing
- Independent testing using mocks

## Important Notes

- **Centralized state management**: Unified state management with BLoC pattern
- **UI/logic separation**: Do not include business logic in widgets
- **Performance**: Optimization to avoid unnecessary re-rendering
- **Accessibility**: Proper semantics implementation
- **Error handling**: User-friendly error display
- **Loading state**: Proper loading indicator display
- **Internationalization support**: Multi-language support consideration
- **Responsive design**: Support for different screen sizes
