---
id: atoms-ui-component-library
title: Atoms UI Component Library
---

# Atoms UI Component Library

## Overview

Develop and manage the smallest unit of UI components (Atoms) based on Atomic Design.
For Flutter implementation, components must be added to WidgetBook and Unit Tests are mandatory.

## Atomic Design - Atoms

Atoms are the most basic UI components that cannot be broken down further into smaller elements.

### Target Component Examples

- **Button**: Basic button component
- **Input**: Text input field
- **Label**: Text label
- **Icon**: Icon component
- **Image**: Image display component
- **Divider**: Separator line
- **Checkbox**: Checkbox
- **Radio Button**: Radio button
- **Switch**: Switch/Toggle

## Development Guidelines

### 1. Component Design Principles

- **Single Responsibility**: Each component should have only one function
- **Reusability**: Design components to be generic and reusable in various contexts
- **Consistency**: Styling that adheres to the design system
- **Accessibility**: Proper semantics and accessibility support

### 2. Flutter Implementation Requirements

#### WidgetBook Integration
```dart
// WidgetBook registration example
@WidgetbookUseCase(name: 'Primary Button', type: AtomButton)
Widget primaryButtonUseCase(BuildContext context) {
  return AtomButton(
    text: context.knobs.string(label: 'Text', initialValue: 'Button'),
    onPressed: () {},
    variant: ButtonVariant.primary,
  );
}
```

#### Unit Test Implementation
```dart
// Unit Test example
group('AtomButton', () {
  testWidgets('should display text correctly', (WidgetTester tester) async {
    const buttonText = 'Test Button';
    
    await tester.pumpWidget(
      MaterialApp(
        home: AtomButton(
          text: buttonText,
          onPressed: () {},
        ),
      ),
    );
    
    expect(find.text(buttonText), findsOneWidget);
  });
  
  testWidgets('should call onPressed when tapped', (WidgetTester tester) async {
    bool wasPressed = false;
    
    await tester.pumpWidget(
      MaterialApp(
        home: AtomButton(
          text: 'Test',
          onPressed: () => wasPressed = true,
        ),
      ),
    );
    
    await tester.tap(find.byType(AtomButton));
    expect(wasPressed, isTrue);
  });
});
```

### 3. Directory Structure

```
lib/
├── presentation/
│   ├── components/
│   │   ├── atoms/
│   │   │   ├── button/
│   │   │   │   ├── atom_button.dart
│   │   │   │   └── atom_button_test.dart
│   │   │   ├── input/
│   │   │   │   ├── atom_input.dart
│   │   │   │   └── atom_input_test.dart
│   │   │   └── ...
```

### 4. Quality Assurance

#### Required Test Items
- **Display Test**: Verify components render correctly
- **Interaction Test**: Verify user interactions work properly
- **Property Test**: Verify each property is reflected correctly
- **Error Handling Test**: Verify behavior with invalid values

#### WidgetBook Verification Items
- **All Variations**: Verify display of all style variations
- **Responsive**: Verify display on different screen sizes
- **State Changes**: Verify states like enabled/disabled, selected/unselected

## Implementation Flow

1. **Design**: Define component specifications based on design system
2. **Implementation**: Develop components in Flutter
3. **Testing**: Create and execute Unit Tests
4. **WidgetBook Registration**: Register in storybook
5. **Review**: Code review and quality verification
6. **Documentation**: Create usage and API documentation

## Important Notes

- All Atoms components must implement Unit Tests
- Register in WidgetBook to enable visual verification
- Always verify consistency with the design system
- Implement with performance considerations in mind
