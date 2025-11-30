# Code Structure Section (コード構造分析)

## Purpose

モジュールの構造、アーキテクチャパターン、依存関係を明らかにし、全体像を理解します。

## Directory Structure Mapping

### Standard Layout Analysis

```markdown
## Directory Structure

\`\`\`
{MODULE_NAME}/
├── src/                        # Source code
│   ├── domain/                 # Domain layer (entities, value objects)
│   ├── application/            # Application layer (use cases, services)
│   ├── infrastructure/         # Infrastructure layer (DB, APIs, frameworks)
│   └── presentation/           # Presentation layer (controllers, routes)
├── test/                       # Test files
├── config/                     # Configuration files
├── scripts/                    # Utility scripts
└── docs/                       # Documentation
\`\`\`

**Architecture Pattern**: {Clean Architecture | Layered | MVC | Other}
\`\`\`
```

### Key Files Identification

#### Entry Points
```markdown
### Main Entry Points

1. **Application Entry**: `src/index.ts` or `src/main.py`
   - Initializes the application
   - Sets up middleware
   - Starts the server on port {PORT}

2. **Module Entry**: `src/app.ts` or `src/app.py`
   - Configures routes
   - Dependency injection setup
   - Error handling configuration
```

#### Configuration Files
```markdown
### Configuration Files

| File | Purpose | Key Settings |
|------|---------|--------------|
| package.json | Dependencies, scripts | Node {version}, TypeScript, Express |
| tsconfig.json | TypeScript config | ES2021, strict mode, path aliases |
| .env.example | Environment variables | DB_URL, API_KEY, PORT |
| docker-compose.yml | Container orchestration | Services, ports, volumes |
```

## Architecture Pattern Detection

### Clean Architecture
```markdown
## Architecture: Clean Architecture

**Layers Identified**:

1. **Domain Layer** (`src/domain/`)
   - Entities: Core business objects
   - Value Objects: Immutable values
   - Domain Services: Business logic
   - Repository Interfaces: Data access contracts

2. **Application Layer** (`src/application/`)
   - Use Cases: Application-specific business rules
   - DTOs: Data Transfer Objects
   - Mappers: Entity ↔ DTO conversion

3. **Infrastructure Layer** (`src/infrastructure/`)
   - Database: PostgreSQL with Knex/TypeORM/Prisma
   - External APIs: Third-party service integrations
   - Framework: Express/FastAPI/NestJS

4. **Presentation Layer** (`src/presentation/`)
   - Controllers: HTTP request handlers
   - Routes: API endpoint definitions
   - Middleware: Authentication, validation

**Dependency Flow**: Presentation → Application → Domain ← Infrastructure
```

### Layered Architecture
```markdown
## Architecture: Layered Architecture

**Layers**:

1. **Presentation Layer**: Controllers, Views
2. **Business Logic Layer**: Services, Domain Logic
3. **Data Access Layer**: Repositories, DAOs
4. **Database Layer**: ORM, Query Builders
```

### MVC Pattern
```markdown
## Architecture: MVC (Model-View-Controller)

**Components**:

1. **Models** (`src/models/`): Data structures and business logic
2. **Views** (`src/views/`): UI templates or API responses
3. **Controllers** (`src/controllers/`): Request handling and routing
```

## Dependency Analysis

### External Dependencies

```markdown
## External Dependencies

### Production Dependencies

| Package | Version | Purpose | Critical |
|---------|---------|---------|----------|
| express | ^4.18.0 | Web framework | ✅ |
| pg | ^8.11.0 | PostgreSQL client | ✅ |
| zod | ^3.22.0 | Schema validation | ✅ |
| winston | ^3.10.0 | Logging | - |

### Development Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| typescript | ^5.2.0 | Type checking |
| jest | ^29.6.0 | Testing framework |
| eslint | ^8.48.0 | Code linting |
```

### Internal Module Dependencies

```markdown
## Internal Dependencies

### Module Dependency Graph

\`\`\`mermaid
graph TD
    A[Presentation Layer] --> B[Application Layer]
    B --> C[Domain Layer]
    A --> D[Infrastructure Layer]
    D --> C
    
    E[Auth Module] --> F[User Module]
    G[Order Module] --> F
    G --> H[Product Module]
\`\`\`

### Dependency Table

| Module | Depends On | Used By |
|--------|-----------|---------|
| UserModule | AuthModule | OrderModule, ProductModule |
| AuthModule | - | UserModule, OrderModule |
| OrderModule | UserModule, ProductModule | - |
```

### Circular Dependency Detection

```markdown
## Circular Dependencies

⚠️ **Warning**: Circular dependencies detected

1. **ModuleA ↔ ModuleB**
   - `src/modules/a/service.ts` imports from `src/modules/b/`
   - `src/modules/b/service.ts` imports from `src/modules/a/`
   - **Impact**: Potential initialization issues
   - **Recommendation**: Extract shared interface

2. **No circular dependencies detected** ✅
```

## Code Organization Patterns

### Feature-Based Organization
```markdown
## Organization: Feature-Based

\`\`\`
src/
├── features/
│   ├── user/
│   │   ├── user.entity.ts
│   │   ├── user.repository.ts
│   │   ├── user.service.ts
│   │   └── user.controller.ts
│   ├── product/
│   │   ├── product.entity.ts
│   │   ├── product.repository.ts
│   │   ├── product.service.ts
│   │   └── product.controller.ts
\`\`\`

**Benefits**: High cohesion, clear feature boundaries
```

### Layer-Based Organization
```markdown
## Organization: Layer-Based

\`\`\`
src/
├── controllers/
│   ├── user.controller.ts
│   └── product.controller.ts
├── services/
│   ├── user.service.ts
│   └── product.service.ts
├── repositories/
│   ├── user.repository.ts
│   └── product.repository.ts
├── entities/
│   ├── user.entity.ts
│   └── product.entity.ts
\`\`\`

**Benefits**: Clear technical separation
```

## Design Patterns Identified

### Repository Pattern
```typescript
// Example from codebase
interface IUserRepository {
  findById(id: string): Promise<User | null>;
  save(user: User): Promise<User>;
  delete(id: string): Promise<void>;
}

// Implementation
class UserRepository implements IUserRepository {
  // ... PostgreSQL implementation
}
```

### Dependency Injection
```typescript
// Example from codebase
class UserService {
  constructor(
    private userRepository: IUserRepository,
    private emailService: IEmailService
  ) {}
}
```

### Factory Pattern
```typescript
// Example from codebase
class UserFactory {
  static create(data: UserDTO): User {
    return new User(data.id, data.name, data.email);
  }
}
```

### Strategy Pattern
```typescript
// Example from codebase
interface PaymentStrategy {
  processPayment(amount: number): Promise<PaymentResult>;
}

class CreditCardPayment implements PaymentStrategy { }
class PayPalPayment implements PaymentStrategy { }
```

## Module Boundaries

```markdown
## Module Boundaries

### Public APIs

**Exported Interfaces**:
- `IUserService` from `@app/user`
- `IOrderService` from `@app/order`
- `IAuthService` from `@app/auth`

**Public DTOs**:
- `UserDTO`, `CreateUserDTO`, `UpdateUserDTO`
- `OrderDTO`, `CreateOrderDTO`

### Internal Implementation

**Not Exported**:
- Repository implementations
- Database models
- Internal helpers

**Encapsulation**: ✅ Good - Implementation details are hidden
```

## Code Quality Indicators

```markdown
## Code Quality Metrics

| Metric | Value | Status |
|--------|-------|--------|
| Total Files | 150 | - |
| Lines of Code | 12,500 | - |
| Avg File Size | 83 LOC | ✅ Good |
| Max File Size | 450 LOC | ⚠️ Consider splitting |
| TypeScript Coverage | 95% | ✅ Excellent |
| Test Files | 80 | ✅ Good |
| TODO Comments | 12 | ⚠️ Address |

**Code Style**: ESLint with Airbnb config
**Formatter**: Prettier
**Pre-commit Hooks**: Husky + lint-staged
```

## Path Aliases

```markdown
## Import Path Configuration

### TypeScript Path Aliases

\`\`\`json
{
  "paths": {
    "@domain/*": ["src/domain/*"],
    "@application/*": ["src/application/*"],
    "@infrastructure/*": ["src/infrastructure/*"],
    "@shared/*": ["src/shared/*"]
  }
}
\`\`\`

**Usage Example**:
\`\`\`typescript
import { User } from '@domain/entities/User';
import { UserService } from '@application/services/UserService';
\`\`\`
```

## Build and Compilation

```markdown
## Build Configuration

### Build Process

1. **TypeScript Compilation**: `tsc` or `esbuild`
2. **Output Directory**: `dist/`
3. **Source Maps**: ✅ Enabled
4. **Target**: ES2021
5. **Module System**: CommonJS

### Build Scripts

| Script | Command | Purpose |
|--------|---------|---------|
| build | `tsc` | Production build |
| dev | `ts-node-dev` | Development with hot reload |
| start | `node dist/index.js` | Run production |
| test | `jest` | Run tests |
```

## Documentation Coverage

```markdown
## Code Documentation

| Area | Coverage | Status |
|------|----------|--------|
| Public APIs | 90% | ✅ Good |
| Internal Functions | 60% | ⚠️ Improve |
| Complex Logic | 80% | ✅ Good |
| Types/Interfaces | 100% | ✅ Excellent |

**Documentation Style**: JSDoc/TSDoc
**README Quality**: ✅ Comprehensive
**API Docs**: ✅ Available (Swagger)
```

## Template Output

```markdown
# Code Structure

## Overview

{MODULE_NAME} follows a {ARCHITECTURE_PATTERN} architecture with {ORGANIZATION_STYLE} organization.

## Directory Structure

{DIRECTORY_TREE}

## Architecture

{ARCHITECTURE_DESCRIPTION}

### Layers

{LAYER_DESCRIPTIONS}

## Dependencies

### External

{EXTERNAL_DEPENDENCIES_TABLE}

### Internal

{DEPENDENCY_GRAPH}

## Design Patterns

{IDENTIFIED_PATTERNS}

## Code Quality

{QUALITY_METRICS}

## Build Configuration

{BUILD_INFO}
```

## Analysis Checklist

- [ ] Directory structure mapped
- [ ] Entry points identified
- [ ] Architecture pattern determined
- [ ] External dependencies listed
- [ ] Internal dependencies visualized
- [ ] Circular dependencies checked
- [ ] Design patterns identified
- [ ] Code organization documented
- [ ] Path aliases documented
- [ ] Build process described
