---
id: microservice-er-diagram
title: Microservice ER Diagram
---

# Guide: Defining Microservice ER Diagrams

- Use this guide to define detailed Entity-Relationship (ER) diagrams for each microservice in your architecture.
- Do not copy the example diagrams as-is; your ER diagrams must reflect your actual database schema and service boundaries.
- ER diagrams should make clear both the internal relational structure of each microservice and its data ownership boundary.  
- Use Mermaid `erDiagram` for standardized, easily maintainable visualizations.

---

## What to Define

### 1. ER Diagram Per Microservice

- For each microservice, create a separate ER diagram showing:
  - All entities (tables or collections) it owns directly.
  - All attributes/columns for each entity, including key constraints (PK for primary key; FK for foreign key; UK for unique).
  - Data types, nullability, and key/default constraints for clarity.
  - Explicit relationships between entities (one-to-one, one-to-many, many-to-many; ownership, assignment, etc.).
- The diagram must cover all core business data for the service but should not include entities owned by other services.

### 2. Naming and Consistency

- Use precise, consistent names for tables and attributes that match your service's codebase and documentation.
- Clearly label each relationship (e.g., "has", "contains", "assigned_to") to make navigation and dependencies explicit.

### 3. Service Data Boundary

- The ER diagram should include only the data managed within a single microservice boundary.
- If foreign references to external (other service) entities are needed, they should be shown as FK fields but not expanded to include those entities’ internal attributes or tables.

### 4. Relationships and Cardinality

- Accurately represent relationship types and cardinality (e.g., `||--o{` for one-to-many).
- Mark foreign key constraints where applicable and describe their business intent if not obvious from naming.

### 5. Diagram Syntax

- Use Mermaid’s `erDiagram` syntax for clear, version-controllable, and tool-friendly documentation.
- Place diagrams near or within service-specific database/architecture docs for continued reference and team alignment.

### 6. Access and Maintenance

- Keep ER diagrams up to date with schema migrations or refactoring.
- Whenever the schema changes (new tables, fields, relationships, or constraints), update the respective service’s ER diagram.

---

**Purpose**

Defining per-microservice ER diagrams ensures each service’s data model, relationships, and boundaries are explicit and consistently maintained.  
This enhances cross-team clarity, database evolution, and aligns code, schema, and business logic across distributed systems.

