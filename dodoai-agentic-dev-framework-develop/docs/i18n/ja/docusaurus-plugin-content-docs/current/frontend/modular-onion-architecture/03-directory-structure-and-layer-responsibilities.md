---
id: directory-structure-and-layer-responsibilities
title: ディレクトリ構造とレイヤー責任
---

# 03. ディレクトリ構造とレイヤー責任

Flutterアプリケーションで「Modular Onion Architecture」を実践する際、ディレクトリ構造は責任と依存関係を明確にし、開発効率と可読性に大きく影響します。この章では、各ディレクトリの設計意図とレイヤー対応に基づいて、プロジェクト全体のフォルダ構造を体系的に整理します。

## 3.1 トップレベル構造

| ディレクトリ | 役割概要 |
|-----------|---------------|
| `app/` | 起動処理、DI定義、ルーティング（Modular）設定 |
| `core/` | グローバル設定、定数、エラーハンドリング、GraphQLなど共通インターフェース群 |
| `features/` | 各ビジネス機能をDDD構造（Domain、Application、Infrastructure、Presentation）でモジュール化 |
| `infrastructure/` | アプリ全体で使用されるインフラ関連共通サービスの実装（GoogleMap、GraphQL、Loggingなど） |
| `shared/` | Atomic Designに基づく再利用可能UIパーツ、共通スタイル、レイアウト構成 |
| `pages/` | 各Featureを統合し、一つの画面を構成するUIレイヤー（View組み立て） |
| `main.dart` | アプリケーションエントリーポイント |

## 3.2 features/ ディレクトリ構造（モジュール分割形式）

```
features/
  └── {feature_name}/
       ├── domain/         # Entity、Repository Interface（純粋なドメイン知識）
       ├── application/    # UseCase、Service層（ビジネスプロセス実装）
       ├── infrastructure/ # API呼び出しとデータ取得処理（Repository実装）
       └── presentation/   # Bloc、Pages、Widgets（Atomic Design構造）
```

**特徴:**
* 各Featureは明確なモジュール単位として管理され、再利用、削除、テストが容易
* `presentation/`はさらに細分化可能：

```
presentation/
  ├── blocs/
  ├── pages/
  └── widgets/
      ├── atoms/
      ├── molecules/
      └── organisms/
```

* `export_{feature}_feature.dart`などを活用してモジュール境界を越えた参照を整理
* import順序と依存方向を維持することで、feature境界と独立性を強化

**特徴:**
* Feature単位での完全な責任分離
* DDD（ドメイン駆動設計）に基づき、UIレイヤーとビジネスレイヤーの干渉を排除
* テスト、モジュール置換、機能追加時の影響範囲を最小化

## 3.3 shared/ と Atomic Design

```
shared/
  └── presentation/
       └── components/
            ├── atoms/
            ├── molecules/
            ├── organisms/
            └── pages/
```

* **Atoms**: テキスト、ボタン、入力フィールドなどの基本パーツ
* **Molecules**: 複数のAtomsを組み合わせた入力フォーム、検索バーなど
* **Organisms**: ヘッダーやカードなど再利用可能なセクション
* **Pages**: 共通レイアウトとテンプレート（例：AppBaseLayout）

この構造により、UIコンポーネントの階層的再利用と視覚的一貫性を確保します。

## 3.4 infrastructure/

* Feature依存ではない、アプリ全体で使用される共通インフラ処理を集約
* 例：GraphQLクライアント初期化、GoogleMap Web/Nativeラッパー、エラーハンドリング
* 各Featureの`infrastructure/`はそのFeature固有の実装に限定

## 3.5 core/

* グローバルに必要な契約、設定、抽象インターフェースを保持
* `graphql/`: GraphQLインターフェース（`i_graphql_services.dart`）
* `config/`: 環境・フレーバー切り替え、グローバル変数
* `themes/`: カラーとタイポグラフィ定義
* `blocs/`: アプリ全体の状態管理（AppBlocなど）
* 他のモジュールから依存されるが、自身は何にも依存しない位置づけ

## 3.6 app/ とルーティング

* Modular DIルート（`AppModule`、`HomeModule`など）を定義
* `core_module.dart`でシングルトンバインドを一元管理
* 各Featureは`child_module/`下で個別にモジュール化し、アプリ規模に応じたルート分割を実現

このディレクトリ構造は、可読性、再利用性、モジュール性、テスタビリティを最大化するよう設計されています。
