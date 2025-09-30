---
id: cd-setting
title: CD Setting
---

## CD Setting File

To view full content of the cd setting plz visit the link below

https://github.com/58web3/llm/blob/develop/.github/workflows/auto-deploy-web-ecs.yaml

## CD Setting

### Continuous Deployment (CD) with GitHub Actions and Amazon ECS

This document covers a series of steps to enable Continuous Deployment (CD) for an application using GitHub Actions and Amazon's Elastic Container Service (ECS). Each step is explained in detail to help you understand the overall process and perform necessary configurations.

### Prerequisites

1. **Amazon Web Services (AWS) Setup**:
    - An Amazon ECS Cluster (`dev-llm`).
    - An ECS Service (`dev-llm-api`).
    - An ECS Task Definition (`dev-llm-api`).

2. **GitHub Repository**:
    - A configured repository where you will create the GitHub Actions workflow.
    - Secrets configured for AWS credentials (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`) and any other necessary configurations.

## GitHub Actions Workflow Steps

Below is a breakdown of the YAML snippet for the GitHub Actions workflow.

### Step 1: Get the ECS Task Definition

```yaml
- name: Get task definition
  run: |
    aws ecs describe-task-definition --task-definition dev-llm-api --query taskDefinition > task-definition.json
```

#### Details:

- **Name**: Get task definition
- **Action**: Execute AWS CLI command to get the ECS Task Definition for the service `dev-llm-api`.
- **Details**:
  - Uses the `aws ecs describe-task-definition` command to fetch the current ECS Task Definition.
  - Filters the response to return only the `taskDefinition` section and stores it in a file named `task-definition.json`.

### Step 2: Update the Task Definition with the New Image

```yaml
- name: Fill in the new image ID in the Amazon ECS task definition
  id: task-def
  uses: aws-actions/amazon-ecs-render-task-definition@v1
  with:
    task-definition: task-definition.json
    container-name: api
    image: ${{ steps.build-image.outputs.image }}
```

#### Details:

- **Name**: Fill in the new image ID in the Amazon ECS task definition
- **ID**: task-def (this `id` is used later to reference the outputs of this action)
- **Action**: Uses the `aws-actions/amazon-ecs-render-task-definition@v1` action to update the `task-definition.json` with the new container image.
- **Inputs**:
  - `task-definition`: The path to the task definition file (`task-definition.json`) retrieved in Step 1.
  - `container-name`: The name of the container (`api`) in the task definition to be updated.
  - `image`: The new image ID that was built previously (`${{ steps.build-image.outputs.image }}`).

### Step 3: Deploy the Updated Task Definition

```yaml
- name: Deploy Amazon ECS task definition
  uses: aws-actions/amazon-ecs-deploy-task-definition@v1
  with:
    task-definition: ${{ steps.task-def.outputs.task-definition }}
    service: dev-llm-api
    cluster: dev-llm
    wait-for-service-stability: true
```

#### Details:

- **Name**: Deploy Amazon ECS task definition
- **Action**: Uses the `aws-actions/amazon-ecs-deploy-task-definition@v1` action to deploy the updated ECS Task Definition.
- **Inputs**:
  - `task-definition`: The updated task definition from Step 2 (`${{ steps.task-def.outputs.task-definition }}`).
  - `service`: The ECS service name (`dev-llm-api`) that is to be updated.
  - `cluster`: The ECS cluster name (`dev-llm`).
  - `wait-for-service-stability`: Ensures that the workflow waits until the service is stable before proceeding (`true`).
