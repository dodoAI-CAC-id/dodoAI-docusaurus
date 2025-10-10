---
id: atomic-design-implementation-rules
title: Atomic Design Implementation Rules
---

# 04. Atomic Design Implementation Rules

Atomic Design is a method for hierarchically dividing and managing UI components, serving as an important pattern for ensuring reusability and design consistency.

## 4.1 Concept and Hierarchy Definition

| Hierarchy | Description | Placement Path Example |
|-----------|-------------|------------------------|
| Atom | Basic UI parts (buttons, text, etc.) | `shared/presentation/components/atoms/` |
| Molecule | Composite parts from multiple Atoms | `shared/presentation/components/molecules/` |
| Organism | Sections combining Molecules | `shared/presentation/components/organisms/` |
| Template | Layout framework | `shared/presentation/templates/` |
| Page | App-wide screen units | `features/{feature}/presentation/pages/` |

## 4.2 Naming and Structure Rules

* Add prefixes to component names for clarity: e.g., `AppButton`, `UserCard`, `SearchBar`
* Match file names with class names
* Always use common design (`AppColors`, `AppTypography`)

## 4.3 Directory Structure (Example)

```
shared/
└── presentation/
    └── components/
        ├── atoms/
        │   ├── app_button.dart
        │   └── spacing.dart
        ├── molecules/
        │   └── labeled_input.dart
        ├── organisms/
        │   └── user_profile_card.dart
        └── templates/
            └── base_page_layout.dart
```

Additionally, Atomic Design can be adopted in `features/{feature}/presentation/widgets/` to ensure local reusability.

## 4.4 Operational Policy

* Widgets intended for reuse go to `shared`
* Cut out in order from smallest, maintaining naming consistency
* Integration with Storybook (Widgetbook) is mandatory
