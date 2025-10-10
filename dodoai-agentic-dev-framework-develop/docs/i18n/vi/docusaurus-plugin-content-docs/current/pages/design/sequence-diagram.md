---
id: sequence-diagram
title: Sơ Đồ Tuần Tự
---

## Hướng Dẫn

Tạo Sơ Đồ Tuần Tự (Cấp Cao) bằng Markdown theo định dạng dưới đây.

## Tổng Quan

Sơ đồ tuần tự thể hiện cách các đối tượng và thành phần tương tác trong các kịch bản cụ thể của một hệ thống.

## Mục Tiêu

Nhằm minh họa trình tự hệ thống cấp cao, ghi lại các tương tác quan trọng từ bên ngoài và các quy trình hướng người dùng mà không đi sâu vào chi tiết các cơ chế nội bộ.

**Lưu ý: Tùy chỉnh ví dụ sơ đồ tuần tự dưới đây để thể hiện chính xác các tương tác hệ thống cấp cao của dự án của bạn.**

## Ví Dụ Về Sơ Đồ Tuần Tự

**Ví dụ dưới đây chỉ mang tính tham khảo về định dạng; nội dung nên thể hiện các tương tác cấp cao của hệ thống của bạn.**

```mermaid
sequenceDiagram
    participant Client
    participant FirebaseAuth as "Firebase Authentication"
    participant APIServer as "Máy Chủ API"
    participant AuthZService as "Dịch Vụ Ủy Quyền"

    %% Quá Trình Xác Thực
    Client ->> FirebaseAuth: Xác Thực (email/password)
    FirebaseAuth ->> Client: Trả Về Token JWT (id, email)

    %% Quá Trình Yêu Cầu API
    Client ->> APIServer: Yêu Cầu API kèm Header `Authorization: Bearer <JWT Token>`
    APIServer ->> AuthZService: Xác Minh và Giải Mã Token JWT
    AuthZService ->> AuthZService: Xác Thực Token (ký, hết hạn, v.v.)

    alt Token Hợp Lệ
        AuthZService ->> AuthZService: Lấy Vai Trò và Quyền Hạn Người Dùng từ DB
        AuthZService ->> APIServer: Trả Về Vai Trò và Quyền Hạn
        APIServer ->> Client: Cung Cấp Dữ Liệu/Hành Động Yêu Cầu
    else Token Không Hợp Lệ
        AuthZService ->> APIServer: Trả Về Thất Bại Uỷ Quyền
        APIServer ->> Client: Truy Cập Bị Từ Chối
    end
```
