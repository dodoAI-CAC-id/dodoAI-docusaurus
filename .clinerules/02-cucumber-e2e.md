# Cucumber / API End-to-End Rules (ReAction)

- MANDATORY RUNNER: Execute Cucumber from the API service.
  - Preferred: cd api && npm run test:cucumber
  - Alternate (manual): cd api && npx cucumber-js --config cucumber.js

Environment setup
- Bring up required services (database, etc.) before running tests:
  - Option A: cd api && docker compose up -d
  - Option B: cd database && docker compose up -d
- Ensure environment variables are set:
  - Use api/.env.test or a suitable .env for testing. Create api/.env from api/.env.test when needed.
- Seed data if tests rely on pre-populated state:
  - database/seed.sql (plus events_seed.sql or seed_fixed.sql if applicable)
  - Run via your chosen docker-compose service or psql container.

Comprehensive E2E validation
- Do not test components in isolation only.
- Validate full API flows against a real database brought up by Docker.
- Use realistic seed data where sensible; tests must remain deterministic.
- Cover authentication and authorization paths when relevant.
- Produce a report if configured (e.g., api/cucumber-report.json).

BDD scenario requirements
- Scenarios should cover core domains present in this repo:
  - users, auth, events, images, interests
- Include both success and failure cases (401/403, 404, validation errors).
- Verify real DB interactions (create/read/update where appropriate).
- Tag smoke flows for quick checks (e.g., @smoke) when useful.

Forbidden superficial testing
- Pure mock-only E2E that skips Docker/real DB.
- Bypassing existing cucumber configuration in api/ (cucumber.js, cucumber.config.js).
- Tests that don’t verify actual API behavior over HTTP.

Operational notes
- Prefer npm run test:cucumber to ensure the project’s config is used.
- Keep scenarios independent and idempotent; clean up created data or use isolated fixtures.
- If flaky due to timing, use explicit waits for API readiness instead of arbitrary sleeps.
