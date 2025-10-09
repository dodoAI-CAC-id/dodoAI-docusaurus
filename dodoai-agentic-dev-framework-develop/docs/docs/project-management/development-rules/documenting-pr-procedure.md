---
id: documenting-pr-procedure
title: Document Pull Request Procedure
---

# Pull Request Procedures Documentation

## Purpose (Goal)

The purpose of this document is to provide detailed instructions for creating Pull Requests (PRs) on GitHub. This ensures that developers follow a consistent process for code changes, improving collaboration and code quality.

## Pull Request Procedure

### Introduction

This section outlines the detailed steps to create a Pull Request (PR) on GitHub. It includes essential Git commands and PR requirements to ensure a smooth workflow.

### Steps to Create a Pull Request

1. **Update Source Code**:
   - Ensure your local repository is up-to-date with the main branch:

     ```sh
     git checkout develop
     git pull origin develop
     ```

2. **Create a New Branch (Using the Issue Screen)**:
   - Navigate to the issue screen of your GitHub repository.
   - Use the functionality available to create a branch directly from the issue. This ensures a contextual linkage without leakage.
  
     - Alternatively, you can create a branch using the command line if your workflow doesn't directly support it:

     ```sh
     git checkout -b <branch-name>
     ```

   - **Note:** It's not recommended to use `git checkout -b <branch-name>` due to the risk of leaking the linkage to the Issue. Instead, it's better to create a branch directly from the Issue screen and then check out the Issue.

3. **Make Changes and Commit**:
   - Add all modified files to the staging area:

     ```sh
     git add .
     ```

   - Alternatively, add specific files if needed:

     ```sh
     git add <file>
     ```

   - Commit your changes with a descriptive message:

     ```sh
     git commit -m "Describe your changes"
     ```

4. **Push Branch to GitHub**:
   - Push your branch to the remote repository:

     ```sh
     git push origin <branch-name>
     ```

   - **Force Push (Optional)**: If you need to overwrite the remote branch with your local changes, use:

     ```sh
     git push origin <branch-name> -f
     ```

   - **`-f` (force)**: This option forces the push even if it results in a non-fast-forward merge on the remote branch. Use with caution as it can overwrite changes made by others.

5. **Create a Pull Request**:
   - Go to your GitHub repository page.
   - Select your branch and create a new Pull Request from your branch.
   - Fill in the PR title and description.
   - Select reviewers and submit the PR.

### PR Requirements and Guidelines

- **PR Title**: Ensure the title is descriptive and summarizes the purpose of the PR.
- **PR Description**: Include a clear description of the changes made and any relevant information for reviewers.
- **Review Process**: Allow time for team members to review and provide feedback. Address any comments or required changes.

## Review and Approval

- Review the document to ensure all information is complete and clear.
- Request feedback from team members to validate the accuracy and usefulness of the documentation.

## Publishing

- Publish the documentation to your GitHub repository or internal documentation platform.

## Related Links and Resources

- [GitHub Pull Request Documentation](https://docs.github.com/en/pull-requests)
- [Git Command Reference](https://git-scm.com/docs)
