# Conditional Commands & Reminders (ReAction)

- On documentation tasks:
  - cd docs && npx markdownlint "**/*.{md,mdx}"
  - Optional (for project planning docs outside docs/): npx markdownlint "devops/plan/**/*.md"
- On development tasks:
  - ls devops/plan/ and review relevant plans before coding.

Purpose
- Provide conservative linting for docs (detect-only, no auto-fix).
- Enforce work-plan-first discipline using devops/plan/ as the source of truth.
