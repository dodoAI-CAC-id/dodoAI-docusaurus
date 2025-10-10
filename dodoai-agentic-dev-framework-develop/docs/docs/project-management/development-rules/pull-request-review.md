---
id: pull-request-review
title: Pull Request & Review
---

# Pull Request & Review

## Overview

- `feature/{milestone_name}_{your_name}_{issue_number}` → `features/{milestone_name}`
- `features/{milestone_name}` → `feature/v{version_number}`
- `feature/v{version_number}` → develop → main

## Attention to PR Review

- For each file modified in the PR, there should be a log entry requesting dodoAI to review that file.
- Review Process:
  - Use the *Code review* feature in the *dodoAI App* to select all modified files in the PR for AI review. Then, request a detailed review of each file by adding "Detailed review for file xxxx.yyy" in the Additional Prompt. Continue this process for each file until all have been reviewed.
  - If using the web-based review template, review each file sequentially until all modified files in the PR have been reviewed.
- Review the AI’s ***suggested code***, incorporate necessary suggestions, or provide a rationale for not including certain suggestions if questioned by the reviewer.

## Pull Request (PR)

### When creating a PR, ensure the following are included

- Fill PR Title and Description : Provide an overview of the changes and link to the related Issue (1 PR: 1 Issue).
- When creating a PR, if you add `Close #issue_id` in the Description, the issue will be closed automatically after merging.
- Note (if necessary) : Record any necessary requirements or configurations related to the order of PR merges.
- DodoAI URL :
Include the URL of LLM tool logs used during development and self-assessment in the PR description.
- Proof (Screenshot Evidence) :
Attach screenshots showing the changes or bug fixes.
- Set Reviewer: Assign reviewers to the PR. 
- Assign Yourself as the Assignee :
Set yourself as the person responsible for the PR.

## PR template

```markdown
## Note  (if necessary)
- Record the NOTES and requirements related to the order of merging PRs or any necessary configurations.

## Description
- Rewrite the summary of the tasks performed for this issue and its goal.

## dodoAI log
- Provide the logs of dodoAI during the development process and self-preview.

## Evidence
- Include screenshots showing changes or fixes.
```

## PR Review

### Merge Rules

- PRs not related to a specific Issue should not be merged by the reviewer.
- Issues related to frontend or backend will be merged by the leader. `feature/{milestone_name}_{your_name}_{issue_number}` → `features/{milestone_name}`
- Managers (PdM/PM) will merge `features/{milestone_name}` → `feature/v{version_number}`.
- Issues related to design and system testing will be merged by the manager (Manager, PdM/PM).
- If merging a branch into `features/{milestone_name}`, at least 1 approval from the reviewers is required to merge.
- If merging into `develop` or `main`, at least 2 approvals from the reviewers are needed to proceed with the merge.

#### PR Review and Merge Process

- After development is complete, the developer will create a PR from `feature/{milestone_name}_{your_name}_{issue_number}` → `features/{milestone_name}`.
  - Then request cross-reviews from other developers and the leader.

#### Leader

- Review the code.
- Merge the PR: `feature/{milestone_name}_{your_name}_{issue_number}` → `features/{milestone_name}`.

#### Tester

- After branch `features/{milestone_name}` is merged into `feature/v{version_number}`, system testing will be conducted according to the previously created and reviewed test scenarios.
- Log bugs into the test scenario sheet, discuss them with the developer, and create issues to address them if necessary.
- Then report to the manager (PM and PdM), who will retest. 
- If everything is OK, the manager will request to create an issue requesting to push the `feature/v{version_number}` to the `main` branch.

#### Leader

- Create a pull request to upload `features/{milestone_name}` to the `feature/v{version_number}` branch.

#### Manager (PdM/PM)

- Review and merge into the main branch: `feature/v{version_number}` → develop → main.

#### Post-Deployment Check (Management)

- Feature Validation : Ensure the new feature has been reflected.
- System Availability : Ensure the system is still functioning properly.
