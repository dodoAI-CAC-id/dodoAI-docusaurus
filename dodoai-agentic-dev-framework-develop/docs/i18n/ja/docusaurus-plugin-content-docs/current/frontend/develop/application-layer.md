---
id: application-layer
title: Application Layer
---

# Application Layer

## 概要

Application Layerは、UseCase基盤のビジネス操作実装を担当します。ビジネスロジックを実装し、Domain LayerとPresentation Layerの橋渡しを行います。この層では、特定のビジネス操作を定義し、複数のDomainエンティティを組み合わせた処理を実装します。

## Flutter実装

### ディレクトリ構造
```
lib/
└── features/
    └── [feature_name]/
        └── application/
            ├── usecases/
            ├── services/
            ├── dto/
            └── mappers/
```

### 実装ガイドライン

#### 1. ユースケース

ユースケースは特定のビジネス操作を実装し、アプリケーションの主要機能を提供します。

```dart
// features/product/application/usecases/get_product_list_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

@injectable
class GetProductListUseCase implements UseCase<List<Product>, GetProductListParams> {
  final ProductRepository _repository;
  
  GetProductListUseCase(this._repository);
  
  @override
  Future<Either<Failure, List<Product>>> call(GetProductListParams params) async {
    try {
      final result = await _repository.getProducts(
        page: params.page,
        limit: params.limit,
        category: params.category,
        searchQuery: params.searchQuery,
      );
      
      return result.fold(
        (failure) => Left(failure),
        (products) {
          // ビジネスロジック: 在庫切れ商品をフィルタリング
          final availableProducts = products
              .where((product) => product.isAvailable)
              .toList();
          
          // ビジネスロジック: 評価順でソート
          if (params.sortByRating) {
            availableProducts.sort((a, b) => b.rating.compareTo(a.rating));
          }
          
          return Right(availableProducts);
        },
      );
    } catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }
}

class GetProductListParams {
  final int page;
  final int limit;
  final String? category;
  final String? searchQuery;
  final bool sortByRating;
  
  const GetProductListParams({
    this.page = 1,
    this.limit = 20,
    this.category,
    this.searchQuery,
    this.sortByRating = false,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetProductListParams &&
        other.page == page &&
        other.limit == limit &&
        other.category == category &&
        other.searchQuery == searchQuery &&
        other.sortByRating == sortByRating;
  }
  
  @override
  int get hashCode {
    return page.hashCode ^
        limit.hashCode ^
        category.hashCode ^
        searchQuery.hashCode ^
        sortByRating.hashCode;
  }
}
```

#### 2. アプリケーションサービス

複雑なビジネスロジックと複数のユースケースを組み合わせた処理を実装します。

```dart
// features/cart/application/services/cart_service.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../../product/domain/entities/product.dart';
import '../../../product/domain/repositories/product_repository.dart';
import '../../../user/domain/entities/user.dart';
import '../../../user/domain/repositories/user_repository.dart';

@injectable
class CartService {
  final CartRepository _cartRepository;
  final ProductRepository _productRepository;
  final UserRepository _userRepository;
  
  CartService(
    this._cartRepository,
    this._productRepository,
    this._userRepository,
  );
  
  Future<Either<Failure, Cart>> addProductToCart({
    required String userId,
    required String productId,
    required int quantity,
  }) async {
    try {
      // 1. ユーザー存在確認
      final userResult = await _userRepository.getUserById(userId);
      if (userResult.isLeft()) {
        return Left(Failure.notFound(message: 'User not found'));
      }
      
      // 2. 商品存在確認と在庫チェック
      final productResult = await _productRepository.getProductById(productId);
      if (productResult.isLeft()) {
        return Left(Failure.notFound(message: 'Product not found'));
      }
      
      final product = productResult.getOrElse(() => throw Exception());
      if (!product.isAvailable) {
        return Left(Failure.validation(message: 'Product is not available'));
      }
      
      // 3. 現在のカート取得
      final cartResult = await _cartRepository.getCartByUserId(userId);
      final currentCart = cartResult.fold(
        (failure) => Cart.empty(userId: userId),
        (cart) => cart,
      );
      
      // 4. カートアイテム作成
      final cartItem = CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productId: productId,
        quantity: quantity,
        unitPrice: product.price,
        addedAt: DateTime.now(),
      );
      
      // 5. ビジネスルール: 同じ商品が既に存在する場合は数量を追加
      final existingItemIndex = currentCart.items
          .indexWhere((item) => item.productId == productId);
      
      List<CartItem> updatedItems;
      if (existingItemIndex != -1) {
        updatedItems = List.from(currentCart.items);
        updatedItems[existingItemIndex] = updatedItems[existingItemIndex]
            .copyWith(quantity: updatedItems[existingItemIndex].quantity + quantity);
      } else {
        updatedItems = [...currentCart.items, cartItem];
      }
      
      // 6. カート更新
      final updatedCart = currentCart.copyWith(
        items: updatedItems,
        updatedAt: DateTime.now(),
      );
      
      return await _cartRepository.updateCart(updatedCart);
    } catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }
  
  Future<Either<Failure, Cart>> removeProductFromCart({
    required String userId,
    required String productId,
  }) async {
    try {
      final cartResult = await _cartRepository.getCartByUserId(userId);
      if (cartResult.isLeft()) {
        return Left(Failure.notFound(message: 'Cart not found'));
      }
      
      final currentCart = cartResult.getOrElse(() => throw Exception());
      final updatedItems = currentCart.items
          .where((item) => item.productId != productId)
          .toList();
      
      final updatedCart = currentCart.copyWith(
        items: updatedItems,
        updatedAt: DateTime.now(),
      );
      
      return await _cartRepository.updateCart(updatedCart);
    } catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }
  
  Future<Either<Failure, double>> calculateCartTotal(String userId) async {
    try {
      final cartResult = await _cartRepository.getCartByUserId(userId);
      if (cartResult.isLeft()) {
        return const Right(0.0);
      }
      
      final cart = cartResult.getOrElse(() => throw Exception());
      
      // ビジネスロジック: 合計金額計算
      double total = 0.0;
      for (final item in cart.items) {
        total += item.unitPrice * item.quantity;
      }
      
      // ビジネスロジック: プレミアムユーザーは10%割引
      final userResult = await _userRepository.getUserById(userId);
      if (userResult.isRight()) {
        final user = userResult.getOrElse(() => throw Exception());
        if (user.isPremium) {
          total *= 0.9; // 10%割引
        }
      }
      
      return Right(total);
    } catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }
}
```

#### 3. データ転送オブジェクト（DTO）

レイヤー間のデータ転送に使用するオブジェクトを定義します。

```dart
// features/product/application/dto/product_list_dto.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/product.dart';

part 'product_list_dto.freezed.dart';
part 'product_list_dto.g.dart';

@freezed
class ProductListDto with _$ProductListDto {
  const factory ProductListDto({
    required List<ProductDto> products,
    required int totalCount,
    required int currentPage,
    required int totalPages,
    required bool hasNextPage,
    required bool hasPreviousPage,
  }) = _ProductListDto;
  
  factory ProductListDto.fromJson(Map<String, dynamic> json) =>
      _$ProductListDtoFromJson(json);
}

@freezed
class ProductDto with _$ProductDto {
  const factory ProductDto({
    required String id,
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    required bool isAvailable,
    @Default([]) List<String> tags,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
    String? createdAt,
    String? updatedAt,
  }) = _ProductDto;
  
  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);
}
```

#### 4. マッパー

DTOとDomainエンティティ間の変換を行います。

```dart
// features/product/application/mappers/product_mapper.dart
import 'package:injectable/injectable.dart';
import '../../domain/entities/product.dart';
import '../dto/product_list_dto.dart';

@injectable
class ProductMapper {
  Product dtoToEntity(ProductDto dto) {
    return Product(
      id: dto.id,
      name: dto.name,
      description: dto.description,
      price: dto.price,
      imageUrl: dto.imageUrl,
      isAvailable: dto.isAvailable,
      tags: dto.tags,
      rating: dto.rating,
      reviewCount: dto.reviewCount,
      createdAt: dto.createdAt != null ? DateTime.parse(dto.createdAt!) : null,
      updatedAt: dto.updatedAt != null ? DateTime.parse(dto.updatedAt!) : null,
    );
  }
  
  ProductDto entityToDto(Product entity) {
    return ProductDto(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      imageUrl: entity.imageUrl,
      isAvailable: entity.isAvailable,
      tags: entity.tags,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      createdAt: entity.createdAt?.toIso8601String(),
      updatedAt: entity.updatedAt?.toIso8601String(),
    );
  }
  
  List<Product> dtoListToEntityList(List<ProductDto> dtoList) {
    return dtoList.map((dto) => dtoToEntity(dto)).toList();
  }
  
  List<ProductDto> entityListToDtoList(List<Product> entityList) {
    return entityList.map((entity) => entityToDto(entity)).toList();
  }
}
```

#### 5. 複合ユースケース

複数のドメインにまたがる複雑なビジネス操作を実装します。

```dart
// features/order/application/usecases/create_order_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../../../cart/application/services/cart_service.dart';
import '../../../payment/application/services/payment_service.dart';
import '../../../inventory/application/services/inventory_service.dart';
import '../../../notification/application/services/notification_service.dart';

@injectable
class CreateOrderUseCase implements UseCase<Order, CreateOrderParams> {
  final OrderRepository _orderRepository;
  final CartService _cartService;
  final PaymentService _paymentService;
  final InventoryService _inventoryService;
  final NotificationService _notificationService;
  
  CreateOrderUseCase(
    this._orderRepository,
    this._cartService,
    this._paymentService,
    this._inventoryService,
    this._notificationService,
  );
  
  @override
  Future<Either<Failure, Order>> call(CreateOrderParams params) async {
    try {
      // 1. カート内容確認
      final cartTotalResult = await _cartService.calculateCartTotal(params.userId);
      if (cartTotalResult.isLeft()) {
        return Left(cartTotalResult.fold((l) => l, (r) => throw Exception()));
      }
      
      final totalAmount = cartTotalResult.getOrElse(() => 0.0);
      if (totalAmount <= 0) {
        return Left(Failure.validation(message: 'Cart is empty'));
      }
      
      // 2. 在庫確認
      final inventoryCheckResult = await _inventoryService.checkAvailability(
        params.userId,
      );
      if (inventoryCheckResult.isLeft()) {
        return Left(inventoryCheckResult.fold((l) => l, (r) => throw Exception()));
      }
      
      // 3. 注文作成
      final order = Order.create(
        userId: params.userId,
        shippingAddress: params.shippingAddress,
        paymentMethod: params.paymentMethod,
        totalAmount: totalAmount,
      );
      
      final createOrderResult = await _orderRepository.createOrder(order);
      if (createOrderResult.isLeft()) {
        return Left(createOrderResult.fold((l) => l, (r) => throw Exception()));
      }
      
      final createdOrder = createOrderResult.getOrElse(() => throw Exception());
      
      // 4. 決済処理
      final paymentResult = await _paymentService.processPayment(
        orderId: createdOrder.id,
        amount: totalAmount,
        paymentMethod: params.paymentMethod,
      );
      
      if (paymentResult.isLeft()) {
        // 決済失敗時は注文をキャンセル
        await _orderRepository.cancelOrder(createdOrder.id);
        return Left(paymentResult.fold((l) => l, (r) => throw Exception()));
      }
      
      // 5. 在庫減算
      final inventoryUpdateResult = await _inventoryService.reserveItems(
        params.userId,
      );
      
      if (inventoryUpdateResult.isLeft()) {
        // 在庫更新失敗時は決済と注文をキャンセル
        await _paymentService.refundPayment(createdOrder.id);
        await _orderRepository.cancelOrder(createdOrder.id);
        return Left(inventoryUpdateResult.fold((l) => l, (r) => throw Exception()));
      }
      
      // 6. 注文確定
      final confirmedOrder = createdOrder.copyWith(
        status: OrderStatus.confirmed,
        confirmedAt: DateTime.now(),
      );
      
      final updateResult = await _orderRepository.updateOrder(confirmedOrder);
      if (updateResult.isLeft()) {
        return Left(updateResult.fold((l) => l, (r) => throw Exception()));
      }
      
      // 7. カートクリア
      await _cartService.clearCart(params.userId);
      
      // 8. 通知送信
      await _notificationService.sendOrderConfirmation(
        userId: params.userId,
        orderId: confirmedOrder.id,
      );
      
      return Right(confirmedOrder);
    } catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }
}

class CreateOrderParams {
  final String userId;
  final String shippingAddress;
  final String paymentMethod;
  
  const CreateOrderParams({
    required this.userId,
    required this.shippingAddress,
    required this.paymentMethod,
  });
}
```

## テスト戦略

### ユースケーステスト

```dart
// test/features/product/application/usecases/get_product_list_usecase_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:myapp/features/product/application/usecases/get_product_list_usecase.dart';
import 'package:myapp/features/product/domain/entities/product.dart';
import 'package:myapp/features/product/domain/repositories/product_repository.dart';

@GenerateMocks([ProductRepository])
import 'get_product_list_usecase_test.mocks.dart';

void main() {
  late GetProductListUseCase usecase;
  late MockProductRepository mockRepository;
  
  setUp(() {
    mockRepository = MockProductRepository();
    usecase = GetProductListUseCase(mockRepository);
  });
  
  const testProducts = [
    Product(
      id: '1',
      name: 'Available Product',
      description: 'Description',
      price: 99.99,
      imageUrl: 'image.jpg',
      isAvailable: true,
      rating: 4.5,
    ),
    Product(
      id: '2',
      name: 'Unavailable Product',
      description: 'Description',
      price: 149.99,
      imageUrl: 'image2.jpg',
      isAvailable: false,
      rating: 3.0,
    ),
  ];
  
  group('GetProductListUseCase', () {
    test('should filter out unavailable products', () async {
      // arrange
      when(mockRepository.getProducts(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
        category: anyNamed('category'),
        searchQuery: anyNamed('searchQuery'),
      )).thenAnswer((_) async => const Right(testProducts));
      
      // act
      const params = GetProductListParams();
      final result = await usecase(params);
      
      // assert
      result.fold(
        (failure) => fail('Should return success'),
        (products) {
          expect(products.length, 1);
          expect(products.first.isAvailable, true);
          expect(products.first.id, '1');
        },
      );
    });
    
    test('should sort by rating when sortByRating is true', () async {
      // arrange
      const availableProducts = [
        Product(
          id: '1',
          name: 'Product 1',
          description: 'Description',
          price: 99.99,
          imageUrl: 'image.jpg',
          isAvailable: true,
          rating: 3.0,
        ),
        Product(
          id: '2',
          name: 'Product 2',
          description: 'Description',
          price: 149.99,
          imageUrl: 'image2.jpg',
          isAvailable: true,
          rating: 4.5,
        ),
      ];
      
      when(mockRepository.getProducts(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
        category: anyNamed('category'),
        searchQuery: anyNamed('searchQuery'),
      )).thenAnswer((_) async => const Right(availableProducts));
      
      // act
      const params = GetProductListParams(sortByRating: true);
      final result = await usecase(params);
      
      // assert
      result.fold(
        (failure) => fail('Should return success'),
        (products) {
          expect(products.length, 2);
          expect(products.first.rating, 4.5);
          expect(products.last.rating, 3.0);
        },
      );
    });
  });
}
```

### サービステスト

```dart
// test/features/cart/application/services/cart_service_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:myapp/features/cart/application/services/cart_service.dart';
import 'package:myapp/features/cart/domain/entities/cart.dart';
import 'package:myapp/features/cart/domain/repositories/cart_repository.dart';
import 'package:myapp/features/product/domain/entities/product.dart';
import 'package:myapp/features/product/domain/repositories/product_repository.dart';
import 'package:myapp/features/user/domain/entities/user.dart';
import 'package:myapp/features/user/domain/repositories/user_repository.dart';

@GenerateMocks([CartRepository, ProductRepository, UserRepository])
import 'cart_service_test.mocks.dart';

void main() {
  late CartService service;
  late MockCartRepository mockCartRepository;
  late MockProductRepository mockProductRepository;
  late MockUserRepository mockUserRepository;
  
  setUp(() {
    mockCartRepository = MockCartRepository();
    mockProductRepository = MockProductRepository();
    mockUserRepository = MockUserRepository();
    service = CartService(
      mockCartRepository,
      mockProductRepository,
      mockUserRepository,
    );
  });
  
  group('CartService', () {
    const testUser = User(
      id: 'user1',
      email: 'test@example.com',
      name: 'Test User',
      role: UserRole.user,
      isEmailVerified: true,
    );
    
    const testProduct = Product(
      id: 'product1',
      name: 'Test Product',
      description: 'Description',
      price: 99.99,
      imageUrl: 'image.jpg',
      isAvailable: true,
    );
    
    test('should add product to cart successfully', () async {
      // arrange
      when(mockUserRepository.getUserById('user1'))
          .thenAnswer((_) async => const Right(testUser));
      when(mockProductRepository.getProductById('product1'))
          .thenAnswer((_) async => const Right(testProduct));
      when(mockCartRepository.getCartByUserId('user1'))
          .thenAnswer((_) async => Left(Failure.notFound(message: 'Cart not found')));
      when(mockCartRepository.updateCart(any))
          .thenAnswer((_) async => Right(Cart.empty(userId: 'user1')));
      
      // act
      final result = await service.addProductToCart(
        userId: 'user1',
        productId: 'product1',
        quantity: 2,
      );
      
      // assert
      expect(result.isRight(), true);
      verify(mockCartRepository.updateCart(any)).called(1);
    });
  });
}
```

## 設計原則

### 1. 単一責任原則
- 各ユースケースは単一のビジネス操作を実装
- サービスは関連する操作をグループ化
- DTOは特定のデータ転送目的のみ

### 2. 依存性逆転
- Domain Layerのインターフェースに依存
- Infrastructure Layerの実装詳細には依存しない
- 依存性注入を活用

### 3. オープン・クローズド原則
- 新しいユースケースの追加は既存コードを変更せずに拡張
- インターフェースによる柔軟な実装

### 4. インターフェース分離原則
- 必要最小限のメソッドのみを含むインターフェース
- クライアントが不要な依存関係を持たない

## 重要な注意事項

- **ビジネスロジック重視**: 技術的詳細よりもビジネス操作に焦点
- **トランザクション管理**: 複数の操作を含む場合の適切な処理
- **パフォーマンス**: 不要なデータ取得や処理を避ける
- **テスタビリティ**: すべてのコンポーネントがユニットテスト可能
- **エラーハンドリング**: 適切な例外処理とエラータイプの使用
- **ログ**: 重要なビジネス操作のログ記録
- **セキュリティ**: 適切な認証・認可の実装
