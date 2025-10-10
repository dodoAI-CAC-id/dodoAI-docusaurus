---
id: ci-setting-api-testing
title: Thiết Lập CI (Kiểm Thử API)
---

## Tổng Quan

Tài liệu này cung cấp chi tiết về thiết lập CI cho kiểm thử API. Thiết lập CI cho kiểm thử API bao gồm việc tích hợp thực thi kiểm thử tự động vào quy trình phát triển của bạn. Điều này đảm bảo chức năng API được kiểm chứng liên tục mỗi khi có thay đổi trong mã nguồn.

## Tại Sao Cần Thiết Lập CI Cho Kiểm Thử API

Thiết lập Tích Hợp Liên Tục (CI) cho kiểm thử API mang lại nhiều lợi ích nâng cao độ tin cậy, hiệu quả và chất lượng của quy trình phát triển phần mềm. Dưới đây là lý do bạn nên xem xét tích hợp CI cho kiểm thử API:

1. **Kiểm Thử Tự Động**
2. **Phát Hiện Lỗi Sớm**
3. **Cải Thiện Hợp Tác**
4. **Nâng Cao Chất Lượng Và Độ Tin Cậy**
5. **Giảm Bớt Công Sức Thủ Công**
6. **Tính Mở Rộng**
7. **Phân Phối Và Triển Khai Liên Tục**
8. **Tuân Thủ Và Tài Liệu**
9. **Tiết Kiệm Chi Phí**

## Cấu Hình

### Tệp Cấu Hình Mẫu

Dưới đây là tệp cấu hình mẫu cho GitHub Actions cho kiểm thử đơn vị Backend API.

```yaml
name: API Unit Test

on:
  push:
    branches:
      - "feature/api_*"
  pull_request:
    types:
      - reopened
    branches:
      - "develop"
    paths:
      - "api/**"

defaults:
  run:
    working-directory: "api"

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Set up Node.js
        uses: actions/setup-node@v2
        with:
          node-version: "14"

      - name: Install dependencies
        run: npm install

      - name: Start API Server
        run: npm start &
        env:
          CI: true

      - name: Run Cucumber tests
        run: npx cucumber-js
```

## Hướng Dẫn

- **Thực Thi Cục Bộ:** Luôn chạy kiểm thử cục bộ trước khi tạo Pull Request (PR).
- **Yêu Cầu PR:** Đảm bảo rằng các kiểm thử đơn vị và các thay đổi mã tương ứng được bao gồm trong cùng một PR.
- **Trách Nhiệm Đội Ngũ:** Đội ngũ Backend chịu trách nhiệm thiết lập và duy trì CI cho các kiểm thử đơn vị.

## Các Bước

1. **Thiết Lập CI Pipeline**

   - Cấu hình pipeline CI của bạn để bao gồm các giai đoạn để kiểm tra mã, thiết lập môi trường cần thiết, chạy kiểm thử API và báo cáo kết quả.

2. **Thiết Lập Môi Trường**

   - Đảm bảo pipeline CI của bạn thiết lập môi trường cần thiết, bao gồm cơ sở dữ liệu, dịch vụ bên thứ ba và các tệp cấu hình, cho kiểm thử API.

3. **Tự Động Hóa Thực Thi Kiểm Thử**

   - Cấu hình công cụ CI của bạn để tự động chạy kiểm thử API khi mã được gộp vào nhánh phát triển.

4. **Báo Cáo Kết Quả và Thông Báo**

   - Tích hợp các cơ chế báo cáo và thông báo để thông báo cho đội ngũ về kết quả kiểm thử. Sử dụng bảng điều khiển, thông báo qua email, hoặc các công cụ trò chuyện (vd: Slack) để giữ mọi người được cập nhật thông tin.

5. **Giám Sát Liên Tục và Cải Tiến**
   - Thường xuyên xem xét và cải thiện pipeline CI và kiểm thử API để đáp ứng bất kỳ yêu cầu mới nào hoặc cập nhật các kiểm thử hiện có. Đảm bảo môi trường CI và các cấu hình luôn được cập nhật.

Bằng cách thiết lập CI cho kiểm thử API, bạn đảm bảo rằng bất kỳ thay đổi nào đối với mã nguồn đều được xác minh kịp thời, duy trì sự vững chắc, độ tin cậy và hiệu suất của các API của bạn. Phương pháp tự động hóa này không chỉ tối ưu hóa quy trình phát triển mà còn giảm thiểu rủi ro sai sót và tăng cường niềm tin vào mã đã triển khai.
