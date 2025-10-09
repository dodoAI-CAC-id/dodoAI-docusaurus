---
id: nfr-portability-migration
title: Portability and Migration Requirements
---

# Portability and Migration – Definition Guide

- Use this guide to comprehensively define Portability and Migration requirements for your system.
- Do not copy verbatim; always adapt the requirements to your actual business, technical, and organizational context.
- For each requirement, specify the target level, rationale, metrics (where applicable), and any dependencies or risks.


## 1. Migration Period and Scheduling

### 1.1 Migration Period
- **What to Define:** Specify the scheduled duration for the migration process—from initial planning to full cutover/production, including any allowable system downtime, the possibility of parallel operation, backup/waiting periods, and rollback timeframes in case of exception.
- **Examples:** "No migration required," "Less than 3 months," "Less than 6 months," "Less than 1 year," "Less than 2 years," or "2 or more years."

### 1.2 Permitted Downtime for Migration
- **What to Define:** The maximum allowed downtime during migration cutover (e.g., allowed any time, only on specified days, less than five days, less than one day, only at night, or not allowed at all).
- **Note:** More restrictive windows require more automation and preparation.

### 1.3 Parallel Operation
- **What to Define:** Whether (and how long) old and new systems will run in parallel as part of the migration plan.
- **Options:** "Not required" (big-bang cutover), "Parallel operation required" (phased approach).

## 2. Migration Approach

### 2.1 System Deployment Steps (Location)
- **What to Define:** Does the migration/new deployment occur at once, or in multiple phases/steps per site/office?
- **Examples:** "Single site, no phasing," "Big-bang deployment," "Phased deployment in less than five steps," "ten or more phases," etc.

### 2.2 Business Deployment Steps (Function/Process)
- **What to Define:** Whether business-side migration is cut over all at once, or in several defined phases.
- **Examples:** "All business at once," "less than four steps," "less than six steps," "less than ten steps," "ten or more steps."

## 3. Migration Targets

### 3.1 Equipment/System
- **What to Define:** The scope of replacement—no changes, only hardware, hardware + OS/middleware, or all system components including integration.
- **Examples:** "No equipment replaced," "Hardware only," "Hardware & OS," "Full system," or "Full system plus integration."

### 3.2 Data Volume and Format
- **What to Define:** Total data (including programs) requiring migration, and whether formats match between source and target.
- **Examples:** "No data migration," "less than one terabyte," "less than one petabyte," "one petabyte or more," etc. Specify whether format conversion is required.

### 3.3 Migration Media Volume and Types
- **What to Define:** Number and type(s) of physical or logical media used for migration.
- **Examples:** "No migration media," "less than ten tapes (less than one terabyte)," "less than one thousand tapes (less than one petabyte)," "one thousand or more tapes," etc. Also define the number of media types: single, dual, triple, four types, five or more types.

### 3.4 Conversion Scope and Tool Complexity
- **What to Define:** Volume of data requiring transformation/conversion, and the complexity of the migration/conversion tool (e.g., number of conversion rules).
- **Examples:** "No conversion," "less than one terabyte," "less than one petabyte," "one petabyte or more," etc. Complexity: "Tool not required/existing tool sufficient," "less than ten rules," "less than fifty rules," "less than one hundred rules," "one hundred or more rules."

## 4. Migration Planning

### 4.1 Migration Task Assignment
- **What to Define:** Who will perform migration tasks (user, vendor, or joint).
- **Options:** "All tasks by user," "Collaborative / shared tasks," "All tasks by vendor."

### 4.2 Rehearsal and Dry-Run
- **What to Define:** Whether and how migration rehearsals are performed (for expected scenarios and exception handling), what kind of rehearsal environment is used (real production data or not), and the number of rehearsals.
- **Examples:** No rehearsal, only normal scenarios, both normal and rollback, fully includes system failure recovery. Rehearsal environment: "None," "Production data allowed," "Production data not allowed." Number: none, once, twice, three times, four times, five times or more.

### 4.3 Rehearsal of External Integration
- **What to Define:** Whether external connections/integrations are included in migration rehearsal, with or without interface changes.
- **Options:** None, included without spec change, included with spec change.

### 4.4 Troubleshooting Plan
- **What to Define:** Is there a documented plan for responding to issues during migration—including not just who will respond, but escalation, rollback, support contacts, and countermeasures.
- **Options:** No plan; Response structure defined; Response structure + specific procedures defined.

---

## Documentation Guidelines

- For every migration and portability aspect, clearly specify the scope, schedule/constraints, responsible actors, and contingency measures.
- State the rationale for each migration approach, including risk, rollback plan, and business–risk/cost trade-offs.
- Provide measurable targets wherever possible (e.g., max downtime, volume, step count, retention).
- Adapt requirements according to system scale, business criticality, and change risk.

---

**Purpose:**  
This guideline helps you document all relevant migration and portability requirements in a way that is thorough, risk-based, and practical for large and small system projects alike.
