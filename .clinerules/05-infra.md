# Goal
AWSでre-action用のステージング環境を構築すること

# 最終ゴール
1. 下記のTerraformなどの設定を参照し、同じAWSアカウントでテスト用環境のTerraformコードを生成する
   - 参照先ディレクト：
     - re-action/infra/prd/
2. 新規作成のTerraform設定を以下のディレクトリに保存する
   - 保存先ディレクト：
     - re-action/infra/staging/
3. 変更点：prefixはstagingではなく、staging2を利用すること
4. Git Actionを利用してTerraformのコードを実行するため、下記のワークフローを参照し、テスト環境用のワークフローを生成する。
  - ワークフロー参照先ディレクト：
    - re-action/.github/workflows






