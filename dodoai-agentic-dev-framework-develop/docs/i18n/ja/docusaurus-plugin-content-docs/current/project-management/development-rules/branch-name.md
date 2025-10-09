---
id: branch-name
title: ブランチ名
---

## ブランチ名

58にて社内的に使用されるSDFに従って開発を進めてください。

- **ステップ 1**: `feature/{milestone_name}_{あなたの名前}_{issue_number}` -> `features/{milestone_name}`。  
  この段階では、ユニットテストCIのみ。

- **ステップ 2**: `features/{milestone_name}` -> `feature/v{version_number}`。  
  この段階ではCucumber CIを設定します。

- **ステップ 3**: `feature/v{version_number}` -> `develop` -> `main`。  
  この段階でリリースの準備を行います。

### ソースコード管理

ソースコードをGitHubで管理します。  
「main」と「develop」を主要なブランチとして使用します。  
また、「feature」、「release」、「hotfix」、「prototype」をサポートブランチとして使用します。

### メインブランチ

- **Main**  
  常に製品として出荷可能な状態を反映するソースコードヘッドのメインブランチ。リリースブランチからのみマージされます。

- **Develop**  
  次期リリースのための最新の開発作業の変更を常に反映するソースコードヘッドのメインブランチ。通常のPRはdevelopブランチにマージされるように設定します。

### サポートブランチ

#### Feature

- 新しい機能の開発に使用します。
- リリーススケジュールの変更に柔軟に対応するため、機能ブランチを2つに分けます。
  - **Feature**: `feature/{milestone_name}_{あなたの名前}_{issue_number}`
  - **Document**: `doc/{あなたの名前}_{機能名}_{issue_number}`
- バージョン固有の機能の場合は、`feature/v{version_number}`を使用します。

#### Hotfix

重大なバグを直ちに解決する必要がある場合に使用します。

- **バックエンド**: `bugfix/api/{あなたの名前}_{バグ}_{issue_number}`
- **フロントエンド**: `bugfix/frontend/{あなたの名前}_{バグ}_{issue_number}`

#### Prototype

調査タスクのためのサンプルコードをコミットする際に使用します。

- `prototype/branch_name`
