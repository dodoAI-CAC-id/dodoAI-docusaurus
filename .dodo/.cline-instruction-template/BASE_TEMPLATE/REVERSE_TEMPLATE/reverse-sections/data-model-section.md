# Data Model Section (データモデル抽出)

## Purpose

データベーススキーマ、エンティティ、型定義を抽出し、データ構造を明確化します。

## Database Schema Analysis

### Table Definitions

```markdown
## Database Tables

### users

**Schema**: `public`

| Column | Type | Nullable | Default | Constraints |
|--------|------|----------|---------|-------------|
| id | UUID | NO | gen_random_uuid() | PRIMARY KEY |
| name | VARCHAR(255) | NO | - | - |
| email | VARCHAR(255) | NO | - | UNIQUE |
| password_hash | VARCHAR(255) | NO | - | - |
| role | VARCHAR(50) | NO | 'user' | CHECK (role IN ('user', 'admin')) |
| created_at | TIMESTAMP | NO | CURRENT_TIMESTAMP | - |
| updated_at | TIMESTAMP | NO | CURRENT_TIMESTAMP | - |
| deleted_at | TIMESTAMP | YES | NULL | - |

**Indexes**:
- `idx_users_email` ON `email` (UNIQUE)
- `idx_users_role` ON `role`
- `idx_users_created_at` ON `created_at`

**Triggers**:
- `update_users_updated_at` BEFORE UPDATE: Sets `updated_at` to current timestamp

### orders

**Schema**: `public`

| Column | Type | Nullable | Default | Constraints |
|--------|------|----------|---------|-------------|
| id | UUID | NO | gen_random_uuid() | PRIMARY KEY |
| user_id | UUID | NO | - | FOREIGN KEY → users(id) |
| total_amount | DECIMAL(10,2) | NO | - | CHECK (total_amount >= 0) |
| status | VARCHAR(50) | NO | 'pending' | CHECK (status IN ('pending', 'completed', 'cancelled')) |
| created_at | TIMESTAMP | NO | CURRENT_TIMESTAMP | - |
| updated_at | TIMESTAMP | NO | CURRENT_TIMESTAMP | - |

**Indexes**:
- `idx_orders_user_id` ON `user_id`
- `idx_orders_status` ON `status`
- `idx_orders_created_at` ON `created_at`

**Foreign Keys**:
- `fk_orders_user_id` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
```

### Entity Relationships

```markdown
## Entity Relationship Diagram

\`\`\`mermaid
erDiagram
    users ||--o{ orders : places
    users ||--o{ sessions : has
    orders ||--|{ order_items : contains
    products ||--o{ order_items : "ordered in"
    categories ||--o{ products : categorizes
    
    users {
        uuid id PK
        string name
        string email UK
        string password_hash
        string role
        timestamp created_at
        timestamp updated_at
    }
    
    orders {
        uuid id PK
        uuid user_id FK
        decimal total_amount
        string status
        timestamp created_at
        timestamp updated_at
    }
    
    order_items {
        uuid id PK
        uuid order_id FK
        uuid product_id FK
        int quantity
        decimal unit_price
    }
    
    products {
        uuid id PK
        uuid category_id FK
        string name
        text description
        decimal price
        int stock
    }
    
    categories {
        uuid id PK
        string name
        text description
    }
\`\`\`
```

## Entity/Domain Models

### TypeScript Entities

```typescript
// User Entity
export class User {
  constructor(
    public readonly id: string,
    public name: string,
    public email: string,
    private passwordHash: string,
    public role: UserRole,
    public readonly createdAt: Date,
    public updatedAt: Date,
    public deletedAt: Date | null = null
  ) {}

  // Business logic methods
  isAdmin(): boolean {
    return this.role === UserRole.ADMIN;
  }

  updateProfile(name: string, email: string): void {
    this.name = name;
    this.email = email;
    this.updatedAt = new Date();
  }

  softDelete(): void {
    this.deletedAt = new Date();
  }
}

// Value Object
export class Email {
  private constructor(public readonly value: string) {}

  static create(email: string): Email {
    if (!this.isValid(email)) {
      throw new Error('Invalid email format');
    }
    return new Email(email);
  }

  private static isValid(email: string): boolean {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  }
}

// Enum
export enum UserRole {
  USER = 'user',
  ADMIN = 'admin',
  SUPERADMIN = 'superadmin'
}
```

### Python Entities

```python
# User Entity (Python)
from dataclasses import dataclass
from datetime import datetime
from enum import Enum
from typing import Optional

class UserRole(Enum):
    USER = "user"
    ADMIN = "admin"
    SUPERADMIN = "superadmin"

@dataclass
class User:
    id: str
    name: str
    email: str
    password_hash: str
    role: UserRole
    created_at: datetime
    updated_at: datetime
    deleted_at: Optional[datetime] = None

    def is_admin(self) -> bool:
        return self.role in (UserRole.ADMIN, UserRole.SUPERADMIN)

    def update_profile(self, name: str, email: str) -> None:
        self.name = name
        self.email = email
        self.updated_at = datetime.utcnow()
```

## DTOs (Data Transfer Objects)

```typescript
// Input DTOs
export interface CreateUserDTO {
  name: string;
  email: string;
  password: string;
  role?: UserRole;
}

export interface UpdateUserDTO {
  name?: string;
  email?: string;
  password?: string;
  role?: UserRole;
}

// Output DTOs
export interface UserResponseDTO {
  id: string;
  name: string;
  email: string;
  role: UserRole;
  createdAt: string; // ISO8601
  updatedAt: string; // ISO8601
}

// List Response DTO
export interface UserListResponseDTO {
  data: UserResponseDTO[];
  pagination: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
  };
}
```

## Validation Schemas

```typescript
// Zod Validation Schema
import { z } from 'zod';

export const CreateUserSchema = z.object({
  name: z.string()
    .min(2, 'Name must be at least 2 characters')
    .max(50, 'Name must be at most 50 characters'),
  email: z.string()
    .email('Invalid email format')
    .max(255, 'Email must be at most 255 characters'),
  password: z.string()
    .min(8, 'Password must be at least 8 characters')
    .regex(/[A-Z]/, 'Password must contain at least one uppercase letter')
    .regex(/[a-z]/, 'Password must contain at least one lowercase letter')
    .regex(/[0-9]/, 'Password must contain at least one number'),
  role: z.enum(['user', 'admin', 'superadmin']).optional()
});

export const UpdateUserSchema = CreateUserSchema.partial();
```

## ORM Mappings

### TypeORM (TypeScript)

```typescript
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, DeleteDateColumn } from 'typeorm';

@Entity('users')
export class UserEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 255 })
  name: string;

  @Column({ type: 'varchar', length: 255, unique: true })
  email: string;

  @Column({ type: 'varchar', length: 255, name: 'password_hash' })
  passwordHash: string;

  @Column({
    type: 'enum',
    enum: UserRole,
    default: UserRole.USER
  })
  role: UserRole;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at' })
  deletedAt: Date | null;
}
```

### Prisma (TypeScript)

```prisma
model User {
  id           String   @id @default(uuid())
  name         String   @db.VarChar(255)
  email        String   @unique @db.VarChar(255)
  passwordHash String   @map("password_hash") @db.VarChar(255)
  role         UserRole @default(USER)
  createdAt    DateTime @default(now()) @map("created_at")
  updatedAt    DateTime @updatedAt @map("updated_at")
  deletedAt    DateTime? @map("deleted_at")
  
  orders       Order[]
  sessions     Session[]

  @@index([email])
  @@index([role])
  @@map("users")
}

enum UserRole {
  USER
  ADMIN
  SUPERADMIN
}
```

### SQLAlchemy (Python)

```python
from sqlalchemy import Column, String, DateTime, Enum
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime
import uuid

Base = declarative_base()

class UserModel(Base):
    __tablename__ = 'users'
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String(255), nullable=False)
    email = Column(String(255), unique=True, nullable=False)
    password_hash = Column(String(255), nullable=False)
    role = Column(Enum('user', 'admin', 'superadmin', name='user_role'), 
                  default='user', nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, 
                       onupdate=datetime.utcnow, nullable=False)
    deleted_at = Column(DateTime, nullable=True)
```

## Mappers

```typescript
// Entity ↔ DTO Mapper
export class UserMapper {
  static toDTO(entity: User): UserResponseDTO {
    return {
      id: entity.id,
      name: entity.name,
      email: entity.email,
      role: entity.role,
      createdAt: entity.createdAt.toISOString(),
      updatedAt: entity.updatedAt.toISOString()
    };
  }

  static toDomain(dto: CreateUserDTO, hashedPassword: string): User {
    return new User(
      uuid(),
      dto.name,
      dto.email,
      hashedPassword,
      dto.role || UserRole.USER,
      new Date(),
      new Date()
    );
  }

  static toEntity(domain: User): UserEntity {
    const entity = new UserEntity();
    entity.id = domain.id;
    entity.name = domain.name;
    entity.email = domain.email;
    entity.passwordHash = domain['passwordHash'];
    entity.role = domain.role;
    entity.createdAt = domain.createdAt;
    entity.updatedAt = domain.updatedAt;
    entity.deletedAt = domain.deletedAt;
    return entity;
  }
}
```

## Database Migrations

```markdown
## Migration Files

### 000001_create_users_table.up.sql

\`\`\`sql
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL DEFAULT 'user' 
        CHECK (role IN ('user', 'admin', 'superadmin')),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_created_at ON users(created_at);

-- Trigger for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
\`\`\`

### 000001_create_users_table.down.sql

\`\`\`sql
DROP TRIGGER IF EXISTS update_users_updated_at ON users;
DROP FUNCTION IF EXISTS update_updated_at_column();
DROP TABLE IF EXISTS users;
\`\`\`
```

## Data Constraints

```markdown
## Business Constraints

### Validation Rules

1. **Email Uniqueness**: Email must be unique across all users
2. **Password Strength**: Min 8 chars, must contain uppercase, lowercase, and number
3. **Name Length**: 2-50 characters
4. **Role Values**: Only 'user', 'admin', or 'superadmin'
5. **Order Amount**: Must be >= 0
6. **Order Status**: Only 'pending', 'completed', or 'cancelled'

### Database Constraints

\`\`\`sql
-- Check constraints
ALTER TABLE users ADD CONSTRAINT check_role 
    CHECK (role IN ('user', 'admin', 'superadmin'));

ALTER TABLE orders ADD CONSTRAINT check_total_amount 
    CHECK (total_amount >= 0);

ALTER TABLE orders ADD CONSTRAINT check_status 
    CHECK (status IN ('pending', 'completed', 'cancelled'));

-- Unique constraints
ALTER TABLE users ADD CONSTRAINT unique_email UNIQUE (email);

-- Foreign key constraints
ALTER TABLE orders ADD CONSTRAINT fk_orders_user_id 
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
\`\`\`
```

## Type Definitions

```typescript
// Type aliases
export type UserId = string;
export type OrderId = string;
export type Email = string;

// Union types
export type OrderStatus = 'pending' | 'completed' | 'cancelled';
export type UserRole = 'user' | 'admin' | 'superadmin';

// Intersection types
export type UserWithOrders = User & { orders: Order[] };

// Generic types
export type Repository<T> = {
  findById(id: string): Promise<T | null>;
  save(entity: T): Promise<T>;
  delete(id: string): Promise<void>;
};

// Utility types
export type CreateUserInput = Omit<User, 'id' | 'createdAt' | 'updatedAt' | 'deletedAt'>;
export type UpdateUserInput = Partial<CreateUserInput>;
```

## Analysis Checklist

- [ ] All database tables documented
- [ ] Entity relationships visualized
- [ ] Domain entities extracted
- [ ] DTOs defined
- [ ] Validation schemas documented
- [ ] ORM mappings identified
- [ ] Mappers documented
- [ ] Database migrations listed
- [ ] Data constraints catalogued
- [ ] Type definitions extracted
