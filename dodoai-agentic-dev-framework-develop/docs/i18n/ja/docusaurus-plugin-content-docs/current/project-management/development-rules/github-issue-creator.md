---
id: github-issue-creator
title: GitHub Issue Creator
---

## 概要

- Kasperが開発し、Google Apps Scriptで作成されたGitHubでのIssue作成の強力なツールです。
- 定義済みのテンプレートに基づいて、複数のIssueを同時に迅速かつ簡単に作成できます。
- この機能を使用することで、時間を節約し、作成されたIssueがSDF規定に準拠していることを確保できます。

[GitHub Issue Creator リンク](https://docs.google.com/spreadsheets/d/1riEJcvGzXSueyBU5tbjlH4DUKx2bpi4r/edit?usp=sharing&ouid=106885423561706431233&rtpof=true&sd=true)

## 主な特徴

- **一括Issue作成**: 定義済みのテンプレートに基づいて複数のIssueを一度に作成できます。
- **標準化されたフォーマット**: 作成されたIssueがSDF規定を遵守していることを保証します。

## 使用方法

このツールを使用するには、事前にトークンを作成し、GitHubでいくつかの手順を設定する必要があります。

### GitHub準備

1. [GitHub Tokens](https://github.com/settings/tokens)でトークンを作成します。

   - **Generate new token**をクリックします。**New personal access token (classic)**を選択します。
   - アクセス権を設定します。
   - **repo**の下で**all**をチェックします。
   - **project**の下で**all**をチェックします。
   - **Generate token**をクリックします。

2. 生成されたトークンをコピーし、安全な場所に保存します。

### ツールの使用手順

- [GitHub Issue Creatorリンク](https://docs.google.com/spreadsheets/d/1tVnxJzJpan8ToeOxC2yEouGM6JQuWBAFohxTXu7Bxi0/edit?gid=912739404#gid=912739404)を開き、このスプレッドシートをプロジェクトフォルダにコピーします。

1. "issues"シートを開きます。
   - シートにタイトル、本文、ラベル、マイルストーン (ID)、担当者を入力します。
   - マイルストーンIDを入力します。
     - これはマイルストーンURLの最後の番号です（例：`https://github.com/58web3/dodoai/milestone/91` の `91`）。

2. 作成したいIssueの行にあるチェックボックスをチェックします。
   - 一度に最大で8項目までチェックできます。
   - チェックが多すぎるとエラーになります。

3. メニューの `Scripts` -> `Create Issue` をクリックします。
   - 初めて実行すると、「このアプリはGoogleによって確認されていません」という警告が表示されます。「詳細」をクリックして許可を与えます。ポップアッププロンプトでAccessTokenを入力します。

4. GitHubのIssuesで結果を確認します。

### このツールは、マネージャーが手作業を減らし、時間を節約し、GitHubでのプロジェクト管理の効率を向上させるのに役立ちます。
