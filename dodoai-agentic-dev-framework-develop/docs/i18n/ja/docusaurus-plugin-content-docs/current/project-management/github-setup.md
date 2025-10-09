---
id: github-setup
title: GitHub セットアップ
sidebar_position: 3
---

## 概要

GitHub の登録が完了したら、GitHub プロジェクトをセットアップしてください。開発者に明確な見通しを提供するため、ガントチャートを含め、イテレーション（スクラム単位）を設定し、タスクをマイルストーンに整理して効率的に管理します。また、イテレーションを設定し、開発者のストーリーポイントを管理するためのタブを作成します。

## 目的

- 各プロジェクトの生産性を測定する。
- 毎週の Dev Velocity（開発速度）をモニタリングする。

## イテレーションのインストールとストーリーポイント管理タブの設定手順

### **ステップ 1: プロジェクトにアクセス**

- 以下のリンクからプロジェクトにアクセス:  [GitHub プロジェクト](https://github.com/orgs/58web3/projects/{project_number})  
- または、以下の画像の手順を参照:  
  <!-- ![GitHub プロジェクトビュー](assets/github-setup/github-project-view.png) -->

### **ステップ 2: イテレーションのインストール**

- 画面右上の「...」ボタンをクリックし、「Settings」を選択。  
  <!-- ![設定ボタン](assets/github-setup/setting-button.png) -->
- **「Settings」内に「Iteration」フィールドがない場合は、以下の手順で追加してください:**

1. 「New Field」をクリックし、ポップアップを開く。
2. 「Field Name」に「Iteration」と入力し、「Field Type」は「Iteration」を選択。
3. 「Save」をクリックして、Iteration フィールドを設定に追加。  
   <!-- ![イテレーション設定](assets/github-setup/iteration-setting.png) -->

- 「Iteration」フィールドが既に存在する場合、または追加後、以下の手順で新しいイテレーションを作成してください:「Add Iteration」をクリックし、新しいイテレーションを追加。  
<!-- ![イテレーション追加](assets/github-setup/add-iteration.png) -->

### **ステップ 3: ストーリーポイントの合計を表示するタブビューの設定**

1. プロジェクト画面に戻り、「+ New View」を選択し、新しいタブビューを作成。
2. タブビューの名前を「Sum Story Points」に設定。
3. 詳細を入力するために、高度なフィルター（Advanced filters）を使用。  
   <!-- ![ストーリーポイント合計](assets/github-setup/sum-story-point.png) -->
