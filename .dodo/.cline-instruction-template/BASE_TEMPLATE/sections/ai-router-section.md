# Backend (AI Router MS)

- Code: `ai-router-ms/src/ai_router/actions/`
- Tests: `ai-router-ms/features/`
- Cucumber BDD: `ai-router-ms/features/*.feature`

## AI Router MS Documentation
- **Specifications**: `docusaurus/docs/6.AI-router-ms/1.Specification/common/`
  - Framework Overview, ActionSpec System, Pydantic-First Pattern, Version Management
- **Development Guides**: `docusaurus/docs/6.AI-router-ms/3.Develop/`
  - [Action Development Guide](docusaurus/docs/6.AI-router-ms/3.Develop/action-development.md) - How to create Actions (5 steps)
  - [Router Development Guide](docusaurus/docs/6.AI-router-ms/3.Develop/router-development.md) - How to build Routers (5 steps)
- **Testing Strategy**: [8-Layer Test Pyramid](docusaurus/docs/19.Test/testing-strategy.md)
  - Contract-First, BDD for Business Logic, AI-Safe Testing
- **Design Documents**: `docusaurus/docs/6.AI-router-ms/2.Design/`
- **Test Specifications**: `docusaurus/docs/6.AI-router-ms/4.test/`

## Architecture
- Framework: FastAPI + Pydantic
- Pattern: Action-based with `@action_spec` decorator
- Database: PostgreSQL (asyncpg) + Dgraph (HTTP)
