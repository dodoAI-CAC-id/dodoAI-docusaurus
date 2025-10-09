---
id: nfr-availability
title: Availability Requirements
---
# Availability – Definition Guide


- Use this guide to comprehensively define availability requirements for your system.
- Do not copy as-is; always adapt to your organizational, social, and business context.
- For each requirement, specify both the target level and its rationale, metrics (if quantifiable), constraints, and dependencies.


## 1. Continuity

### 1.1 Operational Schedule
- **Define** the system’s operational hours for “normal” and “special” days (e.g., holidays, month-ends, vendor holidays).
- Specify whether operation is unrestricted, limited to office hours, allows only nightly shutdown, allows short planned outages, or requires 24/7 uninterrupted service.
- For planned outages: Clearly state whether planned downtime is permitted, and if so, how flexibly they can be scheduled.

### 1.2 Business Continuity
- **Scope:** Identify which business operations/processes must be available and which can be interrupted (e.g., internal vs external, batch vs online, all business operations, etc.).
- **Failover/Switch Time:** Define maximum permitted time for service switchover (e.g., from 24 hours or more down to 60 seconds or less).
- **Continuity Level:** Specify whether downtime is permitted after a single failure, only after double failures, or must be automatically avoided.

### 1.3 Recovery Objectives (System Outages)
- **RPO (Recovery Point Objective):** Define how much data loss is tolerable (e.g., no loss required, up to last daily or weekly backup, up to failure moment).
- **RTO (Recovery Time Objective):** Set maximum time to restore service (e.g., within 1 business day, 12 hours, 2 hours).
- **RLO (Recovery Level Objective):** Clarify whether restoration targets specific applications or all services.

### 1.4 Recovery Objectives (Large Scale Disaster)
- **System Recovery Target:** Specify maximum acceptable restoration time after large-scale disasters (such as earthquakes or fire)—ranging from not required to “within 1 day”.

### 1.5 Service Availability Rate
- **Definition:** Percentage of time the system is able to deliver the required service under agreed operating conditions.
- Outline intended uptime (SLA): ranges from below 95% through 99%, 99.9%, 99.99%, up to 99.999%.
- Indicate clearly how this metric is measured and tracked.

## 2. Fault Tolerance

### 2.1 Servers
- **Device Redundancy:** Specify whether device redundancy is required for all or only for specific types of servers (e.g., DB, application, monitoring servers).
- **Component Redundancy:** Clarify if internal server components (e.g. disks, power, fans, NICs) must be fully, partially, or not at all redundant.

### 2.2 End User Terminals
- **Device Redundancy:** Define if spare terminals are shared, assigned per purpose, or not provided.
- **Component Redundancy:** State the requirement for redundancy (such as disk mirroring) inside terminal devices.

### 2.3 Network Devices
- **Device Redundancy:** Indicate whether all or only certain routers/switches must be redundant.
- **Component Redundancy:** For network gear, specify redundancy for parts like power or CPU.

### 2.4 Networks
- **Physical Line Redundancy:** Determine whether no, some, or all network lines require redundancy.
- **Route Redundancy:** Specify expectations for alternative networking paths.
- **Segmentation:** Determine if networks are segmented not at all, by subsystem, or by business role/use.

### 2.5 Storage
- **Device Redundancy:** Is redundancy needed for all or selected storage arrays?
- **Component Redundancy:** For array controllers, power, fans etc.
- **Disk Redundancy:** Whether single-level (survives one disk loss) or multi-level (survives multiple losses) is required.

### 2.6 Data Protection
- **Backup Method:** Specify if backups are offline (during downtime), online, or hybrid.
- **Data Recovery Scope:** Minimum: only essential data; Maximum: restore all system data.
- **Data Integrity:** Define requirements for error detection, retry, or full correction (ECC).

## 3. Disaster Measures

### 3.1 System Disaster Recovery
- **Recovery Policy:** Define whether you rebuild from scratch, with a reduced configuration, or full DR site build (limited/full spec).

### 3.2 Off-site Data Storage
- **Location Redundancy:** Specify the number/locations of offsite backup copies.
- **Storage Method:** State if it's via portable media, separate storage in same site, or remote site (e.g., DR location).

### 3.3 Disaster Equipment
- **Scope:** Indicate coverage for protection from earthquake, flood, fire, power failure, etc. (from “none” through to “all measures required”).

## 4. Resilience and Recovery

### 4.1 Recovery Workload
- **Recovery Operations:** Indicate whether manual or tool-based recovery (with or without application support) is required. Degree of automation may vary.

### 4.2 Alternate Manual Operations
- **Scope:** Specify if manual fallback for some or all business processes must be prepared in case of prolonged outage.

## 5. Availability Verification

### 5.1 Verification Coverage
- **Scope:** Define the extent to which availability requirements are validated. This ranges from no verification, through simple non-fatal failures, up to all possible outage scenarios.

---

