
# Guide: Swagger Mock Server

- This document is a guide to defining Swagger Mock Server usage as part of your development workflow.
- Do not create user-facing docs for Swagger Mock Server in your Docusaurus Docs.
- Define all usage, configuration, and developer workflow in your codebase and development environment's documentation.

---

## What to Define

### 1. Mock Server Usage

- Swagger Mock Server must be used as a substitute backend by frontend developers whenever the real backend API is not yet available.

### 2. API Spec Location

- All Swagger/OpenAPI (YAML or JSON) files for each microservice should be maintained in a dedicated directory (such as `/static/swagger/`) in your repository.

### 3. Server Run/Setup Instructions

- Define how to run the mock server for each API spec (e.g., using Prism CLI or Docker).
- Specify ports, base URLs, and file mapping so frontend/client code can target the correct endpoints.

### 4. Environment Integration

- Document how frontend and other clients should switch to mock endpoints by configuring environment variables or settings.
- Ensure all API paths and mock responses follow the OpenAPI definition used for production.

### 5. Team Workflow

- Require mock server usage in frontend/manual/integration/API testing until real APIs are deployed.
- Keep specs and mock data updated as your API evolves.

---

**Note:**  
All of the above must be referenced and maintained in your project source code README or development "how-to" documentation, not as a document in the main product docs site.
```