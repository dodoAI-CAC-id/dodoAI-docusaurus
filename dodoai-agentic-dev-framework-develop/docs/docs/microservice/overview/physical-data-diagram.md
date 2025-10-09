---
id: microservice-physical-data-diagram
title: Microservice Physical Data Diagram
---

# Guide: Defining Microservice Physical Data Diagrams

- This guide describes how to define and document the **physical data model** for each microservice.
- Do not copy example diagrams as-is; always reflect your real, current database schema and constraints.
- Focus only on explicit, DB-level entity/table definitions, their columns, types, keys, indexes, and relationships.

---

## What to Define

### 1. Physical Schema Per Microservice

- For each microservice (and its database), create a physical ER diagram showing:
  - All tables/entities managed by the service.
  - All columns/fields for each table, including data type, length/precision, nullability, default values, uniqueness, PK/FK constraints, and indexes if applicable.
  - Explicit relationships (joins, one-to-one, one-to-many, cascades) only as implemented in the database (FK references etc).
- Use real, deployed schema—avoid abstractions or logical-only notation.

### 2. Diagramming Practice

- Use Mermaid's `erDiagram` or a tool that supports detailed field/type notation.
- Ensure every diagram directly maps to DDL/code (keeping docs and DB in sync).
- Keep one physical data diagram per microservice (not cross-service).

---

## Notes

- **Exclude** all operational, backup, replication, or monitoring info from this artifact.
- **Include** only the structural definitions and actual DB constraints that affect runtime queries and data integrity.

---

**Purpose**  
A physical data diagram strictly defines the deployed DB structure per service, serving as the authoritative reference for development, migration, integration, and maintenance.

