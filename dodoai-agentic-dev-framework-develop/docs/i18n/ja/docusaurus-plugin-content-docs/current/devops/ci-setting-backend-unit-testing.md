---
id: ci-setting-backend-unit-testing
title: CI 設定 (バックエンド / ユニットテスト)
---

## CI 設定 (バックエンド / ユニットテスト)

## 概要

このドキュメントは、バックエンド API のユニットテスト向け CI 設定の詳細を提供します。CI を設定することで、特定の GitHub イベントで自動的にテストが実行され、コードの品質と安定性を確保できます。CI プロセスは GitHub Actions を使用して構成されています。

## バックエンドユニットテストの CI 設定の理由

- **自動テスト:** ユニットテストを自動化し、問題を早期に検出する。  
- **コード品質:** マージ前にすべてのテストを通過させることで、高いコード品質を維持する。  
- **継続的インテグレーション:** すべてのプッシュおよびプルリクエストでテストを実行し、継続的な統合を確保する。  

## 設定

### GitHub Actions

CI の設定は GitHub Actions を使用して行います。設定ファイルは `.github/workflows/be-api-unit-test.yaml` に配置してください。

### サンプル設定ファイル

以下は、バックエンド API のユニットテスト用の GitHub Actions 設定ファイルのサンプルです。

```yaml
name: Backend API Unit Test

on:
  push:
    branches:
      - 'feature/api_*'
  pull_request:
    types:
      - reopened
    branches:
      - 'develop'
    paths:
      - 'api/**'

defaults:
  run:
    working-directory: 'api'

jobs:
  test:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [18.9]

    steps:
      - uses: actions/checkout@v3
      - name: Use Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v3
        with:
          node-version: ${{ matrix.node-version }}
      - run: yarn install
      - run: yarn build
      - run: yarn test
        env:
          USE_DYNAMODB_LOCAL: true
          DYNAMODB_REGION: ap-northeast-1
          DYNAMODB_LOCAL_URL: http://localhost:8000
          RUN_MODE: test
```

## ガイドライン

- **ローカル実行:** Pull Request (PR) を作成する前に、必ずローカルでテストを実行する。  
- **PR の要件:** ユニットテストと対応するコードの変更を同じ PR に含める。  
- **チームの責任:** バックエンドチームは、ユニットテストの CI 設定と管理を担当する。  

## 手順

1. **設定ファイルの作成:**  

   - CI 設定ファイルを `.github/workflows/be-api-unit-test.yaml` に追加する。  

2. **GitHub Actions の設定:**  

   - GitHub Actions がリポジトリで有効になっていることを確認する。  

3. **リポジトリ構造の確認:**  

   - ワークフローは `api` ディレクトリに API 関連のコードがあることを前提としている。  

4. **ブランチの命名規則:**  

   - `feature/api_*` の命名規則に従ったブランチを作成する。  

5. **プルリクエストのターゲット:**  

   - `develop` ブランチに向けたプルリクエストでワークフローが実行されることを確認する。  

6. **環境変数の確認:**  

   - テスト用の環境変数 (DynamoDB 設定など) がローカル環境と一致していることを確認する。  

7. **Node.js のバージョンを追加（オプション）:**  
   - 必要に応じて、以下のように `node-version` マトリクスを拡張し、複数の Node.js バージョンでテストを実行できる。  

```yaml
matrix:
  node-version: [18.9, 16.x, 14.x]
```

## 結論

この GitHub Actions 設定を使用することで、バックエンド API のユニットテストを自動化し、コードの信頼性と保守性を確保できます。この設定はコード品質の維持に役立つだけでなく、テストの手動作業を削減することにもつながります。
