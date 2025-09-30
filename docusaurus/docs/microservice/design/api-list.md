---
id: microservice-api-list
title: Microservice API List
---

# Guide: Defining a Microservice API List

- This guide focuses only on listing and documenting API endpoints corresponding to each microservice boundary.
- Your API list must be comprehensive and reflect the actual implementation.
- Use tables for clarity and consistency.

---

## What to Define

- List API endpoints for each microservice separately.
- For each endpoint, define the following columns:
    - **Method:** HTTP method (GET, POST, PUT, DELETE, etc.)
    - **Endpoint:** URL path (e.g., `/users`, `/orders/{orderId}`)
    - **Description:** Brief summary of the endpoint's function
    - **Auth Required:** Required authentication/authorization (e.g., None, User, Admin, System)

---

## Table Sample Format

### [Service Name] APIs

| Method | Endpoint                   | Description                  | Auth Required |
|--------|----------------------------|------------------------------|--------------|
| POST   | /auth/register             | Register a new user account  | No           |
| POST   | /auth/login                | Authenticate user credentials| No           |
| GET    | /users/me                  | Get current user profile     | Yes          |
| PUT    | /users/me                  | Update current user profile  | Yes          |

---

- Repeat this table structure for each microservice and business domain.
- If needed, add or adjust columns based on your development standards.

---

**Purpose:**  
Maintaining a clear, consistently structured API list for each microservice is essential for system integration, development productivity, and reliable maintenance.
