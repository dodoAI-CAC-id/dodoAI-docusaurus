---
id: github-milestone-setup
title: Github Milestone Setup
---

# Github MileStone Setup

## Register Milestones in GitHub
Link the level 1 development tasks registered in Notion to milestones in GitHub.
Set the end date of the milestone to the end date of the level 1 development task in Notion.

Each level 1 task should link directly to the corresponding milestone.
More detailed development tasks (level 2) are defined as issues in GitHub.

Refer to the ADF for the tasks to be registered.
[Miro ADF](https://miro.com/app/board/uXjVNhdn81M=/?moveToWidget=3458764589861350205&cot=14)

## Register Issues in GitHub
When registering tasks based on the ADF, be sure to follow these guidelines:
- If it is cumbersome to create issues for each feature, there is an Issue Registration Tool available using Google App Script (Gas).  [GitHub Issue Creator](https://docs.google.com/spreadsheets/d/1tVnxJzJpan8ToeOxC2yEouGM6JQuWBAFohxTXu7Bxi0/edit?gid=912739404#gid=912739404)
- If you want to use it, ask the lead engineer in the team.

- Requirements definition and design tasks
  - One task for the entire project is sufficient.
- Development tasks
  - Need to be registered for each feature.

**Important Notes on Issue Size**
At 58, development is primarily done using AI. To ensure the efficiency of AI Agents, adhere to the following:
- 1 Issue = 1 PR. Larger development sizes in issues decrease review efficiency and ultimately reduce quality.
- The ideal step count for a single file is less than 100 lines. By consistently outputting complete code, AI automation by AI Agents becomes feasible. Always aim to minimize file size. If the step count becomes large, consider whether it can be modularized and split the files. This also improves maintainability.

