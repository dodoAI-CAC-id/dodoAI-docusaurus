# TDD Rules (Red–Green–Refactor) – ReAction

Principles
- Always follow Red → Green → Refactor for every change.
- Red: Write a failing test before any implementation.
- Green: Write the minimal code to pass.
- Refactor: Improve quality while keeping tests green and behavior unchanged.

Test types in this repository
- Unit tests (API)
  - Runner: Jest
  - Command: cd api && npm test
  - Config: api/jest.config.js
  - Scope: Functions, services, middleware, validators. Use mocks for external systems.
- End-to-End tests (API)
  - Runner: Cucumber
  - Command: cd api && npm run test:cucumber
  - Config: api/cucumber.js (and/or api/cucumber.config.js)
  - Scope: Real HTTP flows against a real database (see 02-cucumber-e2e.md for environment and seeding).

Recommended TDD execution order
1) Red (unit): Add failing Jest tests that specify the desired module-level behavior.
2) Red (E2E): Add failing Cucumber scenarios for the user-facing/API flows.
3) Green: Implement the minimal code to make both unit and E2E tests pass.
4) Refactor: Clean up code, remove duplication, improve design while keeping tests green.
5) Repeat: Iterate in small, incremental steps.

Guidelines
- Keep tests deterministic; control time, randomness, and external IO in unit tests.
- Prefer realistic data via seed files for E2E (database/seed.sql and related files).
- For E2E, bring up dependencies via Docker and ensure env vars are set (see 02-cucumber-e2e.md).
- Tag smoke scenarios (e.g., @smoke) for quick validation when useful.
- Maintain test independence and idempotence; clean up created data or use isolated fixtures.

Forbidden
- Writing implementation without failing tests first.
- Skipping the Red phase (writing tests after implementation).
- Large, non-incremental changes outside TDD cycles.
- E2E that bypass real DB/Docker or do not verify real HTTP behavior.

Operational commands (reference)
- Unit: cd api && npm test
- Coverage: cd api && npm run test:coverage
- Watch mode: cd api && npm run test:watch
- E2E: cd api && npm run test:cucumber

See also
- .clinerules/02-cucumber-e2e.md for environment setup, seeding, and operational notes for Cucumber.
