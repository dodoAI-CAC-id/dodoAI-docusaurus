---
id: infrastructure-develop-tooling-setup
title: Tooling Setup
---

# Guide: Infrastructure Development Tooling Setup

- Use this guide to specify all tools, configurations, and environment requirements necessary for Terraform-based infrastructure development.
- Document only what must be installed, configured, and maintained for every developer; do not include general usage samples or generic scripting.

---

## What to Define

### 1. Development Environment Prerequisites

- Supported OS (version requirements), RAM and disk minimums.
- Mandatory software: Git, Docker, Terraform (minimum version), Node.js, Python, etc.
- Recommended or required code editor(s) and extensions for IaC (e.g., VS Code + HashiCorp Terraform plugin).

---

### 2. Terraform Installation & Configuration

- Standardized installation method (e.g., tfenv, Homebrew, apt, choco) for version management.
- Required Terraform version or minimum supported version.
- Configuration of Terraform PATH and verification.

---

### 3. AWS CLI and Profile Setup

- Mandatory installation and configuration of AWS CLI.
- Profile and credential management requirements: separate profiles for dev, staging, prod; use of AWS SSO if applicable.
- Environment variable setup and requirements for all Terraform executions.

---

### 4. Code Editor & Language Server

- Required or recommended editor setup (e.g., VS Code with Terraform, YAML, and JSON plugins).
- Language server installation for improved linting and autocomplete.

---

### 5. Validation, Linting & Security Tools

- Required Terraform validation tools: tflint, tfsec, checkov, terraform-docs.
- Configuration and installation steps for all pre-commit hooks (pre-commit, pre-commit-terraform, etc.).
- Policy-as-code tools (OPA, conftest, Sentinel) if used.

---

### 6. Testing Tools

- Mandatory tools for infrastructure testing (Terratest, kitchen-terraform, pytest, etc.).
- Directory/command structure for running IaC tests.

---

### 7. Version Control & Git Configuration

- Required Git client version and global settings.
- Git hook configuration for validating commits (pre-commit, etc.).
- Git branch workflow/conventions (e.g., main/develop, feature/ branches).

---

### 8. Containerized Development

- Docker installation and permissions for local Terraform development containers.
- Compose file/development image requirements.
- Any directory mounting, .aws bind, or ENV variable injection rules for development containers.

---

### 9. CI/CD Integration

- Configuration for running Terraform validation/lint/test/plan in CI tools (GitHub Actions, GitLab CI, etc.).
- YAML or script requirements for pipeline configuration.
- Environment variables and AWS secrets usage within CI jobs.

---

### 10. Environment Configuration

- Required env variable and .tfvars setup for each environment (dev/staging/prod/etc.).
- Structure for workspace/project initialization for consistent onboarding.

---

### 11. Troubleshooting and Optimization

- Steps for diagnosing common issues (state lock, provider/plugin, env mismatch).
- Required optimization flags, local backend use, plugin cache, and recommended debug practice.

---

### 12. Security Best Practices

- Credential and secret management requirements (never commit to code; use SSO, Secrets Manager, etc.).
- Code scanning for secrets and sensitive data before push.
- .gitignore policies for state and sensitive files.

---

**Note:**  
Everything in this guide must be documented and version-controlled in your infra codebase onboarding or environment configuration documentation—not just in internal Docs.
