---
id: branch-name
title: Branch Name
---

Please proceed with development according to the ADF used internally at 58

- STEP 1: `feature/{milestone_name}_{your_name}_{issue_number}` -> `features/{milestone_name}`.
  At this stage, only Unit Test CI

- STEP 2: `features/{milestone_name}` -> `feature/v{version_number}`.
  At this stage, set Cucumber CI

- STEP 3: `feature/v{version_number}` -> `develop` -> `main`.
  At this stage, prepare for release.

### Source code Management

Manage source code with Github  
Use "main" and "develop" as the main branch.  
Also, use "feature", "release", "hotfix", and "prototype" as support branches.

### Main branch

- main

    The main branch of the HEAD of source code, which always reflects the state of being ready to ship as a product. Only merged from the release branch.

- develop

    The main branch of the source code HEAD that always reflects the latest development work changes for the next release. Set the normal PR merge destination to the develop branch.

### Support branch

#### feature

- Used to develop new features.
- Divide the feature branch into two to flexibly respond to changes in the release schedule:
  - **feature**: `feature/{milestone_name}_{your_name}_{issue_number}`
  - **Document:** `doc/{your_name}_{function_name}_{issue_number}`
- For version-specific features, use: `feature/v{version_number}`.

#### hotfix

Use when a critical bug needs to be resolved immediately.

- **Backend**: `bugfix/api/{your_name}_{bug}_{issue_number}`
- **Frontend**: `bugfix/frontend/{your_name}_{bug}_{issue_number}`

#### prototype

Used when committing sample code for research tasks.

- prototype/branch_name
