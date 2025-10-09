---
id: cd-setting
title: CD Setting
---

# Guide: Continuous Deployment (CD) Setting

- Use this guide to define required configuration and workflow for Continuous Deployment (CD) of your application using GitHub Actions and Amazon ECS.
- Document only what must be defined and referenced for automated deployment—do not include implementation samples except for workflow step naming and arrangement.

---

## What to Define

### 1. CD Workflow and Configuration Management

- Store the CD workflow YAML file (e.g., `.github/workflows/auto-deploy-web-ecs.yaml`) in your repository and maintain all CD settings in version control.
- All details of the actual CD pipeline (steps, conditions, environment variables, secrets) must be fully documented in the YAML and the project README, not the product docs.

---

### 2. Prerequisites and Environment Preparation

- Define required AWS infrastructure beforehand:
    - ECS Cluster (name and region)
    - ECS Service
    - ECS Task Definition (name/version)
- Specify all required GitHub secrets for workflow (e.g., `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and any others).
- Confirm permissions and environment variable requirements for both GitHub Actions and AWS.

---

### 3. Pipeline Steps (to be included in workflow file)

- **Fetch Task Definition:**  
  - Step to pull the current ECS task definition using AWS CLI and store it as a JSON file (for use in updating).
- **Update Task Definition:**  
  - Step to fill in the new container image/tag in the ECS task definition (using the appropriate GitHub Action).
- **Deploy to ECS:**  
  - Step to deploy updated task definition to ECS service/cluster, with setting to wait for service stability before workflow proceeds.

---

### 4. Configuration Artifacts

- Name precise YAML file for CD workflow (`auto-deploy-web-ecs.yaml` or equivalent).
- Keep all related shell scripts, task definition files, and deployment configuration files in version control and referenced by the workflow.

---

### 5. Documentation/Reference

- Provide a link or direct path to the latest version of your CD setting file (e.g.,  
  [auto-deploy-web-ecs.yaml](https://github.com/58web3/llm/blob/develop/.github/workflows/auto-deploy-web-ecs.yaml)).
- Ensure all pipeline steps, environment variables, and permissions required are explained within source repository's `README.md` or similar onboarding doc.

---

**Note:**  
CD setting and workflow must be managed alongside source code; only reference location and step summary in project documentation.
