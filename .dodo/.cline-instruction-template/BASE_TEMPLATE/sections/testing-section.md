# Testing

## Test Strategy References (MANDATORY)
- **Testing Strategy:** `docusaurus/docs/19.Test/testing-strategy.md`
- **8-Layer Test Pyramid:** `docusaurus/docs/1.DevOps/dev-process/01-foundation/8-layer-test-pyramid.md`
- **Task MS Test Alignment:** `docusaurus/docs/9.Task-ms/4.test/8-layer-test-alignment.md`
- **Frontend Test Guide:** `docusaurus/docs/3.frontend/4.test/`

## Required Test Layers
Refer to testing-strategy.md and 8-Layer Test Pyramid based on complexity level (SIMPLE/STANDARD/COMPLEX)

## Test Execution
**Reference:** `docusaurus/docs/1.DevOps/test-runner/` for detailed usage

```bash
# Using dodoAI Test Runner (Recommended)
python -m dodoai_test_runner run --type=cucumber --module=task-ms
python -m dodoai_test_runner run --type=unit --module=task-ms
```

## Test Results Storage
- Backend: `task-ms/reports/`
- Frontend: `new_dodoai_react_app/vitest/reports/`
- Manual: `.dodo/issue/issue-{number}/`

Refer to Test Alignment documentation for detailed directory structure.
