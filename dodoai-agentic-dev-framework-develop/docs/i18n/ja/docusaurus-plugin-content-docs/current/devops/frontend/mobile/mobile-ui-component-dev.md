---
id: mobile-ui-component-dev
title: モバイル UI コンポーネント開発
---

## モバイル UI コンポーネント開発

## 概要

### iOS

![iOS コンポーネント](../../../../assets/ios-component.png)

- `ViewController` 内の UI 要素を 1 つの単位として扱う。
- コンポーネントの Xib ファイルおよび Swift ファイルは手動で作成する。
- コンポーネントの例: カスタム `UIView` など。
- コンポーネント内の UI 要素をコードで生成する必要がある場合、SS を使用してコードを生成する。
  - 例: 複雑なグラデーション

### Android

![Android コンポーネント](../../../../assets/android-component.png)

- レイアウト XML とそれに対応する Fragment を Atomic Design における Organisms 以下の単位として扱う。
- レイアウト XML および Fragment は手動で作成する（SS ツールは不要）。
- コンポーネント内の UI 要素をコードで生成する必要がある場合、SS を使用してコードを生成する。
  - 例: 複雑なグラデーション

**注意:** `nav_graph.xml` によるナビゲーションの遷移は手動で作成すること。
