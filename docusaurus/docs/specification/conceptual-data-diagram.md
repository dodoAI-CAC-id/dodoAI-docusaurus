---
id: conceptual-data-diagram
title: Conceptual Data Diagram
---

# Conceptual Data Diagram

## Overview

This document presents the conceptual data model for the dodo AI system, illustrating the key entities, their attributes, and relationships that form the foundation of the system's data architecture.

## Core Entities

### User Management Domain

#### User
- **Attributes:**
  - user_id (Primary Key)
  - email (Unique)
  - username (Unique)
  - first_name
  - last_name
  - password_hash
  - created_at
  - updated_at
  - last_login
  - is_active
  - email_verified

#### Role
- **Attributes:**
  - role_id (Primary Key)
  - role_name (Unique)
  - description
  - permissions
  - created_at
  - updated_at

#### UserRole
- **Attributes:**
  - user_id (Foreign Key)
  - role_id (Foreign Key)
  - assigned_at
  - assigned_by

### Project Management Domain

#### Organization
- **Attributes:**
  - organization_id (Primary Key)
  - name
  - description
  - settings
  - created_at
  - updated_at

#### Project
- **Attributes:**
  - project_id (Primary Key)
  - organization_id (Foreign Key)
  - name
  - description
  - status
  - created_by (Foreign Key to User)
  - created_at
  - updated_at
  - settings
  - repository_url

#### ProjectMember
- **Attributes:**
  - project_id (Foreign Key)
  - user_id (Foreign Key)
  - role
  - joined_at
  - permissions

#### Task
- **Attributes:**
  - task_id (Primary Key)
  - project_id (Foreign Key)
  - title
  - description
  - status
  - priority
  - assigned_to (Foreign Key to User)
  - created_by (Foreign Key to User)
  - due_date
  - created_at
  - updated_at
  - estimated_hours
  - actual_hours

### Development Framework Domain

#### Template
- **Attributes:**
  - template_id (Primary Key)
  - name
  - description
  - category
  - version
  - content
  - created_by (Foreign Key to User)
  - created_at
  - updated_at
  - is_public
  - usage_count

#### Component
- **Attributes:**
  - component_id (Primary Key)
  - name
  - description
  - type
  - version
  - source_code
  - documentation
  - created_by (Foreign Key to User)
  - created_at
  - updated_at
  - dependencies

#### CodeGeneration
- **Attributes:**
  - generation_id (Primary Key)
  - user_id (Foreign Key)
  - project_id (Foreign Key)
  - prompt
  - generated_code
  - template_used (Foreign Key to Template)
  - created_at
  - feedback_rating
  - is_applied

### Testing and Quality Domain

#### TestSuite
- **Attributes:**
  - suite_id (Primary Key)
  - project_id (Foreign Key)
  - name
  - description
  - type
  - created_by (Foreign Key to User)
  - created_at
  - updated_at

#### TestCase
- **Attributes:**
  - case_id (Primary Key)
  - suite_id (Foreign Key)
  - name
  - description
  - test_steps
  - expected_result
  - status
  - created_at
  - updated_at

#### TestExecution
- **Attributes:**
  - execution_id (Primary Key)
  - case_id (Foreign Key)
  - project_id (Foreign Key)
  - executed_by (Foreign Key to User)
  - status
  - result
  - execution_time
  - error_message
  - executed_at

### Deployment and Operations Domain

#### Environment
- **Attributes:**
  - environment_id (Primary Key)
  - project_id (Foreign Key)
  - name
  - type
  - configuration
  - status
  - created_at
  - updated_at

#### Deployment
- **Attributes:**
  - deployment_id (Primary Key)
  - project_id (Foreign Key)
  - environment_id (Foreign Key)
  - version
  - status
  - deployed_by (Foreign Key to User)
  - deployed_at
  - rollback_id
  - configuration

#### Pipeline
- **Attributes:**
  - pipeline_id (Primary Key)
  - project_id (Foreign Key)
  - name
  - configuration
  - status
  - created_by (Foreign Key to User)
  - created_at
  - updated_at

### Analytics and Logging Domain

#### ActivityLog
- **Attributes:**
  - log_id (Primary Key)
  - user_id (Foreign Key)
  - project_id (Foreign Key)
  - action
  - entity_type
  - entity_id
  - details
  - ip_address
  - user_agent
  - created_at

#### Metric
- **Attributes:**
  - metric_id (Primary Key)
  - project_id (Foreign Key)
  - metric_name
  - metric_value
  - metric_type
  - recorded_at
  - metadata

#### Report
- **Attributes:**
  - report_id (Primary Key)
  - project_id (Foreign Key)
  - name
  - type
  - parameters
  - generated_by (Foreign Key to User)
  - generated_at
  - file_path

## Entity Relationships

### Primary Relationships

#### User-Centric Relationships
- User ←→ UserRole ←→ Role (Many-to-Many)
- User ←→ ProjectMember ←→ Project (Many-to-Many)
- User → Task (One-to-Many, assigned tasks)
- User → CodeGeneration (One-to-Many)
- User → Template (One-to-Many, created templates)

#### Project-Centric Relationships
- Organization → Project (One-to-Many)
- Project → Task (One-to-Many)
- Project → TestSuite (One-to-Many)
- Project → Environment (One-to-Many)
- Project → Deployment (One-to-Many)
- Project → Pipeline (One-to-Many)

#### Development Workflow Relationships
- Template → CodeGeneration (One-to-Many)
- Component → Template (Many-to-Many, dependencies)
- TestSuite → TestCase (One-to-Many)
- TestCase → TestExecution (One-to-Many)

#### Deployment Relationships
- Environment → Deployment (One-to-Many)
- Project → Pipeline → Deployment (Chain relationship)
- Deployment → Deployment (Self-referencing for rollbacks)

### Secondary Relationships

#### Audit and Tracking
- All entities → ActivityLog (Polymorphic relationship)
- Project → Metric (One-to-Many)
- Project → Report (One-to-Many)

#### Configuration and Settings
- Organization → Project (Configuration inheritance)
- Project → Environment (Configuration deployment)
- Pipeline → Deployment (Configuration application)

## Data Flow Patterns

### User Interaction Flow
1. User authentication and role assignment
2. Project access based on membership and roles
3. Task assignment and execution tracking
4. Code generation and template usage
5. Activity logging for all actions

### Development Workflow
1. Project creation and setup
2. Template and component selection
3. Code generation and customization
4. Testing and quality assurance
5. Deployment and monitoring

### Analytics and Reporting
1. Activity and metric collection
2. Data aggregation and analysis
3. Report generation and distribution
4. Performance monitoring and alerting

## Data Integrity Constraints

### Referential Integrity
- All foreign key relationships must be maintained
- Cascade delete rules for dependent entities
- Orphan record prevention mechanisms

### Business Rules
- User email uniqueness across the system
- Project name uniqueness within organizations
- Role permission validation
- Task assignment validation (project membership required)

### Data Validation
- Email format validation
- Password complexity requirements
- Date range validations
- Status value constraints

## Scalability Considerations

### Partitioning Strategies
- User data partitioned by organization
- Activity logs partitioned by date
- Metrics data partitioned by project and time

### Indexing Strategy
- Primary and foreign key indexes
- Search optimization indexes
- Performance monitoring indexes
- Audit trail indexes

### Archival Policies
- Historical data retention periods
- Automated archival processes
- Data purging strategies
- Backup and recovery procedures

This conceptual data diagram serves as the foundation for the physical database design and ensures data consistency, integrity, and optimal performance across the dodo AI system.
