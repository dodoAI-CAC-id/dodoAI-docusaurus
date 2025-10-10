---
id: ci
title: CI
---

# Guide: Defining Continuous Integration (CI) Requirements

- Use this guide to define CI requirements for your project or system.
- Document only what must be specified, enabled, and tracked for CI—omit placeholder, motivation, or implementation examples.

---

## What to Define

### 1. CI Pipeline Triggers

- Specify the Git events and branch patterns that MUST trigger CI (e.g., push to `main`, PR to `develop`, feature branch updates).

### 2. Build and Test Automation

- List all:
  - Required checks (lint, format, unit test, integration test, etc.)
  - Tools and commands to execute for each check
  - Minimum test and quality coverage to allow merge

### 3. Environment Setup

- Define required versions/containers/runtimes for build agents.
- Specify any environment variables, secrets, or configuration settings needed for automated runs.

### 4. Reporting, Quality Gates, and Notifications

- Specify how CI must report results (dashboards, badges, notifications such as Slack or email).
- State the rules for blocking merges on failed CI or missing tests.

### 5. File Convention

- All CI configuration files (e.g., `.github/workflows/`, `.gitlab-ci.yml`) must be present, version-controlled, and maintained alongside source code.

---

**Note:**  
Maintain and review CI requirements as your project or technology stack evolves.
