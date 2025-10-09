---
id: service-dev-unittest
title: Phát Triển Dịch Vụ & Kiểm Thử Đơn Vị
---

## Hướng Dẫn

Phát triển Dịch vụ và kiểm thử đơn vị tương ứng.

## Tổng Quan

Phát triển lớp dịch vụ tập trung vào việc triển khai logic nghiệp vụ của ứng dụng, tách biệt mã liên quan đến truy cập và thao tác dữ liệu khỏi Bộ điều khiển.

## Mục Tiêu

Tạo các dịch vụ đáp ứng yêu cầu logic nghiệp vụ được quy định bởi thiết kế API và các đặc tả trong Swagger.

## Ví Dụ

**Lưu Ý: Các mẫu mã dưới đây chỉ mang tính chất minh họa. Sử dụng các định dạng này như một hướng dẫn và điều chỉnh nội dung theo yêu cầu thiết kế dịch vụ cụ thể của bạn.**

### Ví Dụ Dịch Vụ (Node.js)

```javascript
// taskService.js
const dataAccess = require('./dataAccess'); // Lớp trừu tượng truy cập dữ liệu

const updateTask = async (task_id, taskData) => {
  // Logic nghiệp vụ để cập nhật nhiệm vụ
  const existingTask = await dataAccess.getTaskById(task_id);
  if (!existingTask) throw new Error('Không tìm thấy nhiệm vụ.');

  // Xác thực dữ liệu nhiệm vụ đầu vào...

  const updatedTask = await dataAccess.updateTask(task_id, taskData);
  return updatedTask;
};

module.exports = {
  updateTask,
};
```

### Kiểm Thử Đơn Vị Cho Dịch Vụ (Sử Dụng Jest)

```javascript
// taskService.test.js
const taskService = require('../services/taskService');
const dataAccess = require('../services/dataAccess');

jest.mock('../services/dataAccess');

describe('updateTask', () => {
  it('nên gọi dataAccess.updateTask và trả về nhiệm vụ đã cập nhật', async () => {
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

  // Thêm nhiều kiểm thử cho các kịch bản như nhiệm vụ không tìm thấy hoặc lỗi xác thực
});
```
