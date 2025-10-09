---
id: cd-for-docusaurus
title: Docusaurus の継続的デプロイ (CD)
---

## 概要

プロジェクトのドキュメントの継続的デプロイ (CD) を簡単に設定できるようにするため、`CD for Docusaurus` は `dodoAI-low-code` プロジェクトに事前設定されています。  これにより、追加のセットアップを必要とせずに CD をすぐに利用でき、ワークフローの進行を加速し、プロジェクトのタイムラインを短縮するとともに、将来の CD 設定時のエラーを最小限に抑えることができます。

## 重要事項

- リポジトリへの適切なアクセス権限を持っていることを確認してください。
- プロジェクトのリポジトリが対応する GitHub プロジェクトとリンクされていることを確認してください。
- 1 つのリポジトリに複数の GitHub プロジェクトが含まれる場合があり、それぞれ異なる機能を持つことを認識してください。

## `CD for Docusaurus` の簡単なセットアップ方法

### ステップ 1: リポジトリの確認とクローン

1.1. [CD for Docusaurus](https://github.com/58web3/dodoai-low-code/tree/develop/cd-for-docusarus) にアクセスし、`CD for Docusaurus` が既に存在するかどうかを確認します。

1.2. [dodoAI Low Code リポジトリ](https://github.com/58web3/dodoai-low-code/) に移動し、**Code** を選択して HTTPS リンクをコピーします。

<!-- ![リポジトリからクローンリンクを取得](assets/cd-for-docusarus/get-clone-link-from-repository.png) -->

1.3. 使用する IDE を開きます。

1.4. ターミナルを開き、以下のコマンドを実行してリポジトリをクローンします。(ここでは macOS の VS Code を使用)

```markdown
Shift Control `
```

- **ファイル → フォルダーを開く** を選択し、コードを保存するフォルダーを選択してください。  フォルダーが存在しない場合は、新しいフォルダーを作成してください。  
  <!-- ![プロジェクトフォルダーを作成](assets/cd-for-docusarus/create-folder-for-project.png) -->
- 以下のコマンドを実行し、リポジトリからコードをクローンします。

```markdown
git clone https://github.com/58web3/dodoai-low-code.git
```

### ステップ 2: 作業用リポジトリをクローン

2.1. *[ステップ 1: リポジトリの確認とクローン](#ステップ-1-リポジトリの確認とクローン)* の方法を使用して、作業中のリポジトリをクローンします。

### ステップ 3: CD 設定をコピー

3.1. クローンした `dodoai-low-code` フォルダーを Finder または Windows のエクスプローラーで開きます。

3.2. `cd-for-docusarus` フォルダーをコピーし、*[ステップ 2: 作業用リポジトリをクローン](#ステップ-2-作業用リポジトリをクローン)* でクローンしたリポジトリ内に貼り付けます。
<!-- ![プロジェクトフォルダーにファイルを移動](assets/cd-for-docusarus/move-into-project.png) -->

### ステップ 4: IDE でセットアップを完了

4.1. VS Code (または使用している IDE) に戻り、次の手順に従って Pull Request のプロセスを進めます:  [ドキュメント Pull Request 手順](../project-management/development-rules/documenting-pr-procedure.md)

### ***特記事項*** : 他のプロジェクトの機能をドキュメント化する場合

- その機能の概要ファイルを追加してください。
- 概要ファイルには、元のプロジェクトの Docusaurus ドキュメントへのリンクを含めてください。

***例*** :  
DID/VC 機能がすでにプロジェクト A で使用されている場合、プロジェクト B の DID/VC ドキュメント作成時には、概要ファイル内でプロジェクト A の DID/VC ドキュメントへのリンクを追加するだけで構いません。
<!-- ![機能リンクの追加](assets/cd-for-docusarus/feature-didvc-link.png) -->

<!-- ![8protocol DID/VC リンク](assets/cd-for-docusarus/8protocol-didvc-link.png) -->
