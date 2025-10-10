---
id: pull-request-review
title: プルリクエストとレビュー
---

## プルリクエストとレビュー

## 概要

- `feature/{milestone_name}_{your_name}_{issue_number}` → `features/{milestone_name}`
- `features/{milestone_name}` → `feature/v{version_number}`
- `feature/v{version_number}` → develop → main

## PRレビューへの注意事項

- PRで変更された各ファイルには、そのファイルをレビューするようにdodoAIにリクエストするログエントリーが必要です。
- レビュープロセス:
  - *dodoAI App* の *コードレビュー* 機能を使用して、AIレビューのためにPR内のすべての変更されたファイルを選択します。次に、追加のプロンプトに「ファイルxxxx.yyyの詳細レビュー」と追加し、各ファイルの詳細なレビューをリクエストします。すべてのファイルがレビューされるまでこのプロセスを続けます。
  - Webベースのレビューテンプレートを使用する場合は、PRにあるすべての変更されたファイルがレビューされるまで、ファイルを順番にレビューします。
- AIの***推奨コード***をレビューし、必要な提案を取り入れるか、レビュアーから質問された場合に特定の提案を含まない理由を提供します。

## プルリクエスト (PR)

### PRを作成する際に含めるべきこと

- PRタイトルと説明を入力: 変更内容の概要と関連する課題へのリンクを提供する（1 PR: 1 Issue）。
- PR作成時にDescriptionに `Close #issue_id` を追加すると、マージ後に自動的にそのIssueがクローズされます。
- 注記（必要に応じて）: PRのマージ順序に関連する必要な要件または設定を記録します。
- DodoAI URL : 
開発および自己評価中に使用したLLMツールのログのURLをPR descriptionに含めます。
- 証拠 (スクリーンショットエビデンス) :
変更またはバグ修正を示すスクリーンショットを添付します。
- レビュワーの設定: PRにレビュワーを割り当てます。
- 自分をアサイニーとして設定:
自分をPRの担当者として設定します。

## PRテンプレート

```markdown
## 注意（必要に応じて）
- PRのマージ順や必要な設定に関する注意事項および要件を記録します。

## 説明
- このイシューのタスクおよびその目的についての概要を再記述します。

## dodoAIログ
- 開発プロセスおよび自己プレビュー中のdodoAIのログを提供します。

## 証拠
- 変更または修正を示すスクリーンショットを含めます。
```

## PR レビュー

### マージルール

- 特定の Issue に関連しない PR は、レビュアーによってマージされるべきではありません。
- フロントエンドまたはバックエンドに関連する Issue はリーダーがマージします。 `feature/{milestone_name}_{your_name}_{issue_number}` → `features/{milestone_name}`
- マネージャー (PdM/PM) は `features/{milestone_name}` を `feature/v{version_number}` へマージします。
- デザインやシステムテストに関する Issue は、マネージャー (Manager, PdM/PM) がマージします。
- `features/{milestone_name}` へのマージには、少なくとも 1 人のレビュアーの承認が必要です。
- `develop` または `main` へのマージには、少なくとも 2 人のレビュアーの承認が必要です。

#### PR レビューおよびマージプロセス

- 開発完了後、開発者は PR を作成します:   `feature/{milestone_name}_{your_name}_{issue_number}` → `features/{milestone_name}`
  - 他の開発者およびリーダーにクロスレビューを依頼します。

#### リーダー

- コードをレビューする。
- PR をマージする: `feature/{milestone_name}_{your_name}_{issue_number}` → `features/{milestone_name}`

#### テスター

- `features/{milestone_name}` が `feature/v{version_number}` ブランチにマージされた後、事前に作成・レビューされたテストシナリオに基づいてシステムテストを実施します。
- バグをテストシナリオシートに記録し、開発者と議論した上で、必要に応じて Issue を作成します。
- その後、マネージャー (PM や PdM) に報告し、再テストを依頼します。
- 問題がなければ、マネージャーが `feature/v{version_number}` を `main` ブランチへプッシュするための Issue 作成を依頼します。

#### リーダー

- `features/{milestone_name}` を `feature/v{version_number}` ブランチへアップロードするためのプルリクエストを作成します。

#### マネージャー (PdM/PM)

- レビューを行い、`feature/v{version_number}` を `develop` → `main` にマージします。

#### デプロイ後チェック (管理)

- **機能確認**: 新機能が正常に反映されていることを確認。
- **システム可用性**: システムが正常に動作していることを確認。
