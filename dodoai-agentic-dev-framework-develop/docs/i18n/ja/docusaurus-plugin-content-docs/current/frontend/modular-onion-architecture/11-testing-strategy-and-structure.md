---
id: testing-strategy-and-structure
title: テスト戦略と構造
---

# 11. テスト戦略と構造

この章では、モジュラーオニオンアーキテクチャにおけるテスト戦略を明確に定義します。責任別にユニットテストから統合テストまで適切な粒度でテストを設計し、品質と開発効率の両立を実現します。

## 11.1 テストタイプと目的

| テストタイプ | 対象 | 主な目的 |
|-----------|--------|--------------|
| ユニットテスト | UseCase、Repository | ロジック正確性、個別検証 |
| Blocテスト | Bloc | イベントと状態遷移確認 |
| Widgetテスト | UIコンポーネント | レンダリング、イベント応答確認 |
| 統合テスト | アプリ全体の主要フロー | 通信・画面遷移を含む動作確認 |

## 11.2 テストディレクトリ構造

`test/`下でプロダクションコードと同じ構造を再現します。

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

* ファイル名は`{target_file_name}_test.dart`に統一
* モジュール分離された構造をそのまま活用することで、責任別の独立したテストが可能

## 11.3 Blocテスト例

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

## 11.4 Widgetテスト例

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

## 11.5 実行とCI統合

* `flutter test`コマンドですべてのテストをローカル実行可能に保つ
* GitHub ActionsやBitriseなどのCIでPR時に自動実行
* テスト失敗がある場合はマージをブロックし、品質を確保

## 11.6 テスト設計ルール

* 外部依存はモック（GraphQLClientなど）で置き換え
* UseCaseとBloc状態遷移は「入力 → 出力」で機能的思考に集中
* 仕様変更時は必ずテストコードも更新（テストが仕様書ドキュメントになる）
