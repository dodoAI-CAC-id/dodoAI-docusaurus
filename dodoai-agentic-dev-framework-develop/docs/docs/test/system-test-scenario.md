---
id: system-test-scenario
title: System Test Scenario
---

# Guide: Defining System Test Scenarios

- Use this guide to define concrete, end-to-end test scenarios for your system test phase.
- Only include what must be explicitly described; do not add implementation examples or prose.

---

## What to Define

### 1. Scenario Structure (Per Business Flow or Feature)

- **Scenario ID:**  
  Unique identifier for each test scenario (e.g., STS-001).
- **Title/Description:**  
  Clear and concise description of the scenario’s purpose.
- **Preconditions:**  
  State required system/data state or setup steps.
- **Actors/Roles:**  
  List all actors or system roles involved in the scenario.
- **Input Data/Parameters:**  
  Specify data or parameters required to execute the scenario.
- **Test Steps:**  
  Ordered, detailed actions to execute the scenario from start to finish.
- **Expected Results:**  
  The outcome or system behavior expected at each step (including main success, alternate, and error paths).
- **Postconditions:**  
  Describe any system state expected after the scenario.
- **Related Requirements:**  
  Reference associated functional or non-functional requirements covered by this scenario.

---

## How to Use

- Write a separate scenario for each major business process, integration, or cross-domain flow.
- Ensure scenarios thoroughly validate real-world, end-to-end behavior—not just unit or component-level logic.
- Collect all system test scenarios in a structured, version-controlled document for traceability.

---

**Note:**  
System test scenarios must be kept up-to-date with system changes and cover both positive ("happy path") and negative (error/exception) cases.
