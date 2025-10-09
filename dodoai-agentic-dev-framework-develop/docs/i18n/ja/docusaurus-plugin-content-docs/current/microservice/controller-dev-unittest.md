---
id: controller-dev-unittest
title: コントローラー開発 & ユニットテスト (Controller Dev & Unit Test)
---

## 指示 (Instruction)
コントローラーとそのユニットテストのプログラムを作成してください。

## 概要 (Overview)
コントローラーの開発では、サーバーサイドアプリケーションのリクエスト-レスポンスのライフサイクルを処理するコンポーネントを作成します。

## 目的 (Goals)
コントローラーが API 設計および Swagger ドキュメントで定義された仕様に適合していることを確認する。

## サンプル (Sample)
**注意: 以下の例はフォーマットの参考用です。コントローラーの設計仕様に合わせて内容をカスタマイズしてください。**

### コントローラーのサンプル (Node.js + Express)
```javascript
const express = require('express');
const router = express.Router();
const taskService = require('../services/taskService');

router.put('/tasks/:task_id', async (req, res) => {
  try {
    const { task_id } = req.params;
    const taskData = req.body;
    const updatedTask = await taskService.updateTask(task_id, taskData);
    res.status(200).json(updatedTask);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
```

### コントローラーのユニットテスト (Jest 使用)
```javascript
const request = require('supertest');
const app = require('../app');
const taskService = require('../services/taskService');

// taskService の updateTask 関数をモック
taskService.updateTask = jest.fn((task_id, taskData) => Promise.resolve({ ...taskData, task_id }));

describe('PUT /tasks/:task_id', () => {
  it('タスクを更新し、更新されたタスクオブジェクトを返すべき', async () => {
    const taskData = { title: 'Updated Task', description: 'Updated Description' };
    const taskId = '1';
    
    const response = await request(app)
      .put(`/tasks/${taskId}`)
      .send(taskData);
    
    expect(response.statusCode).toBe(200);
    expect(response.body).toEqual(expect.objectContaining(taskData));
    expect(taskService.updateTask).toHaveBeenCalledWith(taskId, taskData);
  });

  // その他のシナリオ（例：タスクが見つからない、バリデーションエラー）のテストを追加
});
```
