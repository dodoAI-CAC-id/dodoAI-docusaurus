---
id: infrastructure-template-terraform
title: Infrastructure Template (Terraform)
---

# Guide: Infrastructure Terraform Template and File Documentation

- Use this guide to specify the structure, contents, and purpose of each Terraform file used in your infrastructure-as-code (IaC) setup.
- Document only what must be present and the intent/purpose of each file.  
- Do not provide code samples; give concise, functional file descriptions for maintainability and onboarding.

---

## What to Define

### 1. Repository and Directory Structure

- Specify the directory layout for all Terraform (*.tf) files and directories.
- Ensure each file serves a single responsibility (network, compute, service roles, variables, outputs, etc.).
- Example structure (adjust as needed for your project):

```
├── be.tf
├── ecs-cluster.tf
├── fe.tf
├── locals.tf
├── main.tf
├── output.tf
├── service-roles.tf
├── variables.tf
└── vpc-alb.tf
```

### 2. File-By-File Definition

For each file, define:

- **File name**:  
  - `be.tf`: Backend/server-specific configurations (infrastructure and application)
  - `ecs-cluster.tf`: AWS ECS (Elastic Container Service) cluster configurations and resources
  - `fe.tf`: Frontend server configurations and settings
  - `locals.tf`: Declare reusable local variables and common data
  - `main.tf`: Main entry point; orchestrates overall provider/resource configuration
  - `output.tf`: Declares output variables to expose information about created resources
  - `service-roles.tf`: IAM roles and policies for services (e.g., ECS tasks, Lambda, etc.)
  - `variables.tf`: Input variable declarations, types, defaults, constraints, and documentation
  - `vpc-alb.tf`: VPC, subnet, route table, and ALB (load balancer) setups; security group rules

- **Purpose/Intent:**  
  - Summarize what each file configures/controls (compute, networking, security, modularity, etc.).

- **Contents:**  
  - High-level resource types and relationships included in the file.
  - Reference or link to relevant documentation for complex configurations.

- **Relationships:**  
  - Explicitly note files/modules that depend on or are referenced by others (e.g., outputs used by other configurations).

---

### 3. Documentation and Maintenance

- For every file and module, ensure there is a short, descriptive documentation block either at the top of the file or in a tracked README.
- Keep file purpose descriptions up-to-date as you refactor or change infrastructure design.

---

**Note:**  
Always keep this documentation version-controlled and updated. This enables consistent collaboration, onboarding, and review for all changes to your infrastructure codebase.