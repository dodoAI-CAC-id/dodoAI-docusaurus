---
id: controller-dev-unittest
title: Phát Triển Bộ Điều Khiển & Kiểm Thử Đơn Vị
---

## Hướng Dẫn

Viết chương trình cho Bộ điều khiển và Kiểm thử đơn vị của nó.

## Tổng Quan

Phát triển Bộ điều khiển liên quan đến việc tạo các thành phần xử lý vòng đời yêu cầu-phản hồi trong các ứng dụng phía máy chủ.

## Mục Tiêu

Đảm bảo Bộ điều khiển phù hợp với các đặc tả được nêu trong tài liệu Thiết kế API và Swagger.

## Ví Dụ

**Lưu Ý: Các ví dụ sau được cung cấp để định dạng. Tùy chỉnh nội dung theo các đặc tả của thiết kế Bộ điều khiển của bạn.**

### Ví Dụ Bộ Điều Khiển (Node.js Với Express)

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

### Kiểm Thử Đơn Vị Cho Bộ Điều Khiển (Sử Dụng Jest)

```javascript
const request = require('supertest');
const app = require('../app');
const taskService = require('../services/taskService');

// Giả lập hàm updateTask của taskService
taskService.updateTask = jest.fn((task_id, taskData) => Promise.resolve({ ...taskData, task_id }));

describe('PUT /tasks/:task_id', () => {
  it('nên cập nhật nhiệm vụ và trả về đối tượng nhiệm vụ đã cập nhật', async () => {
    const taskData = { title: 'Updated Task', description: 'Updated Description' };
    const taskId = '1';
    
    const response = await request(app)
      .put(`/tasks/${taskId}`)
      .send(taskData);
    
    expect(response.statusCode).toBe(200);
    expect(response.body).toEqual(expect.objectContaining(taskData));
    expect(taskService.updateTask).toHaveBeenCalledWith(taskId, taskData);
  });

  // Thêm nhiều kiểm thử cho các kịch bản khác nhau (ví dụ: nhiệm vụ không tìm thấy, lỗi xác thực)
});
```
