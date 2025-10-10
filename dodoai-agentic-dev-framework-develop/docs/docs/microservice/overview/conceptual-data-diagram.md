---
id: microservice-conceptual-data-diagram
title: Microservice Conceptual Data Diagram
---

# Guide: Defining Microservice Conceptual Data Diagrams

- Use this guide to define and visualize the high-level data domains, data ownership, and service boundaries in your microservice system.
- Do not copy example diagrams or models as-is—always adapt domain structure and entity relationships to your actual architecture.
- **Do not include columns, fields, or attribute details in conceptual diagrams. Only show entities, domains, and the relationships between them.**
- Focus on making microservice boundaries and key cross-domain flows clear using Mermaid diagrams.

---

## What to Define

### 1. Domain-Oriented Data Modeling

- Explicitly delineate major business data domains (e.g., User, Order, Inventory, Notification, Analytics).
- List only the main entities (such as User, Product, Order) in each domain.
- **Do not show any table columns, fields, or attribute definitions in the conceptual data diagram.**

### 2. Service Data Ownership

- For each microservice, define which entities it fully owns and governs.
- **At the conceptual level, show only entities and their ownership boundaries—never entity columns or detailed field specifications.**
- Visualize all services/domains and primary entity relationships using Mermaid's graph syntax (not erDiagram or SQL table notation for this conceptual diagram).

### 3. Cross-Service Data Relationships & Synchronization

- Define which entities are referenced or communicated across service boundaries (via API, events, or messages).
- Clearly show logical entity relationships—again, not their fields or props.

### 4. Data Consistency and Interaction Patterns

- Indicate high-level mechanisms for propagating data changes (event-driven messaging, CQRS, sagas, etc.).
- Use diagrams for showing flows and handoffs, but **do not add field or message schema definitions.**

### 5. Data Security & Retention

- Note (in text, not diagram) which domains/entities are subject to higher confidentiality or retention.
- Do not show encryption fields, keys, or technical metadata within the conceptual data diagram.

---

## Diagramming Practices

- Always use Mermaid's `graph` syntax for logical domain/entity diagrams.
- For conceptual diagrams, **entities are represented as simple nodes**—not tables with column lists.
- Show only the relationships and boundaries necessary to clarify service domains and ownership.
- Place these diagrams near requirements/spec documentation to support both business and development communication.

---

**Purpose**

A conceptual data diagram must focus only on entities, their relationships, and service boundaries—never on implementation detail like columns.  
This enables cross-team understanding, robust modular design, and maintainable evolution as your system and domains grow.

