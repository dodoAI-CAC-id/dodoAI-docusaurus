---
id: layer-responsibility-matrix
title: Layer Responsibility Matrix
---

# 05. Layer Responsibility Matrix

This chapter explicitly defines responsibility locations and dependency boundaries for each layer. This eliminates design-level confusion about "where to write which processing" and improves team-wide understanding and productivity.

## 5.1 Layer Responsibility Table

| Layer | Data Acquisition | Business Logic | UI Expression | State Management | Screen Construction | External Dependencies |
|-------|------------------|----------------|---------------|------------------|---------------------|----------------------|
| `features/domain` | ❌ | ✅ (Entity unit) | ❌ | ❌ | ❌ | ❌ |
| `features/application` | ✅ (via Repo) | ✅ (UseCase unit) | ❌ | ❌ | ❌ | ❌ |
| `features/presentation` | ❌ | ❌ | ✅ | ✅ | ✅ | ❌ |
| `features/infrastructure` | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ |
| `shared/presentation` | ❌ | ❌ | ✅ (Reusable UI) | ❌ | ❌ | ❌ |
| `pages/` | ✅ (Integration) | ✅ (Light coordination) | ✅ | ✅ | ✅ | ❌ |
| `infrastructure/` | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ |
| `core/` | Abstract only | Abstract only | ❌ | ❌ | ❌ | ❌ |
| `app/` | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ (Startup only) |

## 5.2 Supplementary Rules

* Allow only unidirectional flow: UI → Bloc → UseCase → Repository → Source → API
* UseCase can connect to external sources only through Repository Interface
* RepositoryImpl is constructed depending on DataSource like GraphQL or REST
* Bloc handles only state transitions and holds no logic
