---
id: infrastructure-database-design
title: Database Design
---

# Guide: Defining Infrastructure Database Design

- Use this guide to explicitly define database architecture and required practices for infrastructure in microservice and cloud-native environments.
- Do not include implementation details or general discussion; specify what must be designed, selected, and managed.

---

## What to Define

### 1. Database Configuration

- **RDS and Managed DBs:**  
  - Engine and version
  - Instance type/class, storage (size/type), multi-AZ and backup settings
  - Read replica count, cross-AZ settings, connection pooling tool/config
- **Aurora:**  
  - Engine/version, instance count per role (writer, reader), serverless settings, global DB replication/regions, automatic backup and point-in-time recovery parameters

---

### 2. NoSQL/Data Store Design

- **DynamoDB or Equivalent:**  
  - Table definitions, partition/sort key strategy, attribute listing, TTL fields, billing mode (on-demand/provisioned), indexes (GSI, LSI), and throughput settings
- **Caching (ElastiCache/Redis/Memcached):**  
  - Cluster size, node type, memory config, failover/HA, retention and backup, eviction and TTL policies, use cases distinction (session, query, object cache, etc.)

---

### 3. Security and Access Control

- **Encryption:**  
  - At rest: activation and KMS key use per store
  - In transit: SSL/TLS requirement, minimum TLS version, cert validation
- **Access:**  
  - IAM DB authentication, VPC/network group assignment, user role/privilege design, use of private subnets, MFA for admin, minimum privilege enforcement

---

### 4. Performance & Optimization

- **DB Tuning:**  
  - Resource allocations for buffer/cache/work memory, connection settings, query log/analysis, and max connections.
- **Index Strategies:**  
  - Indexing for PK/FK/queries, monitoring, periodic reviews to remove unused indexes or add based on workload.

---

### 5. Backup, Recovery & DR

- **Backup:**  
  - Frequency/type (automated/manual), cross-region copy, snapshot policies for each DB (SQL/NoSQL/Cache).
- **Recovery:**  
  - RTO/RPO per environment/data class, required recovery/testing frequency, failover steps and required monitoring.

---

### 6. Monitoring and Alerts

- **Database Metrics:**  
  - List required metrics (e.g., IOPS, CPU, memory, latency, lag, error rates).
  - Define alerting thresholds for all production data stores.
- **Performance Insights:**  
  - Enforce usage of tools/features (e.g., RDS Performance Insights) as required, retention, and monitoring practices.

---

### 7. Data Migration

- **Migration Planning:**  
  - Tooling (e.g., DMS), migration flow phases (schema, initial load, change capture, cutover), rollback requirements
- **Validation:**  
  - Process and techniques (row count, checksums, test system validation)

---

### 8. Cost Optimization

- **Instance/Storage Selection:**  
  - Selection and review of reserved instances, right-sizing, adoption of flexible/serverless options for variable workloads
  - Storage/archiving/compression strategies, policy for removing or retaining snapshots and old data

---

**Note:**  
All of the above requirements must be listed, reviewed, and version-controlled as part of your infrastructure design documentation. Where possible, update as technology, workload, or organizational risk changes.
