---
id: infrastructure-compute-design
title: Compute Design
---

# Guide: Defining Compute Infrastructure Design

- Use this guide to explicitly define all requirements, choices, and parameterizations for compute infrastructure in a microservice/cloud-native environment.
- Do not include implementation samples or prose; list what must be specified—by service, tier, or cluster.

---

## What to Define

### 1. Compute Resource Strategy

- **Instance/Node Types:**  
  - Document instance family and type selection for each workload tier (web, application, database, worker, etc.), min/max/desired sizing, vCPU/memory/network requirements.
  - Specify which environments/tier use on-demand, reserved, or spot/preemptible instances.
  - AZ (Availability Zone) and region strategy for spreading resources.

### 2. Container Orchestration and Cluster Design

- **Cluster Management:**  
  - Specify platform (EKS, ECS, AKS, GKE, etc.) and versioning requirements.
  - Node group/Pool configuration—labels, capacity types, min/max sizes, instance types.
- **Pod & Workload Resource Configuration:**  
  - Define namespace-level resource quotas and individual pod/container resource requests, limits, and security contexts.
  - Specify policy for privileged pods, root vs non-root, and user/group assignments.

### 3. Auto Scaling and Performance

- **Horizontal Scaling:**  
  - HPA/VPA settings: metric thresholds, min/max replicas, scaling policy per workload.
- **Cluster Autoscaler:**  
  - Define cluster scaling parameters, downscale delay, and max node provision time.
- **CPU & Memory Management:**  
  - Monitoring thresholds, JVM/container memory flags, swap/overcommit, and performance policies.

### 4. Serverless Components

- **Function Deployment:**  
  - List all serverless compute in use (Lambda/ECS Fargate/Cloud Functions, etc.), runtime, memory/timeout settings, and handler configuration.
- **Containerized Batch/Process:**  
  - Task definitions, networking, and resource allocation for scheduled/background services.

### 5. Load Balancing and High Availability

- **LB Technology and Config:**  
  - Specify LB type (ALB, NLB, internal/external), health check paths, protocols, balancing/algo, and cross-AZ setup.
- **High Availability:**  
  - Explicit AZ distribution for all layers (web, app, DB) and minimum required instance/node count in each.

### 6. Monitoring and Alerting

- **Metrics:**  
  - Required metrics namespaces and metrics to be gathered for both application- and infrastructure-level (latency, error rate, CPU, memory, network, etc.).
- **Alert Policy:**  
  - Define threshold, alerting channel, and escalation policy for all critical resource utilization and errors.
