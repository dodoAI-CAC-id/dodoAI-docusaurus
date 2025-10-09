---
id: docusaurus-setup
title: Docusaurus Setup
---

At 58, AI Agents work based on a correct understanding of the design. Therefore, it is crucial to manage documentation from requirements definition to design in a machine-readable format. Manage all system-related documentation for the project in Markdown using Docusaurus.

If submission to the client is necessary, export the Markdown and submit it via Google Docs or similar.

## Overview

- [Overview](#overview)
- [How to Create Docusaurus](#how-to-create-docusaurus)
  - [1. Pull the code from dodoai-low-code to your local machine](#1-pull-the-code-from-dodoai-low-code-to-your-local-machine)
  - [2. Pull the code of the new project](#2-pull-the-code-of-the-new-project)
  - [3. Copy Docusaurus from dodoai-low-code to the new project](#3-copy-docusaurus-from-dodoai-low-code-to-the-new-project)
  - [4. Push the Docusaurus of the new project to GitHub](#4-push-the-docusaurus-of-the-new-project-to-github)
  - [5. Create a PR (Pull Request)](#5-create-a-pr-pull-request)

## How to Create Docusaurus

### 1. Pull the code from dodoai-low-code to your local machine

- Access the [***dodoai-low-code***](https://github.com/58web3/dodoai-low-code).
- Copy the repository URL.

- Open Terminal or Git Bash.
- Run the command git clone with the URL you just copied: `git clone URL`
- Navigate to the directory (The directory will have the same name as the repository): `cd project-name`

### 2. Pull the code of the new project

The steps are the same as in step 1 [Pull the code from dodoai-low-code to your local machine](#1-pull-the-code-from-dodoai-low-code-to-your-local-machine).

### 3. Copy Docusaurus from dodoai-low-code to the new project

- Copy the docusaurus folder from `dodoai-low-code` (Ctrl+C).

- Paste the copied `docusaurus` folder into the newly created project folder (Ctrl+V).

### 4. Push the Docusaurus of the new project to GitHub

Open the terminal and run the following commands:

- Add files to Git: run the command `git add .`
- Commit changes: run the command `git commit -m "Your commit message"`
- Push the code to GitHub: run the command `git push`

### 5. Create a PR (Pull Request)

- Start creating the Pull Request: go to the `Pull requests` tab and select `New pull request`.
- Choose the base branch and the branch you want to merge into.
- Fill in the Pull Request information: Title, Description...
- Submit the Pull Request: click `Create pull request` to submit.
