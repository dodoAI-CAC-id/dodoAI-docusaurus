---
id: microservice-unit-tests-planning
title: Microservice Unit Tests Planning
---


# Guide: Microservice Unit Tests Planning

- This guide defines what to specify when planning unit tests for microservices, with a focus on explicit test coverage metrics using standards such as C0, C1, etc.
- Do not include sample code or test theory—focus only on planning items, code structure, and required coverage metrics.

---

## What to Define

### 1. Test Scope and Coverage

- Identify all layers to be covered by unit tests for each microservice:
  - **Controller Layer:** Input validation, request handling, error paths
  - **Service Layer:** Business logic, error logic, orchestration
  - **Repository/DAO Layer:** Persistence logic, mapping
  - **Domain Model:** Entity and value object rules/validation

- For each layer and component, specify required unit test cases to meet the defined coverage metrics.

---

### 2. Coverage Metrics (C0, C1, etc.)

- **C0 (Statement Coverage):**
  - Ensure that every executable statement is executed by at least one test case.
  - **Target:** 80%+ for all code; 100% for critical modules.

- **C1 (Branch Coverage):**
  - Ensure that every branch (e.g., if, else) in the decision structures is taken at least once.
  - **Target:** 70%+ for all code; 100% for security- or logic-critical code.

- **C2 (Path Coverage) [optional/advanced]:**
  - Ensure that all linearly independent paths through each module are tested.
  - Use for highly critical or complex modules only.

- **MC/DC (Modified Condition/Decision Coverage) [for safety-critical]:**
  - All individual conditions in a decision influence the outcome independently.
  - Use for modules requiring regulatory or highest assurance.

- Clearly document which coverage metric is required for each module, and how coverage is to be measured (e.g., JaCoCo, Istanbul, Coverage.py, etc.)

---

### 3. Test Organization

- Organize tests by feature and layer, mirroring production code structure.
- Use separate test files for each class/component and layer (controller/service/model).

---

### 4. Required Tooling

- Specify tools for:
  - Test execution (e.g., JUnit, PyTest)
  - Mocking/stubbing (e.g., Mockito)
  - Coverage measurement (e.g., JaCoCo for Java, coverage.py for Python)

---

### 5. Policy and Review

- Tests must be maintained and updated as code changes.
- Code reviews must block merges if coverage falls below the minimum for C0/C1 metrics in any module.

---

**Note:**  
These coverage metrics and policies should be enforced in your codebase and CI pipelines, not documented in end-user Docs.