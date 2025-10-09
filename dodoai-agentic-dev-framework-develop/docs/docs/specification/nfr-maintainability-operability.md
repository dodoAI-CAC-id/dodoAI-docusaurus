---
id: nfr-maintainability-operability
title: Maintainability and Operability Requirements
---

# Maintainability and Operability – Definition Guide

- Use this guide to comprehensively define maintainability and operability requirements for your system.
- Do not copy verbatim; always adapt to your business, organizational, and operational context.
- For each requirement, specify the target level, rationale, metrics (where applicable), and any dependencies or constraints.


## 1. Routine Operations

### 1.1 Operation Schedule
- **What to Define:** The standard hours of operation for the system (e.g., whether it runs 24/7, only during business hours, or allows night shutdown).
- **Key Points:** Also specify special days (e.g., holidays), and whether there are restrictions or extended hours.
- **Options/Levels:** "No restriction," "Business hours (e.g. 9:00-17:00)," "Night shutdown only," "Slight stoppage allowed," "24/7 nonstop."

### 1.2 Backup
- **What to Define:** Coverage and policies for system/data backup and restore.
- **Sub-Items:**
  - **Data Recovery Scope:** Specify whether no data, partial, or all data must be restorable.
  - **Use of External Data:** Whether external data sources can be used for restore.
  - **Backup Usage Scope:** Is backup only for failures, for recovering from user errors, or also for long-term archiving?
  - **Backup Automation:** Indicate if backup is fully manual, partially automated, or fully automated.
  - **Backup Interval:** Define timing/frequency (e.g. none, ad hoc, monthly, weekly, daily, or real-time/mirrored).
  - **Backup Retention:** How long must backups be kept (e.g., 1 year, 3 years, permanent)?
  - **Backup Method:** Offline (system stopped), online (running), or both.
- **Considerations:** Link scope and strategy to business/data criticality and compliance requirements.

### 1.3 Monitoring
- **What to Define:** Monitoring coverage and depth for the system, hardware, software, network, and application.
- **Sub-Items:**
  - **Monitoring Targets:** None, liveness check ("ping"), error log monitoring, performance/resource monitoring, trace info.
  - **Monitoring Frequency:** Ranges from "none," "manual/ad hoc," "daily," "hourly," "minute-by-minute," to "real time (sec-level)."
  - **Scope:** At each layer – system, process, DB, storage, node/server, endpoint, network device, network packet.
- **Considerations:** Higher granularity and real-time requires more setup and operational effort.

### 1.4 Time Synchronization
- **What to Define:** The scope of time synchronization between system components.
- **Levels:** None, servers only, servers plus clients, all system devices (including network devices), synchronization with external time services.

## 2. Maintenance Operations

### 2.1 Planned Downtime
- **What to Define:** Whether planned downtime for maintenance is permitted, and advance announcement requirements.
- **Sub-Items:** "Permitted/flexible," "Permitted/not flexible," or "No planned downtime." Also, advance notification period (annual/1 month/week/day before).

### 2.2 Maintenance Workload Reduction
- **What to Define:** The extent of automation for routine maintenance tasks (updates, patching, hardware replacement, etc.).
- **Levels:** Manual only, partial automation, full automation.
- **Sub-Items:** Whether server and endpoint software updates are distributed/applied manually, semi or fully automatically.

### 2.3 Patch Policy
- **What to Define:** Information dissemination and timing for security/bug patches. Whether all, recommended, or only urgent patches are applied, and how soon (e.g., only on incident, regularly, or immediately).
- **Patch Testing:** Whether security/critical patches are tested before deployment.

### 2.4 Hot/Active Maintenance
- **What to Define:** Whether hardware/software can be maintained/updated without service interruption, and for which components.

### 2.5 Preventive Maintenance & Regular Maintenance
- **What to Define:** Frequency of regular (e.g. weekly, monthly) and preventive checks. Are signs of potential failure actively screened for, and at what interval? Is there real-time detection?

## 3. Operations During Failures

### 3.1 Recovery Process
- **What to Define:** Human effort and tooling needed to restore from system failure.
- **Options:** No recovery, manual only, tool-assisted, fully automated, with or without reliance on business applications for restoration.

### 3.2 Alternate Operation
- **What to Define:** Whether alternative/manual business operations should be prepared in case restoration is not possible.
- **Levels:** None, partially covered, or all business processes covered.

### 3.3 Recovery Automation
- **What to Define:** Scope (if any) of automated failover or restoration processes (manual only, partial, or full automation).

### 3.4 Incident Response & On-Call
- **What to Define:** Vendor/user operation coverage hours for incident response, and guaranteed arrival/support times for field engineers or support staff.
- **Options:** Business hours only, evening, 24/7. For on-site: "several days," "next business day," "start of next business day," "within hours," or "resident/on-site staff."

### 3.5 Spare Parts/Equipment Availability
- **What to Define:** Policy for keeping spares/backup devices on hand (not kept, partial, or full coverage for all components).

## 4. Operational Environment

### 4.1 Deployment and Testing Environments
- **What to Define:** Whether development, test, and staging environments are provided, and their closeness to production.

### 4.2 Manuals and Documentation
- **What to Define:** Coverage and customizability of user and ops manuals (product-standard, general, detailed, or fully customized).

### 4.3 Remote Operation
- **What to Define:** Whether monitoring and control can be performed remotely (and from what locations), as well as scope of remote operations (routine vs. any operation).

### 4.4 External System Connections
- **What to Define:** Whether (and how) system connects to and integrates with other internal or external systems, monitoring, or job scheduling tools.

## 5. Support Structure

### 5.1 Support and Maintenance Contracts
- **What to Define:** Whether hardware and software maintenance is provided through vendor or multi-vendor support, and scope/coverage.

### 5.2 Lifecycle Support
- **What to Define:** Duration of support/maintenance/lifecycle (e.g. 3, 5, 7, or 10+ years).

### 5.3 Roles and Responsibilities
- **What to Define:** User/vendor responsibility division for maintenance work, incident response, and support. Indicate on-site staff presence, coverage times, and skill requirements (including escalation/on-call policy).

### 5.4 Rollout/Introduction Support & Training
- **What to Define:** Length and depth of system introduction support, and roles/responsibilities and coverage for operational training (routine, maintenance, incident recovery) post go-live.

### 5.5 Reporting and Review
- **What to Define:** Frequency and content of periodic reporting meetings with vendor/support (annually, quarterly, monthly, or more frequent; content - incidents, status, improvement suggestions).

## 6. Operational Management Policy

### 6.1 Internal Controls
- **What to Define:** Whether and how IT operational processes comply with internal or regulatory control requirements (using existing or custom policies).

### 6.2 Service Desk
- **What to Define:** Whether a service/help desk is provided, and if so, if it is shared with existing systems or newly set up.

### 6.3 Incident, Problem, Change, Release, and Configuration Management
- **What to Define:** For each process, indicate whether it is handled at all, whether existing corporate/industry standard processes are used, or whether a new, explicit process is defined for the system.

---

## Documentation Guidelines

- Always specify the required level and detail for each requirement.
- State the rationale for each design or policy decision.
- Be explicit about automation coverage, operational cost/impact, and any support/vendor dependencies.
- Adjust rigor and detail depending on your system’s criticality and operational impact.

---

**Purpose:**  
These comprehensive guidelines help ensure your system’s maintainability and operability requirements are explicit, suited to your operational scenario, and agreed upon by all stakeholders. Use this guidance to set realistic, testable expectations for system operations and support.
