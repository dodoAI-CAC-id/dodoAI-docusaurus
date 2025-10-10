---
id: layer-responsibility-matrix
title: レイヤー責任マトリックス
---

# 05. レイヤー責任マトリックス

この章では、各レイヤーの責任場所と依存境界を明示的に定義します。これにより「どの処理をどこに書くか」という設計レベルの混乱を解消し、チーム全体の理解と生産性を向上させます。

## 5.1 レイヤー責任表

| レイヤー | データ取得 | ビジネスロジック | UI表現 | 状態管理 | 画面構築 | 外部依存 |
|-------|------------------|----------------|---------------|------------------|---------------------|----------------------|
| `features/domain` | ❌ | ✅ (Entity単位) | ❌ | ❌ | ❌ | ❌ |
| `features/application` | ✅ (Repo経由) | ✅ (UseCase単位) | ❌ | ❌ | ❌ | ❌ |
| `features/presentation` | ❌ | ❌ | ✅ | ✅ | ✅ | ❌ |
| `features/infrastructure` | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ |
| `shared/presentation` | ❌ | ❌ | ✅ (再利用可能UI) | ❌ | ❌ | ❌ |
| `pages/` | ✅ (統合) | ✅ (軽い調整) | ✅ | ✅ | ✅ | ❌ |
| `infrastructure/` | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ |
| `core/` | 抽象のみ | 抽象のみ | ❌ | ❌ | ❌ | ❌ |
| `app/` | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ (起動時のみ) |

## 5.2 補足ルール

* 単方向フローのみ許可：UI → Bloc → UseCase → Repository → Source → API
* UseCaseは Repository Interface を通してのみ外部ソースに接続可能
* RepositoryImplは GraphQL や REST などの DataSource に依存して構築
* Bloc は状態遷移のみを処理し、ロジックは持たない
