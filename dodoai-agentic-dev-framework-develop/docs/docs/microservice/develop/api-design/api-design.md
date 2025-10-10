---
id: api-design
title: API Design
---

# Guide: API Design Internal Documentation

- Use this guide to create and maintain detailed, consistent documentation for API endpoint internal designs.
- This is a **general API design guide** .
- For each API endpoint, clearly document the flow and boundary between Controller, Service, and Model, and visualize with Mermaid diagrams.
- Do not include pseudocode; describe only system/process flows and responsibility separation.

---

## What to Define

### 1. Separate File Per Endpoint

- For every REST endpoint, create a dedicated Markdown file in your API documentation directory (e.g., `docs/apis/[resource]/[method-endpoint].md`).
- Each file must specify:
  - Endpoint definition (HTTP method/path)
  - Purpose and main behavior
  - Request example/schema
  - Response example/schema
  - Validation/business rules
  - Processing flow

---

### 2. Controller / Service / Model Boundary

- Clearly distinguish the responsibilities in the documentation:
  - **Controller**: Handles the HTTP request, input parsing/validation, authorization, and delegates to Service.
  - **Service**: Holds business logic, workflows, coordination, applies rules, and manages domain operations.
  - **Model**: Responsible for persistence, schema, direct database/entity operation, and low-level validation.

---

### 3. Process Flow Visualization

- Use a **Mermaid diagram (sequenceDiagram or flowchart)** for each endpoint file to clarify the process.
- The diagram must clearly show how a request travels from Controller to Service to Model (and back), including all validation, checks, and error handling paths.

#### Example Mermaid Sequence Diagram
```mermaid
sequenceDiagram
    participant APIClient as API Client
    participant Controller
    participant Service
    participant Model

    APIClient->>Controller: POST /endpoint (data)
    Controller->>Controller: Validate input & auth
    Controller->>Service: Call business logic
    Service->>Model: Query/update data
    Model-->>Service: Result/data
    Service->>Controller: Build output
    Controller-->>APIClient: HTTP response (success/error)
