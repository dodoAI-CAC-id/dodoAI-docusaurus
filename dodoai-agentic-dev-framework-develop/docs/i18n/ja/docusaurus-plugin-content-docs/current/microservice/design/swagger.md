---
id: microservice-swagger
title: マイクロサービス Swagger ドキュメント
---


# マイクロサービス Swagger ドキュメント

- **Docusaurusでマイクロサービスの Swagger/OpenAPI をドキュメント化する際は、以下に説明するディレクトリとインポート構造に厳密に従ってください。**
- Swagger YAML を Markdown に直接埋め込まないでください。一貫した Swagger UI レンダリングのために、常に React コンポーネントインポート方式を使用してください。

---

## ディレクトリとインポート構造（Docusaurus 標準）

### 1. Swagger YAML の配置

- OpenAPI YAML ファイルを以下に配置してください：  
  `docs/static/swagger/v2/`  
  例：`docs/static/swagger/v2/aiAgent.yaml`

### 2. Swagger UI React コンポーネントの作成

- `docs/src/swagger/[your-path]/[SwaggerUIComponent].js` の下にコンポーネントを作成してください  
  例：`docs/src/swagger/ai/ai/AIAgentAPIUIComponent.js`
- コンポーネントは Swagger UI React をインポートし、以下のように YAML ファイルを読み込む必要があります：

```jsx
// 例：docs/src/swagger/ai/ai/AIAgentAPIUIComponent.js
import React from 'react';
import SwaggerUI from 'swagger-ui-react';
import 'swagger-ui-react/swagger-ui.css';

const AIAgentAPIUIComponent = () => {
  return (
    <div style={{ height: "80vh", width: "100%", overflowY: "scroll" }}>
      <SwaggerUI url="/swagger/v2/aiAgent.yaml" />
    </div>
  );
};

export default AIAgentAPIUIComponent;
```

### 3. Markdown でのコンポーネントインポート

- API の Markdown ドキュメントで、Swagger UI コンポーネントをインポートして使用してください：

```markdown
---
id: ai-agent-api
title: AI Agent API
---

## 機能 API ドキュメント

import AIAgentAPIUIComponent from '@site/src/swagger/ai/ai/AIAgentAPIUIComponent.js';

<AIAgentAPIUIComponent />
```

- YAML を Markdown ファイルに直接コピー＆ペーストしないでください。

---

## 追加の注意事項

- 各マイクロサービスは、API ドキュメント用に個別の Swagger ファイル、コンポーネント、MD ファイルを持つ必要があります。
- [OpenAPI 3.x](https://swagger.io/specification/) 標準に従って Swagger/OpenAPI 仕様を維持してください。
- UI コンポーネントの YAML ファイル URL は、静的パスと一致する必要があります（例：`/swagger/v2/[service].yaml`）。

---

## 構造例

- docs/docs/ai-agent/design/ai-vision-api.md（Markdown、コンポーネントインポート）
- docs/src/swagger/ai-agent-pipeline/AgentAIPipelineSwaggerUIComponent.js（React UI コンポーネント）
- docs/static/swagger/v2/aiAgent.yaml（Swagger YAML）

---

**目的:**  
この構造に従うことで、Docusaurus ドキュメントサイトのすべてのマイクロサービスに対して、一貫性があり、保守可能で、明確にレンダリングされた API ドキュメントが保証されます。
