---
id: cd-setting
title: CD設定
---

## CD設定ファイル
CD設定の全コンテンツは以下のリンクからご覧ください

https://github.com/58web3/llm/blob/develop/.github/workflows/auto-deploy-web-ecs.yaml


## CD設定
## GitHub Actions と Amazon ECS を使用した継続的デプロイメント（CD）

このドキュメントでは、GitHub Actions と Amazon の Elastic Container Service (ECS) を使ったアプリケーションのための継続的デプロイメント（CD）を可能にする一連のステップを説明します。それぞれのステップについて詳しく説明し、全体的なプロセスを理解し、必要な設定を行えるようサポートします。

## 事前準備

1. **Amazon Web Services (AWS) の設定**:
    - Amazon ECS クラスター（`dev-llm`）。
    - ECS サービス（`dev-llm-api`）。
    - ECS タスク定義（`dev-llm-api`）。

2. **GitHub リポジトリ**:
    - GitHub Actions ワークフローを作成するための設定済みのリポジトリ。
    - AWS資格情報（`AWS_ACCESS_KEY_ID`、`AWS_SECRET_ACCESS_KEY`）およびその他の必要な設定のためのシークレットを設定。

## GitHub Actions ワークフローステップ

以下に、GitHub Actions ワークフローの YAML スニペットを分解した内容を示します。

### ステップ1: ECS タスク定義を取得

```yaml
- name: Get task definition
  run: |
    aws ecs describe-task-definition --task-definition dev-llm-api --query taskDefinition > task-definition.json
```

#### 詳細:
- **名前**: タスク定義の取得
- **アクション**: AWS CLI コマンドを実行し、サービス `dev-llm-api` の ECS タスク定義を取得する。
- **詳細**:
  - `aws ecs describe-task-definition` コマンドを使用して、現在の ECS タスク定義を取得する。
  - 応答を `taskDefinition` セクションのみにフィルタリングし、`task-definition.json` というファイルに保存する。

### ステップ 2: 新しいイメージでタスク定義を更新

```yaml
- name: Amazon ECS タスク定義に新しいイメージ ID を反映
  id: task-def
  uses: aws-actions/amazon-ecs-render-task-definition@v1
  with:
    task-definition: task-definition.json
    container-name: api
    image: ${{ steps.build-image.outputs.image }}
```

#### 詳細:
- **名前**: Amazon ECS タスク定義に新しいイメージ ID を反映
- **ID**: task-def（この `id` は後のステップで出力を参照するために使用）
- **アクション**: `aws-actions/amazon-ecs-render-task-definition@v1` を使用し、`task-definition.json` に新しいコンテナイメージを適用。
- **入力**:
  - `task-definition`: ステップ 1 で取得したタスク定義ファイルのパス (`task-definition.json`)。
  - `container-name`: 更新対象のコンテナ名 (`api`)。
  - `image`: 以前のステップでビルドされた新しいイメージ ID (`${{ steps.build-image.outputs.image }}`)。

### ステップ 3: 更新されたタスク定義をデプロイ

```yaml
- name: Amazon ECS タスク定義をデプロイ
  uses: aws-actions/amazon-ecs-deploy-task-definition@v1
  with:
    task-definition: ${{ steps.task-def.outputs.task-definition }}
    service: dev-llm-api
    cluster: dev-llm
    wait-for-service-stability: true
```

#### 詳細:
- **名前**: Amazon ECS タスク定義をデプロイ
- **アクション**: `aws-actions/amazon-ecs-deploy-task-definition@v1` を使用して、更新された ECS タスク定義をデプロイ。
- **入力**:
  - `task-definition`: ステップ 2 で更新されたタスク定義 (`${{ steps.task-def.outputs.task-definition }}`)。
  - `service`: 更新対象の ECS サービス名 (`dev-llm-api`)。
  - `cluster`: ECS クラスター名 (`dev-llm`)。
  - `wait-for-service-stability`: サービスが安定するまでワークフローを待機させる (`true`)。
