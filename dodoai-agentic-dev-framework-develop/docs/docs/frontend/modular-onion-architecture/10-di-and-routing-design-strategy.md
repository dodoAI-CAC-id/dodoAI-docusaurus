---
id: di-and-routing-design-strategy
title: DI and Routing Design Strategy
---

# 10. DI and Routing Design Strategy

By utilizing Flutter Modular, DI (Dependency Injection) and routing configuration can be separated by functional unit while enhancing reusability and testability.

## 10.1 DI (Dependency Injection) Principles

* `Bind.factory`: Use for temporary objects with state like Bloc, UseCase
* `Bind.singleton`: Use for global dependencies like GraphQLClient, Repository implementations
* Avoid lazy initialization and circular references: Properly resolve dependencies at module boundaries

```dart
class HomeModule extends Module {
  @override
  List<Bind> get binds => [
    Bind.singleton((i) => GraphQLService()),
    Bind.factory((i) => DashboardRepositoryImpl(i())),
    Bind.factory((i) => GetHomeDataUseCase(i())),
    Bind.factory((i) => HomeBloc(i())),
  ];
}
```

* Always depend on interface and switch implementation on module side
* Explicitly show Interface → Impl in DI container for repository

## 10.2 Modular Routing

* Define overall routes in `app_module.dart` and divide by functional Module

```dart
class AppModule extends Module {
  @override
  List<ModularRoute> get routes => [
    ModuleRoute('/', module: HomeModule()),
    ModuleRoute('/profile', module: ProfileModule()),
  ];
}
```

* Each Module defines screen-unit transitions using ChildRoute

```dart
class HomeModule extends Module {
  @override
  List<ModularRoute> get routes => [
    ChildRoute('/', child: (_, __) => HomePage()),
    ChildRoute('/detail', child: (_, args) => DetailPage(id: args.data)),
  ];
}
```

## 10.3 Routing Best Practices

* Compose by module unit: Confine Feature's screen transitions and DI to same Module
* Centralize URL string constants: Centrally manage screen transition paths in `app_routes.dart` etc.
* Argument passing: Use Modular's `args.data` to pass data
* BackStack-aware transition control: Control return behavior, utilize `replaceNamed`
