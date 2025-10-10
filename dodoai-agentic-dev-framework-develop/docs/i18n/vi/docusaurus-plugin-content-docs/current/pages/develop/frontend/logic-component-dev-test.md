---
id: logic-component-dev-test
title: Phát Triển & Kiểm Thử Đơn Vị Thành Phần Logic
---

## Hướng Dẫn

Tạo các thành phần logic nghiệp vụ và kiểm thử đơn vị tương ứng.

## Tổng Quan

Phát triển các thành phần logic phía giao diện người dùng xử lý giao tiếp API, xử lý nội bộ, quản lý trạng thái cục bộ và logic nghiệp vụ.

## Mục Tiêu

Đáp ứng các yêu cầu được đặt ra bởi Thiết Kế Thành Phần Giao Diện Người Dùng.

## Điểm Quan Trọng

- Loại bỏ hành vi giao diện người dùng khỏi các thành phần logic.
- Giữ cho các phương thức nhỏ để dễ dàng kiểm thử.
- Cô lập giao tiếp API vào các phương thức riêng biệt.

## Ví Dụ

**Lưu Ý: Ví dụ sau đây là một hướng dẫn. Tùy chỉnh theo nhu cầu thành phần logic Flutter và kiểm thử của bạn.**

### Ví Dụ Thành Phần Logic Flutter

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
      throw Exception('Failed to load tasks');
    }
  }

  Future<bool> updateTaskStatus(String taskId, String status) async {
    var response = await _apiService.updateTask(taskId, status);

    return response.statusCode == 200;
  }

  // Các phương thức logic nghiệp vụ khác...
}
```

### Ví Dụ Kiểm Thử Đơn Vị Thành Phần Logic Flutter

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

  test('fetchTasks trả về một danh sách các nhiệm vụ nếu cuộc gọi HTTP hoàn tất thành công', () async {
    when(mockApiService.getTasks()).thenAnswer((_) async => http.Response('{"tasks": []}', 200));

    expect(await taskManager.fetchTasks(), isA<List<Task>>());
  });

  test('updateTaskStatus trả về true nếu cập nhật trạng thái nhiệm vụ thành công', () async {
    when(mockApiService.updateTask(any, any)).thenAnswer((_) async => http.Response('', 200));

    expect(await taskManager.updateTaskStatus('1', 'completed'), true);
  });

  // Nhiều kiểm thử đơn vị khác...
});
```
