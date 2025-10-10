---
id: frontend-feature-module-design
title: Frontend Feature Module Design
---

# Guide: Frontend Feature Module Design

- Use this guide to integrate the principles of the Domain, Application, Presentation, Infrastructure, and Composition layers into a single, self-contained frontend feature module.
- Focus on architectural responsibilities, component types, dependency rules, configuration, testing, and operational practices for a feature. Do not document backend implementation specifics or visual design details.

---

## What to Define

### 1. Feature Scope and Layer Responsibilities

- Define the purpose and boundaries of the feature (screens/flows it owns).
- Specify responsibilities per layer within the feature:
  - Domain: business rules, entities, value objects, aggregates, domain services, domain events; no external dependencies.
  - Application: orchestrate use cases, coordinate workflows/transactions, application-specific rules outside the domain model, command/query/event handlers, sagas/coordinators; entry point for presentation.
  - Presentation: UI rendering, input handling, view models/presenters, controllers/coordinators; request/response coordination with application.
  - Infrastructure: concrete adapters for HTTP/storage/logging/metrics/etc. as required by the feature; translate between external data and domain/application contracts.
  - Composition: dependency registration and wiring for all feature services; lifecycle, configuration, and cross-cutting setup.

---

### 2. Dependency Rules

- Define allowed dependency directions:
  - Presentation → Application → Domain.
  - Application → Infrastructure via contracts/interfaces defined in domain/application.
  - Composition wires concrete infrastructure into application; contains no business logic.
- Prohibit:
  - Domain depending on application/presentation/infrastructure.
  - Application depending on UI framework types/components.
  - Presentation calling infrastructure directly (must go through application).
  - Service locator pattern; require explicit dependency injection.
- Require contract-first design:
  - Expose interfaces in domain/application; implement them in infrastructure.
  - Maintain strict no-cycle rules between modules; enforce via CI.

---

### 3. Component Structure

- Define component types for each layer:
  - Domain: entities, value objects (immutable, self-validating, equality by value), domain services (stateless), aggregates (root-only mutations), domain events (business-side eventing).
  - Application: use case handlers (execute request/return response), application services (auth, transformation, validation), command/query/event handlers, sagas/coordinators for long-running workflows.
  - Presentation: UI components (atomic and reusable), view models/presenters (state and projection), controllers/coordinators (user actions, navigation, orchestration), routing endpoints for this feature.
  - Infrastructure: repositories/adapters (HTTP/GraphQL, storage, cache), mappers/DTO translators, cross-cutting clients (logger, metrics, tracing), resiliency wrappers (retry, timeout, circuit breaker).
  - Composition: DI container bindings, providers, feature-level bootstrapping glue.
- Define public API surface per layer (what is exported) to prevent leaking internals.

---

### 4. Module and Folder Structure

- Specify a feature-scoped structure such as:
  - feature/[FeatureName]/
    - domain/ (entities, value-objects, services, aggregates, events)
    - application/ (use-cases, services, handlers, coordinators, dto, errors)
    - presentation/ (components, screens, view-models, controllers, state, routes)
    - infrastructure/ (repositories, http, storage, adapters, mappers)
    - composition/ (container, providers, config)
    - index.ts (feature public exports)
- Require minimal, intentional exports from each index to preserve boundaries.
- Define rules for shared code placement (shared/ module) and allowed import directions.

---

### 5. Dependency Injection and Composition

- Specify the DI mechanism (container/framework or explicit constructor injection).
- Define registration patterns and lifetimes:
  - Singleton (e.g., HTTP client, logger), scoped (e.g., screen/view model), transient (e.g., use cases).
- Require explicit bindings from interfaces to implementations; avoid reflection-heavy auto-wiring.
- Document steps to add new services/modules to the composition root and how they are discovered by the app shell.

---

### 6. Configuration Management

- Define how environment variables, feature flags, and secrets flow into the feature (via composition).
- Require schema validation of configuration at startup; fail fast on misconfiguration.
- Document default values, override precedence (env → app shell → feature), and secure handling of sensitive settings.

---

### 7. State Management and UX Patterns

- Define the state strategy:
  - Local vs feature-scoped vs global store; restrict global state to cross-cutting concerns (auth, theme, config).
  - Data synchronization, optimistic updates, conflict resolution, and cache invalidation rules per use case.
- Specify standard UI states and transitions:
  - Loading, error, empty, and success patterns; consistent messaging and retry affordances.
- Require accessibility, responsiveness, and internationalization readiness for all presentation elements.

---

### 8. Error Handling and Monitoring

- Define an error taxonomy and mapping:
  - DomainError (business rule), AppError (use case/workflow), InfraError (I/O), PresentationError (UI/render).
  - Map infrastructure failures to application errors; map application errors to user-meaningful presentation states.
- Require centralized logging, metrics, and tracing:
  - Correlation/trace IDs, anonymized user context, structured logs.
- Specify graceful degradation and fallbacks:
  - Retries, offline cache, skeleton UIs, partial renders, and circuit breaking behavior.

---

### 9. Testing Requirements

- Unit tests:
  - Domain models/services and invariants.
  - Application use cases/handlers with mocked dependencies.
  - Presentation view models/controllers (state transitions) and key components (accessibility).
- Integration tests:
  - Application services with concrete infrastructure adapters (HTTP/storage) using test doubles or sandbox endpoints.
- End-to-end tests:
  - Critical user journeys that span presentation → application → infrastructure adapters.
- Define fixtures, boundary cases, and error scenarios; require deterministic, isolated tests and CI execution.

---

### 10. Performance and Code Splitting

- Define performance budgets and targets (render time, bundle size).
- Require feature-level code splitting and lazy loading; memoization and avoiding unnecessary re-renders.
- Specify network efficiency practices:
  - Request batching, debouncing/throttling, cache policies (e.g., stale-while-revalidate), pagination.

---

### 11. Security and Privacy

- Define client-side security practices:
  - No secrets in client code; prefer HttpOnly cookies for tokens; if using storage, use short-lived tokens with rotation.
  - Output escaping, CSP, XSS and CSRF protections, safe URL handling.
- Specify PII handling, redaction in logs, and data minimization in telemetry.

---

### 12. Bootstrapping, Health, and Shutdown

- Define initialization order:
  - Config validation → composition/DI registration → cross-cutting setup (logging/metrics) → feature routes/providers mounting.
- Specify readiness/health checks as applicable to the shell (e.g., feature readiness signals).
- Define cleanup procedures:
  - Unsubscribe listeners, dispose stores, flush pending telemetry on unmount/navigation.

---

### 13. Change Management and Versioning

- Define how breaking changes are introduced:
  - Version contracts (interfaces/DTOs), provide migration notes, and maintain backward compatibility within a grace period.
- Require synchronous updates to this document and the feature’s public API surface when contracts change.

---

**Note:**  
Apply this structure to every frontend feature or micro-frontend. Keep the code and this guide aligned to preserve separation of concerns, testability, and maintainability across layers.
