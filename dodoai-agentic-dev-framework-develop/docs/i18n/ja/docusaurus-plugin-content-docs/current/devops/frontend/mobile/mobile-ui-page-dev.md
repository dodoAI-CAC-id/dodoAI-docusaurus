---
id: mobile-ui-page-dev
title: モバイル UI ページ開発（UI デザインではない）
---

## モバイル UI ページ開発（UI デザインではない）

## 概要

### iOS

![iOS View Controller](../../../../assets/ios-view-controller.png)

- 各 `ViewController` を 1 つのページ単位として扱う。
- `ViewController` の Xib ファイルおよび Swift ファイルは手動で作成する（SS ツールは不要）。

### Android

- Atomic Design における最上位の概念（ページ）に相当するレイアウト XML と、それに対応する Fragment を 1 つの単位として扱う。
- 各ページは Organism 以下のコンポーネントをコンテナとしてまとめる役割を持つ。
- レイアウト XML および Fragment の作成は手動で行う（SS ツールは不要）。
