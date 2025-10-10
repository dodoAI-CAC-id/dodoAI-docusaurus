---
id: infrastructure-availability-resilience
title: Availability and Resilience
---

# Guide: Defining Infrastructure Availability and Resilience

- Use this guide to define your infrastructure's availability and resilience requirements and designs.
- Focus on making explicit the required patterns, strategies, mechanisms, and tests for high availability, fault tolerance, disaster recovery, resilience, and monitoring in a microservices/cloud environment.
- Do not include implementation prose or operational philosophy—specify only what needs to be defined and guaranteed by the infrastructure.

---

## What to Define

### 1. High Availability Architecture

- **Multi-AZ and Multi-Region Design:**  
  - Document required AZ/region layout, instance and component distribution, and balancing/placement strategies for compute, DB, and cache.
- **Load Balancing:**  
  - Specify which LB technology is used (ALB, NLB, etc.), health check criteria/rules, target group settings, and cross-zone/failover settings.

---

### 2. Fault Tolerance Mechanisms

- **Circuit Breaker Pattern:**  
  - Define configuration for handling service faults, including thresholds, window timings, and state transitions (closed/open/half-open).
- **Retry Policies and Backoff:**  
  - State retry logic for failed calls, including limits, delays, and dead letter queue policies.
- **Graceful Degradation:**  
  - Specify what features should gracefully degrade under failure, such as fallback APIs or cache strategies.

---

### 3. Database and Storage Resilience

- **Database High Availability:**  
  - Document use of multi-AZ/multi-region DB clusters, standby/replica strategy, failover process, and connection retry.
  - Recovery time and automation target for failover.
- **Connection Pooling:**  
  - Pool size, overflow, timeouts, validation, and query failover.

---

### 4. Application and Microservices Resilience

- **Service Mesh Settings:**  
  - Detail timeouts, retries, circuit breaker, rate limiting, health check probes (liveness/readiness/startup).
- **Caching Strategies:**  
  - Document patterns: cache-aside, write-through, warmup, fallback policies.
- **Feature Flags:**  
  - Features or flows to disable during resilience events or high load.

---

### 5. Disaster Recovery

- **Backup Frequency and Type:**  
  - Tiering by RTO/RPO requirements, backup cadence, retention, and recovery test cadence for each data class.
- **Cross-Region Replication:**  
  - Data replication approach, regions, service scope, infrastructure configuration, and failover activation steps.

---

### 6. Monitoring, Alerting, and Health Checking

- **Health Check Endpoints:**  
  - All application, DB, and infra endpoints/pings—structure and schedule.
- **Monitoring Coverage:**  
  - List all infra/application components subject to health and performance checks.
- **Alerting Severity and Escalation:**  
  - Alert level definitions, response times, and escalation processes matched to business criticality.

---

### 7. Chaos and Resilience Testing

- **Chaos Experimentation:**  
  - Define types/frequency of chaos events (infra and application), target/failure modes exercised, and tools to be used (e.g., Chaos Monkey, Gremlin, Litmus).
- **Recovery Procedures:**  
  - Test plans for verifying DB failover, region failover, backup restoration, data integrity, and end-to-end service recovery during chaos or DR drills.

---

### 8. Compliance & Documentation

- **SLAs:**  
  - Codify availability, performance, RTO/RPO, and other resilience metrics—plus monitoring and reporting approach.
- **Required Documentation:**  
  - Specify mandatory runbooks, network & infra diagrams, DR/HA plan docs, process/test docs, and continuous improvement material.

---

**Note:**  
Document and validate your availability and resilience design at the architecture level, making non-negotiable requirements and validation (including chaos/resilience testing) explicit.
