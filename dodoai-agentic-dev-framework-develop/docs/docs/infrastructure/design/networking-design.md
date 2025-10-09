---
id: infrastructure-networking-design
title: Networking Design
---

# Guide: Defining Infrastructure Networking Design

- Use this guide to clearly define required networking practices, patterns, and configurations for infrastructure in a modern, secure, microservice/cloud environment.
- Only list explicit requirements and design items—do not include general commentary or implementation tutorials.

---

## What to Define

### 1. VPC and Subnet Architecture

- **VPC Configuration:**  
  - CIDR strategy (IPv4 and IPv6 allocations if needed)
  - Region and AZ count; DNS hostnames/resolution policy
  - VPC tenancy (default/dedicated), flow logs activation

- **Subnet Design:**  
  - Define public, private (application), and database subnet segmentation across AZs.
  - Specify subnet CIDR blocks and mapping, automatic public IP assignments, and route table mapping.
  - Environment-based VPC/subnet structure if isolation is required.

---

### 2. Routing and Connectivity

- **Route Table Structure:**  
  - Assignments of public, private, and DB route tables; configure default routes to IGW, NAT, or Local.
- **Internet Gateway & NAT Gateways:**  
  - Define required gateways, their AZ mapping, elastic IP assignments, and associated routing.

---

### 3. Security Groups and NACLs

- **Security Group Design:**  
  - Inbound and outbound rules (protocol, port, source/destination, descriptive labels)
  - Principle of least privilege for tiered resources (web/app/db), segregation between environments
  - Reference groups for trusted sources (e.g., ALB, bastion hosts, monitoring)

- **Network ACL Design:**  
  - NACL for each subnet type (public/private), define all inbound/outbound rules and actions (allow/deny), and ensure stateless traffic flow alignment with application needs.

---

### 4. Load Balancing

- **Application/NLB Design:**  
  - Types used (Application LB, Network LB), attached subnets, listener/target group configuration, health check criteria, security group mapping, and support for blue-green/canary/rolling deployments.

---

### 5. DNS and Health Checking

- **DNS Management:**  
  - Hosted zones (public/private), record types for service endpoints, alias/CNAME/A records, and automation of DNS with IaC.
- **Health Checks:**  
  - All endpoint/target health check configuration (path, interval, thresholds) for DNS and load balancers.

---

### 6. VPN and Private Connectivity

- **Site-to-Site and Client VPN Design:**  
  - Required gateways, tunnel configs, client auth, allowed IPs, split tunneling, and route propagation.
- **VPC Endpoints:**  
  - Required endpoints for AWS/SaaS service access in private subnets, addressing NAT gateway/billing/flow reduction.

---

### 7. Network Monitoring

- **Flow Logs:**  
  - Resources covered, log group config, retention, field sets for analysis.
- **Network Insights:**  
  - Path and reachability analysis requirements (critical flows, frequency, reporting, and alerting).

---

### 8. Security, Performance, Cost

- **Security:**  
  - Enforce least privilege in all rules; regular audits and monitoring; defense-in-depth (SG + NACL).
- **Performance:**  
  - Placement groups for high-performance resources, subnet/AZ optimization, appropriate LB policies, monitoring for bottlenecks.
- **Cost:**  
  - Controls for cross-AZ data transfer, NAT cost reduction, VPC endpoint use, and network resource right-sizing.

---

**Note:**  
All networking requirements and designs must be documented in version-controlled architecture artifacts. Review and update network design as your system, traffic, and security landscape evolve.
