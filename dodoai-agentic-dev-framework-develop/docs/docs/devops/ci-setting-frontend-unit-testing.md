---
id: ci-setting-frontend-unit-testing
title: CI Setting (Frontend/Unit Testing)
---

# Guide: CI Setting for Frontend Unit Testing

- Use this guide to specify what must be configured to enable automated unit testing for the frontend in continuous integration (CI).
- Focus on pipeline triggers, project structure, and execution requirements for frontend unit tests.
- Only document configuration and workflow—omit general motivation or implementation prose.

---

## What to Define

### 1. CI Workflow Configuration

- Place the CI configuration file for frontend unit tests in `.github/workflows/frontend-test-develop.yaml`.
- Trigger conditions must include:
  - Push events to branches matching `feature/frontend_*`.
  - Pull requests (including reopened PRs) to the `develop` branch affecting the frontend directory (e.g., `desktop-app/`).

### 2. Test Execution Steps

- Checkout repository code.
- Cache or install dependencies for the frontend tech stack (e.g., Flutter pub packages).
- Set up the required runtime (e.g., install Flutter at the required version).
- Build, clean, and install dependencies as needed.
- Run the unit test suite (`flutter test`, `npm test`, etc.) in the correct directory.
- Set environment variables as required (e.g., `RUN_MODE: test`).

### 3. Team and PR Policy

- Require all developers to run and pass unit tests locally before opening a PR.
- All code changes must include related test changes in the PR.
- The frontend team must maintain the CI workflow, test standards, and all required environment configuration.

### 4. Required File/Directory Structure

- Frontend source and tests should reside in a single root (e.g., `desktop-app/`) or other designated directory.
- Workflow file must set the working directory for all relevant steps.

### 5. Test Coverage and Maintenance

- Ensure that CI blocks merges if any required frontend unit tests fail.
- All new features and bugfixes must include corresponding unit test updates.

---

### Sample Configuration Reference (GitHub Actions)

```yaml
name: Flutter Test Develop

on:
  push:
    branches:
      - 'feature/frontend_*'
  pull_request:
    types: [reopened]
    branches: ['develop']
    paths: ['desktop-app/**']

defaults:
  run:
    working-directory: 'desktop-app'

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Cache Flutter dependencies
        uses: actions/cache@v3
        with:
          path: ${{ github.workspace }}/desktop-app/.pub-cache
          key: flutter-${{ hashFiles('**/pubspec.yaml') }}
          restore-keys: |
            flutter-

      - name: Install Flutter
        run: |
          git clone https://github.com/flutter/flutter.git -b 3.22.0 $HOME/flutter
          echo "$HOME/flutter/bin" >> $GITHUB_PATH

      - name: Flutter Doctor
        run: flutter doctor

      - name: Get Dependencies
        run: |
          flutter clean
          flutter pub get

      - name: Run Flutter Tests
        run: flutter test
        env:
          RUN_MODE: test
