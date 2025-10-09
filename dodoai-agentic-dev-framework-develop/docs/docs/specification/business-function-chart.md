---
id: business-function-chart
title: Business Function Chart
---

# Guide

- This document serves as a guide for defining the essential contents of a Business Flow in your organization.
- Do not use any sample flows directly. Always define a business flow that fits your actual operations and context.
- The Business Flow is designed to bridge understanding between business and technology stakeholders.


When creating a Business Flow, be sure to define the following key elements to ensure that all stakeholders share a common and precise understanding of the process:

## Items to Define in a Business Flow

1. **Process Name / Scope**
   - Clearly state the business process, task, or goal that the flow represents.
   - Define boundaries: where the process starts and ends.

2. **Start and End Points**
   - Specify the initial trigger that begins the process (Start).
   - Specify the final outcome or completion event (End).

3. **Major Steps**
   - List each primary action or phase in the process, in sequential order.
   - Use simple, business-oriented wording.

4. **Decision Points**
   - Identify all points where a decision may change the direction of the process (e.g., approvals, conditional branching).

5. **Roles and Responsibilities**
   - For each step and decision point, define the responsible person, team, or department.

6. **Tools and Resources**
   - Note any required systems, documents, or materials (e.g., CRM, order forms) at each step.

7. **Control and Verification Points**
   - Indicate any steps that require quality control, verification, or approval before the process can continue.

8. **Input and Output**
   - Specify what triggers each step (input) and what is produced (output), as needed.

9. **Exception Handling**
   - Briefly describe how exceptions, errors, or special cases are managed.

10. **Sequence and Relationship**
    - Clearly illustrate how each step is connected, including the sequence and any branches.

---

## Using Mermaid for Business Flow Diagrams

- Use Mermaid's [flowchart syntax](https://mermaid-js.github.io/mermaid/#/flowchart) to visually represent your business flow.
- Map each major step, decision point, start/end, and roles to distinct nodes.
- Avoid technical implementation details—keep diagrams focused on business process steps and decisions.
- Regularly update the diagrams to reflect the actual business operations.

---

## Mermaid Example

> **Note:**  
> The following Mermaid code is a reference example only; do not copy as-is. Always create diagrams based on your actual business flow.

```mermaid

flowchart TD
    Start([Start: Order Placed])
    Payment{Payment Confirmed?}
    InventoryCheck[Inventory Check]
    Stock{Stock Available?}
    Ship[Ship Item]
    Notify[Notify Customer: Out of Stock]
    Complete([End: Order Completed])
    RequestPayment[Request Payment]

    Start --> Payment
    Payment -- Yes --> InventoryCheck
    Payment -- No --> RequestPayment
    RequestPayment --> Payment
    InventoryCheck --> Stock
    Stock -- Yes --> Ship --> Complete
    Stock -- No --> Notify --> Complete
