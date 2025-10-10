---
id: nfr-security
title: Security Requirements
---

# Guide – Security Requirements


- Use this guideline to define security requirements for your system and organization.
- For each item: define the required level and scope, the rationale, any related policies or standards, and how each requirement will be assured or verified.
- Always align with relevant legal, corporate, contractual, and business risk contexts.


## 1. Compliance & Constraints

### 1.1 Regulatory, Corporate, and Industry Compliance
- **What to Define:** List all applicable regulations, internal security rules, laws, certifications, and guidelines to which your system must adhere.
- **Examples:** Local/global laws (GDPR, SOX, HIPAA), industry guidelines, organizational policies, security certifications.
- **Considerations:** Ensure no contradictions between requirements and existing rules.

## 2. Security Risk Management

### 2.1 Security Risk Analysis
- **What to Define:** The scope and frequency at which security risk assessments/threat modeling are conducted for the system.
- **Example Levels:** None / Analysis limited to critical assets or external interfaces / Full system-wide analysis.
- **How to Use:** Define the criteria or methodology (e.g., STRIDE, asset inventory, data lifecycle mapping).

### 2.2 Security Assessment & Testing
- **What to Define:** Which security-specific assessments and tests will be performed (network pentests, web app tests, code reviews, DB assessments, etc.).
- **Example Levels:** None / Only some layers (e.g., network only) / Full multi-layer (network, web, DB, source code).

## 3. Ongoing Security Risk Control

### 3.1 Risk Reassessment
- **What to Define:** Policy for reassessing security risks after deployment.
- **When:** Only after incidents / Both after incidents and on a regular (e.g., annual) schedule.
- **Scope:** Only for critical or externally-facing assets / All system assets.

### 3.2 Remediation Policy
- **What to Define:** The scope and extent to which new discovered threats or vulnerabilities must be remediated after go-live.
- **Levels:** No remediation / Only for high-impact assets or interfaces / All threats.
- **Requirement:** Formulate a policy or process for ongoing risk remediation/tracking.

### 3.3 Security Patch Policy
- **What to Define:** For all platform layers (OS, middleware, etc.), specify scope, timing, and policy for applying security patches and virus definition updates.
- **Levels/Options:**
  - Scope: None / Critical assets or interfaces / Full system.
  - Timing: Only on occurrence, on regular intervals, or immediately on release.
  - Policy: Only urgent/emergency patches, or all available patches applied.

## 4. Access and Usage Control

### 4.1 Authentication & Authorization
- **What to Define:** Authentication requirements for privileged and non-privileged users/devices; number of authentication factors required; authentication methods (password, biometrics, IC card, etc.).
- **Levels:**
  - None
  - Single-factor
  - Multi-factor
  - Multi-factor, multi-method.

### 4.2 Access & Usage Restrictions
- **What to Define:** The degree and method of controlling what authenticated users/devices can access or do; both in software (commands, files, apps) and in hardware (physical locks, peripheral device limitations).
- **Levels/Options:** None / Minimal necessary operations only / Hardware usage limitations.

### 4.3 Credential Management Policy
- **What to Define:** Rules for adding, updating, and revoking authentication credentials; frequency and responsibility for such procedures.

## 5. Data Confidentiality

### 5.1 Data Encryption
- **What to Define:** Scope of encryption for data in transit and at rest.
- **Levels/Options:** None / Only authentication credentials encrypted / All important or sensitive data encrypted.
- **Key Management:** Define whether keys are managed in software only or in tamper-proof hardware.

## 6. Monitoring & Audit

### 6.1 Threat & Intrusion Monitoring
- **What to Define:** What types of potentially unauthorized actions should be monitored (devices, network events, user actions), and the depth and frequency of log retention.
- **Levels/Options:**
  - Logging: None / For critical assets only / Entire system.
  - Retention: 6 months, 1 year, 3 years, up to indefinitely.
  - Monitoring scope: Devices, networks, intrusions.
  - Review timing: Only on event, on event plus periodic review, or continuous automated detection.

### 6.2 Data Integrity Verification
- **What to Define:** Whether digital signatures or similar means are used to verify that saved and transmitted data is unaltered.
- **Review Frequency:** On events, periodically, or always.

## 7. Network Security

### 7.1 Network Traffic Control
- **What to Define:** Whether and how to control/block unauthorized network connections (firewall, ACL, etc.).
- **Detection:** Scope of monitoring for malicious traffic (none, partial, full system).
- **DDoS/Attack Protection:** Specify if and how against network congestion/attacks (firewall, WAF, IDS, anti-DDoS).

## 8. Malware Protection

### 8.1 Malware Countermeasures
- **What to Define:** The scope of malware prevention (e.g., endpoints, email, network), real-time scanning, and frequency of full scans and pattern/signature updates.
- **Levels:** None / Critical assets / Entire system / Real-time.

## 9. Web Security

### 9.1 Web Application Security
- **What to Define:** Requirements and measures for secure coding practices, hardening of web server configs, and use of third-party controls (e.g., WAF).
- **Levels:** None / Secure coding / WAF introduced.

## 10. Security Incident Response & Recovery

### 10.1 Incident Response
- **What to Define:** Is an organized support structure in place to detect, respond to, minimize, and quickly recover from security incidents?
- **Levels:** None / Basic / Full response/recovery with business impact minimization procedures.

---

## Documentation Guidelines

For each item above, clearly:
- Specify the subject/system/component covered.
- Describe required/target level and selection rationale.
- State the applicable standard, policy, or methodology (if relevant).
- Indicate how compliance/assurance will be demonstrated or audited.
- Update requirements as threats, technology, and regulations evolve.

---

**Purpose:**  
Careful, explicit definition of security requirements ensures your system and data are protected, regulatory obligations are met, and risks are managed in line with business expectations and capabilities.
