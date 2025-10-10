---
id: infrastructure-monitoring-logging
title: Monitoring and Logging
---

# Guide: Defining Infrastructure Monitoring and Logging

- Use this guide to specify your required monitoring and logging practices at the infrastructure and application level.
- List concrete architectural, operational, and policy requirements for metrics, logging, alerting, observability, and incident response.
- Do not include code implementation or tool-specific tutorials—clearly define what must be implemented, tracked, and acted upon.

---

## What to Define

### 1. Monitoring Architecture

- **Metrics Collection:**  
  - List source systems (VMs, containers, managed services, cloud resources).
  - Specify required metrics for compute, storage, networking, database, application, and business KPIs.
  - Document tools and intervals for metrics collection (e.g., CloudWatch, Prometheus, StatsD).

- **Retention Policies:**  
  - Define minimum/maximum retention period for each log/metric type by criticality (e.g., app logs: 30 days, audit logs: 7 years).

- **Dashboards and Visualization:**  
  - State dashboard requirements (e.g., infrastructure overview, application latency, business metrics).
  - Specify roles with access (e.g., Ops, Security, Product).

---

### 2. Log Management

- **Centralized Collection and Aggregation:**  
  - List required log types: application logs, infrastructure/system, security/audit logs.
  - Required log sources: files, cloud resources, network/infra devices.
  - Define aggregation pipeline (e.g., Filebeat, Logstash, ELK, CloudWatch Logs).

- **Processing, Filtering, and Tagging:**  
  - Required metadata/tagging for source, environment, owner, etc.
  - Filtering, enrichment, and PII/redaction rules to be applied before storing logs.

---

### 3. Application Performance Monitoring (APM) & Tracing

- **APM Integration:**  
  - Define tool integration (e.g., New Relic, Datadog, Jaeger, X-Ray).
  - Required metrics: response times, errors, throughput, business KPIs.
- **Distributed Tracing:**  
  - Mandate tracing and correlation for all inter-service requests.
  - Specify a unique trace/request ID to be propagated in logs.

---

### 4. Alerting Strategy

- **Alerting Policies:**  
  - List alerting thresholds and conditions for resource, infra, and application metrics.
  - Define severity categories (Critical/P1, High/P2, Medium/P3, Low/P4) and response times for each.
- **Notification Channels:**  
  - Required integrations (PagerDuty, Slack, Email, SMS, etc.).
- **Alert Routing and Escalation:**  
  - Document on-call rotation, escalation chains, and suppression logic (for maintenance, known issues).

---

### 5. Security and Compliance Monitoring

- **Log Collection:**  
  - Mandatory logging for security-relevant events (authn, authz, privilege escalation, config changes).
  - Retention requirements and audit access controls.

- **SIEM Integration:**  
  - List required log sources for security event monitoring and minimum dashboard/reporting/alert capabilities.

- **Compliance Reporting:**  
  - Define required rules and alerting—e.g., public S3 bucket detection, network rule checks, encryption status, backup verification.

---

### 6. Performance Monitoring

- **Infrastructure KPIs:**  
  - Required system, application, and business KPIs (CPU, memory, latencies, error rates, end-user experience metrics).
  - Specify required monitoring for storage, database, network, and cloud managed resources.

- **Application KPIs:**  
  - Define monitoring requirements for frontend/mobile, backend/API, and end-to-end user journeys.

---

### 7. Incident Response Integration

- **Detection and Triage:**  
  - Define which automated monitoring events trigger incident response and escalation.
- **Runbooks/Playbooks:**  
  - Required runbooks for alert response, auto-remediation, failover, and escalation.
- **Correlation and Context:**  
  - Require tracing, correlation ID, and context in logs/metrics for rapid investigation.

---

### 8. Cost and Storage Optimization

- **Log and Metric Storage:**  
  - Specify log/metric resolution, storage tiering, and automated cleanup/lifecycle.
- **Cost Tagging:**  
  - Require resource tagging and allocation for cost attribution and optimization.
- **Budget Alerts:**  
  - Specify cost thresholds and alerting for log and metric-related spend.

---

**Note:**  
Keep all monitoring and logging requirements version controlled, systematically reviewed, and updated with changes to infrastructure, workload, or compliance needs.
