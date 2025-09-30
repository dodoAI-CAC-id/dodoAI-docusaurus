---
id: ci-setting-frontend-unit-testing
title: CI Setting (Frontend/Unit Testing)
---

# CI Setting (Frontend/Unit Testing)

## Overview

This document provides details on the CI settings for Frontend unit testing. Setting up CI for unit tests ensures code quality and stability by automatically running tests on certain GitHub events. The CI process is set up using GitHub Actions.

## Why Set Up CI for Frontend Unit Testing

- **Automated Testing:** Automate the unit testing process to catch issues early.
- **Code Quality:** Maintain high code quality by ensuring all tests pass before merging.
- **Continuous Integration:** Ensure continuous integration by testing on every push and pull request.

## Configuration

### GitHub Actions

The CI setup is configured using GitHub Actions. The configuration file should be placed in `.github/workflows/frontend-test-develop.yaml`.

### Sample Configuration File

Below is a sample GitHub Actions configuration file for Frontend unit testing.

```yaml
name: Flutter Test Develop

on:
  push:
    branches:
      - 'feature/frontend_*'
  pull_request:
    types:
      - reopened
    branches:
      - 'develop'
    paths:
      - 'desktop-app/**'

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
```

## Guidelines

- **Local Execution:** Always run tests locally before creating a Pull Request (PR).
- **PR Requirements:** Ensure that unit tests and corresponding code changes are included in the same PR.
- **Team Responsibility:** The Frontend team is responsible for setting up and maintaining CI for unit tests.

## Steps

1. **Create Configuration File:**
   - Add the CI configuration file to `.github/workflows/frontend-test-develop.yaml`.

2. **Set Up GitHub Actions:**
   - Ensure GitHub Actions are enabled for your repository.

3. **Run Tests Locally:**
   - Execute unit tests locally using the same configuration before pushing changes.

4. **Create Pull Request:**
   - Include unit tests and code changes in the same PR.
   - The CI process will automatically run tests on every push to `feature/frontend_*` branches and on PRs to the `develop` branch.

By following these steps and guidelines, you ensure a robust and automated testing process for the frontend, enhancing code quality and stability.