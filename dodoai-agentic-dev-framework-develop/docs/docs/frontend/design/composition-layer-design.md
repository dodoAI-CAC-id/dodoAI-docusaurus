---
id: composition-layer-design
title: Composition Layer Design
---

# Guide: Composition Layer Design

- Use this guide to explicitly define requirements for your composition layer (a.k.a. the "composition root" or bootstrap layer) in DDD, microservice, or modular architectures.
- Do not describe controller, service, or domain logic—focus only on wiring, dependency management, and bootstrapping.

---

## What to Define

### 1. Layer Responsibility

- Centralize all application-wide dependency registrations in a single composition root.
- Manage service instantiation, lifetime (singleton, transient, scoped), and explicit dependency graph creation.
- Configure cross-cutting concerns (logging, monitoring, config, security, caching, etc.).
- Handle application bootstrapping (startup, shutdown, health checks).

---

### 2. Dependency Injection and Service Registration

- Specify the dependency injection mechanism (container, framework, etc.) to be used.
- List all registration patterns:
  - Singleton, scoped, transient service patterns
  - Factory or provider registration for advanced/lazy cases
- Require explicit (not implicit) dependency mapping and avoid the service locator pattern.
- Document how new modules and services are added to the DI graph.

---

### 3. Module System

- Define the practice for:
  - Core, feature, and shared modules organizational structure
  - Registration of module dependencies in the root composition layer
  - Lazy-loaded or conditional module support (if needed)

---

### 4. Configuration Management

- Specify how environment-specific variables, feature toggles, and secrets are made available to the composition layer and injected dependencies.
- Require validation of configuration at startup; fail fast on misconfiguration.

---

### 5. Bootstrapping and Shutdown

- Define initialization sequence:
  - In what order services, modules, and listeners are started.
  - Registration and execution of health checks or readiness probes.
  - Graceful shutdown procedures for service teardown and cleanup.

---

**Note:**  
The composition layer must be a single, documented location for dependency and service graph construction.  
Keep this guide updated with changes in framework, dependency conventions, or architecture patterns.
