---
id: ci-setting-frontend-unit-testing
title: Thiết Lập CI (Frontend/Unit Testing)
---

# Thiết Lập CI (Frontend/Unit Testing)

## Tổng Quan

Tài liệu này cung cấp các chi tiết về thiết lập CI cho kiểm tra unit test của Frontend. Việc thiết lập CI đảm bảo chất lượng và tính ổn định của mã nguồn bằng cách tự động chạy các bài kiểm tra unit test trên các sự kiện nhất định trên GitHub. Quá trình CI này được thiết lập thông qua GitHub Actions.

## Lý Do Cần Thiết Lập CI Cho Frontend Unit Testing

- **Kiểm Tra Tự Động:** Tự động hóa quá trình kiểm tra unit test để phát hiện sớm các vấn đề.
- **Chất Lượng Mã Nguồn:** Đảm bảo chất lượng mã nguồn cao bằng cách kiểm tra tất cả các bài test trước khi merge.
- **Tích Hợp Liên Tục:** Đảm bảo tích hợp liên tục bằng cách tiến hành kiểm tra trên mỗi lần push và pull request.

## Cấu Hình

### GitHub Actions

Thiết lập CI được cấu hình bằng GitHub Actions. Tệp cấu hình nên được đặt trong thư mục `.github/workflows/frontend-test-develop.yaml`.

### Tệp Cấu Hình Mẫu

Dưới đây là một ví dụ về tệp cấu hình GitHub Actions cho kiểm tra unit test Frontend.

```yaml
name: Flutter Test Develop

on:
  push:
    branches:
      - 'feature/frontend_*'
  pull_request:
    types:
      - reopened
    branches:
      - 'develop'
    paths:
      - 'desktop-app/**'

defaults:
  run:
    working-directory: 'desktop-app'

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Cache Flutter dependencies
        uses: actions/cache@v3
        with:
          path: ${{ github.workspace }}/desktop-app/.pub-cache
          key: flutter-${{ hashFiles('**/pubspec.yaml') }}
          restore-keys: |
            flutter-

      - name: Install Flutter
        run: |
          git clone https://github.com/flutter/flutter.git -b 3.22.0 $HOME/flutter
          echo "$HOME/flutter/bin" >> $GITHUB_PATH

      - name: Flutter Doctor
        run: flutter doctor

      - name: Get Dependencies
        run: |
          flutter clean
          flutter pub get

      - name: Run Flutter Tests
        run: flutter test
        env:
          RUN_MODE: test
```

## Hướng Dẫn

- **Chạy Kiểm Tra Cục Bộ:** Luôn chạy các bài kiểm tra unit test trên môi trường cục bộ trước khi tạo Pull Request (PR).
- **Yêu Cầu PR:** Đảm bảo rằng các bài kiểm tra unit test và thay đổi mã liên quan được đưa vào cùng một PR.
- **Trách Nhiệm Đội Nhóm:** Đội Frontend chịu trách nhiệm trong việc thiết lập và duy trì CI cho kiểm tra unit test.

## Các Bước Thực Hiện

1. **Tạo Tệp Cấu Hình:**
   - Thêm tệp cấu hình CI vào `.github/workflows/frontend-test-develop.yaml`.

2. **Kích Hoạt GitHub Actions:**
   - Đảm bảo rằng GitHub Actions đã được kích hoạt cho kho lưu trữ của bạn.

3. **Chạy Kiểm Tra Cục Bộ:**
   - Thực thi các bài kiểm tra unit test bằng cấu hình giống nhau trên môi trường cục bộ trước khi đẩy (push) thay đổi.

4. **Tạo Pull Request:**
   - Bao gồm các bài kiểm tra unit test và thay đổi mã nguồn trong cùng một PR.
   - Quy trình CI sẽ tự động chạy các bài kiểm tra trên mỗi lần push đến các nhánh có tên `feature/frontend_*` và trên các PR đến nhánh `develop`.

Bằng cách tuân thủ các bước và hướng dẫn này, bạn đảm bảo một quy trình kiểm tra tự động và mạnh mẽ cho Frontend, từ đó nâng cao chất lượng và tính ổn định của mã nguồn.
