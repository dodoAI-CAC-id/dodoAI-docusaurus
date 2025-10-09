---
id: nfr-performance-scalability
title: Performance and Scalability Requirements
---

# Definition Guide – Performance and Scalability Non-Functional Requirements

- This guide enables comprehensive definition of performance and scalability non-functional requirements.
- Do not copy sample values directly; always customize based on business needs, system characteristics, lifecycle, and realistic growth.
- Clearly indicate which requirements are critical and provide rationale, metrics, constraints, and future-proofing considerations.


## 1. Business Workload
Define the characteristics and assumptions regarding business volume that affect system performance and scalability.

### 1.1 Workload at Steady State
- **Number of Users:** Define user profiles (specific users, fixed upper limit, large/unspecified public access).
- **Concurrent Access:** Specify concurrent sessions or requests (single, fixed max, or many/unspecified).
- **Data Volume:** Identify which and how much data (all data or just major datasets) is included.
- **Online Request Volume:** Clarify the number of online transactions per process (per operation, or only for key operations).
- **Batch Volume:** Define batch job volumes (per each job, or only major jobs).
- **Number of Business Functions:** List and confirm business functions (whether fixed, finalized, or yet to be finalized).
- **Special Consideration:** Workload requirements should account for peak periods and seasonality if relevant.

### 1.2 Workload Growth Ratio
Define the expected growth in business workload from system launch to lifecycle end.
- **User Growth Rate:** Expected multiplier increase (e.g., 1.2x, 2x, 3x, 10x+).
- **Concurrent Access Growth Rate:** Same as above, but for concurrent load.
- **Data Volume Growth Rate:** Anticipate future data size increases.
- **Online/Batch Request Growth:** Set expectations for how load rises over time.
- **Business Functions Growth:** Will more features be added? State multiplier.

### 1.3 Data Retention Period
- **Retention Duration:** Define how long different data types (business, log, system) must be kept (e.g., one year, five years, ten or more years, permanent).
- **Scope:** Clearly specify if only online data is covered, or if archive/offline storage is also necessary.

## 2. Performance Targets

### 2.1 Online Response Time
Clearly specify the required system response time and the compliance rate for each scenario.
- **Normal Response Compliance:** Percentage of requests meeting target under standard conditions (e.g., ninety percent, ninety-five percent, ninety-nine percent or more).
- **Peak Period Compliance:** Percentage compliance under peak load.
- **Degraded Mode Compliance:** Percentage compliance in case of failover, cluster reduction, or partial system outage.

### 2.2 Batch Processing Turnaround Time
- **Normal Period:** Ability to finish jobs within a set time or allow for retry if failed.
- **Peak/Degraded Periods:** Same, but under heavier or unstable conditions.

### 2.3 Online Throughput
- **Normal Throughput Efficiency:** Ratio of actual vs. required processing (e.g., supports double required rate, triple, etc.).
- **Peak/Degraded Throughput:** Define tolerance and minimum maintainable level under stress.

### 2.4 Batch Throughput
- **Normal/Peak/Degraded:** As above, for periodic, large, or one-off batch jobs.
- **Examples:** Monthly payroll, annual migrations, daily summary jobs.

### 2.5 Print (Report) Throughput
- **Normal/Peak/Degraded:** Pages or reports per time unit, considering peaks and fallback plans.

## 3. Resource Scalability

### 3.1 CPU Scalability
- **CPU Utilization:** Define desired usage target and threshold for expansion (e.g., less than fifty percent, less than eighty percent).
- **CPU Expansion:** State by how much CPU can be expanded (e.g., doubles, eight times, no expansion).

### 3.2 Memory Scalability
- **Memory Utilization:** As above, for memory (e.g., less than fifty percent, less than eighty percent).
- **Expansion Capability:** Multipliers allowed or needed (e.g., doubles, quadruples).

### 3.3 Disk Scalability
- **Disk Utilization:** Usage targets and max thresholds (e.g., less than seventy percent).
- **Expansion Options:** Factor of expansion (double, quadruple, etc.), including physical or virtual options.

### 3.4 Network Scalability
- **Network Range/Scope:** Define network area covered at deployment (none, single LAN, inter-office WAN/VPN, connection to external/partner sites).
- **Bandwidth Assurance:** State if and how network bandwidth is guaranteed (e.g., none, per protocol, per server, app end-to-end).

## 4. Server Upgrades & Expansion

- **Scale-up:** Replacement with higher-spec servers—define for which elements and in what scope.
- **Scale-out:** Adding horizontal servers—define which layers, how distributed, for which workloads.

## 5. Performance Quality Assurance

### 5.1 Resource Exclusivity
- **HW Resource Exclusivity:** Whether critical hardware (CPU, memory) is dedicated or shared. Shared leads to performance risk from other tenants/workloads.

### 5.2 Performance Testing
- **Measurement Frequency:** How often and when is performance tested? (never, upon deployment, ad-hoc during ops, continual)
- **Coverage:** Scope of test (all features, main features, none)
- **Load Spike Handling:** State assumptions and protections for large, short-term spikes (B2C traffic surges, promotional events, etc.).

### 5.3 Spike Protection & Transaction Limiting
- **Transaction Protections:** Is there a cap on concurrent transactions? Are there “sorry pages” (graceful denial) or specialized servers for overload fallback?

---
