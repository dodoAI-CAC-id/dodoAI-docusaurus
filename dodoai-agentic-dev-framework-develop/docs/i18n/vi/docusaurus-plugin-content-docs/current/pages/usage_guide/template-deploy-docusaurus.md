---
id: template-deploy-docusaurus
title: Triển Khai Mẫu Docusaurus
---

## Giới Thiệu

Để Cài Đặt Docusaurus Bằng Triển Khai Mẫu

## Yêu Cầu Trước Khi Sử Dụng

- Một Tài Khoản Email (Email Và Mật Khẩu) Để Đăng Ký Tài Khoản DodoAI.
- Một Tài Khoản Google Để Đăng Nhập Vào DodoAI.
- Chuẩn Bị Tài Liệu Cần Thiết Cho Mỗi Tính Năng Trước.

## Hướng Dẫn Sử Dụng

- Truy Cập Triển Khai
- Nhấp Nút Triển Khai
- Nhập Thông Tin Triển Khai Và Triển Khai

### Truy Cập Triển Khai

- Nhấp Mục Triển Khai.
![Truy Cập Triển Khai](../../assets/user-guide/template-deploy/docusaurus-1.png)

### Nhấp Nút Triển Khai

![Nhấp Nút Triển Khai](../../assets/user-guide/template-deploy/docusaurus-2.png)

- Owner: `58web3`
- Lowcode_repo: `58web3/dodoai-low-code`
- Ví Dụ Project Repo: `58web3/lowcode-sample-project`
- Subdomain: `xxx-docs`
  - URL: `https://xxx-docs.58llm.link`
- Port: 4000
  - Hiện Tại, Nhiều Tài Liệu Được Triển Khai Trên Cùng Một EC2, Vì Vậy Nếu Các Port 4000 Bị Trùng Lặp, Hãy Thiết Lập Các Port Khác Nhau.

### Nhập Thông Tin Triển Khai Và Triển Khai

![Nhập Thông Tin Triển Khai](../../assets/user-guide/template-deploy/docusaurus-3.png)

### Cấu Hình Subdomain Trong AWS Route53 Bởi Kỹ Sư Hạ Tầng

![Cấu Hình Subdomain](../../assets/user-guide/template-deploy/docusaurus-4.png)

- Tên Bản Ghi: Tên Subdomain
- Loại Bản Ghi: A
- Alias: Bật
- Loại Route: Application Và Classic Load Balancer
- Khu Vực: Châu Á Thái Bình Dương (Tokyo)
- Tên ALB: `dualstack.dodoai-dev-617494054.ap-northeast-1.elb.amazonaws.com`
- Chính Sách Route: `Simple routing`

### Truy Cập Trang

URL: `https://xxx-docs.58llm.link`
