# Business Logic Section (ビジネスロジック抽出)

## Purpose

コアドメインロジック、ユースケース、ビジネスルールを抽出し、システムの振る舞いを文書化します。

## Core Domain Logic

```markdown
## Domain Services

### UserDomainService

**Location**: `src/domain/services/UserDomainService.ts`

**Responsibilities**:
- User creation with password hashing
- Email uniqueness validation
- Role assignment logic
- User profile updates

**Key Methods**:

\`\`\`typescript
class UserDomainService {
  // Create new user with validation
  async createUser(data: CreateUserData): Promise<User> {
    // 1. Validate email uniqueness
    const existingUser = await this.userRepository.findByEmail(data.email);
    if (existingUser) {
      throw new DomainError('Email already exists');
    }
    
    // 2. Hash password
    const passwordHash = await this.hashPassword(data.password);
    
    // 3. Create user entity
    const user = new User(
      uuid(),
      data.name,
      data.email,
      passwordHash,
      data.role || UserRole.USER,
      new Date(),
      new Date()
    );
    
    // 4. Persist
    return await this.userRepository.save(user);
  }
  
  // Update user profile with business rules
  async updateUserProfile(userId: string, data: UpdateUserData): Promise<User> {
    const user = await this.userRepository.findById(userId);
    if (!user) {
      throw new DomainError('User not found');
    }
    
    // Business rule: Admin cannot change their own role
    if (data.role && user.isAdmin() && data.role !== UserRole.ADMIN) {
      throw new DomainError('Admin cannot demote themselves');
    }
    
    user.updateProfile(data.name, data.email);
    return await this.userRepository.save(user);
  }
}
\`\`\`
```

## Use Cases / Application Services

```markdown
## Application Use Cases

### CreateUserUseCase

**Actor**: Admin
**Preconditions**: User must be authenticated as admin
**Postconditions**: New user created in system

**Flow**:

\`\`\`mermaid
sequenceDiagram
    participant Controller
    participant UseCase as CreateUserUseCase
    participant Domain as UserDomainService
    participant Repo as UserRepository
    participant DB as Database
    
    Controller->>UseCase: execute(dto)
    UseCase->>UseCase: validate input
    UseCase->>Domain: createUser(data)
    Domain->>Repo: findByEmail(email)
    Repo->>DB: SELECT * FROM users WHERE email = ?
    DB-->>Repo: null
    Repo-->>Domain: null
    Domain->>Domain: hashPassword()
    Domain->>Repo: save(user)
    Repo->>DB: INSERT INTO users
    DB-->>Repo: user
    Repo-->>Domain: user
    Domain-->>UseCase: user
    UseCase->>UseCase: mapToDTO()
    UseCase-->>Controller: UserResponseDTO
\`\`\`

**Implementation**:

\`\`\`typescript
export class CreateUserUseCase {
  constructor(
    private userDomainService: UserDomainService,
    private userMapper: UserMapper
  ) {}

  async execute(dto: CreateUserDTO): Promise<UserResponseDTO> {
    // 1. Validate input
    const validatedData = CreateUserSchema.parse(dto);
    
    // 2. Execute domain logic
    const user = await this.userDomainService.createUser(validatedData);
    
    // 3. Map to DTO
    return this.userMapper.toDTO(user);
  }
}
\`\`\`

### GetUserListUseCase

**Actor**: Admin
**Preconditions**: User must be authenticated
**Postconditions**: Paginated list of users returned

**Business Rules**:
- Regular users can only see active (non-deleted) users
- Admins can see all users including soft-deleted
- Results are paginated with max 100 items per page
- Default sort is by creation date (desc)

**Implementation**:

\`\`\`typescript
export class GetUserListUseCase {
  async execute(
    query: UserListQuery,
    currentUser: User
  ): Promise<UserListResponseDTO> {
    // Apply business rules based on user role
    const filters = {
      ...query,
      includeDeleted: currentUser.isAdmin()
    };
    
    // Enforce max page size
    filters.limit = Math.min(filters.limit || 20, 100);
    
    const [users, total] = await this.userRepository.findWithPagination(filters);
    
    return {
      data: users.map(u => this.userMapper.toDTO(u)),
      pagination: {
        page: filters.page,
        limit: filters.limit,
        total,
        totalPages: Math.ceil(total / filters.limit)
      }
    };
  }
}
\`\`\`
```

## Business Rules Catalog

```markdown
## Business Rules

### User Management

| Rule ID | Rule | Enforcement Layer |
|---------|------|-------------------|
| BR-U001 | Email must be unique | Domain + Database |
| BR-U002 | Password must be at least 8 characters | Application + Database |
| BR-U003 | Admin cannot change their own role | Domain |
| BR-U004 | Deleted users cannot login | Application |
| BR-U005 | User email cannot be changed after creation | Domain |

### Order Management

| Rule ID | Rule | Enforcement Layer |
|---------|------|-------------------|
| BR-O001 | Order amount must be >= 0 | Domain + Database |
| BR-O002 | Cancelled orders cannot be modified | Domain |
| BR-O003 | Order must have at least one item | Domain |
| BR-O004 | Order total must match sum of items | Domain |
| BR-O005 | Completed orders cannot be cancelled | Domain |

### Authorization Rules

| Rule ID | Rule | Enforcement Layer |
|---------|------|-------------------|
| BR-A001 | Only admins can create users | Application |
| BR-A002 | Users can only view their own orders | Application |
| BR-A003 | Superadmins can access all resources | Application |
```

## Workflow Identification

```markdown
## Key Workflows

### User Registration Workflow

\`\`\`mermaid
stateDiagram-v2
    [*] --> SubmitForm: User fills form
    SubmitForm --> Validating: Submit
    Validating --> CreateUser: Valid
    Validating --> ShowErrors: Invalid
    ShowErrors --> SubmitForm: Retry
    CreateUser --> SendEmail: Success
    CreateUser --> ShowErrors: Failure
    SendEmail --> AwaitConfirmation
    AwaitConfirmation --> Active: Confirm email
    AwaitConfirmation --> Expired: 24h timeout
    Expired --> [*]
    Active --> [*]
\`\`\`

### Order Processing Workflow

\`\`\`mermaid
stateDiagram-v2
    [*] --> Draft: Create order
    Draft --> Pending: Submit
    Draft --> Cancelled: Cancel
    Pending --> Processing: Payment received
    Pending --> Cancelled: Payment failed
    Processing --> Shipped: Items shipped
    Processing --> Cancelled: Out of stock
    Shipped --> Delivered: Delivery confirmed
    Delivered --> Completed
    Completed --> [*]
    Cancelled --> [*]
\`\`\`

### Authentication Flow

\`\`\`mermaid
sequenceDiagram
    participant User
    participant Client
    participant API
    participant Auth
    participant DB
    
    User->>Client: Enter credentials
    Client->>API: POST /auth/login
    API->>Auth: validateCredentials()
    Auth->>DB: findUserByEmail()
    DB-->>Auth: user
    Auth->>Auth: verifyPassword()
    alt Valid credentials
        Auth->>Auth: generateTokens()
        Auth-->>API: {accessToken, refreshToken}
        API-->>Client: 200 OK + tokens
        Client->>Client: Store tokens
        Client-->>User: Login successful
    else Invalid credentials
        Auth-->>API: Invalid credentials
        API-->>Client: 401 Unauthorized
        Client-->>User: Login failed
    end
\`\`\`
```

## State Machines

```markdown
## State Transitions

### Order State Machine

**States**: Draft, Pending, Processing, Shipped, Delivered, Completed, Cancelled

**Transitions**:

| From | Event | To | Guard | Action |
|------|-------|----|----|---------|
| Draft | submit | Pending | hasItems() | validateItems() |
| Draft | cancel | Cancelled | - | - |
| Pending | paymentReceived | Processing | - | notifyWarehouse() |
| Pending | paymentFailed | Cancelled | - | notifyCustomer() |
| Processing | ship | Shipped | itemsAvailable() | updateTracking() |
| Processing | outOfStock | Cancelled | - | refund() |
| Shipped | deliver | Delivered | - | confirmDelivery() |
| Delivered | complete | Completed | after48Hours() | closeOrder() |

**Implementation**:

\`\`\`typescript
class OrderStateMachine {
  async transition(
    order: Order, 
    event: OrderEvent
  ): Promise<Order> {
    const currentState = order.status;
    const nextState = this.getNextState(currentState, event);
    
    // Validate transition
    if (!this.isValidTransition(currentState, event, nextState)) {
      throw new InvalidStateTransitionError();
    }
    
    // Execute guard
    if (!await this.checkGuard(order, event)) {
      throw new GuardFailedError();
    }
    
    // Execute action
    await this.executeAction(order, event);
    
    // Update state
    order.status = nextState;
    return await this.orderRepository.save(order);
  }
}
\`\`\`
```

## Validation Rules

```markdown
## Input Validation

### CreateUserDTO Validation

\`\`\`typescript
const CreateUserSchema = z.object({
  name: z.string()
    .min(2, 'Name must be at least 2 characters')
    .max(50, 'Name must be at most 50 characters')
    .regex(/^[a-zA-Z\s]+$/, 'Name can only contain letters and spaces'),
  
  email: z.string()
    .email('Invalid email format')
    .max(255, 'Email too long')
    .transform(val => val.toLowerCase()),
  
  password: z.string()
    .min(8, 'Password must be at least 8 characters')
    .max(100, 'Password too long')
    .regex(/[A-Z]/, 'Must contain uppercase letter')
    .regex(/[a-z]/, 'Must contain lowercase letter')
    .regex(/[0-9]/, 'Must contain number')
    .regex(/[^a-zA-Z0-9]/, 'Must contain special character'),
  
  role: z.enum(['user', 'admin', 'superadmin'])
    .optional()
    .default('user')
});
\`\`\`

### Business Logic Validation

\`\`\`typescript
class UserValidator {
  async validateUniqueEmail(email: string): Promise<void> {
    const existing = await this.userRepository.findByEmail(email);
    if (existing) {
      throw new ValidationError('Email already in use');
    }
  }
  
  validateRoleChange(currentUser: User, newRole: UserRole): void {
    // Admin cannot demote themselves
    if (currentUser.isAdmin() && newRole !== UserRole.ADMIN) {
      throw new ValidationError('Cannot change own admin role');
    }
    
    // Only superadmin can create superadmins
    if (newRole === UserRole.SUPERADMIN && !currentUser.isSuperAdmin()) {
      throw new ValidationError('Insufficient permissions');
    }
  }
}
\`\`\`
```

## Domain Events

```markdown
## Domain Events

### Event Catalog

| Event | Trigger | Subscribers | Payload |
|-------|---------|-------------|---------|
| UserCreated | User registration | EmailService, AuditLog | {userId, email, timestamp} |
| UserUpdated | Profile update | AuditLog, Cache | {userId, changes, timestamp} |
| UserDeleted | Soft delete | EmailService, AuditLog | {userId, timestamp} |
| OrderPlaced | Order submission | InventoryService, EmailService | {orderId, userId, items} |
| OrderCompleted | Order completion | RewardService, AnalyticsService | {orderId, totalAmount} |

### Event Implementation

\`\`\`typescript
// Event definition
export class UserCreatedEvent extends DomainEvent {
  constructor(
    public readonly userId: string,
    public readonly email: string,
    public readonly timestamp: Date = new Date()
  ) {
    super('UserCreated', timestamp);
  }
}

// Event publisher
class EventPublisher {
  private subscribers: Map<string, EventHandler[]> = new Map();
  
  subscribe(eventType: string, handler: EventHandler): void {
    const handlers = this.subscribers.get(eventType) || [];
    handlers.push(handler);
    this.subscribers.set(eventType, handlers);
  }
  
  async publish(event: DomainEvent): Promise<void> {
    const handlers = this.subscribers.get(event.type) || [];
    await Promise.all(handlers.map(h => h.handle(event)));
  }
}

// Event handler
class SendWelcomeEmailHandler implements EventHandler {
  async handle(event: UserCreatedEvent): Promise<void> {
    await this.emailService.sendWelcomeEmail(
      event.email,
      event.userId
    );
  }
}
\`\`\`
```

## Algorithm Documentation

```markdown
## Complex Algorithms

### Password Hashing Algorithm

**Algorithm**: bcrypt with salt rounds = 10

\`\`\`typescript
async function hashPassword(plainPassword: string): Promise<string> {
  const saltRounds = 10;
  return await bcrypt.hash(plainPassword, saltRounds);
}

async function verifyPassword(
  plainPassword: string, 
  hashedPassword: string
): Promise<boolean> {
  return await bcrypt.compare(plainPassword, hashedPassword);
}
\`\`\`

### Order Total Calculation

\`\`\`typescript
function calculateOrderTotal(order: Order): number {
  // 1. Sum item prices
  const itemsTotal = order.items.reduce(
    (sum, item) => sum + (item.unitPrice * item.quantity),
    0
  );
  
  // 2. Apply discount if any
  const discountAmount = order.discount
    ? itemsTotal * (order.discount.percentage / 100)
    : 0;
  
  // 3. Calculate subtotal
  const subtotal = itemsTotal - discountAmount;
  
  // 4. Add tax
  const taxAmount = subtotal * (order.taxRate / 100);
  
  // 5. Add shipping
  const shippingCost = calculateShipping(order);
  
  // 6. Final total
  return subtotal + taxAmount + shippingCost;
}
\`\`\`
```

## Analysis Checklist

- [ ] Core domain services documented
- [ ] Use cases extracted and visualized
- [ ] Business rules catalogued
- [ ] Workflows identified with diagrams
- [ ] State machines documented
- [ ] Validation rules extracted
- [ ] Domain events listed
- [ ] Complex algorithms documented
- [ ] Sequence diagrams created
- [ ] Business constraints documented
