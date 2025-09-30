---
id: ci-setting-backend-unit-testing
title: CI Setting (Backend/Unit Testing)
---

# CI Setting (Backend/Unit Testing)

## Overview

This document provides details on the CI settings for Backend API unit testing. Setting up CI for unit tests ensures code quality and stability by automatically running tests on certain GitHub events. The CI process is set up using GitHub Actions.

## Why Set Up CI for Backend Unit Testing

- **Automated Testing:** Automate the unit testing process to catch issues early.
- **Code Quality:** Maintain high code quality by ensuring all tests pass before merging.
- **Continuous Integration:** Ensure continuous integration by testing on every push and pull request.

## Configuration

### GitHub Actions

The CI setup is configured using GitHub Actions. The configuration file should be placed in `.github/workflows/be-api-unit-test.yaml`.

### Sample Configuration File

Below is a sample GitHub Actions configuration file for Backend API unit testing.

```yaml
name: Backend API Unit Test

on:
  push:
    branches:
      - 'feature/api_*'
  pull_request:
    types:
      - reopened
    branches:
      - 'develop'
    paths:
      - 'api/**'

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
```

## Guidelines

- **Local Execution:** Always run tests locally before creating a Pull Request (PR).
- **PR Requirements:** Ensure that unit tests and corresponding code changes are included in the same PR.
- **Team Responsibility:** The Backend team is responsible for setting up and maintaining CI for unit tests.

## Steps

1. **Create Configuration File:**

   - Add the CI configuration file to `.github/workflows/be-api-unit-test.yaml`.

2. **Set Up GitHub Actions:**

   - Ensure GitHub Actions are enabled for your repository.

3. **Ensure Your Repository Structure Matches the Setup**:

   - The workflow expects the API-related code to be in the `api` directory.

4. **Branch Naming Convention**:

   - Make sure that feature branches follow the naming convention `feature/api_*`.

5. **Pull Request Targeting**:

   - Ensure that your pull requests target the `develop` branch to trigger the workflow.

6. **Ensure Environment Variables are Correct**:

   - Double-check the environment variables used for testing (such as DynamoDB configurations) to match your local setup.

7. **Add Additional Node.js Versions (Optional)**:
   - If desired, extend the node-version matrix to test against multiple Node.js versions.

```yaml
matrix:
  node-version: [18.9, 16.x, 14.x]
```

## Conclusion

By setting up and using this GitHub Actions configuration, you can automate the process of running unit tests for your backend API, ensuring that your code stays reliable and maintainable. This configuration not only helps in maintaining code quality but also reduces the manual effort required for testing.
