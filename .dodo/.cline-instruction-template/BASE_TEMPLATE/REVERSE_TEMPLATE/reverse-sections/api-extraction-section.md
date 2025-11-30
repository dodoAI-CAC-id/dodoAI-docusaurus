# API Extraction Section (API仕様抽出)

## Purpose

すべてのAPIエンドポイントを抽出し、リクエスト/レスポンス仕様を文書化します。

## Endpoint Discovery

### REST API Extraction

```markdown
## REST API Endpoints

### User Management

#### GET /api/v1/users

**Description**: Retrieve list of users

**Authentication**: Required (Bearer Token)

**Query Parameters**:
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| page | number | No | 1 | Page number |
| limit | number | No | 20 | Items per page |
| sort | string | No | 'createdAt' | Sort field |
| order | 'asc'\|'desc' | No | 'desc' | Sort order |

**Response**: 200 OK
\`\`\`json
{
  "data": [
    {
      "id": "uuid",
      "name": "string",
      "email": "string",
      "createdAt": "ISO8601",
      "updatedAt": "ISO8601"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "totalPages": 5
  }
}
\`\`\`

**Error Responses**:
- 401 Unauthorized: Missing or invalid token
- 403 Forbidden: Insufficient permissions
- 500 Internal Server Error: Server error

#### POST /api/v1/users

**Description**: Create a new user

**Authentication**: Required (Admin role)

**Request Body**:
\`\`\`json
{
  "name": "string",
  "email": "string",
  "password": "string",
  "role": "user" | "admin"
}
\`\`\`

**Validation Rules**:
- name: Required, 2-50 characters
- email: Required, valid email format, unique
- password: Required, min 8 characters, must contain uppercase, lowercase, number
- role: Optional, defaults to "user"

**Response**: 201 Created
\`\`\`json
{
  "id": "uuid",
  "name": "string",
  "email": "string",
  "role": "user",
  "createdAt": "ISO8601"
}
\`\`\`

**Error Responses**:
- 400 Bad Request: Validation error
- 401 Unauthorized: Not authenticated
- 403 Forbidden: Not admin
- 409 Conflict: Email already exists
```

### GraphQL API Extraction

```markdown
## GraphQL API

### Schema

\`\`\`graphql
type User {
  id: ID!
  name: String!
  email: String!
  role: UserRole!
  createdAt: DateTime!
  updatedAt: DateTime!
}

enum UserRole {
  USER
  ADMIN
}

type Query {
  users(page: Int, limit: Int): UserConnection!
  user(id: ID!): User
}

type Mutation {
  createUser(input: CreateUserInput!): User!
  updateUser(id: ID!, input: UpdateUserInput!): User!
  deleteUser(id: ID!): Boolean!
}

input CreateUserInput {
  name: String!
  email: String!
  password: String!
  role: UserRole
}
\`\`\`

### Example Queries

**Get Users**:
\`\`\`graphql
query GetUsers($page: Int, $limit: Int) {
  users(page: $page, limit: $limit) {
    nodes {
      id
      name
      email
    }
    pageInfo {
      hasNextPage
      hasPreviousPage
    }
  }
}
\`\`\`
```

### gRPC API Extraction

```markdown
## gRPC API

### Service Definition

\`\`\`protobuf
syntax = "proto3";

package user.v1;

service UserService {
  rpc GetUser(GetUserRequest) returns (GetUserResponse);
  rpc CreateUser(CreateUserRequest) returns (CreateUserResponse);
  rpc ListUsers(ListUsersRequest) returns (ListUsersResponse);
}

message User {
  string id = 1;
  string name = 2;
  string email = 3;
  string role = 4;
}

message GetUserRequest {
  string id = 1;
}

message GetUserResponse {
  User user = 1;
}
\`\`\`
```

## Authentication & Authorization

```markdown
## Authentication

### Method: JWT Bearer Token

**Token Location**: Authorization header
**Format**: `Bearer <token>`
**Token Lifetime**: 24 hours
**Refresh Token**: Yes, 30 days

### Authentication Flow

\`\`\`mermaid
sequenceDiagram
    participant Client
    participant API
    participant Auth
    participant DB

    Client->>API: POST /auth/login (credentials)
    API->>Auth: Validate credentials
    Auth->>DB: Query user
    DB-->>Auth: User data
    Auth->>Auth: Generate JWT
    Auth-->>API: Access token + Refresh token
    API-->>Client: 200 OK (tokens)
\`\`\`

### Authorization

**Roles**:
- `user`: Basic access
- `admin`: Full access
- `superadmin`: System administration

**Permission Model**: Role-Based Access Control (RBAC)

**Endpoint Permissions**:
| Endpoint | user | admin | superadmin |
|----------|------|-------|------------|
| GET /users | ❌ | ✅ | ✅ |
| POST /users | ❌ | ✅ | ✅ |
| DELETE /users | ❌ | ❌ | ✅ |
```

## Request/Response Schemas

### Common Data Types

```markdown
## Common Types

### Pagination
\`\`\`typescript
interface Pagination {
  page: number;
  limit: number;
  total: number;
  totalPages: number;
}
\`\`\`

### Error Response
\`\`\`typescript
interface ErrorResponse {
  error: {
    code: string;
    message: string;
    details?: Record<string, any>;
  };
}
\`\`\`

### Success Response
\`\`\`typescript
interface SuccessResponse<T> {
  data: T;
  meta?: {
    pagination?: Pagination;
    timestamp: string;
  };
}
\`\`\`
```

## API Versioning

```markdown
## Versioning Strategy

**Method**: URL Path Versioning
**Current Version**: v1
**Format**: `/api/v{version}/{resource}`

**Deprecation Policy**:
- Announce deprecation 6 months in advance
- Maintain previous version for 12 months
- Provide migration guide

**Version History**:
| Version | Status | Release Date | EOL Date |
|---------|--------|--------------|----------|
| v1 | Active | 2024-01-01 | - |
```

## Rate Limiting

```markdown
## Rate Limiting

**Method**: Token Bucket Algorithm

**Limits**:
| Tier | Requests/minute | Requests/hour |
|------|-----------------|---------------|
| Anonymous | 10 | 100 |
| Authenticated | 100 | 1000 |
| Premium | 1000 | 10000 |

**Headers**:
- `X-RateLimit-Limit`: Maximum requests
- `X-RateLimit-Remaining`: Remaining requests
- `X-RateLimit-Reset`: Reset timestamp

**Rate Limit Exceeded Response**: 429 Too Many Requests
\`\`\`json
{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Too many requests",
    "retryAfter": 60
  }
}
\`\`\`
```

## Error Handling

```markdown
## Error Codes

| Code | HTTP Status | Description | Action |
|------|-------------|-------------|--------|
| VALIDATION_ERROR | 400 | Invalid input | Check request body |
| UNAUTHORIZED | 401 | Not authenticated | Provide valid token |
| FORBIDDEN | 403 | Insufficient permissions | Contact admin |
| NOT_FOUND | 404 | Resource not found | Check resource ID |
| CONFLICT | 409 | Resource conflict | Resolve conflict |
| INTERNAL_ERROR | 500 | Server error | Retry later |

### Error Response Format

\`\`\`json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed",
    "details": {
      "fields": {
        "email": "Invalid email format",
        "password": "Must be at least 8 characters"
      }
    },
    "timestamp": "2024-01-01T00:00:00Z",
    "requestId": "req_123456"
  }
}
\`\`\`
```

## OpenAPI Specification

```markdown
## OpenAPI/Swagger Documentation

**Location**: `/api/docs`
**Format**: OpenAPI 3.0

### Generated OpenAPI YAML

\`\`\`yaml
openapi: 3.0.0
info:
  title: {MODULE_NAME} API
  version: 1.0.0
  description: API documentation for {MODULE_NAME}

servers:
  - url: http://localhost:8080/api/v1
    description: Development server

paths:
  /users:
    get:
      summary: List users
      tags:
        - Users
      security:
        - bearerAuth: []
      parameters:
        - name: page
          in: query
          schema:
            type: integer
            default: 1
      responses:
        '200':
          description: Success
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserListResponse'

components:
  schemas:
    User:
      type: object
      properties:
        id:
          type: string
          format: uuid
        name:
          type: string
        email:
          type: string
          format: email
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
\`\`\`
```

## WebSocket/SSE APIs

```markdown
## Real-Time APIs

### WebSocket Endpoints

**URL**: `ws://localhost:8080/ws`

**Connection**:
\`\`\`typescript
const ws = new WebSocket('ws://localhost:8080/ws?token=<JWT>');
\`\`\`

**Message Format**:
\`\`\`json
{
  "type": "event_type",
  "payload": {},
  "timestamp": "ISO8601"
}
\`\`\`

**Events**:
- `user.created`: User created
- `user.updated`: User updated
- `user.deleted`: User deleted

### Server-Sent Events (SSE)

**Endpoint**: GET /api/v1/events

**Response**:
\`\`\`
event: message
data: {"type": "user.created", "payload": {...}}

event: message
data: {"type": "user.updated", "payload": {...}}
\`\`\`
```

## API Client Examples

```markdown
## Client Implementation Examples

### cURL
\`\`\`bash
curl -X GET 'http://localhost:8080/api/v1/users' \
  -H 'Authorization: Bearer <token>' \
  -H 'Content-Type: application/json'
\`\`\`

### JavaScript/TypeScript
\`\`\`typescript
const response = await fetch('http://localhost:8080/api/v1/users', {
  method: 'GET',
  headers: {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json'
  }
});
const data = await response.json();
\`\`\`

### Python
\`\`\`python
import requests

response = requests.get(
    'http://localhost:8080/api/v1/users',
    headers={'Authorization': f'Bearer {token}'}
)
data = response.json()
\`\`\`
```

## Analysis Checklist

- [ ] All endpoints discovered and documented
- [ ] Request/response schemas extracted
- [ ] Authentication method identified
- [ ] Authorization rules documented
- [ ] Error responses catalogued
- [ ] Rate limiting documented
- [ ] API versioning strategy identified
- [ ] OpenAPI spec generated
- [ ] Client examples provided
- [ ] WebSocket/SSE endpoints documented
