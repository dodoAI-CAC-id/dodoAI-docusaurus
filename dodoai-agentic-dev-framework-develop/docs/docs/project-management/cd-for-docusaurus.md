---
id: cd-for-docusaurus
title: Docusaurus for LowCode
---

## Overview

To facilitate the straightforward setup of Continuous Deployment (CD) for project documentation, `CD for Docusaurus` has been pre-configured in the `dodoAI-low-code` project for immediate use. `CD for Docusaurus` enables immediate utilization of CD without requiring setup, thus accelerating workflow progress and project timelines while minimizing potential errors during future CD setups.

## Essential Information

- Ensure that you have the necessary access permissions to the repositories.
- Verify that the project repository is linked to its respective GitHub project.
- Recognize that a repository may contain multiple GitHub projects, each serving a distinct function.

## How to Implement the Simple Setup of `CD for Docusaurus`

### Step 1: Check and Clone Repository

1.1. Access the link [CD for Docusaurus](https://github.com/58web3/dodoai-low-code/tree/develop/cd-for-docusarus) to determine whether `CD for Docusaurus` already exists.

1.2. Navigate to the repository using this link [dodoAI Low Code repository](https://github.com/58web3/dodoai-low-code/); select **Code** and then copy the HTTPS link (clone using the web URL).

1.3. Return to your Integrated Development Environment (IDE).

1.4. Open your terminal and execute the following command to clone the repository (Here, I am using VS Code on macOS) by pressing the keyboard shortcut

```markdown
Shift Control `
```

- Select File → Open Folder. Choose the destination folder (if one does not exist, please create a new folder to store the code).
- Execute the command to clone the code from the repository:

```markdown
git clone https://github.com/58web3/dodoai-low-code.git
```

### Step 2: Clone Your Working Repository

2.1. Clone the repository code you are working on using the method described in *[Step 1: Check and Clone Repository](#step-1-check-and-clone-repository)*.

### Step 3: Copy CD Configuration

3.1. Open the `dodoai-low-code` folder you just cloned, in Finder or on your computer (Windows).

3.2. Copy the `cd-for-docusarus` section and paste it into the folder where you cloned the code in *[Step 2: Clone Your Working Repository](#step-2-clone-your-working-repository)*.
### Step 4: Finalize Setup in IDE

4.1. Return to your VS Code (IDE) and perform actions similar to those in this step: [Document Pull Request Procedure](../project-management/development-rules/documenting-pr-procedure.md)

### ***Special Note*** : When Documenting an Existing Feature from Another Project

- Add an overview file beneath that feature.
- In the overview file, include links to the Docusaurus documentation of the original project.
  
***Example*** :
If the DID/VC feature is already being used in Project A, then when creating documentation for DID/VC in Project B, simply add links to the existing DID/VC documentation from Project A in the overview file of DID/VC in Project B.
