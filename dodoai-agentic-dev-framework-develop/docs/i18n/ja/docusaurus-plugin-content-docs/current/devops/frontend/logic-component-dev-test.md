---
id: logic-component-dev-test
title: ロジックコンポーネント開発 & ユニットテスト
---

## ロジックコンポーネント開発 & ユニットテスト

## 手順
ビジネスロジックコンポーネントと、それに対応するユニットテストを作成する。

## 概要
API 通信、内部処理、ローカル状態管理、ビジネスロジックを処理するフロントエンドのロジックコンポーネントを開発する。

## 目的
UI コンポーネント設計で定められた要件を満たす。

## 重要なポイント
- UI の振る舞いをロジックコンポーネントから除外する。
- メソッドはテストしやすいように小さくする。
- API 通信を専用のメソッドに分離する。

## サンプル
**注: 以下のサンプルはあくまでガイドラインです。Flutter のロジックコンポーネントとテストの要件に応じて適宜カスタマイズしてください。**

### Flutter ロジックコンポーネントのサンプル

```dart
// task_manager.dart
import 'package:flutter/material.dart';
import 'api_service.dart';

class TaskManager {
  final ApiService _apiService;
  
  TaskManager(this._apiService);

  Future<List<Task>> fetchTasks() async {
    var response = await _apiService.getTasks();
    
    if (response.statusCode == 200) {
      return Task.fromJsonList(response.data);
    } else {
      throw Exception('タスクの取得に失敗しました');
    }
  }

  Future<bool> updateTaskStatus(String taskId, String status) async {
    var response = await _apiService.updateTask(taskId, status);

    return response.statusCode == 200;
  }

  // その他のビジネスロジックメソッド...
}
```

### Flutter ロジックコンポーネントのユニットテストサンプル

```dart
// task_manager_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'task_manager.dart';
import 'api_service.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  MockApiService mockApiService;
  TaskManager taskManager;

  setUp(() {
    mockApiService = MockApiService();
    taskManager = TaskManager(mockApiService);
  });

  test('fetchTasks は HTTP 呼び出しが成功した場合、タスクのリストを返す', () async {
    when(mockApiService.getTasks()).thenAnswer((_) async => http.Response('{"tasks": []}', 200));

    expect(await taskManager.fetchTasks(), isA<List<Task>>());
  });

  test('updateTaskStatus はタスクの状態更新が成功した場合、true を返す', () async {
    when(mockApiService.updateTask(any, any)).thenAnswer((_) async => http.Response('', 200));

    expect(await taskManager.updateTaskStatus('1', 'completed'), true);
  });

  // その他のユニットテスト...
});
```