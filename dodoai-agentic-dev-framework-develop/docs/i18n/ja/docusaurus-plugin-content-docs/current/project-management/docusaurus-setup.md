---
id: docusaurus-setup
title: Docusaurus セットアップ
---

58 では、AI エージェントが設計を正しく理解した上で動作するため、要件定義から設計までのドキュメントを機械可読形式で管理することが重要です。プロジェクトのシステム関連ドキュメントはすべて Docusaurus を使用し、Markdown で管理します。  

クライアントへの提出が必要な場合は、Markdown をエクスポートして Google ドキュメントなどを通じて提出してください。

## 概要
- [概要](#概要)
- [Docusaurus の作成方法](#docusaurus-の作成方法)
  - [1. dodoai-low-code のコードをローカル環境に取得](#1-dodoai-low-code-のコードをローカル環境に取得)
  - [2. 新しいプロジェクトのコードを取得](#2-新しいプロジェクトのコードを取得)
  - [3. dodoai-low-code から新しいプロジェクトに Docusaurus をコピー](#3-dodoai-low-code-から新しいプロジェクトに-docusaurus-をコピー)
  - [4. 新しいプロジェクトの Docusaurus を GitHub にプッシュ](#4-新しいプロジェクトの-docusaurus-を-github-にプッシュ)
  - [5. PR (プルリクエスト) を作成](#5-pr-プルリクエスト-を作成)

## Docusaurus の作成方法

### 1. dodoai-low-code のコードをローカル環境に取得

- [***dodoai-low-code***](https://github.com/58web3/dodoai-low-code) にアクセスします。
- リポジトリの URL をコピーします。

  <!-- ![alt text](assets/docusarus-setup/docusaurus.1.png) -->

- ターミナルまたは Git Bash を開きます。
- 以下のコマンドを実行してリポジトリをクローンします: `git clone URL`
- クローンしたディレクトリへ移動します（ディレクトリ名はリポジトリ名と同じです）：`cd project-name`

  <!-- ![alt text](assets/docusarus-setup/docusaurus.2.png) -->

 ### 2. 新しいプロジェクトのコードを取得

手順は [1. dodoai-low-code のコードをローカル環境に取得](#1-dodoai-low-code-のコードをローカル環境に取得) と同様です。

### 3. dodoai-low-code から新しいプロジェクトに Docusaurus をコピー
- `dodoai-low-code` 内の `docusaurus` フォルダーをコピーします（Ctrl+C）。

  <!-- ![alt text](assets/docusarus-setup/docusaurus.3.png) -->

- コピーした `docusaurus` フォルダーを、新しく作成したプロジェクトフォルダーに貼り付けます（Ctrl+V）。

  <!-- ![alt text](assets/docusarus-setup/docusaurus.4.png) -->

### 4. 新しいプロジェクトの Docusaurus を GitHub にプッシュ

ターミナルを開き、以下のコマンドを実行します：

- ファイルを Git に追加: `git add .` を実行  
- 変更をコミット: `git commit -m "コミットメッセージ"` を実行  
- コードを GitHub にプッシュ: `git push` を実行  

### 5. PR (プルリクエスト) を作成  

- プルリクエストの作成を開始: `Pull requests` タブに移動し、`New pull request` を選択  
- ベースブランチとマージ先のブランチを選択  
- プルリクエストの情報を入力: タイトル、説明など  
- プルリクエストを送信: `Create pull request` をクリックして送信        

 
