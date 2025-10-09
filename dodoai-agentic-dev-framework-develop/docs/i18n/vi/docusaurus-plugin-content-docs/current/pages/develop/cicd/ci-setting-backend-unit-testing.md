---
id: ci-setting-backend-unit-testing
title: Thiết Lập CI (Kiểm Thử Đơn Vị/Backend)
---

## Tổng Quan

Tài liệu này cung cấp chi tiết về thiết lập CI cho kiểm thử đơn vị API Backend. Thiết lập CI cho kiểm thử đơn vị đảm bảo chất lượng và sự ổn định của mã bằng cách tự động chạy kiểm thử trên các sự kiện nhất định của GitHub. Quá trình CI được thiết lập sử dụng GitHub Actions.

## Tại Sao Cần Thiết Lập CI Cho Kiểm Thử Đơn Vị Backend

- **Kiểm Thử Tự Động:** Tự động hóa quá trình kiểm thử đơn vị để phát hiện lỗi sớm.
- **Chất Lượng Mã Nguồn:** Duy trì chất lượng mã cao bằng cách đảm bảo tất cả các bài kiểm thử đều thành công trước khi gộp mã.
- **Tích Hợp Liên Tục:** Đảm bảo tích hợp liên tục bằng cách kiểm thử ở mỗi lần đẩy và yêu cầu gộp mã.

## Cấu Hình

### GitHub Actions

Thiết lập CI được cấu hình sử dụng GitHub Actions. Tệp cấu hình nên được đặt trong `.github/workflows/be-api-unit-test.yaml`.

### Tệp Cấu Hình Mẫu

Dưới đây là tệp cấu hình mẫu cho GitHub Actions để kiểm thử đơn vị API Backend.

```yaml
name: Backend API Unit Test

on:
  push:
    branches:
      - 'feature/api_*'
  pull_request:
    types:
      - reopened
    branches:
      - 'develop'
    paths:
      - 'api/**'

defaults:
  run:
    working-directory: 'api'

jobs:
  test:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [18.9]

    steps:
      - uses: actions/checkout@v3
      - name: Sử dụng Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v3
        with:
          node-version: ${{ matrix.node-version }}
      - run: yarn install
      - run: yarn build
      - run: yarn test
        env:
          USE_DYNAMODB_LOCAL: true
          DYNAMODB_REGION: ap-northeast-1
          DYNAMODB_LOCAL_URL: http://localhost:8000
          RUN_MODE: test
```

## Hướng Dẫn

- **Thực Thi Cục Bộ:** Luôn chạy kiểm thử cục bộ trước khi tạo Pull Request (PR).
- **Yêu Cầu PR:** Đảm bảo rằng các kiểm thử đơn vị và các thay đổi mã tương ứng được bao gồm trong cùng một PR.
- **Trách Nhiệm Đội Ngũ:** Đội ngũ Backend chịu trách nhiệm cho việc thiết lập và duy trì CI cho các kiểm thử đơn vị.

## Các Bước

1. **Tạo Tệp Cấu Hình:**

- Thêm tệp cấu hình CI vào `.github/workflows/be-api-unit-test.yaml`.

2. **Thiết Lập GitHub Actions:**

- Đảm bảo GitHub Actions đã được kích hoạt cho kho lưu trữ của bạn.

3. **Đảm Bảo Cấu Trúc Kho Lưu Trữ Của Bạn Phù Hợp Với Thiết Lập:**

- Workflow mong đợi mã liên quan đến API nằm trong thư mục `api`.

4. **Quy Tắc Đặt Tên Nhánh:**

- Đảm bảo rằng các nhánh tính năng theo quy tắc đặt tên `feature/api_*`.

5. **Mục Tiêu Yêu Cầu Gộp Mã:**

- Đảm bảo rằng yêu cầu gộp mã mục tiêu là nhánh `develop` để kích hoạt workflow.

6. **Đảm Bảo Các Biến Môi Trường Chính Xác:**

- Kiểm tra kỹ các biến môi trường dùng cho kiểm thử (như cấu hình DynamoDB) để phù hợp với thiết lập cục bộ của bạn.

7. **Thêm Các Phiên Bản Node.js Khác (Tùy Chọn):**

- Nếu muốn, mở rộng ma trận node-version để kiểm thử với nhiều phiên bản Node.js.

```yaml
matrix:
  node-version: [18.9, 16.x, 14.x]
```

## Kết Luận

Bằng cách thiết lập và sử dụng cấu hình GitHub Actions này, bạn có thể tự động hóa quá trình chạy kiểm thử đơn vị cho API backend của mình, đảm bảo rằng mã của bạn vẫn đáng tin cậy và dễ bảo trì. Cấu hình này không chỉ giúp duy trì chất lượng mã nguồn mà còn giảm thiểu công sức thủ công cần thiết cho kiểm thử.
