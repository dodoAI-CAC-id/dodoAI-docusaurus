---
id: testing-strategy-and-structure
title: Testing Strategy and Structure
---

# 11. Testing Strategy and Structure

This chapter clearly defines testing strategy in Modular Onion Architecture. Design tests at appropriate granularity from unit tests to integration tests by responsibility to achieve both quality and development efficiency.

## 11.1 Test Types and Purposes

| Test Type | Target | Main Purpose |
|-----------|--------|--------------|
| Unit Test | UseCase, Repository | Logic accuracy, individual verification |
| Bloc Test | Bloc | Event and state transition confirmation |
| Widget Test | UI Components | Rendering, event response confirmation |
| Integration Test | App-wide main flows | Operation confirmation including communication and screen transitions |

## 11.2 Test Directory Structure

Reproduce the same structure as production code under `test/`.

```
test/
├── core/
├── features/
│   └── post/
│       ├── application/
│       ├── domain/
│       ├── infrastructure/
│       └── presentation/
│           ├── blocs/
│           └── widgets/
└── shared/
```

* Unify file names to `{target_file_name}_test.dart`
* By utilizing the modularly separated structure as-is, independent tests by responsibility become possible

## 11.3 Bloc Test Example

```dart
test('should emit Loaded when usecase returns data', () async {
  when(() => mockUseCase()).thenAnswer((_) async => Right(sampleData));

  blocTest<HomeBloc, HomeState>(
    'emits [Loading, Loaded] when LoadHomeEvent is added',
    build: () => HomeBloc(mockUseCase),
    act: (bloc) => bloc.add(LoadHomeEvent()),
    expect: () => [HomeLoadingState(), HomeLoadedState(sampleData)],
  );
});
```

## 11.4 Widget Test Example

```dart
testWidgets('displays user name when loaded', (tester) async {
  final bloc = MockHomeBloc();
  whenListen(bloc, Stream.fromIterable([
    HomeLoadedState(user: User(name: 'Taro'))
  ]));

  await tester.pumpWidget(
    BlocProvider.value(
      value: bloc,
      child: HomePage(),
    ),
  );

  expect(find.text('Taro'), findsOneWidget);
});
```

## 11.5 Execution and CI Integration

* Keep all tests executable locally with `flutter test` command
* Automatic execution in CI like GitHub Actions or Bitrise during PR
* Block merge if failed tests exist to ensure quality

## 11.6 Test Design Rules

* Replace external dependencies with mocks (GraphQLClient, etc.)
* Focus on "input → output" with functional thinking for UseCase and Bloc state transitions
* Always update test code when specifications change (tests become specification documentation)
