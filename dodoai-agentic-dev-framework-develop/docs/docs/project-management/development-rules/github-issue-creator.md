---
id: github-issue-creator
title: GitHub Issue Creator
---

## Overview

- A powerful tool for creating issues on GitHub, developed by Kasper and written in Google Apps Script.
- This tool allows you to create multiple issues simultaneously based on pre-defined templates quickly and easily.
- With this feature, you can save time and ensure that the issues created adhere to ADF regulations.

[GitHub Issue Creator link](https://docs.google.com/spreadsheets/d/1riEJcvGzXSueyBU5tbjlH4DUKx2bpi4r/edit?usp=sharing&ouid=106885423561706431233&rtpof=true&sd=true)

## Key Features

- **Bulk Issue Creation:** Create multiple issues at once based on pre-defined templates.
- **Standardized Formatting:** Ensures that the created issues comply with ADF regulations.

## How to Use

To use this tool, you need to create a token and set up a few steps on GitHub beforehand.

### GitHub Preparation

1. Create a token at [GitHub Tokens](https://github.com/settings/tokens).

   - Click **Generate new token**. Select **New personal access token (classic)**.
   - Set permissions.
   - Check **all** under **repo**.
   - Check **all** under **project**.
   - Click **Generate token**.

2. Copy the generated token and save it somewhere secure.

### Steps to Using the Tool

- Open the [GitHub Issue Creator link](https://docs.google.com/spreadsheets/d/1tVnxJzJpan8ToeOxC2yEouGM6JQuWBAFohxTXu7Bxi0/edit?gid=912739404#gid=912739404) and copy this spreadsheet to your project folder.

1. Open the "issues" sheet.
   - Enter Title, Body, Labels, Milestone (ID), and Assignees in the sheet.
   - Enter the Milestone ID.
     - This is the number at the end of the milestone URL (e.g., `91` in `https://github.com/58web3/dodoai/milestone/91`).

2. Check the checkbox in the row of the issue you want to create.
   - You can check up to 8 items at the same time.
   - Too many checks will result in an error.

3. Click `Scripts` -> `Create Issue` in the menu.
   - The first time you run this, you will receive a warning saying "This app has not been verified by Google." Click on "Details" to give permission. Enter the AccessToken in the pop-up prompt.

4. Check the results on GitHub issues.

### This tool helps managers reduce manual work, save time, and improve efficiency in managing projects on GitHub.
