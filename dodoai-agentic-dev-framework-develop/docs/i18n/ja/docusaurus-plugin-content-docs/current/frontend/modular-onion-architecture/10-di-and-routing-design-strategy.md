---
id: di-and-routing-design-strategy
title: DIとルーティング設計戦略
---

# 10. DIとルーティング設計戦略

Flutter Modularを活用することで、DI（依存性注入）とルーティング設定を機能単位で分離しながら、再利用性とテスタビリティを向上させることができます。

## 10.1 DI（依存性注入）原則

* `Bind.factory`: Bloc、UseCaseなど状態を持つ一時的なオブジェクトに使用
* `Bind.singleton`: GraphQLClient、Repository実装などグローバル依存に使用
* 遅延初期化と循環参照を避ける：モジュール境界で適切に依存関係を解決

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

* 常にインターフェースに依存し、モジュール側で実装を切り替え
* RepositoryについてはDIコンテナでInterface → Implを明示的に表示

## 10.2 Modularルーティング

* `app_module.dart`で全体ルートを定義し、機能別Moduleで分割

```dart
class AppModule extends Module {
  @override
  List<ModularRoute> get routes => [
    ModuleRoute('/', module: HomeModule()),
    ModuleRoute('/profile', module: ProfileModule()),
  ];
}
```

* 各ModuleはChildRouteを使用して画面単位の遷移を定義

```dart
class HomeModule extends Module {
  @override
  List<ModularRoute> get routes => [
    ChildRoute('/', child: (_, __) => HomePage()),
    ChildRoute('/detail', child: (_, args) => DetailPage(id: args.data)),
  ];
}
```

## 10.3 ルーティングベストプラクティス

* モジュール単位で構成：Featureの画面遷移とDIを同一Moduleに限定
* URL文字列定数の一元化：`app_routes.dart`などで画面遷移パスを一元管理
* 引数の受け渡し：Modularの`args.data`を使用してデータを渡す
* BackStack対応の遷移制御：戻り動作を制御、`replaceNamed`を活用
