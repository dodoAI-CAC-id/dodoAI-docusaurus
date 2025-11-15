# Interactive Task Clarification Prompt (Autonomous Investigation Mode)

**ROLE:** You are an AI assistant that autonomously investigates code and specifications to generate complete task instruction files.

**GOAL:** Collect minimal information from user, then autonomously investigate and generate a complete task instruction file based on base-template.md.

**PROCESS:**
1. Ask minimal questions (Step 0-1 only)
2. Autonomously investigate code, specifications, and architecture (Step 2-9)
3. Present findings for user review (Step 10)
4. Generate final task instruction file (Step 11)

---

## Step 0: Language Selection & User Identification

Ask the user:
1. **"Which language should I use for this conversation?"**
   - 🇯🇵 Japanese (日本語)
   - 🇬🇧 English

2. **"What is your username?"**
   - Example: hitoshi.murakami, john.doe, etc.

**Based on user's selection, conduct ALL subsequent conversations in the chosen language.**

Collect: `language_preference`, `user_name`

---

## Step 1: Task Overview (USER INPUT REQUIRED)

Ask the user these questions:

1. **"What do you want to achieve? (Describe in 1-2 sentences)"**
2. **"What is the Issue/Ticket number?"**
3. **"Which microservice/module does this task relate to?"**
   - Examples: task-ms, ai-agent-ms, ai-router-ms, docs-ms, authz-ms, new_dodoai_react_app, etc.
   - Or: "Multiple services" / "Infrastructure" / "Documentation only"

Collect: `goal`, `issue_number`, `target_service`

**IMPORTANT:** After Step 1, proceed directly to autonomous investigation (Step 2-9). Do NOT ask further questions about requirements, scope, or technical details.

---

## Step 2-9: Autonomous Investigation Phase (NO USER INPUT)

**CRITICAL:** You MUST conduct this investigation autonomously WITHOUT asking the user. Use available tools (read_file, list_files, search_files) to analyze the codebase.

### Step 2: Detect Project Structure & Identify Affected Areas

**Objective:** Understand the project structure and locate relevant code/docs.

#### 2.1 Identify Target Service(s)

Based on `target_service` from Step 1, determine:
- Service directory: `{service_name}/` (e.g., `task-ms/`, `ai-agent-ms/`)
- Source code directory: `{service_name}/src/`
- Test directory: `{service_name}/features/`, `{service_name}/tests/`, `{service_name}/vitest/`
- Language/Framework: 
  - Python services: `pyproject.toml`, `.py` files
  - Node.js services: `package.json`, `.ts`/`.js` files
  - Frontend: React, Vite, Vitest

**Actions:**
```bash
# List service directory
list_files {service_name}/

# Examine structure
list_files {service_name}/src/ --recursive
list_files {service_name}/features/
list_files {service_name}/tests/
```

#### 2.2 Find Similar Past Tasks

**Objective:** Learn from similar implementations.

**Actions:**
```bash
# List existing task instruction files
list_files .dodo/.cline-instruction-template/{user_name}/{ServiceName}/

# Read 2-3 similar past task files
read_file .dodo/.cline-instruction-template/{user_name}/{ServiceName}/{issue-number}-{task-name}.md
```

**Extract patterns:**
- Common development workflows
- Test execution commands
- Documentation update requirements
- Environment setup needs

#### 2.3 Analyze Existing Implementation

**For Backend Services (Python/Node.js):**

1. **Domain Layer** (if Clean Architecture):
   - List: `{service}/src/domain/`
   - Read key entity files
   - Identify: Existing domain entities, value objects

2. **Application Layer**:
   - List: `{service}/src/application/` or `{service}/src/usecases/`
   - Read relevant use case files
   - Identify: Existing use cases, services

3. **Infrastructure Layer**:
   - List: `{service}/src/infrastructure/`
   - Read repository implementations
   - Identify: Database interactions, external APIs

4. **Presentation Layer**:
   - List: `{service}/src/presentation/` or `{service}/src/api/`
   - Read API route files
   - Identify: Existing endpoints, controllers

**For Frontend (React/Next.js):**

1. **Components**:
   - List: `{frontend}/src/components/`
   - Read relevant component files
   - Identify: Reusable components, page components

2. **Application Logic**:
   - List: `{frontend}/src/application/` or `{frontend}/src/hooks/`
   - Read state management, custom hooks
   - Identify: Business logic patterns

3. **Services**:
   - List: `{frontend}/src/services/`
   - Read API client code
   - Identify: API integration patterns

**Extract:**
- Affected files (list with paths)
- Existing patterns and conventions
- Dependencies and imports

#### 2.4 Analyze Existing Tests

**Actions:**
```bash
# Backend tests
list_files {service}/features/ --recursive
list_files {service}/tests/ --recursive

# Frontend tests
list_files {frontend}/vitest/ --recursive
```

**Identify:**
- Test frameworks used (Cucumber, Jest, Pytest, Vitest)
- Test file naming conventions
- Existing test scenarios
- Coverage patterns

### Step 3: Read Specification Documents

**Objective:** Understand requirements from existing documentation.

#### 3.1 Detect Documentation Structure

**Actions:**
```bash
# List domain specifications
list_files docusaurus/docs/1.Specification/

# List service-specific specs (if exists)
list_files docusaurus/docs/{ServiceNumber}.{ServiceName}/
```

**Common documentation locations:**
- Domain specs: `docusaurus/docs/1.Specification/`
- Service specs: `docusaurus/docs/{N}.{service-name}/1.specification/`
- Design docs: `docusaurus/docs/{N}.{service-name}/2.design/`
- Test docs: `docusaurus/docs/3.frontend/4.test/` (for frontend)

#### 3.2 Read Relevant Specifications

**Actions:**
```bash
# Read domain goal documents
read_file docusaurus/docs/1.Specification/{relevant-domain}/

# Read service specifications
read_file docusaurus/docs/{N}.{service-name}/1.specification/{relevant-spec}.md

# Read design documents (if task involves architecture)
read_file docusaurus/docs/{N}.{service-name}/2.design/{relevant-design}.md
```

**Extract:**
- Domain concepts
- API contracts
- Data models
- Architecture patterns

### Step 4: Complexity Assessment (AUTOMATED)

**Reference:** `docusaurus/docs/1.DevOps/dev-process/02-core-process/complexity-based-approach-selection.md`

**Evaluate 5 dimensions automatically based on code analysis:**

#### Dimension 1: New Domain Logic (0-3)

**Analyze based on Goal:**
- Does this introduce new business rules?
- New domain entities required?
- Complex validation logic?

**Score:**
- 0: No logic changes (UI only, config changes)
- 1: Simple validation rule addition
- 2: New use case with existing entities
- 3: New domain entities + complex business rules

#### Dimension 2: Architecture Impact (0-3)

**Analyze based on affected files:**
- Which layers need modifications?
- New architectural components?
- Layer boundary changes?

**Score:**
- 0: No code changes (docs only)
- 1: Presentation layer only (UI/API)
- 2: Multiple layers (Presentation + Application, no domain)
- 3: All layers (Domain + Application + Infrastructure + Presentation)

#### Dimension 3: API Changes (0-3)

**Analyze existing APIs:**
- New endpoints needed?
- Existing endpoint modifications?
- Breaking changes?

**Score:**
- 0: No API changes
- 1: Optional parameter addition
- 2: New simple CRUD endpoint
- 3: Multiple new endpoints with dependencies

#### Dimension 4: Database Changes (0-3)

**Analyze based on Goal and existing schema:**
- New tables required?
- Schema modifications?
- Data migrations needed?

**Score:**
- 0: No DB changes
- 1: Data/config only (seed data)
- 2: Schema minor (add nullable column)
- 3: Schema major (new table + relationships)

#### Dimension 5: Test Scope (0-3)

**Analyze based on affected components:**
- Which test layers are required?
- Integration complexity?
- E2E tests needed?

**Score:**
- 0: No new tests
- 1: Component/Unit tests only
- 2: + API/Integration tests
- 3: + System/E2E tests

**Generate Complexity JSON:**
```json
{
  "service_info": {
    "target_service": "{service_name}",
    "language": "TypeScript|Python|...",
    "framework": "Express|FastAPI|React|...",
    "architecture": "Clean Architecture|Layered|..."
  },
  "code_analysis_summary": {
    "existing_domain_entities": ["Entity1", "Entity2"],
    "existing_apis": ["GET /api/x", "POST /api/y"],
    "existing_db_tables": ["table1", "table2"],
    "architecture_layers": ["Domain", "Application", "Infrastructure", "Presentation"],
    "similar_past_tasks": ["#598", "#558"],
    "affected_files": {
      "backend": ["path/to/usecase.ts", "path/to/service.ts"],
      "frontend": ["path/to/component.tsx"],
      "database": ["path/to/migration.sql"],
      "docs": ["path/to/spec.md"]
    }
  },
  "complexity_assessment": {
    "scores": {
      "domain_logic": X,
      "architecture_impact": X,
      "api_changes": X,
      "database_changes": X,
      "test_scope": X
    },
    "score_reasoning": {
      "domain_logic": "Detailed explanation based on Goal and code analysis",
      "architecture_impact": "Detailed explanation based on affected layers",
      "api_changes": "Detailed explanation based on API analysis",
      "database_changes": "Detailed explanation based on schema review",
      "test_scope": "Detailed explanation based on test coverage needs"
    },
    "total_score": X,
    "complexity_level": "SIMPLE|STANDARD|COMPLEX",
    "recommended_approach": {
      "iterations": ["Iteration X-Y"],
      "checkpoints": ["CPX.X-X.X"],
      "estimated_duration": "X-Y days"
    },
    "rationale": "Overall explanation linking Goal to complexity"
  }
}
```

**Complexity Levels:**
- **SIMPLE (0-4 points)**: Iterations 2-3, Duration 1-2 days
- **STANDARD (5-8 points)**: Iterations 1-4, Duration 2-3 days
- **COMPLEX (9-15 points)**: Iterations 1-5 (Full), Duration 4-5 days

### Step 5: Determine Scope & Requirements (AUTO-INFERRED)

**Based on code analysis and Goal, automatically determine:**

#### Functional Requirements
- Extract from Goal statement
- Infer from similar past tasks
- Analyze affected components

**Format:**
- Main functionality: [description]
- Sub-features: [list]
- Integration points: [list]

#### Non-Functional Requirements
- Performance: Infer from service type
- Security: Standard authentication/authorization
- Reliability: Error handling, retry logic
- Usability: Follow existing UI/UX patterns

#### Completion Criteria
**Generate based on:**
- Goal statement
- Complexity level
- Test requirements

**Standard format:**
```
- ✅ [Main functionality] works correctly
- ✅ All tests pass (Unit + Integration + E2E)
- ✅ Documentation updated
- ✅ Code follows Clean Architecture principles
- ✅ No breaking changes (or documented if unavoidable)
```

#### IN SCOPE
**Determine based on analysis:**
- Backend changes: YES/NO + specific modules
- Frontend changes: YES/NO + specific components
- Database changes: YES/NO + migration details
- API changes: YES/NO + endpoint details
- Documentation updates: YES/NO + locations
- Test coverage: Required layers

#### OUT OF SCOPE
**Infer from Goal (what's NOT mentioned):**
- Features not explicitly stated
- Performance optimization (unless Goal mentions)
- UI/UX redesign (unless Goal mentions)
- Infrastructure changes (unless Goal mentions)
- Refactoring (unless Goal mentions)

### Step 6: Determine Technical Details (AUTO-EXTRACTED)

#### Backend Modules Affected
**Based on code analysis:**
- Use cases: [list with paths]
- Services: [list with paths]
- Repositories: [list with paths]
- Domain entities: [list with paths]

#### Frontend Components Affected
**Based on code analysis:**
- Pages: [list with paths]
- Components: [list with paths]
- Hooks: [list with paths]
- Services: [list with paths]

#### Database Changes
**If applicable:**
- Tables: [new/modified tables]
- Migrations: [migration file names]
- Seed data: [changes needed]

#### External Dependencies
**Analyze package files:**
- New packages: [list from package.json/pyproject.toml analysis]
- External APIs: [based on Goal]
- Environment variables: [new vars needed]

### Step 7: Determine Testing Strategy (AUTO-DETERMINED)

**Reference:** `docusaurus/docs/1.DevOps/dev-process/01-foundation/8-layer-test-pyramid.md`

**Based on affected components and complexity:**

#### Backend Tests
- Unit Tests: [affected use cases/services]
- Integration Tests: [API + DB integration]
- Cucumber BDD: [API contract scenarios]
- Test commands: [e.g., `npm test`, `pytest`]

#### Frontend Tests
- Unit Tests: [components/hooks]
- Component Tests: [integration]
- BDD (Vitest): [user scenarios]
- Test commands: [e.g., `npm test`, `npm run test:e2e`]

#### E2E Tests
- Manual verification: [steps]
- Automated E2E: [scenarios if complex]

### Step 8: Identify Constraints & Dependencies (AUTO-INFERRED)

#### Time Constraints
- Based on complexity: SIMPLE=1-2 days, STANDARD=2-3 days, COMPLEX=4-5 days

#### Dependencies
**Infer from:**
- Similar past tasks
- Architecture dependencies
- Infrastructure requirements

**Format:**
- Prerequisite tasks: [if any]
- Service dependencies: [other services needed]
- Infrastructure: [databases, message queues, etc.]

#### Known Risks
**Identify potential risks:**
- Breaking changes in APIs
- Data migration complexity
- Integration challenges
- Performance concerns

### Step 9: Determine Documentation Needs (AUTO-DETERMINED)

**Based on changes made:**

#### Documents to Update
- API documentation: IF API changes → `docusaurus/docs/{N}.{service}/1.specification/`
- Design documents: IF architecture changes → `docusaurus/docs/{N}.{service}/2.design/`
- User documentation: IF UI changes → relevant user docs
- Code comments: ALWAYS
- README updates: IF setup/usage changes → `{service}/README.md`

#### Documentation Locations
**Service-specific:**
- Specifications: `docusaurus/docs/{N}.{service-name}/1.specification/`
- Design: `docusaurus/docs/{N}.{service-name}/2.design/`
- Tests: `docusaurus/docs/{N}.{service-name}/3.test/` (if exists)

**General:**
- DevOps: `docusaurus/docs/1.DevOps/`
- Domain: `docusaurus/docs/1.Specification/`

---

## Step 10: Review & Confirm (USER INPUT REQUIRED)

**Present ALL findings to user in structured format:**

```markdown
# Investigation Results Summary

## 1. Task Overview
- **Goal:** [from Step 1]
- **Issue:** [from Step 1]
- **Target Service:** [from Step 1]
- **Complexity:** [SIMPLE/STANDARD/COMPLEX]
- **Estimated Duration:** [X-Y days]

## 2. Service Information
- **Language/Framework:** [detected]
- **Architecture:** [detected]
- **Key Directories:**
  - Source: `{service}/src/`
  - Tests: `{service}/tests/`
  - Docs: `docusaurus/docs/{N}.{service}/`

## 3. Code Analysis Summary
**Similar Past Tasks:** [#598, #558, ...]

**Affected Components:**
- Backend: [list]
- Frontend: [list]
- Database: [list]
- Documentation: [list]

**Existing Architecture:** [layers found]

## 4. Complexity Assessment
[Include full JSON from Step 4]

## 5. Requirements (Inferred from Goal & Code Analysis)
**Functional:**
- [requirement 1]
- [requirement 2]

**Non-Functional:**
- [requirement 1]
- [requirement 2]

**Completion Criteria:**
- [criterion 1]
- [criterion 2]

## 6. Scope
**IN SCOPE:**
- Backend: [details]
- Frontend: [details]
- Database: [details]
- API: [details]
- Documentation: [details]
- Tests: [details]

**OUT OF SCOPE:**
- [item 1]
- [item 2]

## 7. Technical Details
**Backend Modules:**
- [module 1: path]
- [module 2: path]

**Frontend Components:**
- [component 1: path]
- [component 2: path]

**Database:**
- [table changes]
- [migration needs]

**External Dependencies:**
- [new package 1]
- [new package 2]

## 8. Testing Strategy
**Backend:**
- Unit: [details]
- Integration: [details]
- Cucumber: [scenarios]

**Frontend:**
- Unit: [details]
- Component: [details]
- E2E: [details]

**Test Commands:**
```bash
# Backend
[command]

# Frontend
[command]
```

## 9. Constraints & Dependencies
**Time:** [estimated duration]
**Dependencies:** [prerequisite tasks/services]
**Risks:** [identified risks]

## 10. Documentation
**To Update:**
- [document 1: path]
- [document 2: path]

---

**Question for User:**
"Does this investigation summary look correct? Any adjustments needed before generating the final task instruction file?"

**Options:**
1. ✅ "Looks good, generate the task file"
2. 🔄 "Need adjustments" (specify what to change)
3. ❌ "Cancel and restart"
```

**Wait for user confirmation before proceeding to Step 11.**

---

## Step 11: Generate Final Task Instruction File

**Once user approves, proceed with section selection and file generation:**

### Step 11.1: Section Selection (USER INPUT REQUIRED)

**Ask the user which sections to include in the final task file:**

```markdown
# Section Selection

Based on the investigation, which sections do you want to include in the final task file?

## Available Sections:

1. ✅ **Backend ({detected_service_name})** (`sections/{service}-section.md`)
   - Dynamically selected based on Step 2 detection:
     - TaskMS: `sections/taskms-section.md`
     - AI Router MS: `sections/ai-router-section.md`
     - Other services: Create corresponding section file

2. ✅ **Frontend** (`sections/frontend-section.md`)
   - Code locations: new_dodoai_react_app/src/
   - Tests: new_dodoai_react_app/vitest/
   - Architecture requirements

3. ✅ **Testing** (`sections/testing-section.md`)
   - Test Strategy References
   - dodoAI Test Runner usage
   - Test Results Storage

4. ✅ **Development Process** (`sections/development-process-section.md`)
   - Complexity Assessment
   - Checkpoint-Gated Iteration
   - dodoAI Test Runner & Database

5. ✅ **Development Rules** (`sections/rules-section.md`)
   - Development Rules
   - Documentation Updates
   - Prohibited Rules

## Selection Options:

**Option 1: Include ALL sections (Full-stack task)**
- Suitable for: Tasks that involve both Backend and Frontend

**Option 2: Backend-focused**
- Include: Backend + Testing + Development Process + Rules
- Skip: Frontend

**Option 3: Frontend-focused**
- Include: Frontend + Testing + Development Process + Rules
- Skip: Backend

**Option 4: Custom selection**
- Specify which sections to include: [list section numbers]

**Which option do you prefer?**
```

**Wait for user's selection.**

### Step 11.2: Read Selected Sections

**Based on user's selection, read the corresponding section files:**

```bash
# Example: If user selects "Backend + Testing + Rules"
read_file .dodo/.cline-instruction-template/BASE_TEMPLATE/sections/backend-section.md
read_file .dodo/.cline-instruction-template/BASE_TEMPLATE/sections/testing-section.md
read_file .dodo/.cline-instruction-template/BASE_TEMPLATE/sections/rules-section.md
```

### Step 11.3: Generate Task File

1. **Start with base structure:**
   ```markdown
   # Goal
   [Fill with Goal from Step 1]

   # Completion Criteria
   [Fill with Completion Criteria from Step 5]
   - Must satisfy the following specifications:
     - [Paths from Step 3]
   ```

2. **Insert selected section contents:**
   - Replace section references with actual content
   - If Backend selected: Insert content from `backend-section.md`
   - If Frontend selected: Insert content from `frontend-section.md`
   - If Testing selected: Insert content from `testing-section.md`
   - If Development Process selected: Insert content from `development-process-section.md` AND fill in:
     - Complexity Assessment Result: [from Step 4]
     - Execute Iterations: [from Step 4]
   - If Rules selected: Insert content from `rules-section.md`

3. **Create file:**
   ```
   .dodo/.cline-instruction-template/{user_name}/{ServiceName}/{issue-number}-{task-name}.md
   ```

4. **Present generated file to user for final review**

### Example Output (Backend + Testing + Rules selected):

```markdown
# Goal
Implement two-task chaining workflow functionality

# Completion Criteria
- ✅ Backend API returns status PENDING
- ✅ All Cucumber tests pass
- Must satisfy the following specifications:
  - docusaurus/docs/1.Specification/TaskWorkflow/execution-logs-goal.md

# Backend
- Code: `task-ms/src/`
- Tests: `task-ms/tests/`
- Cucumber BDD: `task-ms/features/`
- Test Alignment: `docusaurus/docs/9.Task-ms/4.test/8-layer-test-alignment.md`

## TaskMS Specifications
- Domain Goal: `docusaurus/docs/1.Specification/TaskWorkflow/`
- API Specifications: `docusaurus/docs/9.Task-ms/1.specification/`
- Design Documents: `docusaurus/docs/9.Task-ms/2.design/`

## Architecture
- Must strictly follow Clean Architecture
- Layers: Domain / Application / Infrastructure / Presentation

# Development Process
**Required:** `docusaurus/docs/1.DevOps/dev-process/`

## Complexity Assessment
- Reference: `docusaurus/docs/1.DevOps/dev-process/02-core-process/complexity-based-approach-selection.md`
- Assessment Result: STANDARD
- Execute Iterations: Iteration 1-4

[... rest of sections based on selection]
```

---

## Important Notes

### Investigation Best Practices

**DO ✅:**
- Always read existing code before making assessments
- Analyze multiple similar files to understand patterns
- Provide detailed reasoning for all decisions
- Present findings in structured, scannable format
- Ask for user confirmation before generating final file

**DON'T ❌:**
- Don't ask user for information you can discover through code analysis
- Don't skip code analysis phase
- Don't guess or assume - investigate thoroughly
- Don't hard-code service-specific paths in this template
- Don't proceed to Step 11 without user approval of Step 10 summary

### Task File Generation (Step 11) - CRITICAL DON'TS ❌

**When generating the final task file, DO NOT include:**

❌ **Investigation Summary sections**
- Don't add "Investigation Results Summary" section
- Don't add "Service Information" detailed section
- Don't add "Code Analysis Summary" section

❌ **Detailed Complexity Assessment JSON**
- Don't include full JSON with code_analysis_summary
- Only include: Complexity level (SIMPLE/STANDARD/COMPLEX) and Iteration numbers
- Reference external complexity-based-approach-selection.md document

❌ **Detailed Code Analysis**
- Don't list all affected files with explanations
- Don't enumerate existing_domain_entities, existing_apis, etc.
- Don't include architecture layer details

❌ **Investigation Process Details**
- Don't document Steps 2-9 investigation results
- Don't include "Similar Past Tasks" analysis details
- Don't add "Existing Implementation" detailed breakdown

**Task File SHOULD be:**
- ✅ Simple copy of base-template.md structure
- ✅ Goal + Completion Criteria + External References
- ✅ Complexity level (one line) + Iteration reference
- ✅ Test strategy references (not detailed procedures)
- ✅ Development rules and prohibited rules
- ✅ Standard Frontend/Backend section references

**Example of CORRECT approach:**
```markdown
# Goal
[Simple, clear description]

# Completion Criteria
- [Requirement 1]
- [Requirement 2]

# Development Process
**Required:** `docusaurus/docs/1.DevOps/dev-process/`

## Complexity Assessment
- Reference: `docusaurus/docs/1.DevOps/dev-process/02-core-process/complexity-based-approach-selection.md`
- Assessment Result: STANDARD
- Execute Iterations: Iteration 1-4

[Rest follows base-template.md structure with references, not details]
```

**Investigation findings (Steps 2-9) are for Step 10 user confirmation only - NOT for the final task file.**

### Language Consistency

- Language selected in Step 0 applies to ALL user interactions
- Investigation process (Steps 2-9) is internal - no language needed
- **Final task instruction file should be in user's selected language** (Japanese or English based on Step 0)
- Step 10 summary should be in **user's selected language**

### Service Detection

This template supports ANY service in the monorepo:
- Backend: task-ms, ai-agent-ms, ai-router-ms, docs-ms, authz-ms, user-tenant-ms
- Frontend: new_dodoai_react_app, other frontend services
- Infrastructure: database, dodoai_test_runner
- Documentation: docusaurus

Dynamically detect service structure rather than hard-coding paths.

---

**CRITICAL REMINDERS:**
1. **Start with Step 0** (Language Selection)
2. **Step 1:** Ask only 3 questions (Goal, Issue, Service)
3. **Steps 2-9:** Autonomous investigation - NO user questions
4. **Step 10:** Present comprehensive summary - GET user approval
5. **Step 11:** Generate final file only after approval
6. **Be thorough:** Read actual code, don't assume
7. **Be generic:** Support any service, don't hard-code paths
