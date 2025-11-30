# Output Format Section (出力フォーマット定義)

## Purpose

生成される仕様書のフォーマット、構造、配置先を定義します。

## Output Directory Structure

```markdown
## Generated Documentation Structure

\`\`\`
docusaurus/docs/{MODULE_NAME}/
├── 1.Specification/
│   ├── 01-overview.md                    # Module overview and architecture
│   ├── 02-architecture.md                # Detailed architecture design
│   ├── 03-api-specification.md           # Complete API documentation
│   ├── 04-data-model.md                  # Database schema and entities
│   └── 05-business-logic.md              # Business rules and workflows
├── 2.Implementation/
│   ├── 01-code-structure.md              # Code organization and patterns
│   ├── 02-component-details.md           # Component-level documentation
│   └── 03-integration-points.md          # External integrations
├── 3.Testing/
│   ├── 01-test-strategy.md               # Testing approach and patterns
│   ├── 02-test-coverage.md               # Coverage report and gaps
│   └── 03-test-scenarios.md              # Test case documentation
└── 4.Operations/
    ├── 01-environment-setup.md           # Setup instructions
    ├── 02-deployment.md                  # Deployment guide
    └── 03-troubleshooting.md             # Common issues and solutions
\`\`\`
```

## Document Templates

### 01-overview.md Template

```markdown
# {MODULE_NAME} - Overview

## Introduction

{Brief description of the module and its purpose}

## Purpose

{What business problem does this module solve?}

## Key Features

- Feature 1: {Description}
- Feature 2: {Description}
- Feature 3: {Description}

## Technology Stack

| Category | Technology | Version |
|----------|-----------|---------|
| Runtime | {Node.js/Python} | {version} |
| Framework | {Express/FastAPI} | {version} |
| Database | {PostgreSQL/MongoDB} | {version} |
| ORM | {TypeORM/Prisma/SQLAlchemy} | {version} |

## Architecture Overview

\`\`\`mermaid
graph TD
    A[Client] --> B[API Gateway]
    B --> C[{MODULE_NAME}]
    C --> D[Database]
    C --> E[External Services]
\`\`\`

## Module Boundaries

**Responsibilities**:
- {Responsibility 1}
- {Responsibility 2}

**Dependencies**:
- {Service 1}: {Purpose}
- {Service 2}: {Purpose}

**Dependents**:
- {Service A}: {How it uses this module}
- {Service B}: {How it uses this module}

## Quick Start

\`\`\`bash
# Install dependencies
npm install

# Setup environment
cp .env.example .env

# Run migrations
npm run migrate

# Start development server
npm run dev
\`\`\`

## Related Documentation

- [Architecture Details](./02-architecture.md)
- [API Specification](./03-api-specification.md)
- [Data Model](./04-data-model.md)
```

### 02-architecture.md Template

```markdown
# {MODULE_NAME} - Architecture

## Architecture Style

**Pattern**: {Clean Architecture | Layered | MVC | Hexagonal}

## Layers

### {Layer 1 Name}

**Location**: `src/{path}/`

**Responsibilities**:
- {Responsibility 1}
- {Responsibility 2}

**Key Components**:
- {Component 1}: {Purpose}
- {Component 2}: {Purpose}

### {Layer 2 Name}

{Same structure as Layer 1}

## Component Diagram

\`\`\`mermaid
graph TB
    subgraph "Presentation Layer"
        A[Controllers]
        B[Routes]
    end
    
    subgraph "Application Layer"
        C[Use Cases]
        D[DTOs]
    end
    
    subgraph "Domain Layer"
        E[Entities]
        F[Services]
    end
    
    subgraph "Infrastructure Layer"
        G[Repositories]
        H[External APIs]
    end
    
    A --> C
    C --> F
    F --> E
    G --> E
\`\`\`

## Design Patterns

### {Pattern 1 Name}

**Purpose**: {Why this pattern is used}

**Implementation**: {Where it's implemented}

**Example**:
\`\`\`{language}
{Code example}
\`\`\`

## Dependencies

{Module dependency graph and descriptions}

## Scalability Considerations

{How the architecture supports scaling}

## Security Architecture

{Security patterns and implementation}
```

### 03-api-specification.md Template

```markdown
# {MODULE_NAME} - API Specification

## Base URL

- **Development**: `http://localhost:{PORT}`
- **Production**: `https://api.{domain}/{service}`

## Authentication

**Method**: {JWT | OAuth2 | API Key}

{Authentication details}

## Endpoints

### {Resource Name}

#### {HTTP_METHOD} {PATH}

**Description**: {What this endpoint does}

**Authentication**: {Required | Optional | Not required}

**Request Parameters**:

| Name | Type | Location | Required | Description |
|------|------|----------|----------|-------------|
| {param} | {type} | {path/query/body} | {Yes/No} | {description} |

**Request Body**:
\`\`\`json
{
  "field": "value"
}
\`\`\`

**Response**: {STATUS_CODE} {STATUS_TEXT}
\`\`\`json
{
  "data": {}
}
\`\`\`

**Error Responses**:
- {CODE}: {Description}
- {CODE}: {Description}

**Example**:
\`\`\`bash
curl -X {METHOD} '{URL}' \
  -H 'Authorization: Bearer {token}' \
  -H 'Content-Type: application/json' \
  -d '{json}'
\`\`\`

## OpenAPI Specification

\`\`\`yaml
{OpenAPI YAML content}
\`\`\`
```

## Markdown Standards

```markdown
## Document Formatting Rules

### Headings

- **H1** (`#`): Document title (one per file)
- **H2** (`##`): Major sections
- **H3** (`###`): Subsections
- **H4** (`####`): Details

### Code Blocks

Always specify language:

\`\`\`typescript
// TypeScript example
const example: string = 'value';
\`\`\`

\`\`\`python
# Python example
example: str = 'value'
\`\`\`

\`\`\`bash
# Shell commands
npm install
\`\`\`

### Tables

Use consistent alignment:

| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Value 1  | Value 2  | Value 3  |

### Lists

**Unordered**:
- Item 1
- Item 2
  - Sub-item 2.1
  - Sub-item 2.2

**Ordered**:
1. Step 1
2. Step 2
   1. Sub-step 2.1
   2. Sub-step 2.2

### Links

- Internal: `[Link Text](./relative/path.md)`
- External: `[Link Text](https://example.com)`
- Section: `[Link Text](#section-heading)`

### Emphasis

- **Bold**: `**text**` for important terms
- *Italic*: `*text*` for emphasis
- `Code`: `` `text` `` for inline code
```

## Mermaid Diagram Standards

```markdown
## Diagram Types and Usage

### Flowchart (Process Flow)

\`\`\`mermaid
graph TD
    A[Start] --> B{Decision}
    B -->|Yes| C[Action 1]
    B -->|No| D[Action 2]
    C --> E[End]
    D --> E
\`\`\`

**Use for**: Process flows, decision trees

### Sequence Diagram (Interactions)

\`\`\`mermaid
sequenceDiagram
    participant A as Client
    participant B as Server
    participant C as Database
    
    A->>B: Request
    B->>C: Query
    C-->>B: Result
    B-->>A: Response
\`\`\`

**Use for**: API interactions, request flows

### Entity Relationship (Data Model)

\`\`\`mermaid
erDiagram
    USER ||--o{ ORDER : places
    ORDER ||--|{ ORDER_ITEM : contains
    PRODUCT ||--o{ ORDER_ITEM : "included in"
\`\`\`

**Use for**: Database schemas, relationships

### State Diagram (State Transitions)

\`\`\`mermaid
stateDiagram-v2
    [*] --> Active
    Active --> Suspended
    Active --> Deleted
    Suspended --> Active
    Deleted --> [*]
\`\`\`

**Use for**: State machines, workflow states

### Class Diagram (Object Structure)

\`\`\`mermaid
classDiagram
    class User {
        +String id
        +String name
        +String email
        +login()
        +logout()
    }
    
    class Order {
        +String id
        +Date createdAt
        +calculate()
    }
    
    User "1" --> "*" Order
\`\`\`

**Use for**: Class structures, inheritance
```

## File Naming Conventions

```markdown
## Naming Rules

### Document Files

**Pattern**: `{number}-{descriptive-name}.md`

**Examples**:
- ✅ `01-overview.md`
- ✅ `02-architecture.md`
- ✅ `03-api-specification.md`
- ❌ `Overview.md` (no number prefix)
- ❌ `api_spec.md` (use hyphens, not underscores)

### Directory Names

**Pattern**: `{Number}.{CamelCase}/`

**Examples**:
- ✅ `1.Specification/`
- ✅ `2.Implementation/`
- ✅ `3.Testing/`
- ❌ `specification/` (no number, no capitalization)

### Image Files

**Pattern**: `{module}-{description}.{ext}`

**Examples**:
- ✅ `task-ms-architecture.png`
- ✅ `user-flow-diagram.svg`
- ❌ `image1.png` (not descriptive)
```

## Docusaurus Integration

```markdown
## Docusaurus Metadata

### Front Matter

Add to top of each markdown file:

\`\`\`yaml
---
id: {unique-id}
title: {Display Title}
sidebar_label: {Short Label}
sidebar_position: {number}
---
\`\`\`

**Example**:

\`\`\`yaml
---
id: task-ms-overview
title: Task Management Service - Overview
sidebar_label: Overview
sidebar_position: 1
---
\`\`\`

### Sidebar Configuration

Update `docusaurus/sidebars.js`:

\`\`\`javascript
module.exports = {
  docs: [
    {
      type: 'category',
      label: '{MODULE_NAME}',
      items: [
        '{MODULE_NAME}/1.Specification/01-overview',
        '{MODULE_NAME}/1.Specification/02-architecture',
        // ...
      ],
    },
  ],
};
\`\`\`
```

## Quality Checklist

```markdown
## Documentation Quality Standards

Before finalizing documentation, verify:

### Content Quality

- [ ] All code examples are syntactically correct
- [ ] All links work (no 404s)
- [ ] All diagrams render properly
- [ ] Technical accuracy verified
- [ ] No placeholder text (e.g., "TODO", "{INSERT}")
- [ ] Consistent terminology throughout

### Formatting

- [ ] Proper heading hierarchy (H1 → H2 → H3)
- [ ] Code blocks have language specified
- [ ] Tables are properly formatted
- [ ] Lists are consistent (ordered vs unordered)
- [ ] Mermaid diagrams use correct syntax

### Completeness

- [ ] All sections filled out
- [ ] Cross-references added
- [ ] Examples provided
- [ ] Edge cases documented
- [ ] Error scenarios covered

### Docusaurus Compatibility

- [ ] Front matter added to all files
- [ ] No special characters that break MDX
- [ ] Images in correct directory
- [ ] Sidebar configured correctly
- [ ] Linting passes (`npm run lint:md`)
```

## Post-Generation Steps

```markdown
## After Generation Workflow

### 1. Review and Validation

\`\`\`bash
# Check markdown linting
cd docusaurus/docs
npm run lint:md

# Fix any issues manually
# DO NOT use lint:md:fix (can break MDX)
\`\`\`

### 2. Preview Documentation

\`\`\`bash
cd docusaurus
npm run start

# Open http://localhost:4000
# Navigate to generated docs
# Verify all pages render correctly
\`\`\`

### 3. Commit to Repository

\`\`\`bash
git add docusaurus/docs/{MODULE_NAME}/
git commit -m "docs: add reverse-engineered specification for {MODULE_NAME}"
git push
\`\`\`

### 4. Team Review

- Share documentation link with team
- Gather feedback on accuracy
- Update based on feedback
- Get approval from module owner

### 5. Maintenance

- Add to documentation update schedule
- Set up monitoring for code-doc drift
- Plan periodic reviews (quarterly)
```

## Analysis Checklist

- [ ] Output directory structure defined
- [ ] Document templates created
- [ ] Markdown standards documented
- [ ] Mermaid diagram standards defined
- [ ] File naming conventions specified
- [ ] Docusaurus integration documented
- [ ] Quality checklist provided
- [ ] Post-generation workflow documented
