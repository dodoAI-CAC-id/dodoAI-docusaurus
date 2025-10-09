---
id: directory-structure-and-layer-responsibilities
title: Directory Structure and Layer Responsibilities
---

# 03. Directory Structure and Layer Responsibilities

In practicing "Modular Onion Architecture" for Flutter applications, directory structure clarifies responsibilities and dependencies, significantly affecting development efficiency and readability. This chapter systematically organizes the folder structure of the entire project based on the design intent and layer correspondence of each directory.

## 3.1 Top-Level Structure

| Directory | Role Overview |
|-----------|---------------|
| `app/` | Startup processing, DI definition, routing (Modular) configuration |
| `core/` | Global settings, constants, error handling, GraphQL and other common interface groups |
| `features/` | Modularization of each business function in DDD structure (Domain, Application, Infrastructure, Presentation) |
| `infrastructure/` | Implementation of infrastructure-related common services used throughout the app (GoogleMap, GraphQL, Logging, etc.) |
| `shared/` | Reusable UI parts based on Atomic Design, common styles, layout composition |
| `pages/` | UI layer that integrates each Feature and composes one screen (View assembly) |
| `main.dart` | Application entry point |

## 3.2 features/ Directory Structure (Module Division Format)

```
features/
  └── {feature_name}/
       ├── domain/         # Entity, Repository Interface (pure domain knowledge)
       ├── application/    # UseCase, Service layer (business process implementation)
       ├── infrastructure/ # API calls and data acquisition processing (Repository implementation)
       └── presentation/   # Bloc, Pages, Widgets (Atomic Design structure)
```

**Characteristics:**
* Each Feature is managed as a clear module unit, making reuse, deletion, and testing easy
* `presentation/` can be further subdivided:

```
presentation/
  ├── blocs/
  ├── pages/
  └── widgets/
      ├── atoms/
      ├── molecules/
      └── organisms/
```

* Utilize `export_{feature}_feature.dart` etc. to organize references across module boundaries
* By maintaining import order and dependency direction, feature boundaries and independence are enhanced

**Characteristics:**
* Complete responsibility separation by Feature unit
* Based on DDD (Domain-Driven Design), eliminating interference between UI layer and business layer
* Minimizing impact scope for testing, module replacement, and feature addition

## 3.3 shared/ and Atomic Design

```
shared/
  └── presentation/
       └── components/
            ├── atoms/
            ├── molecules/
            ├── organisms/
            └── pages/
```

* **Atoms**: Basic parts like text, buttons, input fields
* **Molecules**: Input forms, search bars combining multiple Atoms
* **Organisms**: Reusable sections like headers and cards
* **Pages**: Common layouts and templates (e.g., AppBaseLayout)

This structure ensures hierarchical reuse of UI components and visual consistency.

## 3.4 infrastructure/

* Aggregates common infrastructure processing used throughout the app that is not Feature-dependent
* Examples: GraphQL client initialization, GoogleMap Web/Native wrapper, error handling
* Each Feature's `infrastructure/` is limited to implementations specific to that Feature

## 3.5 core/

* Holds globally necessary contracts, settings, and abstract interfaces
* `graphql/`: GraphQL interface (`i_graphql_services.dart`)
* `config/`: Environment/flavor switching, global variables
* `themes/`: Color and typography definitions
* `blocs/`: App-wide state management (AppBloc, etc.)
* Positioned to be depended upon by other modules but not depend on anything itself

## 3.6 app/ and routing

* Define Modular DI routes (`AppModule`, `HomeModule`, etc.)
* Centrally manage singleton binds in `core_module.dart`
* Each Feature is modularized individually under `child_module/`, achieving route division according to app scale

This directory structure is designed to maximize readability, reusability, modularity, and testability.
