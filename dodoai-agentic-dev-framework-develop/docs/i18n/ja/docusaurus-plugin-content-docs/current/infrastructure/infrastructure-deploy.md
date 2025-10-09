---
id: infrastructure-deploy
title: インフラストラクチャのデプロイ
---

## インフラストラクチャのデプロイ

## 概要

このドキュメントは、提供されたスクリプトに基づいてシステムをデプロイする手順を説明します。デプロイプロセスは次の2つの主要セクションに分かれています: 要件と実行手順。

### 要件

デプロイプロセスを開始する前に、以下の前提条件を確認してください:

1. **AWS IAMユーザー認証情報**: AWSアクセスキーIDおよびシークレットアクセスキーを用意し、AWSでインフラストラクチャを作成および管理するための十分な権限を持っていることを確認してください。

2. **AWS設定**:
   - AWS_ACCESS_KEY_ID
   - AWS_SECRET_ACCESS_KEY
   - AWS_DEFAULT_REGION

3. **Git**: システムにGitがインストールされていて、リポジトリをクローンするためのGitHub SSHキーが設定されていることを確認してください。

4. **Terraform**: システムにTerraformがインストールされていて、適切に構成されていることを確認してください。

5. **コードリポジトリアクセス**: GitHubリポジトリ `58web3/llm.git` へのアクセスを確認してください。

6. **テキストエディタ**: `vi`、`nano`、またはGUIベースのテキストエディタなど、`variables.tf`を編集するためのテキストエディタをインストールしてください。

### 実行手順

以下の手順に従ってシステムをデプロイしてください:

#### ステップ 1: AWS環境変数をセットアップする

AWS認証情報とデフォルトのリージョンを設定するために、必要な環境変数をエクスポートします:

```sh
# AWS環境変数をセットアップ
export AWS_ACCESS_KEY_ID=xxxx
export AWS_SECRET_ACCESS_KEY=xxxx
export AWS_DEFAULT_REGION=ap-northeast-1
```

> *注*: `xxxx`を実際のAWSアクセスキーとシークレットアクセスキーに置き換えてください。

#### ステップ 2: インフラコードをクローンする

インフラストラクチャコードを含むGitHubリポジトリをクローンします:

```sh
# インフラコードをクローン
git clone git@github.com:58web3/llm.git
cd llm/infra
```

#### ステップ 3: Terraformの変数を更新する

`variables.tf` ファイルを開き、要件に応じて必要な変数を更新します:

```sh
# variables.tfを編集
vi variables.tf
```

#### ステップ 4: Terraformの初期化

Terraformの作業ディレクトリを初期化し、必要なプラグインとモジュールをセットアップします:

```sh
# Terraformを初期化
terraform init
```

#### ステップ 5: ワークスペースの作成と選択

使用するワークスペースが目的のワークスペースであることを確認してください。ワークスペースが存在しない場合は、新しく作成して切り替えてください:

```sh
# ワークスペースを新規作成（存在しない場合）
terraform workspace new dev

# ワークスペースを選択
terraform workspace select dev
```

#### ステップ 6: インフラ計画の作成

構成ファイルで指定された目的の状態に一致するように、Terraformが実行するアクションをプレビューするための実行計画を作成します:

```sh
# 実行計画を作成
terraform plan
```

#### ステップ 7: Terraform計画の適用

Terraform計画を実行して、インフラを作成または変更します:

```sh
# Terraform計画を適用
terraform apply
```

適用ステップを進行するには確認が必要な場合があります。