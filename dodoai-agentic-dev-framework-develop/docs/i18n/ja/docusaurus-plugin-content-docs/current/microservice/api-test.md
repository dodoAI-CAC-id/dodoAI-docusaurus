---
id: api-test
title: APIテスト
---

## API テスト

## 手順
Cucumberで定義されたすべてのテストシナリオが合格することを確認します。Cucumberを使用してAPIテストを実行し、エラーが発生した場合、テストが成功するまで修正を繰り返してください。

## 概要
Cucumberを使用してAPIテストを実行し、システム機能を検証し、見つかったエラーをトラブルシューティングします。

## 目標
APIの実装がSwaggerに指定された設計およびAPIテストシナリオを満たすことを確認します。

## サンプル
**注:** 下記の例は説明を目的としています。フォーマットをガイドとして利用し、特定のAPIテストシナリオにコードを適応してください。

### Node.jsでCucumberを実行する例
```bash
# Cucumberをグローバルにまたはプロジェクトの依存関係としてインストール
npm install --save-dev @cucumber/cucumber

# Cucumberテストを実行
npx cucumber-js
```