# Analysis Scope Section (分析範囲定義)

## Purpose

リバースエンジニアリングの対象範囲を明確に定義し、効率的かつ正確な分析を実現します。

## Scope Definition

### Include Patterns (含める対象)

#### Source Code
```
src/**/*.ts
src/**/*.tsx
src/**/*.js
src/**/*.jsx
src/**/*.py
```

#### Configuration Files
```
*.config.js
*.config.ts
package.json
requirements.txt
pyproject.toml
tsconfig.json
.env.example
docker-compose.yml
Dockerfile
```

#### Database Files
```
database/migrations/**/*.sql
prisma/schema.prisma
knexfile.js
seeds/**/*
```

#### Test Files
```
test/**/*.test.ts
tests/**/*.test.py
__tests__/**/*
*.spec.ts
features/**/*.feature
```

#### Documentation
```
README.md
docs/**/*.md
*.md (root level)
```

### Exclude Patterns (除外する対象)

#### Build Artifacts
```
dist/**
build/**
out/**
.next/**
coverage/**
```

#### Dependencies
```
node_modules/**
venv/**
__pycache__/**
*.pyc
.pytest_cache/**
```

#### IDE/Editor Files
```
.vscode/**
.idea/**
*.swp
*.swo
.DS_Store
```

#### Logs and Temporary Files
```
*.log
tmp/**
temp/**
.cache/**
```

## Priority Levels

### P0 (Critical - 必須分析)

1. **API Endpoints**: すべてのルート定義とハンドラー
2. **Data Models**: エンティティ、スキーマ、型定義
3. **Core Business Logic**: ドメインロジック、ユースケース
4. **Database Schema**: マイグレーション、テーブル定義

### P1 (High - 重要)

1. **Service Layer**: ビジネスサービス、ヘルパー
2. **Middleware/Interceptors**: 認証、ロギング、エラーハンドリング
3. **Configuration**: 環境変数、設定ファイル
4. **Test Coverage**: 既存テストの分析

### P2 (Medium - 推奨)

1. **Utilities**: ユーティリティ関数、ヘルパー
2. **Constants**: 定数定義、列挙型
3. **Validation Rules**: バリデーションスキーマ
4. **Documentation**: 既存のREADME、コメント

### P3 (Low - オプション)

1. **Example Code**: サンプル実装
2. **Scripts**: ビルド・デプロイスクリプト
3. **Development Tools**: 開発支援ツール
4. **Legacy Code**: 非推奨・未使用コード

## Analysis Depth

### Level 1: Surface Analysis (表層分析)
- ファイル構造のマッピング
- エントリーポイントの特定
- 主要な依存関係の抽出

**適用対象**: 大規模モジュール、初回分析

### Level 2: Standard Analysis (標準分析)
- API仕様の完全抽出
- データモデルの詳細分析
- ビジネスロジックの文書化
- テストカバレッジの評価

**適用対象**: 通常のマイクロサービス、標準モジュール

### Level 3: Deep Analysis (詳細分析)
- コードフロー分析
- パフォーマンス特性の特定
- セキュリティパターンの評価
- コード品質メトリクスの収集

**適用対象**: クリティカルサービス、複雑なドメインロジック

## Module-Specific Scope

### Backend Services (task-ms, ai-router-ms, etc.)

**Focus Areas**:
- REST/GraphQL/gRPC endpoints
- Database operations
- Business logic services
- Authentication/Authorization
- Error handling patterns

**Skip**:
- Frontend assets
- Static files
- Build configurations (unless P1)

### Frontend Applications (new_dodoai_react_app)

**Focus Areas**:
- Component hierarchy
- State management (Redux, Zustand, etc.)
- Routing configuration
- API client implementation
- Form validation

**Skip**:
- Image/media assets
- CSS preprocessor configurations
- Storybook stories (unless documenting component library)

### Shared Libraries

**Focus Areas**:
- Exported functions/classes
- Type definitions
- Interfaces/Contracts
- Usage patterns

**Skip**:
- Internal utilities (unless exported)
- Test fixtures (unless P1)

## Time Budget Allocation

### Small Module (\<5K LOC)
- **Total Time**: 2-3 hours
- **Structure Analysis**: 30 mins
- **API Extraction**: 45 mins
- **Data Model**: 30 mins
- **Business Logic**: 45 mins
- **Documentation**: 30 mins

### Medium Module (5K-20K LOC)
- **Total Time**: 4-6 hours
- **Structure Analysis**: 1 hour
- **API Extraction**: 1.5 hours
- **Data Model**: 1 hour
- **Business Logic**: 1.5 hours
- **Documentation**: 1 hour

### Large Module (\>20K LOC)
- **Total Time**: 8-12 hours (分割推奨)
- **Phase 1**: Core structure + APIs (4 hours)
- **Phase 2**: Data models + Logic (4 hours)
- **Phase 3**: Testing + Documentation (4 hours)

## Filtering Strategies

### Complexity-Based Filtering

**High Complexity (優先分析)**:
```typescript
// Criteria:
- Cyclomatic complexity > 10
- Dependencies > 5
- Lines of code > 200
- Used by > 3 modules
```

**Low Complexity (スキップ可能)**:
```typescript
// Criteria:
- Simple getters/setters
- Pure utility functions
- Trivial mappers
- Auto-generated code
```

### Impact-Based Filtering

**High Impact (必須)**:
- Public APIs
- Database operations
- Authentication/Authorization
- Core business logic

**Low Impact (オプション)**:
- Internal helpers
- Development utilities
- Logging wrappers
- Deprecated code

## Validation Checklist

Before starting analysis, confirm:

- [ ] Target module is clearly identified
- [ ] Include/exclude patterns are defined
- [ ] Priority levels are assigned
- [ ] Analysis depth is selected
- [ ] Time budget is allocated
- [ ] Module-specific focus areas are identified

## Dynamic Scope Adjustment

During analysis, adjust scope if:

1. **Complexity exceeds estimate**: Break into smaller chunks
2. **Critical gaps found**: Increase priority of related areas
3. **Time budget exceeded**: Reduce analysis depth
4. **Dependencies discovered**: Expand scope to include critical deps

## Output Scope Documentation

Include in final specification:

```markdown
## Analysis Scope

**Module**: {MODULE_NAME}
**Analysis Date**: {DATE}
**Analysis Level**: Level 1/2/3
**Total Files Analyzed**: {COUNT}
**Lines of Code**: {LOC}
**Priority Coverage**:
- P0: 100%
- P1: 95%
- P2: 70%
- P3: 20%

**Excluded from Analysis**:
- {List of excluded areas with rationale}

**Known Gaps**:
- {Areas that require manual review}
```

## Notes

- このスコープ定義は初期設定です。分析中に調整可能です。
- 不明な点があれば、優先度の高い項目から開始してください。
- 時間制約がある場合は、P0とP1に集中してください。
