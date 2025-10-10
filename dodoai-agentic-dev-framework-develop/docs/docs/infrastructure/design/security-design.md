---
id: infrastructure-security-design
title: Security Design
---

# Guide: Defining Infrastructure Security Design

- Use this guide to specify infrastructure security requirements, controls, and architecture for cloud-native and microservices environments.
- List all security layers to be defined—network, identity/access, data protection, monitoring, automation, and compliance.
- Only describe structure, policies, and controls needed. Do not include sample policies or implementation code.

---

## What to Define

### 1. Defense in Depth Architecture

- Specify all security layers:
    - **Perimeter Security:** WAF (Web Application Firewall), CDN, DDoS protection
    - **Network Security:** VPC isolation, security groups, NACLs, VPN/gateway requirements
    - **Application Security:** IAM policy structure, RBAC, API security requirements, authentication standards
    - **Data Security:** Encryption (at rest/in transit), key management, secrets management, backup protection
    - **Monitoring & Compliance:** Audit logging, security monitoring, compliance checks, incident response coverage

- Use a **Mermaid diagram** (e.g., as a layered graph/flow) to visualize all boundaries and protection paths from external to internal systems.

---

### 2. Identity and Access Management

- Define IAM roles, policy principles, and separation of duties (admin, service, app, DB, etc.).
- Detail authentication and authorization methods:
    - MFA policy (required/enforced for all privileged access)
    - Service-to-service authentication (IRSA, OIDC, token rotation)
    - Role-based access/least privilege for each resource/class

---

### 3. Network Security

- Specify security group and NACL requirements by resource/service/tier.
- Define required inbound/outbound rules, trusted source/destinations, protocol/port granularities.
- Document load balancer and firewall requirements (e.g., WAF, application vs. network tier separation, health check security).
- Require VPN, VPC endpoint, and private connectivity usage as appropriate.

---

### 4. Data Protection Policies

- Encryption requirements for all data-at-rest and in-transit; specify KMS/customer-managed keys.
- Certificate management (provider, min TLS version, renewal, rotation schedule).
- Secrets management workflows (rotations, access policy, audit logging).

---

### 5. Application & Container Security

- Define API gateway security policies (authentication, rate limiting, validation, logging).
- Container image registry and runtime security (base image controls, scanning, signature, non-root enforcement).
- Pod and workload security context for Kubernetes: RBAC, admission controllers, network policies, mTLS in service mesh.

---

### 6. Monitoring, Logging, and Compliance

- Security monitoring and SIEM tool integration requirements.
- Mandatory logging (audit log types, retention, access reviews).
- Compliance framework coverage (SOC 2, ISO 27001, PCI DSS, GDPR, as required).
- Incident response playbook and notification requirements.

---

### 7. Security Automation

- Specify mandatory static and dynamic security scans (code, containers, infrastructure, dependencies) and frequency.
- Automation for credential rotation, incident ticketing, access revocation, and remediation workflow.
- Integration with SIEM, ticket, and communication platforms.

---

### 8. Security Governance & Best Practices

- Security assessment schedules, training mandates, escalation and audit requirements.
- Responsibilities and roles for all teams in incident response, monitoring, policy updates, and regular review.

---

**Note:**  
Document all security design and policy requirements with diagrams where possible—especially to clarify defense layers, data flows, and service boundaries for all critical systems.
