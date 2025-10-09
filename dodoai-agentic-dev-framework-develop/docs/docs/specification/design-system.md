---
id: design-system
title: Design System
---

# Guide: Defining and Operating a Design System

- Use this guide to define, document, and govern the Design System for your product or organization.
- Do not copy this content directly; always adapt usage and principles to your business, platform, and brand needs.
- A Design System is a shared asset that brings consistency, efficiency, and quality to all design, development, and planning activities.

---

## 1. Overview and Purpose

- **Standardization:**  
  The Design System prevents unnecessary reinvention and fragmentation of UI/UX by providing a single, authoritative source for all front-end components and patterns.
- **Design and Brand Consistency:**  
  All products share a unified look and feel, enhancing user experience, brand fidelity, and accessibility compliance.
- **Efficiency and Debt Reduction:**  
  Reusing standardized assets dramatically cuts front-end development costs and technical debt.
- **Governance:**  
  The Design System enforces design standards and accessibility, and is used for vendor or development acceptance.

---

## 2. Intended Users

- **Designers** – Create, document, and maintain reusable components, plan with common patterns, and consult accessibility guidelines.
- **Front-End Developers** – Use only pre-approved UI components, avoid custom implementations, and reference code & guidelines from the central resource.
- **Planners / Information Architects** – Use standard components and patterns for prototyping and documentation, ensuring UI plans are in line with the design system.
- **Spec/Procurement Authors** – Leverage the design system to set governance and acceptance criteria for external vendors or contractors.

---

## 3. Components of the Design System

- **Usage Guide:**  
  Clearly explain how to use, adapt, and extend the system—including the process for requesting new components.

- **Component Design:**  
  Catalogue of pre-designed UI components:
    - Always use existing components where possible.
    - Source code must come from the shared catalog (Widgetbook or similar).
    - To add new components:
      1. Propose and design in the system documentation.
      2. Export source/definition code (via Figma, other tools).
      3. Integrate it into Widgetbook (or equivalent).
      4. Inform developers and include in ongoing documentation.

- **Style Guide:**  
  Foundation for brand and product consistency, including color, typography, iconography, layout, and spacing.  
  When extending, always follow the brand rules, and ensure accessibility criteria are met.

- **Asset Library:**  
  Central repository of logos and brand assets.  
  Usage must strictly adhere to documented guidance for size, ratio, color, and non-alteration.

---

## 4. Usage by Role

- **Designers:**  
  - Select, assemble, and refine screen designs using catalogued components.
  - Use the design system for planning, not just for drawing.
  - Consult accessibility guidance embedded within components.
- **Developers:**  
  - Only build using pre-approved code/components.
  - Never create custom components without designer request and approval.
  - Use code snippets as a starting point; rely on Widgetbook or equivalent for quality and consistency.
  - Reference accessibility rules during implementation.
- **Planners/Information Architects:**  
  - Use design system templates/components for wireframes, mockups, or documentation.
  - Plan for accessibility from the beginning.
- **Procurement/Spec Planners:**  
  - Set the design system as a hard requirement for suppliers/vendors.
  - Use its accessibility checklist for contract acceptance.

---

## 5. Operational Guidelines

- **Consistency:**  
  Use existing designs/components/styles whenever possible to maintain brand and user experience consistency.
- **Communication:**  
  Maintain open dialogue between designers, developers, and planners. When requirements change, promptly update the design system and communicate to all users.
- **Component Lifecycle:**  
  - If a new component is *needed*:
    1. Confirm and document necessity (approval process).
    2. Design and register in the design system first.
    3. Assign implementation for Widgetbook.
    4. Release into Widgetbook for developer use.
- **Keep Widgetbook in Sync:**  
  Whenever the design system is updated, the developer/component catalog must be also.  
  Avoid divergence between the documentation, design assets, and developer code.

---

## 6. Developer Notes

- **No Custom Components:**  
  Never independently implement UI. Submit a request for new designs/components to the designer.
- **Governance and Approval:**  
  Use the design system for workflow approvals; ensure changes go through documented processes (request, approval, implementation).
- **Addition Workflow:**  
  Set clear steps for proposal, approval, design, implementation, and rollout, aligning with project leaders and stakeholders.

---

## 7. Accessibility & Branding

- Always maintain accessibility as per the design system checklist.
- Never modify brand assets (logo, colors, proportions) except as documented.
- When in doubt, consult a designer or system owner before making changes.

---

**How to Use This Guide**  
Apply these principles and operational practices to make the design system a living foundation for all development and design work. Update and govern centrally, and extend only through formalized, reviewed processes to maintain brand, quality, and accessibility at scale.

