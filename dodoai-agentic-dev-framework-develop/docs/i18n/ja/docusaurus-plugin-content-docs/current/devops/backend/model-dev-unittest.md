---
id: model-dev-unittest
title: モデル開発とユニットテスト
---

## 手順
モデルとそのユニットテストのプログラムを作成してください。

## 概要
システムのデータおよびビジネスロジックを正確に表現するモデルを作成し、信頼性の高いユニットテストを開発することに焦点を当てます。

## 目標
- API設計とSwagger仕様に整合したモデルを開発する。
- モデルが物理データモデルを反映し、データベーススキーマを含むことを確認する。
- モデルの機能性と完全性を検証するための対応するユニットテストを作成する。

## サンプル
**注:** 以下のサンプルコードをテンプレートとして活用し、モデル設計やテストのニーズに合わせて詳細を調整してください。


### スキーマサンプルコード
```javascript
// ExampleSchema.js
const mongoose = require('mongoose');

const exampleSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
    trim: true
  },
  status: {
    type: String,
    required: true,
    enum: ['active', 'completed', 'archived']
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
  // 物理データモデルで定義された追加フィールドとバリデーションルール
});

module.exports = mongoose.model('Example', exampleSchema);
```

### モデルのサンプル (Model Sample)
```javascript
// ExampleModel.js (Assuming a Node.js environment)
const mongoose = require('mongoose');

const ExampleSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true
  },
  description: {
    type: String
  }
  // Define additional fields based on your physical data model
});

const ExampleModel = mongoose.model('Example', ExampleSchema);

module.exports = ExampleModel;
```

### モデルのユニットテスト (Unit Test for Model)
```javascript
// ExampleModel.test.js
const chai = require('chai');
const expect = chai.expect;
const ExampleModel = require('../models/ExampleModel');

describe('ExampleModel', () => {
  it('should be invalid if name is empty', (done) => {
    const m = new ExampleModel();

    m.validate((err) => {
      expect(err.errors.name).to.exist;
      done();
    });
  });

  // Additional unit tests to cover other scenarios
});
```