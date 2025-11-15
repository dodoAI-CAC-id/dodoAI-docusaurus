# Development Rules

- No long CLI commands (causes Cline to freeze)
- Contract-First (Cucumber) to solidify interfaces first
  - TDD strictly required when errors occur
- Always update work plan: `.dodo/issue/[issue-number]`
- Strictly follow Clean Architecture
- Database Schema & Migrations** (if applicable): `.clinerules/11-database-migration-section.md`
  - **CRITICAL:** If task requires schema changes, must follow migration versioning strategy

# Documentation Updates

**Docusaurus Rules:** `.clinerules/09-docusaurus-updates.md`
- Write in English (unless requested otherwise)
- Location: `docusaurus/docs/`
- Lint before commit: `cd docusaurus/docs && npm run lint:md`
- Fix errors manually (no auto-fix)

# Prohibited Rules

- ❌ DO NOT update env files
- ❌ DO NOT use `npm run lint:md:fix` (breaks MDX)
