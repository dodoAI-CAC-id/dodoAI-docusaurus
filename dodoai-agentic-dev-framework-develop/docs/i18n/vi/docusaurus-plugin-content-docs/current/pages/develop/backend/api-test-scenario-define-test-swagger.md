---
id: api-test-scenario-define-test-swagger
title: Kịch Bản Kiểm Thử API và Định Nghĩa Thử Để Đáp Ứng API
---

## Hướng Dẫn

Soạn thảo kịch bản kiểm thử trong Cucumber đáp ứng các đặc tả API được mô tả trong Swagger. Triển khai các bài kiểm tra bằng Node.js.

## Tổng Quan

Tạo kịch bản kiểm thử chi tiết và thử nghiệm đảm bảo API đáp ứng các yêu cầu đã chỉ định và hoạt động đúng.

## Mục Tiêu

- Xác thực tất cả các điểm cuối API theo các đặc tả trong Swagger.
- Xác định và khắc phục bất kỳ sự khác biệt hoặc lỗi nào trong chức năng của API.
- Tự động hóa việc kiểm thử API để đảm bảo tính nhất quán và hiệu quả.

## Ví Dụ

**Lưu Ý: Các ví dụ này chỉ phục vụ như mô hình. Thay đổi cấu trúc để phù hợp với kịch bản kiểm thử của bạn.**

### Tệp Tính Năng

Một tệp tính năng dựa trên cú pháp Gherkin định nghĩa hành vi mong đợi từ API.

```gherkin
Tính Năng: Các Điểm Cuối API Nhiệm Vụ

  Kịch Bản Mẫu: Cập Nhật Một Nhiệm Vụ
    Given Tôi đã được ủy quyền với "<token>"
    When Tôi yêu cầu cập nhật nhiệm vụ với id "<task_id>" với "<update_data>"
    Then Tôi mong nhận được trạng thái "<response_status>"

    Ví Dụ:
      | token        | task_id | update_data        | response_status |
      | valid_token  | 1       | dữ liệu cập nhật hợp lệ | 200             |
      | invalid_token| 1       | dữ liệu cập nhật hợp lệ | 401             |
      | valid_token  | 1       | dữ liệu cập nhật không hợp lệ | 400             |
```

### Tệp Kiểm Thử Cucumber

Các kiểm thử Cucumber được triển khai trong Node.js để tích hợp với kịch bản kiểm thử.

```javascript
// task_api_steps.js
const assert = require('assert').strict;
const { Given, When, Then } = require('@cucumber/cucumber');
const axios = require('axios');
const baseURL = 'http://api.example.com/';

Given('Tôi đã được ủy quyền với {string}', function (token) {
  this.authToken = token;
});

When('Tôi yêu cầu cập nhật nhiệm vụ với id {string} với {string}', async function (task_id, update_data) {
  try {
    const response = await axios.put(`${baseURL}/tasks/${task_id}`, update_data, {
      headers: { Authorization: `Bearer ${this.authToken}` }
    });
    this.responseStatus = response.status;
  } catch (error) {
    this.responseStatus = error.response.status;
  }
});

Then('Tôi mong nhận được trạng thái {string}', function (expectedStatus) {
  assert.strictEqual(this.responseStatus.toString(), expectedStatus);
});
```

Hãy nhớ, mã được cung cấp nhằm hướng dẫn triển khai kiểm thử của bạn và bạn nên tùy chỉnh theo các đặc tả API thực tế và yêu cầu kiểm thử của mình.
