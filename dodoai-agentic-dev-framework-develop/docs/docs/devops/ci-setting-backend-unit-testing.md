---
id: ci-setting-backend-unit-testing
title: CI Setting (Backend/Unit Testing)
---

# Guide: CI Setting for Backend/Unit Testing

- Use this guide to define the requirements and setup for continuous integration (CI) of backend API unit tests.
- Focus on the explicit actions and configuration needed to automate unit test execution and enforce code quality in your microservice or backend repository.
- Limit content to what must be defined and maintained; do not include general motivation or implementation details.

---

## What to Define

### 1. CI Workflow Configuration

- Create a CI workflow YAML file in `.github/workflows/be-api-unit-test.yaml`.
- The workflow must:
  - Be triggered for push events to `feature/api_*` branches.
  - Be triggered for pull requests (including reopen events) targeting the `develop` branch and affecting files under `api/`.
  - Set the working directory (usually `api` or subdirectory containing your backend code).

### 2. Test Execution Steps

- Always include actions to:
  - Check out code from the repository
  - Set up the appropriate language/runtime version(s) (e.g., Node.js, Python, Java)
  - Install dependencies (`yarn install`, `npm install`, etc.)
  - Build or compile code if needed
  - Run your unit test suite (`yarn test`, `npm test`, `pytest`, etc.)
  - Define and export all required environment variables for test execution (including local/mock DB endpoints if used)

### 3. Version Matrix (Optional)

- Use a matrix build if you support or require testing across multiple versions of Node.js, Python, etc.

### 4. PR and Local Practice Policy

- Require all developers to run tests locally before submitting a PR.
- Require that all new/changed code is accompanied by corresponding unit tests in the same PR.
- Only allow merges to protected branches if all unit tests pass in CI.

### 5. Review and Ownership

- Designate the backend API team as responsible for maintaining the CI workflow, test standards, and environment configuration.


---

### Sample Configuration Reference

```yaml
name: Backend API Unit Test

on:
  push:
    branches:
      - 'feature/api_*'
  pull_request:
    types: [reopened]
    branches: ['develop']
    paths: ['api/**']

defaults:
  run:
    working-directory: 'api'

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [18.9]
    steps:
      - uses: actions/checkout@v3
      - name: Use Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v3
        with:
          node-version: ${{ matrix.node-version }}
      - run: yarn install
      - run: yarn build
      - run: yarn test
        env:
          USE_DYNAMODB_LOCAL: true
          DYNAMODB_REGION: ap-northeast-1
          DYNAMODB_LOCAL_URL: http://localhost:8000
          RUN_MODE: test
