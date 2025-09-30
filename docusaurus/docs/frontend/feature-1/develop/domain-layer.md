---
id: domain-layer
title: Domain Layer
---

# Domain Layer

## Overview

The Domain Layer is the core layer of Clean Architecture that defines business logic and entities. This layer does not depend on other layers and contains the most important business rules of the application.

## Flutter Implementation

### Directory Structure
```
lib/
├── core/
│   ├── entities/
│   ├── errors/
│   ├── usecases/
│   └── utils/
└── features/
    └── [feature_name]/
        └── domain/
            ├── entities/
            ├── repositories/
            └── usecases/
```

### Implementation Guidelines

#### 1. Entities

Entities represent the core data structures of the business.

```dart
// features/product/domain/entities/product.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    required bool isAvailable,
    @Default([]) List<String> tags,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Product;
  
  const Product._();
  
  // Business logic
  bool get isOnSale => price > 0 && isAvailable;
  
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  
  bool hasTag(String tag) => tags.contains(tag);
  
  Product applyDiscount(double discountPercentage) {
    final discountedPrice = price * (1 - discountPercentage / 100);
    return copyWith(price: discountedPrice);
  }
}
```

#### 2. Repository Interfaces

Repository interfaces provide abstraction for data access.

```dart
// features/product/domain/repositories/product_repository.dart
import 'package:dartz/dartz.dart';
import '../entities/product.dart';
import '../../../../core/errors/failures.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts({
    int page = 1,
    int limit = 20,
    String? category,
    String? searchQuery,
  });
  
  Future<Either<Failure, Product>> getProductById(String id);
  
  Future<Either<Failure, List<Product>>> getFeaturedProducts();
  
  Future<Either<Failure, List<Product>>> getProductsByCategory(
    String category, {
    int page = 1,
    int limit = 20,
  });
  
  Future<Either<Failure, List<Product>>> searchProducts(
    String query, {
    int page = 1,
    int limit = 20,
  });
  
  Future<Either<Failure, Unit>> addToFavorites(String productId);
  
  Future<Either<Failure, Unit>> removeFromFavorites(String productId);
  
  Future<Either<Failure, List<Product>>> getFavoriteProducts();
}
```

#### 3. Use Cases

Use cases implement specific business operations.

```dart
// features/product/domain/usecases/get_products.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

@injectable
class GetProducts implements UseCase<List<Product>, GetProductsParams> {
  final ProductRepository repository;
  
  GetProducts(this.repository);
  
  @override
  Future<Either<Failure, List<Product>>> call(GetProductsParams params) async {
    return await repository.getProducts(
      page: params.page,
      limit: params.limit,
      category: params.category,
      searchQuery: params.searchQuery,
    );
  }
}

class GetProductsParams {
  final int page;
  final int limit;
  final String? category;
  final String? searchQuery;
  
  const GetProductsParams({
    this.page = 1,
    this.limit = 20,
    this.category,
    this.searchQuery,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetProductsParams &&
        other.page == page &&
        other.limit == limit &&
        other.category == category &&
        other.searchQuery == searchQuery;
  }
  
  @override
  int get hashCode {
    return page.hashCode ^
        limit.hashCode ^
        category.hashCode ^
        searchQuery.hashCode;
  }
}
```

#### 4. Core Entities

Define common entities used throughout the application.

```dart
// core/entities/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String name,
    String? avatarUrl,
    required UserRole role,
    required bool isEmailVerified,
    DateTime? lastLoginAt,
    DateTime? createdAt,
  }) = _User;
  
  const User._();
  
  bool get isAdmin => role == UserRole.admin;
  bool get isPremium => role == UserRole.premium;
  
  String get displayName => name.isNotEmpty ? name : email;
}

enum UserRole {
  user,
  premium,
  admin,
}
```

#### 5. Value Objects

Define objects to represent complex values.

```dart
// core/entities/email.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'email.freezed.dart';

@freezed
class Email with _$Email {
  const factory Email._(String value) = _Email;
  
  factory Email(String input) {
    if (input.isEmpty) {
      throw ArgumentError('Email cannot be empty');
    }
    
    if (!_isValidEmail(input)) {
      throw ArgumentError('Invalid email format');
    }
    
    return Email._(input.toLowerCase().trim());
  }
  
  static bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

// core/entities/money.dart
@freezed
class Money with _$Money {
  const factory Money({
    required double amount,
    required String currency,
  }) = _Money;
  
  const Money._();
  
  Money operator +(Money other) {
    if (currency != other.currency) {
      throw ArgumentError('Cannot add different currencies');
    }
    return Money(amount: amount + other.amount, currency: currency);
  }
  
  Money operator -(Money other) {
    if (currency != other.currency) {
      throw ArgumentError('Cannot subtract different currencies');
    }
    return Money(amount: amount - other.amount, currency: currency);
  }
  
  String get formatted {
    switch (currency) {
      case 'USD':
        return '\$${amount.toStringAsFixed(2)}';
      case 'JPY':
        return '¥${amount.toStringAsFixed(0)}';
      default:
        return '${amount.toStringAsFixed(2)} $currency';
    }
  }
}
```

### Error handling

```dart
// core/errors/failures.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.server({
    required String message,
    int? statusCode,
  }) = ServerFailure;
  
  const factory Failure.network({
    required String message,
  }) = NetworkFailure;
  
  const factory Failure.cache({
    required String message,
  }) = CacheFailure;
  
  const factory Failure.validation({
    required String message,
    Map<String, String>? fieldErrors,
  }) = ValidationFailure;
  
  const factory Failure.unauthorized({
    required String message,
  }) = UnauthorizedFailure;
  
  const factory Failure.notFound({
    required String message,
  }) = NotFoundFailure;
}

// core/errors/exceptions.dart
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  
  const ServerException(this.message, [this.statusCode]);
}

class NetworkException implements Exception {
  final String message;
  
  const NetworkException(this.message);
}

class CacheException implements Exception {
  final String message;
  
  const CacheException(this.message);
}
```

### Base Use Case

```dart
// core/usecases/usecase.dart
import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {
  const NoParams();
}

// Use case for streams
abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}
```

## Testing Strategy

### Entity Tests

```dart
// test/features/product/domain/entities/product_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/features/product/domain/entities/product.dart';

void main() {
  group('Product Entity', () {
    const testProduct = Product(
      id: '1',
      name: 'Test Product',
      description: 'Test Description',
      price: 99.99,
      imageUrl: 'https://example.com/image.jpg',
      isAvailable: true,
    );
    
    test('should return true for isOnSale when price > 0 and available', () {
      expect(testProduct.isOnSale, true);
    });
    
    test('should return false for isOnSale when not available', () {
      final unavailableProduct = testProduct.copyWith(isAvailable: false);
      expect(unavailableProduct.isOnSale, false);
    });
    
    test('should format price correctly', () {
      expect(testProduct.formattedPrice, '\$99.99');
    });
    
    test('should apply discount correctly', () {
      final discountedProduct = testProduct.applyDiscount(10);
      expect(discountedProduct.price, closeTo(89.99, 0.01));
    });
  });
}
```

### UseCase Tests

```dart
// test/features/product/domain/usecases/get_products_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:myapp/features/product/domain/entities/product.dart';
import 'package:myapp/features/product/domain/repositories/product_repository.dart';
import 'package:myapp/features/product/domain/usecases/get_products.dart';

@GenerateMocks([ProductRepository])
import 'get_products_test.mocks.dart';

void main() {
  late GetProducts usecase;
  late MockProductRepository mockRepository;
  
  setUp(() {
    mockRepository = MockProductRepository();
    usecase = GetProducts(mockRepository);
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
    Product(
      id: '2',
      name: 'Product 2',
      description: 'Description 2',
      price: 149.99,
      imageUrl: 'image2.jpg',
      isAvailable: true,
    ),
  ];
  
  test('should get products from repository', () async {
    // arrange
    when(mockRepository.getProducts(
      page: anyNamed('page'),
      limit: anyNamed('limit'),
      category: anyNamed('category'),
      searchQuery: anyNamed('searchQuery'),
    )).thenAnswer((_) async => const Right(testProducts));
    
    // act
    const params = GetProductsParams();
    final result = await usecase(params);
    
    // assert
    expect(result, const Right(testProducts));
    verify(mockRepository.getProducts(
      page: 1,
      limit: 20,
      category: null,
      searchQuery: null,
    ));
    verifyNoMoreInteractions(mockRepository);
  });
}
```

## Design Principles

### 1. Dependency Inversion
- Domain Layer does not depend on Infrastructure Layer
- Define Repository Interface in Domain Layer
- Implementation is done in Infrastructure Layer

### 2. Single Responsibility Principle
- Each Entity represents a single concept
- Each UseCase implements a single business operation
- Clear separation of responsibilities

### 3. Open-Closed Principle
- Adding new features extends without modifying existing code
- Ensure extensibility through interfaces

### 4. Interface Segregation Principle
- Interfaces containing only the minimum necessary methods
- Design where clients do not have unnecessary dependencies

## Important Notes

- **Framework independent**: Does not depend on specific Flutter or Dart features
- **Testable**: All components can be unit tested
- **Business rule focused**: Focus on business logic rather than technical details
- **Immutability**: Entities are designed as immutable objects
- **Error handling**: Proper exception handling and error type definition
- **Documentation**: Documentation of business rules and domain knowledge
