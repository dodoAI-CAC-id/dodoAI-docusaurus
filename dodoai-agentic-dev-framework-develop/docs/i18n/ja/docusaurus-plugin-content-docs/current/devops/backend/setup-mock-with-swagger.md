---
id: setup-mock-with-swagger
title: Swaggerを用いたモックのセットアップ
---

## Swaggerを用いたモックのセットアップ

## 手順
Swaggerモックライブラリ（例：Node.js Express）を使用して、Swagger定義に基づいたモックサーバーを作成します。

## 概要
実際のバックエンドAPIが存在しない場合でもフロントエンド開発を進行させるために、Swaggerモックサーバーを開発します。

## 目標
- フロントエンドの統合テストのためにバックエンドAPIのレスポンスをシミュレートする。
- フロントエンドとバックエンドの開発を並行して進めることを促進する。

## 主なポイント
- Swagger定義ファイルを使用して、期待されるAPIレスポンスを概説します。
- dodo lowcodeまたは同様の既存のモックサーバー展開サービスが利用可能な場合、それを活用してプロセスを簡素化します。

## サンプル
**注:** 以下のサンプルは、モックサーバー環境を設定するためのテンプレートとして提供されています。具体的なSwagger API定義に応じて内容をカスタマイズしてください。

```javascript
// Expressとswagger-ui-expressを使用したモックサーバーの例

const express = require('express');
const swaggerUi = require('swagger-ui-express');
const YAML = require('yamljs');

const app = express();
const swaggerDocument = YAML.load('./path/to/your/swagger.yaml');

app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));

// Swagger定義に基づくエンドポイントの動作を定義する
app.get('/api/<endpoint>', (req, res) => {
  // Swaggerで定義されたモックデータを使って応答する
  res.json({ message: 'This is a mocked response' });
});

// 他のエンドポイント...

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Mock server running on port ${PORT}`);
});
```