---
id: sequence-diagram
title: Sequence Diagram
---

## Instruction
Create Sequence Diagram(High Level) in Markdown according to the following format.


## Overview
Sequence Diagrams represent how objects and components interact within specific scenarios of a system.

## Goal
To illustrate high-level system sequences, capturing key external interactions and user-facing processes without delving into detailed internal mechanics.

**Remember: Customize the sequence diagram example below to represent your project's high-level system interactions accurately.**


## Sample Sequence Diagram
**The sample specified is for format use; the content should depict your system's high-level interactions.**

```mermaid
sequenceDiagram
    participant Client
    participant FirebaseAuth as "Firebase Authentication"
    participant APIServer as "API Server"
    participant AuthZService as "Authorization Service"

    %% Authentication Process
    Client ->> FirebaseAuth: Authenticate (email/password)
    FirebaseAuth ->> Client: Return JWT Token (id, email)

    %% API Request Process
    Client ->> APIServer: API Request with HTTP Header `Authorization: Bearer <JWT Token>`
    APIServer ->> AuthZService: Verify and Decode JWT Token
    AuthZService ->> AuthZService: Validate Token (signing, expiration, etc.)

    alt Token Valid
        AuthZService ->> AuthZService: Fetch User Roles and Permissions from DB
        AuthZService ->> APIServer: Return roles and permissions
        APIServer ->> Client: Provide Requested Data/Action
    else Token Invalid
        AuthZService ->> APIServer: Return Authorization Failure
        APIServer ->> Client: Access Denied
    end
```
