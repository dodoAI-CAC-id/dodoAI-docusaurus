---
id: molecules-ui-component-library
title: Molecules UI Component Library
---

# Molecules UI Component Library

## Overview

Develop and manage UI components (Molecules) that combine multiple Atoms based on Atomic Design.
For Flutter implementation, components must be added to WidgetBook and Unit Tests are mandatory.

## Atomic Design - Molecules

Molecules are components with more complex functionality created by combining multiple Atoms.

### Target Component Examples

- **Search Box**: Input field + Search button
- **Form Field**: Label + Input field + Error message
- **Card Header**: Title + Action button
- **Navigation Item**: Icon + Text label
- **Alert**: Icon + Message + Close button
- **Pagination**: Previous button + Page numbers + Next button
- **Rating**: Star icons × 5 + Rating text
- **Tag**: Label + Delete button

## Development Guidelines

### 1. Component Design Principles

- **Atoms Combination**: Utilize existing Atoms components
- **Functional Cohesion**: Meaningful units that group related functionality
- **State Management**: Properly manage internal state
- **Event Handling**: Integrate events from child components

### 2. Flutter Implementation Requirements

#### WidgetBook Integration
```dart
// WidgetBook registration example
@WidgetbookUseCase(name: 'Search Box', type: MoleculeSearchBox)
Widget searchBoxUseCase(BuildContext context) {
  return MoleculeSearchBox(
    placeholder: context.knobs.string(
      label: 'Placeholder', 
      initialValue: 'Search...'
    ),
    onSearch: (query) => print('Search: $query'),
    showClearButton: context.knobs.boolean(
      label: 'Show Clear Button', 
      initialValue: true
    ),
  );
}
```

#### Unit Test Implementation
```dart
// Unit Test example
group('MoleculeSearchBox', () {
  testWidgets('should display placeholder text', (WidgetTester tester) async {
    const placeholder = 'Search products...';
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MoleculeSearchBox(
            placeholder: placeholder,
            onSearch: (_) {},
          ),
        ),
      ),
    );
    
    expect(find.text(placeholder), findsOneWidget);
  });
  
  testWidgets('should call onSearch when search button is pressed', 
    (WidgetTester tester) async {
    String? searchQuery;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MoleculeSearchBox(
            onSearch: (query) => searchQuery = query,
          ),
        ),
      ),
    );
    
    await tester.enterText(find.byType(TextField), 'test query');
    await tester.tap(find.byIcon(Icons.search));
    
    expect(searchQuery, equals('test query'));
  });
  
  testWidgets('should clear input when clear button is pressed', 
    (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MoleculeSearchBox(
            onSearch: (_) {},
            showClearButton: true,
          ),
        ),
      ),
    );
    
    await tester.enterText(find.byType(TextField), 'test');
    await tester.tap(find.byIcon(Icons.clear));
    
    expect(find.text('test'), findsNothing);
  });
});
```

### 3. Directory Structure

```
lib/
├── presentation/
│   ├── components/
│   │   ├── molecules/
│   │   │   ├── search_box/
│   │   │   │   ├── molecule_search_box.dart
│   │   │   │   └── molecule_search_box_test.dart
│   │   │   ├── form_field/
│   │   │   │   ├── molecule_form_field.dart
│   │   │   │   └── molecule_form_field_test.dart
│   │   │   └── ...
```

### 4. Implementation Patterns

#### State Management Pattern
```dart
class MoleculeFormField extends StatefulWidget {
  final String label;
  final String? initialValue;
  final String? errorMessage;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  
  const MoleculeFormField({
    Key? key,
    required this.label,
    this.initialValue,
    this.errorMessage,
    this.onChanged,
    this.validator,
  }) : super(key: key);
  
  @override
  State<MoleculeFormField> createState() => _MoleculeFormFieldState();
}

class _MoleculeFormFieldState extends State<MoleculeFormField> {
  late TextEditingController _controller;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _errorMessage = widget.errorMessage;
  }
  
  void _validateInput(String value) {
    if (widget.validator != null) {
      setState(() {
        _errorMessage = widget.validator!(value);
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AtomLabel(text: widget.label),
        const SizedBox(height: 8),
        AtomInput(
          controller: _controller,
          onChanged: (value) {
            _validateInput(value);
            widget.onChanged?.call(value);
          },
          hasError: _errorMessage != null,
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 4),
          AtomErrorMessage(message: _errorMessage!),
        ],
      ],
    );
  }
}
```

### 5. Quality Assurance

#### Required Test Items
- **Component Integration Test**: Verify proper integration with Atoms
- **State Management Test**: Verify internal state changes are handled correctly
- **Event Propagation Test**: Verify child component events are handled properly
- **Validation Test**: Verify input validation works correctly

#### WidgetBook Verification Items
- **Interaction**: Verify user interaction behavior
- **State Changes**: Verify display in each state
- **Error States**: Verify display during errors
- **Responsive**: Verify behavior on different screen sizes

## Implementation Flow

1. **Requirements Definition**: Clarify Atoms to combine and functional requirements
2. **Design**: Design component API and properties
3. **Implementation**: Develop components in Flutter
4. **Testing**: Create and execute Unit Tests
5. **WidgetBook Registration**: Register in storybook
6. **Integration Testing**: Verify integration with other components
7. **Documentation**: Create usage and API documentation

## Important Notes

- Maximize utilization of existing Atoms components
- Maintain appropriate granularity to avoid excessive complexity
- All Molecules components must implement Unit Tests
- Register in WidgetBook to enable visual verification
- Implement with performance and memory usage considerations in mind
