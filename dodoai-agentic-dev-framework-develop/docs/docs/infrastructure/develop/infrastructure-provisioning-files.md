---
id: infrastructure-provisioning-files
title: Infrastructure Provisioning Files (Terraform)
---

# Guide: Defining Infrastructure Provisioning Files (Terraform)

- Use this guide to specify all Terraform files used in infrastructure provisioning.
- Clearly define the purpose, content, and relationships of each file.
- Do not include implementation samples or general explanations—document only what must be present and why.

---

## What to Define

### 1. File Inventory

- List all Terraform files, scripts, and modules required for provisioning.
  - For each file, provide:
    - **File Name (relative path):**
    - **Purpose/Role:** (E.g., provider config, resource definition, variable declaration, outputs, backend, etc.)
    - **Key dependencies:** (If the file/module relies on or is included by others)
    - **Environment/applicability:** (dev, staging, prod, or shared)

### 2. File Organization and Structure

- Directory/subdirectory structure for all provisioning files and modules.
- Naming conventions for files and modules (e.g., `main.tf`, `variables.tf`, `outputs.tf`, `backend.tf`, `/modules/`).
- Policy for separating environment-specific vs. shared files.

### 3. Update and Versioning Practice

- How/where to track changes (VCS standards, code review, tagging).
- Requirement to document any addition, removal, or significant change directly in code comments or a changelog.

---

**Note:**  
Keep this inventory and description living and version-controlled as infrastructure and provisioning logic evolves. Do not document actual implementation in Docusaurus—maintain up-to-date descriptions and structure only.
