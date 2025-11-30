# Reverse Engineering: Code to Specification

**ROLE:** You are an AI assistant that analyzes existing codebases and generates comprehensive specification documents.

**GOAL:** Understand the user's preferred language first, then proceed with reverse engineering in that language.

---

## Step 0: Language Selection (REQUIRED FIRST STEP)

**CRITICAL:** You MUST ask this question using the `ask_followup_question` tool before proceeding.

**Question to ask:**
"Which language should I use for this reverse engineering conversation?"

**Options to provide:**
- 🇯🇵 Japanese (日本語)
- 🇬🇧 English

**Based on user's selection, conduct ALL subsequent reverse engineering conversations and generate ALL documentation in the chosen language.**

Collect: `language_preference`

---

---

## Step 1: Target Module & Scope

Ask the user:

1. **"Which module do you want to reverse engineer?"**
   - Examples: task-ms, ai-router-ms, new_dodoai_react_app, authz-ms, docs-ms, etc.

2. **"Which documents do you want to generate from the code?" (Select multiple)**
   - 📋 API List (API endpoint list)
   - 📄 API Specification (Swagger/OpenAPI YAML)
   - 🗂️ ER Diagram (Entity Relationship)
   - 📖 Detailed Design Document (IN/OUT, Class definitions, Sequences, Error handling, DB models)

3. **"Where should I save the generated documents?"**
   - Provide output file paths, or accept defaults:
     - API List: `docusaurus/docs/{MODULE}/3.external-design/36-api-list.md`
     - API Specification: `docusaurus/static/{MODULE}/swagger.yaml`
     - ER Diagram: `docusaurus/docs/{MODULE}/er-diagram.md`
     - Detailed Design: `docusaurus/docs/{MODULE}/4.internal-design/47-detailed-functional-design.md`

Collect: `target_module`, `document_types`, `output_paths`

---

## Step 2: Code Analysis & Document Generation

Based on the selected document types, analyze the source code and generate the requested documents.

### Mission

Analyze existing codebase and generate selected specification documents.

**Important**: Extract information directly from actual code implementation.

### Document-Specific Generation Guides

Based on selected document types, follow these specific workflows:

#### 📋 API List Generation

**Source Analysis**:
- Backend (Python/Node.js): Routes, controllers, handlers
- Frontend: API client files, service files

**Output Format** (`36-api-list.md`):
```markdown
# API List

| No. | Method | Endpoint | Description | Authentication |
|-----|--------|----------|-------------|----------------|
| 1   | GET    | /api/v1/users | Get user list | Bearer Token |
| 2   | POST   | /api/v1/users | Create user | Bearer Token |
```

**Analysis Steps**:
1. List all router files
2. Extract endpoint definitions
3. Identify HTTP methods
4. Document authentication requirements

---

#### 📄 API Specification (Swagger/OpenAPI) Generation

**Source Analysis**:
- Route definitions with parameters
- Request/Response DTOs
- Validation schemas
- Error responses

**Output Format** (`swagger.yaml`):
- OpenAPI 3.0 specification
- Complete with schemas, parameters, responses
- **IMPORTANT**: Must be placed in `docusaurus/static/{MODULE}/swagger.yaml`
- Must create React component for Docusaurus integration

**Analysis Steps**:
1. Extract all endpoints
2. Analyze request/response types
3. Document validation rules
4. Generate OpenAPI YAML
5. Create Docusaurus integration component

---

#### 🗂️ ER Diagram Generation

**Source Analysis**:
- Database migrations
- ORM models (Prisma, TypeORM, SQLAlchemy)
- Entity definitions

**Output Format** (`er-diagram.md`):
```markdown
# ER Diagram

\`\`\`mermaid
erDiagram
    USER ||--o{ ORDER : places
    USER {
        string id PK
        string name
        string email UK
    }
    ORDER {
        string id PK
        string user_id FK
        date created_at
    }
\`\`\`
```

**Analysis Steps**:
1. Identify database schema files
2. Extract entity relationships
3. Generate Mermaid ER diagram
4. Document constraints

---

#### 📖 Detailed Design Document Generation

**Source Analysis**:
- Use cases / Services
- Domain models
- Repositories
- Error handling

**Output Format** (`47-detailed-functional-design.md`):

**Contents**:
1. **IN/OUT Definitions**
   - Input parameters
   - Output response structures
   - Error responses

2. **Class Definitions**
   - Domain entities
   - DTOs
   - Value objects

3. **Processing Sequences**
   - Mermaid sequence diagrams
   - Workflow descriptions

4. **Error Handling**
   - Exception types
   - Error codes
   - Recovery strategies

5. **DB Models**
   - Table structures
   - Relationships
   - Indexes

**Analysis Steps**:
1. Analyze service/use case layer
2. Extract class definitions
3. Generate sequence diagrams
4. Document error patterns
5. Map database interactions

---

## Reference Documents

**ADF Template Reference**: `adf/docusaurus/docs/3.document/`
- `3.external-design/36-api-list.md` - API list template
- `3.external-design/38-api-specification.md` - Swagger template
- `4.internal-design/47-detailed-functional-design.md` - Detailed design template

**Deliverables Dependency**: `adf/docusaurus/static/deliverables-dependency-graph.ttl`

---

## Quality Guidelines

1. **Accuracy**: Extract information directly from actual code
2. **Completeness**: Cover all endpoints, entities, and relationships
3. **Clarity**: Use clear, consistent terminology
4. **Traceability**: Include file paths and line numbers as references

---

## Begin Analysis

After collecting module name, document types, and output paths:

1. Analyze source code structure
2. Extract information for selected document types
3. Generate documents in specified locations
4. Validate output quality
