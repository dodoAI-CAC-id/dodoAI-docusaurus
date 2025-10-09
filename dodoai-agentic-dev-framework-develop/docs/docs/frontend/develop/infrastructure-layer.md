---
id: infrastructure-layer
title: Infrastructure Layer
---

# Infrastructure Layer

## Overview

The Infrastructure Layer is responsible for API clients, storage implementations, etc. It handles technical implementation details such as communication with external systems, data persistence, and integration with external services. This layer provides concrete implementations of Repository Interfaces defined in the Domain Layer.

## Flutter Implementation

### Directory Structure
```
lib/
├── features/
│   └── [feature_name]/
│       └── infrastructure/
│           ├── datasources/
│           │   ├── local/
│           │   └── remote/
│           ├── repositories/
│           ├── models/
│           └── mappers/
└── infrastructure/
    ├── core/
    │   ├── network/
    │   ├── storage/
    │   ├── cache/
    │   └── services/
    ├── external/
    └── config/
```

### Implementation Guidelines

#### 1. Repository Implementations

Provide concrete implementations of Repository Interfaces defined in the Domain Layer.

```dart
// features/product/infrastructure/repositories/product_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../infrastructure/core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/local/product_local_datasource.dart';
import '../datasources/remote/product_remote_datasource.dart';
import '../mappers/product_mapper.dart';

@Injectable(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  final ProductLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final ProductInfrastructureMapper _mapper;
  
  ProductRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
    this._mapper,
  );
  
  @override
  Future<Either<Failure, List<Product>>> getProducts({
    int page = 1,
    int limit = 20,
    String? category,
    String? searchQuery,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        // Get from remote data source when online
        final remoteProducts = await _remoteDataSource.getProducts(
          page: page,
          limit: limit,
          category: category,
          searchQuery: searchQuery,
        );
        
        // Cache locally
        await _localDataSource.cacheProducts(remoteProducts);
        
        // Convert to Entity and return
        final products = remoteProducts
            .map((model) => _mapper.modelToEntity(model))
            .toList();
        
        return Right(products);
      } else {
        // Get from local data source when offline
        final cachedProducts = await _localDataSource.getCachedProducts(
          page: page,
          limit: limit,
          category: category,
          searchQuery: searchQuery,
        );
        
        final products = cachedProducts
            .map((model) => _mapper.modelToEntity(model))
            .toList();
        
        return Right(products);
      }
    } on ServerException catch (e) {
      return Left(Failure.server(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(Failure.network(message: e.message));
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message));
    } catch (e) {
      return Left(Failure.server(message: e.toString()));
    }
  }
}
```

#### 2. Remote Data Sources

Handle communication with external APIs.

```dart
// features/product/infrastructure/datasources/remote/product_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/errors/exceptions.dart';
import '../../models/product_model.dart';

part 'product_remote_datasource.g.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 20,
    String? category,
    String? searchQuery,
  });
  
  Future<ProductModel> getProductById(String id);
  Future<List<ProductModel>> getFeaturedProducts();
  Future<List<ProductModel>> searchProducts(String query);
}

@Injectable(as: ProductRemoteDataSource)
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio _dio;
  
  ProductRemoteDataSourceImpl(this._dio);
  
  @override
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 20,
    String? category,
    String? searchQuery,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (category != null) 'category': category,
        if (searchQuery != null) 'search': searchQuery,
      };
      
      final response = await _dio.get(
        '/products',
        queryParameters: queryParameters,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          'Failed to load products',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  void _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw NetworkException('Connection timeout');
    } else if (e.type == DioExceptionType.connectionError) {
      throw NetworkException('No internet connection');
    } else {
      throw ServerException(
        e.response?.data['message'] ?? 'Server error',
        e.response?.statusCode,
      );
    }
  }
}
```

#### 3. Local Data Sources

Handle integration with local storage.

```dart
// features/product/infrastructure/datasources/local/product_local_datasource.dart
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/errors/exceptions.dart';
import '../../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getCachedProducts({
    int page = 1,
    int limit = 20,
    String? category,
    String? searchQuery,
  });
  
  Future<ProductModel> getCachedProductById(String id);
  Future<void> cacheProducts(List<ProductModel> products);
  Future<void> cacheProduct(ProductModel product);
  Future<void> clearCache();
}

@Injectable(as: ProductLocalDataSource)
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static const String _boxName = 'products';
  static const String _cacheKey = 'cached_products';
  static const String _timestampKey = 'cache_timestamp';
  static const Duration _cacheExpiry = Duration(hours: 1);
  
  Box<dynamic>? _box;
  
  Future<Box<dynamic>> get box async {
    _box ??= await Hive.openBox(_boxName);
    return _box!;
  }
  
  @override
  Future<List<ProductModel>> getCachedProducts({
    int page = 1,
    int limit = 20,
    String? category,
    String? searchQuery,
  }) async {
    try {
      final cacheBox = await box;
      
      // Check cache expiration
      final timestamp = cacheBox.get(_timestampKey) as int?;
      if (timestamp == null || 
          DateTime.now().millisecondsSinceEpoch - timestamp > 
          _cacheExpiry.inMilliseconds) {
        throw CacheException('Cache expired');
      }
      
      final cachedData = cacheBox.get(_cacheKey) as List<dynamic>?;
      if (cachedData == null) {
        throw CacheException('No cached data found');
      }
      
      List<ProductModel> products = cachedData
          .map((json) => ProductModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
      
      // Filtering and pagination
      if (category != null) {
        products = products
            .where((product) => product.category == category)
            .toList();
      }
      
      if (searchQuery != null && searchQuery.isNotEmpty) {
        products = products
            .where((product) => 
                product.name.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      }
      
      final startIndex = (page - 1) * limit;
      final endIndex = startIndex + limit;
      
      if (startIndex >= products.length) {
        return [];
      }
      
      return products.sublist(
        startIndex,
        endIndex > products.length ? products.length : endIndex,
      );
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
  
  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      final cacheBox = await box;
      final productsJson = products.map((product) => product.toJson()).toList();
      
      await cacheBox.put(_cacheKey, productsJson);
      await cacheBox.put(_timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
```

#### 4. Models

Define data structures for API responses and local storage.

```dart
// features/product/infrastructure/models/product_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
@HiveType(typeId: 0)
class ProductModel with _$ProductModel {
  const factory ProductModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String description,
    @HiveField(3) required double price,
    @HiveField(4) required String imageUrl,
    @HiveField(5) required bool isAvailable,
    @HiveField(6) @Default([]) List<String> tags,
    @HiveField(7) @Default(0.0) double rating,
    @HiveField(8) @Default(0) int reviewCount,
    @HiveField(9) String? category,
    @HiveField(10) String? createdAt,
    @HiveField(11) String? updatedAt,
  }) = _ProductModel;
  
  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}
```

#### 5. Core Infrastructure Services

```dart
// infrastructure/core/network/network_info.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

@Injectable(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;
  
  NetworkInfoImpl(this._connectivity);
  
  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}

// infrastructure/core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@module
abstract class NetworkModule {
  @singleton
  Dio provideDio() {
    final dio = Dio();
    
    dio.options = BaseOptions(
      baseUrl: 'https://api.example.com/v1',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    
    dio.interceptors.addAll([
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
      AuthInterceptor(),
      ErrorInterceptor(),
    ]);
    
    return dio;
  }
}
```

## Testing Strategy

### Repository Tests

```dart
// test/features/product/infrastructure/repositories/product_repository_impl_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  ProductRemoteDataSource,
  ProductLocalDataSource,
  NetworkInfo,
  ProductInfrastructureMapper,
])
import 'product_repository_impl_test.mocks.dart';

void main() {
  late ProductRepositoryImpl repository;
  late MockProductRemoteDataSource mockRemoteDataSource;
  late MockProductLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MockProductInfrastructureMapper mockMapper;
  
  setUp(() {
    mockRemoteDataSource = MockProductRemoteDataSource();
    mockLocalDataSource = MockProductLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockMapper = MockProductInfrastructureMapper();
    repository = ProductRepositoryImpl(
      mockRemoteDataSource,
      mockLocalDataSource,
      mockNetworkInfo,
      mockMapper,
    );
  });
  
  group('getProducts', () {
    test('should return products from remote when online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getProducts()).thenAnswer((_) async => [testProductModel]);
      when(mockLocalDataSource.cacheProducts(any)).thenAnswer((_) async {});
      when(mockMapper.modelToEntity(testProductModel)).thenReturn(testProduct);
      
      // act
      final result = await repository.getProducts();
      
      // assert
      expect(result, const Right([testProduct]));
      verify(mockRemoteDataSource.getProducts());
      verify(mockLocalDataSource.cacheProducts([testProductModel]));
    });
  });
}
```

## Design Principles

### 1. Dependency Inversion
- Implement Domain Layer interfaces
- Hide external library details
- Loose coupling through dependency injection

### 2. Single Responsibility Principle
- Each data source has only specific responsibilities
- Repository coordinates multiple data sources
- Models only represent data structures

### 3. Open-Closed Principle
- Adding new data sources extends without modifying existing code
- Flexible implementation through interfaces

## Important Notes

- **Error handling**: Proper exception handling and conversion to Failure type
- **Cache strategy**: Offline support and data consistency
- **Network optimization**: Efficient API calls and data transfer
- **Security**: Proper authentication token management
- **Performance**: Efficient processing of large data
- **Testability**: Independent testing using mocks
