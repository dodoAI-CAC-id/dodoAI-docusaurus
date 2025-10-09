---
id: service-dev-unittest
title: サービス開発 & ユニットテスト (Service Dev & Unit Test)
---

## 指示 (Instruction)
サービスとその対応するユニットテストを開発してください。

## 概要 (Overview)
サービス層の開発は、アプリケーションのビジネスロジックを実装することに焦点を当て、コントローラーからデータアクセスやデータ操作のコードを分離します。

## 目的 (Goals)
API 設計および Swagger 仕様で定義されたビジネスロジック要件を満たすサービスを作成すること。

## サンプル (Sample)
**注意: 以下のコードサンプルは参考用の例です。フォーマットをガイドとして使用し、サービス設計の要件に合わせて内容を修正してください。**

### サービスのサンプル (Node.js)
```javascript
// taskService.js
const dataAccess = require('./dataAccess'); // データアクセス層の抽象化

const updateTask = async (task_id, taskData) => {
  // タスクを更新するためのビジネスロジック
  const existingTask = await dataAccess.getTaskById(task_id);
  if (!existingTask) throw new Error('Task not found.');

  // 受信したタスクデータをバリデーション...

  const updatedTask = await dataAccess.updateTask(task_id, taskData);
  return updatedTask;
};

module.exports = {
  updateTask,
};
```

#### サービスのユニットテスト (Jest 使用)
```javascript
// taskService.test.js
const taskService = require('../services/taskService');
const dataAccess = require('../services/dataAccess');

jest.mock('../services/dataAccess');

describe('updateTask', () => {
  it('dataAccess.updateTask を呼び出し、更新されたタスクを返すべき', async () => {
    const task_id = '1';
    const taskData = { title: 'Updated Task Title' };
    const expectedTask = { ...taskData, task_id };

    dataAccess.getTaskById.mockResolvedValue({ task_id });
    dataAccess.updateTask.mockResolvedValue(expectedTask);

    const result = await taskService.updateTask(task_id, taskData);
    
    expect(dataAccess.getTaskById).toHaveBeenCalledWith(task_id);
    expect(dataAccess.updateTask).toHaveBeenCalledWith(task_id, taskData);
    expect(result).toEqual(expectedTask);
  });

  // タスクが見つからない場合やバリデーションエラーのテストを追加
});
```