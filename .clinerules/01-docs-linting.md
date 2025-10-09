# Documentation Linting Rules (ReAction, Conservative)

- CONSERVATIVE APPROACH: Detect issues only; do NOT auto-fix to avoid breaking valid MD/MDX authoring.
- Docs site (Docusaurus) content lives under docs/. This repository does not define a lint:md script in docs/package.json. Use a direct, detect-only command:
  - cd docs && npx markdownlint "**/*.{md,mdx}"
- Manually fix any reported issues — do not use auto-fix flags.
- Optional (project planning documents outside docs/): The plan and completion-report files live under devops/plan/ and are not part of the Docusaurus site. You may lint them separately if desired:
  - From repo root: npx markdownlint "devops/plan/**/*.md"

Key MDX issues to manually fix
- Escape < and > characters in text: <5% ⇒ \<5% or write "less than 5%".
- Fix undefined references: [dict] should be `dict` or escape as \[dict\].
- Remove unused link definitions.
- Close any unclosed HTML elements if they must be used.

Policy
- The linting configuration approach is conservative and aims to preserve author style choices.
- Pre-commit hooks may warn but should not block commits.
- Language requirement: Write documentation in English unless explicitly requested otherwise.
