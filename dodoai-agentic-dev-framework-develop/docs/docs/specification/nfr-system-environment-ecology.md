---
id: nfr-system-environment-ecology
title: System Environment and Ecology Requirements
---

# System Environment and Ecology – Definition Guide


- Use this guide to comprehensively define system environment and ecology requirements for your system.
- Do not copy sample wording directly. Always adapt each item to your actual system architecture, business characteristics, and operational environment.
- For each item, clearly specify what is required, the rationale, the relevant level or policy, and any metrics or conditions.


## 1. System Constraints and Assumptions

### 1.1 Construction-time Constraints
- **What to Define:** Any internal policies, laws, or mandatory standards affecting system construction, including location-specific or governmental regulations.
- **Examples:** SOX, ISO27000-series, national security standards, privacy marks, site restrictions.
- **Levels:** No constraints / Only critical constraints applied / All relevant constraints applied.

### 1.2 Operational Constraints
- **What to Define:** Applied standards/laws or ordinances/organizational rules that must be followed during operations.
- **Examples:** Data privacy, J-SOX, regulations on remote operation.
- **Levels:** No constraints / Only important constraints / All constraints.

## 2. System Characteristics

### 2.1 User and Client Scale
- **Number of Users:** Define whether only specific users, a capped number, or an unlimited/unidentified number of users will use the system.
- **Number of Clients:** Same as above, but for client systems/devices.
- **Number of Sites:** Indicate whether system runs at one location or multiple.
- **Geographic Spread:** Clarify the deployment area (single site, city, region, country, global).

### 2.2 Product/Component Specification
- **Specific Products:** State whether specified OSS/third-party products must be used, and consider the impact on supportability.
- **System Usage Scope:** Whether usage is intra-departmental, company-wide, or includes B2B/B2C external use.
- **Multilingual Support:** Whether multiple languages are required (and how many); consider language accessibility as needed.

## 3. Compliance and Standards

### 3.1 Product Safety Standards
- **What to Define:** If the system must use only certified hardware/products (e.g., UL60950).
- **Levels:** No need / Compliant as per standard (UL60950, RoHS, VCCI Class A/B, etc.).

### 3.2 Environmental Protection
- **What to Define:** Must products comply with, for example, RoHS (restricting hazardous materials) or similar standards?

### 3.3 Electromagnetic Interference
- **What to Define:** State whether compliance with EMI/EMC standards is needed.

## 4. Equipment/Floor Installation Requirements

### 4.1 Seismic and Vibration Resistance
- **What to Define:** Maximum earthquake resistance required by location.
- **Levels:** No requirement, Tokai/Tohoku quake (e.g. magnitude 4, 5, 6, or 7), set in gal (acceleration).

### 4.2 Floor Space and Physical Constraints
- **What to Define:** Space (WxDxH) required, rack/floor specifics, special constraints for parallel operation (during migration).
- **Sub-Items:**
  - Machine room space/restrictions.
  - Office installation (dedicated/shared space).
  - Free space for parallel run or expansion.
- **Consideration:** Balance with need for expansion and parallel migration.

### 4.3 Weight and Load
- **What to Define:** Weight limitations per square meter and countermeasures (reinforcing, load distribution, rack usage).
- **Levels:** e.g., 200kg/m² to 2000kg/m² or more, and requirements for installation modifications.

### 4.4 Electrical and Cooling Suitability
- **What to Define:** Compatibility of power supply, voltage, phases, circuits, and the air conditioning/cooling requirements.
- **Sub-Items:** Power adequacy, custom work needed, capacity for parallel run, blackout measures, voltage and frequency fluctuation tolerance, and grounding type.

### 4.5 Temperature and Humidity Range
- **What to Define:** Operating temperature and humidity bands required for stable operations.
- **Levels:** From standard ranges (e.g. 16–32°C, 5–35°C, 0–40°C) to extended ranges for special conditions. Humidity from "no limit," to 45–55%, to condensation-free at wider levels.

### 4.6 Air Conditioning and Cooling Capacity
- **What to Define:** Whether cooling is adequate for all equipment, any hotspots, or if upgrades are needed.
- **Levels:** No constraints, partial constraint (easily handled), severe constraint (requires custom engineering).

## 5. Environmental Management

### 5.1 Eco-Friendliness and Green Procurement
- **What to Define:** To what degree eco-friendly products (e.g. Green Purchasing Law in Japan) are used, and how system expansion/disposal affects environmental load.
- **Levels:** Not required, partially green-compliant, fully green-compliant.

### 5.2 Expansion Potential and Lifecycle
- **What to Define:** The capability for hardware/configuration expansion (expressed as multiplier: 2x, 4x, 10x, etc.), and lifecycle periods (e.g., 3, 5, 10 years).

### 5.3 Energy Consumption Efficiency
- **What to Define:** Target or policy for total energy use, power efficiency, or use of energy benchmarks like PUE or DPPE.  
- **Levels:** None, has a target, has a target plus improvement mechanisms.

### 5.4 CO2 Emission Management
- **What to Define:** Whether CO2 maximum thresholds lie over product/system lifecycle; is there a target or requirement for continual reduction?

### 5.5 Noise/Vibration
- **What to Define:** Noise emission level requirements (e.g., below 87dB for offices; below 40dB or less for quiet environments).

---

## Documentation Points

- For every item, state the exact scope and requirement level, with rationale and, where possible, measurement standards or metrics.
- Note any critical constraints and their business/technical impact.
- Align requirements with environmental, compliance, and business expansion plans.

---

**Purpose:**  
These guidelines ensure your system's environmental and compliance requirements are explicit and realistic, minimizing project risk and enabling support for expansion, green management, and safe operations throughout system lifecycle.
