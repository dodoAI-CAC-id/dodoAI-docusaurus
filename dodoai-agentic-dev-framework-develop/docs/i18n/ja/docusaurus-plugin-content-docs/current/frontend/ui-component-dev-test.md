---
id: ui-component-dev-test
title: UI コンポーネント開発 & ユニットテスト
---

## 手順
対応する UI コンポーネントとそのユニットテストのプログラムを作成する。

## 概要
UI コンポーネントの開発とユニットテストの実施は、機能的で信頼性が高く、ユーザーフレンドリーなインターフェースを確保するために重要です。

## 目的
- 再利用可能で一貫性のある UI コンポーネントを構築する。
- ユニットテストを通じて、コンポーネントが意図したとおりに動作することを確認する。

## 重要なポイント
- UI コンポーネントのコードをクリーンで保守しやすい形で記述する。
- テスト駆動開発（TDD）アプローチを採用する。
- 適切なライブラリとフレームワークを使用して開発とテストを行う。

## サンプルコード
**注: 以下の例はあくまで参考です。自身の実装に合わせてカスタマイズしてください。**

### React.js のサンプルコード & ユニットテスト
```jsx
// SampleComponent.js
import React from 'react';

const SampleComponent = ({ text }) => {
  return <div>{text}</div>;
};

export default SampleComponent;
```

```jsx
// SampleComponent.test.js
import React from 'react';
import { render } from '@testing-library/react';
import SampleComponent from './SampleComponent';

test('SampleComponent を正しくレンダリングする', () => {
  const { getByText } = render(<SampleComponent text="Hello, World!" />);
  expect(getByText("Hello, World!")).toBeInTheDocument();
});
```

### Flutter のサンプルコード & ユニットテスト
```dart
// sample_widget.dart
import 'package:flutter/material.dart';

class SampleWidget extends StatelessWidget {
  final String text;

  SampleWidget({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(text));
  }
}
```

```dart
// sample_widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'sample_widget.dart';

void main() {
  testWidgets('SampleWidget にタイトルとメッセージが含まれているか確認', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SampleWidget(text: "Hello, World!")));
    final textFinder = find.text('Hello, World!');
    expect(textFinder, findsOneWidget);
  });
}
```