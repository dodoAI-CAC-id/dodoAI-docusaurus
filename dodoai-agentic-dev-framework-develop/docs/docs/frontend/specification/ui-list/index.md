---
id: ui-list
title: UI Component List
---

# Guide: UI Page List (Not a Component List)

- This document is a **UI Page List**, not a granular UI component list.
- The focus is on listing all user interface "pages" or templates your application provides, not individual buttons, fields, or widgets.
- Organize the list by page structure, page type, and template, following atomic design principles at the Page or Template level as appropriate.

---

## What to Define

- **List every distinct UI page or screen in the application.**
- For each page, include:
  - The page name (e.g., Home Page, User Profile).
  - Optional grouping by purpose (e.g., Auth Pages, Dashboard Pages, Error Pages).
  - Optional notes on the page template or primary components (e.g., uses Dashboard Template).
- Do **not** use this list to track atoms, molecules, or organism-level reusable components.

---

## Example: Application UI Page List

### Entry and Layout Pages
- Home Page
- Landing Page Template
- Dashboard Template

### User Pages
- User Profile
- Settings Page

### Forms and Data Entry Pages
- Login Form
- Registration Form
- Contact Form
- Search Form
- Form Page Template

### Data and Content Pages
- Content Page Template
- Data Table View
- List View
- Card Grid View
- Dashboard Widget Page

### Navigation Pages
- Navigation Bar (as part of page layout)
- Sidebar (if its own page)

### Error and Utility Pages
- Error Page (404)
- Error Page (500)

---

**Note:**  
For a true component inventory (atoms, molecules, organisms), maintain a separate UI Component List. This document is strictly for enumerating application-level pages and templates.
