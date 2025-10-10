---
id: screen-design
title: Screen Design
---

# Guide: Screen Design Template

- Use this template to design any "List" screen (e.g., users, offices, orders) that supports search, navigation to detail, and pagination.
- Keep it technology-agnostic and focus on UI responsibilities, field definitions, behaviors, and API mappings—not backend implementation details or visual styling specifics.

---

## What to Define

1. Screen Overview
- Purpose and scope of the screen.
- Primary user roles and permissions.
- Entities/resources shown and the relationship to the signed-in user/org.
- Out-of-scope behaviors and constraints.

2. Layout and Navigation
- Wireframe reference or mock link.
- Major regions (search area, list/table, pagination, status bar).
- Entry points (routes, deep links) and exit/navigation targets (detail, create, back).

3. UI Component Catalog (Atomic Design)
- Catalog the components to be used and their abstraction level:
  - Atoms: basic building blocks (input, button, icon, label).
  - Molecules: small composed elements (search box, filter chip, breadcrumbs, pagination controls, error banner).
  - Organisms: complex, data-aware assemblies (data table/list, search + toolbar, empty-state panel).
  - Templates: page-level layout scaffolds (header/toolbar/content/footer).
  - Pages: concrete composition for this screen using the template.
- For each component, define:
  - Purpose and responsibilities.
  - Props/inputs and events/outputs (names, types, constraints).
  - Accessibility requirements (labels, roles, keyboard support).
  - Theming/responsiveness guidelines.
  - Reuse rules and variation strategy (e.g., variants, slots).

4. List Configuration
- Pagination policy (default page size, supported sizes, client vs server pagination).
- Sorting (default sort key/order, sortable columns, multi-sort rules if any).
- Filtering (search fields, filter chips, server-side vs client-side behavior).
- Visibility rules (which records are eligible to display).

5. UI Field Definitions
- For each input/output field specify:
  - Field name and type (text, select, date, etc.).
  - Direction (input/output).
  - API contract mapping (endpoint, param name, request/response shape).
  - Edit/display rules (read-only, clickable row, masking).
  - Constraints (length, pattern, min/max).
  - Default/initial value and required flags.
  - Accessibility labels and placeholders.

6. Pagination and Counters
- Counters and labels (e.g., "Showing X–Y of Z").
- Page indicator format (e.g., "P/N").
- Behavior on data changes (reset to page 1, preserve filters).

7. Events and Flows
- Event catalog: initial load, search/submit, row click (navigate), page change, refresh.
- For each event: trigger, preconditions, side effects, server interaction, success/failure paths.

8. Validation Rules
- Client-side validations for inputs (length, regex, required).
- Error message IDs/keys and copy rules.
- Validation control flow (stop on first error vs accumulate).

9. Error Handling and Empty States
- Error taxonomy and mapping to UI states (validation vs data fetch errors).
- User-facing messages, retry options, escalation.
- Loading, empty, success display patterns.

10. API Contracts
- Endpoints used (method, path, query/body schema).
- Required headers/auth.
- Response schema (fields used by the screen), error codes, and pagination model.

11. Accessibility and i18n
- Focus order, keyboard support, ARIA roles, labels.
- Localization keys for all static text and messages.
- Number/date formatting and RTL considerations if applicable.

12. Performance and Telemetry
- Performance targets (TTI, render time, max bundle size for the screen).
- Caching, debounce/throttle, request batching rules.
- Metrics and logs: events to track (search, paginate, navigate).

13. Testing
- Unit tests for view-model/presenter logic and validators.
- Component tests for key UI states (loading/error/empty/success).
- Integration tests with API stubs for list/search/pagination.
- E2E for core flows (load → search → navigate).

---

## Specification Template (Generic Entity List Screen)

Screen Overview
- Name: [Entity] List
- Purpose: Display and manage a list of [EntityPlural] associated with the signed-in user's organization.
- Capabilities:
  - Search by [EntityName] (partial match).
  - Navigate to [Entity] Detail.
  - Paginate through results.
- Primary Users: [PrimaryRole(s)]

Layout and Navigation
- Regions:
  - Search bar
  - [Entity] table/list
  - Pagination controls
  - Status/counter area
- Route: /[entity]/list
- Detail Route: /[entity]/[entityId]

UI Components to Use (Atomic Design)
- Atoms
  - TextInput: props value, onChange, maxLength, placeholder, aria-label.
  - Button: props label, onClick, variant, disabled, aria-label.
  - Icon: props name, decorative flag, aria-hidden/label.
  - Badge/Status: props text, tone, aria-label.
- Molecules
  - SearchBox: composed of TextInput + optional Button; props value, onChange, onSubmit, placeholder, maxLength.
  - FilterChip / ChipGroup: props chips[], onRemove, onClearAll, selectable.
  - Breadcrumbs: props items[], onNavigate, aria-label.
  - PaginationControls: props page, pageSize, total, onPageChange, onPageSizeChange; announce updates to SR.
  - ErrorBanner / Toast: props message, severity, onRetry.
  - LoadingSkeleton: props variant (table/list), rows, animated.
- Organisms
  - EntityDataTable (or List): props columns[], rows[], sort, onSortChange, onRowClick, selection?, emptyState.
  - SearchAndToolbar: wraps SearchBox, FilterChipGroup, action buttons; emits onSearch, onAction.
  - EmptyStatePanel: props title, description, action (optional).
- Templates
  - ListPageTemplate: header (title, breadcrumbs), toolbar (SearchAndToolbar), content (EntityDataTable), footer (PaginationControls, counters).
- Page (Concrete Composition)
  - [Entity]ListPage: composes ListPageTemplate with feature-specific props and handlers.

List Configuration
- Pagination: Enabled (default [PageSize] items/page; e.g., 20)
- Sorting: Default by [EntityId] ascending; sortable by [SortableColumns]
- Visibility: Only records within the user's organization/tenant

Field Definitions

Search Criteria
- Field: Search Box
  - Type: text
  - Direction: input
  - API: GET /api/[entity]
  - Param: search
  - Rules: free text, partial match on [EntityName]
  - Constraints: max length 100 (configurable)
  - Default: empty
  - Required: no
  - Placeholder: "Search by [EntityName]"

List Columns
- Field: [EntityName]
  - Type: text
  - Direction: output
  - Source: response.[entity_name]
  - Rules: read-only; row is clickable for navigation to detail
- Field: [SecondaryIdentifier] (e.g., Supply Point ID)
  - Type: text
  - Direction: output
  - Source: response.[secondary_id]
  - Rules: read-only

Pagination and Counters
- Total Count Display: "Showing [from]-[to] of [total]"
- Page Indicator: "[currentPage]/[totalPages]"
- Behavior: preserve current filters; reset page to 1 when search changes

Events

Event List
- Initial Load
  - Trigger: on screen mount
  - Server Call: yes (synchronous)
  - Outcome: render initial [Entity] list and pagination info
- Search
  - Trigger: Enter key in search box or Search button click
  - Server Call: yes (synchronous)
  - Outcome: filter [Entity] list by search keyword
- Row Click (Navigate to Detail)
  - Trigger: click on a row or name cell
  - Server Call: no
  - Outcome: navigate to detail with [entityId] as parameter
- Pagination
  - Trigger: pagination control interaction
  - Server Call: yes (synchronous)
  - Outcome: fetch and render requested page

Event Details

1) Initial Load
- Validation: none
- Steps:
  1. Obtain signed-in user's org/tenant context
  2. Verify access rights to [Entity] list
  3. Fetch [Entity] list for current context with default sort/pagination
  4. Render list and pagination counters

2) Search
- Validation
  - Rule: search keyword length `<=` 100
  - On error: show message and abort request
- Error Messages
  - validation.maxlength: "Please enter up to [max] characters."
  - error.data.fetch: "Failed to fetch data."
- Steps (if no validation errors)
  1. Execute search with keyword (partial match on [EntityName])
  2. Update list results
  3. Reset or update pagination as needed

3) Navigate to Detail
- Validation: none
- Steps
  1. Read [entityId] from clicked row
  2. Navigate to /[entity]/[entityId]

4) Pagination
- Validation: none
- Steps
  1. Fetch page [n] with current filters and sort
  2. Update list and counters

API Contracts

List Endpoint
- Method/Path: GET /api/[entity]
- Query Params:
  - search: string (optional)
  - page: number (1-based)
  - pageSize: number
  - sortBy: string
  - sortOrder: asc|desc
- Response:
  - items: `Array<{ entityId, entityName, secondaryId, ... }>`
  - total: number
  - page: number
  - pageSize: number
  - totalPages: number
- Errors: 400 (validation), 401/403 (auth), 500 (server)

Validation Rules
- search: max length 100; trim whitespace
- page/pageSize: positive integers; bounds-checked
- sortBy/sortOrder: must be allowed values

Error and Empty States
- Loading: skeleton or spinner in list area
- Empty: "No results found" with optional clear/reset
- Validation Error: inline field error
- Fetch Error: banner/toast with retry option

Accessibility and i18n
- Labels: all controls have accessible names
- Keyboard: tab order, Enter triggers search, pagination is keyboard operable
- Announcements: live region for list updates
- i18n: all strings use localization keys

Performance and Telemetry
- Debounce search input (e.g., 300–500ms) or require explicit submit
- Cache last result per query if applicable
- Track metrics: initial load success/failure, search submissions, pagination interactions, navigation to detail

Testing
- Unit: validators; view-model state transitions for each event
- Component: render loading/error/empty/success; row click navigates
- Integration: list/search/pagination with stubbed API
- E2E: load → search → paginate → navigate to detail flow

Notes
- Replace placeholders with concrete names (e.g., replace "[Entity]" with "Office", replace "[entityId]" with "officeId").
- Adjust constraints (lengths, page sizes) and error copy to match product standards.
