---
id: ci-setting-frontend-unit-testing
title: CI設定 (フロントエンド/ユニットテスト)
---

## CI設定 (フロントエンド/ユニットテスト)

## 概要

このドキュメントでは、フロントエンドのユニットテスト用のCI設定について詳しく説明します。ユニットテスト用のCIを設定することで、特定のGitHubイベントでテストを自動的に実行し、コードの品質と安定性を確保します。CIプロセスはGitHub Actionsを使用して設定されています。

## フロントエンドユニットテストのためにCIを設定する理由

- **自動化テスト**: ユニットテストプロセスを自動化して早期に問題を発見します。
- **コード品質**: すべてのテストが通過してからマージすることで、高いコード品質を維持します。
- **継続的インテグレーション**: プッシュおよびプルリクエストごとにテストを実行して継続的インテグレーションを確保します。

## 設定

### GitHub Actions

CI設定はGitHub Actionsを使用して構成されます。構成ファイルは`.github/workflows/frontend-test-develop.yaml`に配置してください。

### サンプル構成ファイル

以下はフロントエンドのユニットテスト用のGitHub Actions構成ファイルのサンプルです。

```yaml
name: Flutter Test Develop

on:
  push:
    branches:
      - 'feature/frontend_*'
  pull_request:
    types:
      - reopened
    branches:
      - 'develop'
    paths:
      - 'desktop-app/**'

defaults:
  run:
    working-directory: 'desktop-app'

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Cache Flutter dependencies
        uses: actions/cache@v3
        with:
          path: ${{ github.workspace }}/desktop-app/.pub-cache
          key: flutter-${{ hashFiles('**/pubspec.yaml') }}
          restore-keys: |
            flutter-

      - name: Install Flutter
        run: |
          git clone https://github.com/flutter/flutter.git -b 3.22.0 $HOME/flutter
          echo "$HOME/flutter/bin" >> $GITHUB_PATH

      - name: Flutter Doctor
        run: flutter doctor

      - name: Get Dependencies
        run: |
          flutter clean
          flutter pub get

      - name: Run Flutter Tests
        run: flutter test
        env:
          RUN_MODE: test
```

## ガイドライン

- **ローカル実行:** Pull Request (PR) を作成する前に、必ずローカルでテストを実行すること。  
- **PR の要件:** ユニットテストと対応するコードの変更を同じ PR に含めること。  
- **チームの責任:** フロントエンドチームは、ユニットテストの CI 設定と管理を担当する。  

## 手順

1. **設定ファイルの作成:**  
   - CI 設定ファイルを `.github/workflows/frontend-test-develop.yaml` に追加する。  

2. **GitHub Actions の設定:**  
   - GitHub Actions がリポジトリで有効になっていることを確認する。  

3. **ローカルでテストを実行:**  
   - プッシュする前に、ローカル環境で同じ設定を使用してユニットテストを実行する。  

4. **Pull Request を作成:**  
   - ユニットテストとコードの変更を同じ PR に含めること。  
   - CI プロセスは、`feature/frontend_*` ブランチへのプッシュ時、および `develop` ブランチへの PR 作成時に自動でテストを実行する。  

これらの手順とガイドラインに従うことで、フロントエンドの堅牢で自動化されたテストプロセスを確立し、コードの品質と安定性を向上させることができます。

