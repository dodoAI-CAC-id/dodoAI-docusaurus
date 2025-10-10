---
id: microservice-swagger
title: Microservice Swagger Documentation
---


# Microservice Swagger Documentation

- **When documenting Swagger/OpenAPI for any microservice in Docusaurus, adhere strictly to the directory and import structure described below.**
- Do not embed Swagger YAML directly in Markdown; always use the React component import method for consistent Swagger UI rendering.

---

## Directory and Import Structure (Docusaurus Standard)

### 1. Place Swagger YAML

- Place your OpenAPI YAML file in:  
  `docs/static/swagger/v2/`  
  Example: `docs/static/swagger/v2/aiAgent.yaml`

### 2. Create Swagger UI React Component

- Create a component under `docs/src/swagger/[your-path]/[SwaggerUIComponent].js`  
  Example: `docs/src/swagger/ai/ai/AIAgentAPIUIComponent.js`
- The component should import Swagger UI React and load the YAML file as follows:

```jsx
// Example: docs/src/swagger/ai/ai/AIAgentAPIUIComponent.js
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

### 3. Import Component in Markdown

- In your Markdown documentation for the API, import and use the Swagger UI component:

```markdown
---
id: ai-agent-api
title: AI Agent API
---

## Feature API Documentation

import AIAgentAPIUIComponent from '@site/src/swagger/ai/ai/AIAgentAPIUIComponent.js';

<AIAgentAPIUIComponent />
```

- *Do not* copy-paste the YAML directly into the Markdown file.

---

## Additional Notes

- Each microservice should have a separate Swagger file, component, and MD file for its API documentation.
- Maintain Swagger/OpenAPI specs according to [OpenAPI 3.x](https://swagger.io/specification/) standard.
- YAML file URLs in UI components must match your static path (e.g., `/swagger/v2/[service].yaml`).

---

## Example Structure

- docs/docs/ai-agent/design/ai-vision-api.md (Markdown, import component)
- docs/src/swagger/ai-agent-pipeline/AgentAIPipelineSwaggerUIComponent.js (React UI component)
- docs/static/swagger/v2/aiAgent.yaml (Swagger YAML)

---

**Purpose:**  
Following this structure ensures consistent, maintainable, and clearly rendered API documentation for all microservices in your Docusaurus documentation site.