---
id: release_add-tag_and_build-binary
title: Thêm Tag Phiên Bản Và Xây Dựng Tệp Nhị Phân
---

## Thêm Tag Phiên Bản Và Xây Dựng Tệp Nhị Phân

## Tổng Quan

Sau khi hợp nhất tính năng mới vào nhánh chính (develop), chúng ta cần thực hiện các bước sau:

- Thêm tag phiên bản mới vào nhánh develop.
- Khi việc gắn tag hoàn tất, xây dựng tệp nhị phân và lưu trữ trong thư mục phát hành trên Google Drive.

## Quy Trình

### Bước 1: Thêm Tag Phiên Bản Mới

#### Thực Hành Tốt Nhất Cho Quản Lý Phiên Bản Bằng Tag Trên GitHub Như Sau:

- Áp Dụng Phiên Bản Ngữ Nghĩa. Số phiên bản nên được quản lý theo định dạng `MAJOR.MINOR.PATCH`.
  - MAJOR: Tăng khi thực hiện các thay đổi không tương thích.
  - MINOR: Tăng khi thêm các tính năng mới tương thích ngược.
  - PATCH: Tăng khi sửa lỗi tương thích ngược.
    - Ví dụ: `v1.0.0`, `v1.1.0`, `v1.1.1`

#### Sử Dụng Tag Có Chú Thích

- Sử dụng tag có chú thích (`git tag -a`) để thêm thông điệp có ý nghĩa vào tag. Điều này cho phép tham khảo dễ dàng các thay đổi hoặc ghi chú phát hành liên quan đến tag.

- Ví dụ: `git tag -a v1.0.0 -m "Phát hành ban đầu với chức năng cốt lõi"`

### Bước 2: Xây Dựng Tệp Nhị Phân Và Lưu Trữ Trong Thư Mục Phát Hành Trên Google Drive

- Sau khi hợp nhất, tạo các tệp nhị phân và lưu trữ chúng trong [liên kết thư mục Google Drive](https://drive.google.com/drive/u/0/folders/1wvxdkx3qkvgNjU6bdFTQrbYSr-A8U-lV).

- Liên hệ với Ông Han để yêu cầu quyền truy cập [liên kết thư mục Google Drive](https://drive.google.com/drive/u/0/folders/1wvxdkx3qkvgNjU6bdFTQrbYSr-A8U-lV) nếu bạn chưa có.
