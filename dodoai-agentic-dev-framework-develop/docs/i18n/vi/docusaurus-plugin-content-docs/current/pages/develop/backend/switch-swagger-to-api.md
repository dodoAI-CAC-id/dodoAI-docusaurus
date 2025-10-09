---
id: switch-swagger-to-api
title: Chuyển Từ Swagger Sang API (Từng Bước)
---

## Hướng Dẫn

Thay đổi định tuyến từ máy chủ mô phỏng Swagger sang Bộ Điều Khiển chính thức.

## Tổng Quan

Sửa đổi định tuyến để cho phép giao tiếp với API chính thức từ giao diện người dùng.

## Mục Tiêu

Chuyển định tuyến từ máy chủ mô phỏng Swagger sang Bộ Điều Khiển, Dịch Vụ, và Mô Hình đã triển khai cho mỗi API đã được phát triển.

## Ví Dụ

**Lưu Ý: Mẫu dưới đây được cung cấp như một khuôn mẫu. Cập nhật mã để chuyển từ Swagger mô phỏng sang Bộ Điều Khiển chính thức đã triển khai.**

### Ví Dụ Về Tệp Route.js Trong Node.js

Trong tệp định tuyến của Node.js, ghi chú quyền truy cập vào máy chủ mô phỏng Swagger và chuyển sang các tuyến của Bộ Điều Khiển chính thức.

```javascript
const express = require('express');
const router = express.Router();

// Import các Bộ Điều Khiển đã phát triển
const taskController = require('./controllers/taskController');
// const swaggerMockController = require('./controllers/swaggerMockController'); // Bộ Điều Khiển Mô Phỏng cho Swagger

// Các tuyến API
router.put('/tasks/:task_id', taskController.update); // Đã chuyển sang Bộ Điều Khiển chính thức
// router.put('/tasks/:task_id', swaggerMockController.update); // Swagger Mô Phỏng - ghi chú lại sau khi chuyển

// ...các tuyến API khác...

module.exports = router;
```
