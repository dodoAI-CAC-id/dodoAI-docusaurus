# Work Plan Verification & Update Rules (ReAction)

- BEFORE any development, consult work plans in devops/plan/.
- Directory structure: devops/plan/ contains work plans, analyses, and completion reports for this repo.
- Follow the repository’s planning-first workflow.

Consultation workflow
1. Read devops/plan/ for overview and current status.
2. Locate plan files matching the task:
   - "*-plan.md", "*-completion-report.md"
   - Timestamp-prefixed documents as per naming convention below.
3. Review completion reports to avoid duplication and to follow prior decisions.
4. Follow established patterns (structure, naming, and sections).

Plan updates
- Update plan docs when significant changes occur.
- Create new plan docs for major initiatives.
- Mark sections as completed when done.
- Keep structure consistent across documents.
- Keep language in plans and reports in English unless explicitly requested otherwise.

Naming convention (timestamp-first)
- Use a numeric timestamp prefix followed by a descriptive slug and suffix.
- Format:
  - TIMESTAMP-feature-or-topic-slug-plan.md
  - TIMESTAMP-feature-or-topic-slug-completion-report.md
- Examples (aligned with existing repository files):
  - 1757060614-keycloak-reset-password-theme-design-plan.md
  - 1757060614-keycloak-reset-password-theme-design-completion-report.md
  - 1756275386-events-date-fields-refactor-plan.md
  - 1756275386-events-date-fields-refactor-completion-report.md
- Guidance:
  - TIMESTAMP is a monotonically increasing numeric value (e.g., Unix-style or the existing project convention).
  - The slug should be short, lowercase, hyphen-separated.
  - Keep the suffix exactly "-plan" or "-completion-report".

Decision protocol
- Reference the relevant plan before architectural or major code changes.
- Document decisions and rationale in both the plan and the final completion report.
- If a conflict arises between docs and code, confirm by running tests (see 02-cucumber-e2e.md) before proceeding.

Operational reminders
- Use: ls devops/plan/ to quickly locate related plans.
- Avoid proceeding on assumptions; verify with documented specs and existing plans first.
