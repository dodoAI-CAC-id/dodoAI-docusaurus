---
id: summarize-story-points
title: ストーリーポイントのまとめ
---

## 参考

フィードバック機能についての詳細な理解のために、以下の解説動画をご参照ください。

<div style={{ position: 'relative', paddingBottom: '56.25%', height: '0', overflow: 'hidden', maxWidth: '100%' }}>
  <iframe
    src="https://drive.google.com/file/d/1Pti0X6RJ2Y48Vzo3-iWxaApX9bLhoJrB/preview"
    style={{ position: 'absolute', top: '0', left: '0', width: '100%', height: '100%' }}
    frameBorder="0"
    allow="autoplay; encrypted-media"
    allowFullScreen
    loading="lazy"
    title="ストーリーポイント動画"
  ></iframe>
</div>

## 目的

ストーリーポイントをまとめる主な目的は、作業負荷を評価し、プロジェクトの進行状況を監視し、リソースを効率的に管理することです。過去のタスクのストーリーポイントを分析することで、今後の作業見積もりの精度を向上させることができます。

## GitHubでのストーリーポイントのまとめ方

### 1. プロジェクトの選択

1.1. このリンクを使用して、組織のプロジェクトリストページに移動します: [GitHub Projects](https://github.com/orgs/58web3/projects)。

注意: 他の組織の場合は、このURL内の組織名を変更してアクセスしてください。`https://github.com/orgs/{organization_name}/projects`

<!-- ![プロジェクトの選択](assets/summarize-story-point/select-project.png) -->

### 2. ストーリーポイントをまとめる

- ストーリーポイントをまとめるタブビューが利用可能か確認します。表示されない場合は、関連するドキュメントを参照して次のステップに進んでください [GitHub Setup](github-setup.md)。
- `Sum Story Point`タブビューで、反映されるイテレーションが必要な週と一致しているか確認します。一致していない場合、[GitHub Setup](github-setup.md) の手順にエラーがある可能性があるので、再確認してください。

例: `Iteration 50` from Oct 28 - Nov 03 → 実際の期間と一致しているか確認。

<!-- ![ストーリーポイントのコピー](assets/summarize-story-point/copy-story-point.png) -->

- `StoryPoints(1,2,4,8,16)`フィールドを強調し、コピーして、[`dodoAIツール`](https://dodoai.ai/)を使って計算します。

```markdown
リリース環境: https://dodoai.ai/
テスト環境: https://58llm.link/
```

セキュリティ上の理由から、環境の認証を正常に取得するために、以下のNotionリンクにアクセスしてください: [Notion](https://www.notion.so/Basic-Auth-Info-14634bff208b80758e32fb17c6bb941c?pvs=4)

<!-- ![dodoAIを使って計算する](assets/summarize-story-point/use-dodoai-for-caculator.png) -->

- dodoAIによって提供された出力と結果を確認してください。

<!-- ![dodoAIの出力](assets/summarize-story-point/dodoai-output.png) -->

- 最後に、管理表 [Dev Velocity Story Point](https://www.notion.so/PJT-Health-Check-Status-3e9024b67ffd4f1e8d1a4ce3435240c7) に、表に記載された必要な情報を基にストーリーポイントを入力してください。

<!-- ![ストーリーポイントの入力](assets/summarize-story-point/input-story-point.png) -->
