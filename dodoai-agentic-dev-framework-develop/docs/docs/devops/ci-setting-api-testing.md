---
id: ci-setting-api-testing
title: CI Setting (API Testing)
---

# Guide: CI Setting for API Testing

- Use this guide to define what must be configured for Continuous Integration (CI) to automate API testing.
- Do not discuss implementation philosophy or give general motivation—focus on the explicit elements to be codified and maintained.

---

## What to Define

### 1. CI Pipeline Triggers

- Specify the branches, PR conditions, or directory path patterns that trigger API tests in CI (e.g., on push to `feature/api_*` or PR to `develop` with code under `api/`).

### 2. Environment Preparation

- Require automated steps to:
  - Check out code
  - Set up required runtime (Node.js, Python, Java, etc.)
  - Install all dependencies
  - Start the API/service under test (if needed)
  - Configure test database, test data fixtures, or mock dependencies

### 3. Test Execution

- Specify the commands or tools (e.g., `npx cucumber-js`, `pytest`) to automatically run the API test suite.
- Ensure all API interface and contract tests are executed, with results reported as pass/fail.

### 4. Reporting and Notification

- Require integration with reporting tools:
  - Output test results in the CI dashboard
  - Optionally, send notifications (e.g., Slack, email) on failures or test status

### 5. PR/Branch Policy

- Enforce that tests must pass for PR merge approval.
- Ensure that all code and related test changes are included together in each PR.

### 6. Maintenance Responsibility

- Specify the team or role responsible for CI pipeline and test upkeep (e.g., Backend team).

---

### Sample CI Configuration Reference (GitHub Actions)

```yaml
name: API Unit Test

on:
  push:
    branches:
      - "feature/api_*"
  pull_request:
    types:
      - reopened
    branches:
      - "develop"
    paths:
      - "api/**"

defaults:
  run:
    working-directory: "api"

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Set up Node.js
        uses: actions/setup-node@v2
        with:
          node-version: "14"

      - name: Install dependencies
        run: npm install

      - name: Start API Server
        run: npm start &
        env:
          CI: true

      - name: Run Cucumber tests
        run: npx cucumber-js
