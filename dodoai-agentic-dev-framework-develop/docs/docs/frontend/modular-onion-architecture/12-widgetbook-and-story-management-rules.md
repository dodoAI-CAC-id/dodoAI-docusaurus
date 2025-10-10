---
id: widgetbook-and-story-management-rules
title: Widgetbook and Story Management Rules
---

# 12. Widgetbook and Story Management Rules

To maintain quality and consistency of UI components adopting Atomic Design, we introduce component story management tools. This chapter describes rules for defining Story (usage examples) for each level component to prevent design and implementation discrepancies.

## Tool Selection by Framework

* **Flutter**: Use **Widgetbook** for component story management and visual testing
* **React**: Use **Storybook** for component story management and visual testing
* **Other frameworks**: Choose appropriate story management tools that support component isolation and visual testing

## 12.1 What is Widgetbook (Flutter Example)

* Storybook equivalent for Flutter applications
* Visually confirm each component's "state" and "variations"
* Useful for UI review, regression testing, and consensus building with designers

## 12.2 Story File Structure Example

```
lib/
└── widgetbook/
    ├── main.dart                  # Entry point
    └── stories/
        ├── atoms/
        │   ├── app_button.stories.dart
        │   └── spacing.stories.dart
        ├── molecules/
        └── organisms/
```

## 12.3 Story Definition Rules

* One file per Atom/Molecule/Organism
* Define multiple states (enabled/disabled, etc.) with WidgetbookUseCase

```dart
final appButtonStory = WidgetbookComponent(
  name: 'AppButton',
  useCases: [
    WidgetbookUseCase(name: 'default', builder: (_) => AppButton(label: 'Click Me')),
    WidgetbookUseCase(name: 'disabled', builder: (_) => AppButton(label: 'Click Me', disabled: true)),
  ],
);
```

## 12.4 Integration into Development Flow

* Create Story simultaneously when adding Component
* Review Story content with designers
* Include Widgetbook build in CI (optional)
* Always update corresponding Story when changes occur

This comprehensive documentation establishes the foundation for implementing Modular Onion Architecture in Flutter applications, ensuring consistency, maintainability, and scalability across development teams.
