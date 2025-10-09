---
id: switch-swagger-to-api
title: Swagger から API への切り替え (一つずつ)
---

## Swagger から API への切り替え (一つずつ)

## 指示 (Instruction)
Swagger のモックサーバーから公式のコントローラーへルーティングを変更する。

## 概要 (Overview)
フロントエンドが公式 API と通信できるようにルーティングを変更する。

## 目的 (Goals)
開発済みの各 API について、Swagger のモックサーバーから実装済みの Controller、Service、Model へルーティングを切り替える。

## サンプル (Sample)
**注意: 以下のサンプルはテンプレートとして提供されています。Swagger のモックサーバーから公式のコントローラーに切り替えるようにコードを更新してください。**

### Node.js のルート設定ファイルの例
Node.js のルーティングファイルにて、Swagger のモックサーバーへのアクセスをコメントアウトし、公式の Controller ルートに切り替える。

```javascript
const express = require('express');
const router = express.Router();

// 開発済みのコントローラーをインポート
const taskController = require('./controllers/taskController');
// const swaggerMockController = require('./controllers/swaggerMockController'); // Swagger 用のモックコントローラー

// API ルート
router.put('/tasks/:task_id', taskController.update); // 公式のコントローラーに切り替え
// router.put('/tasks/:task_id', swaggerMockController.update); // Swagger Mock - 切り替え後にコメントアウト

// ...その他の API ルート...

module.exports = router;
```