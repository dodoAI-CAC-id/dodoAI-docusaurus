---
id: issue-registration
title: Issue Registration
---

# Issue Registration

This document outlines the process for registering issues on GitHub, detailing the information required for each task.

## Purpose

The guidelines provided here ensure that each issue registered on GitHub is clear and actionable, facilitating efficient handling.

## Issue Status

- **Todo**  
  Backlog or not ready to start.
- **In Progress**  
  Currently under development or receiving support.
- **In Review**  
  Being reviewed by peers or team lead.
- **Done**  
  Completed with an associated Pull Request (PR).

**Note**: Typically, issues are closed automatically when the related PR is merged. Handle this setting with care.

## Rules

1. **Issue Title**
   - Provide a concise and clear title that accurately reflects the issue's content.

2. **Purpose (Goal)**
   - Clearly state the goal of the issue.
   - Example: "The purpose of this issue is to fix a login bug that hinders user experience."

3. **Specification (Spec)**
   - **New Feature**: List detailed requirements for new features.
   - **Bug**: Provide reproducibility steps, expected behavior, and actual behavior.

4. **Project**
   - Select the relevant project.

5. **Related Links and Resources**
   - Include any related documents, links, screenshots, code snippets, etc.

6. **Checklist (if necessary)**
   - Use a checklist to outline steps or tasks.
   - Example:
     - [ ] Reproduce the bug
     - [ ] Fix the code
     - [ ] Write unit tests
     - [ ] Conduct code review

### After the above details have been filled, select 'Submit new issue' to save. Proceed to set up the following issue information:

1. **Assignees**
   - Specify the member handling the issue.
   - Example: `@username`

2. **Labels**
   - Apply suitable labels such as bug, feature request, or documentation.
   - Example: `bug, high priority`

3. **Milestone**
   - Associate the issue with a milestone if applicable.

## Issue Creation Using Tools

To minimize manual input, consider using screenshot (SS) tools. Ensure images are correctly pasted by referring to the image below.

[Sample template in SS](https://58llm.link/main/restore/28c911c2-4060-45f2-81c0-2609dfbc7c82)

## Issue Templates

### New Feature Template

```markdown
# Issue Title

## Purpose (Goal)
The purpose of this issue is to achieve [specific goal].

## Specification (Spec)
- Requirements:
  1. [Requirement 1]
  2. [Requirement 2]
  3. [Requirement 3]

## Project
- Project: [Project Name]

## Related Links and Resources
- [Related documents and links]

## Checklist (if necessary)
- [ ] [Task 1]
- [ ] [Task 2]
- [ ] [Task 3]
```

### Bug Template

```markdown
# Issue Title

## Purpose (Goal)
The purpose of this issue is to achieve [specific goal].

## Specification (Spec)
- Steps to reproduce:
  1. [Step 1]
  2. [Step 2]
  3. [Step 3]
- Expected behavior: [Expected behavior]
- Current behavior: [Current behavior]

## Project
- Project: [Project Name]

## Related Links and Resources
- [Related documents and links]

## Checklist (if necessary)
- [ ] Reproduce the bug
- [ ] Fix the code
- [ ] Write unit tests
- [ ] Conduct code review
```
