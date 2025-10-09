---
id: security-architecture
title: Kiến Trúc Bảo Mật
---

# Kiến Trúc Bảo Mật Cho Dịch Vụ Trên Đám Mây AWS

## Tổng Quan

Tài liệu này phác thảo các thực tiễn tốt nhất và nguyên tắc kiến trúc để bảo mật dịch vụ triển khai trên đám mây AWS. Tài liệu tập trung vào quản lý danh tính, bảo mật mạng, bảo vệ dữ liệu, và giám sát. Một mẫu triển khai để bảo mật dịch vụ ECS cũng được bao gồm.

---

## 1. Nguyên Tắc Kiến Trúc Bảo Mật

### **1. Quản Lý Danh Tính và Truy Cập**

- Sử dụng **AWS Identity and Access Management (IAM)** để cấp quyền chi tiết.
  - Áp dụng nguyên tắc **ít quyền hạn nhất**.
  - Sử dụng các vai trò IAM cho dịch vụ truy cập tài nguyên thay vì mã hóa cứng thông tin đăng nhập.
  - Kích hoạt **MFA** cho người dùng truy cập AWS Management Console.

### **2. Bảo Mật Mạng**

- Thực hiện **Bảo Mật VPC**:
  - Tạo các subnet riêng tư cho tài nguyên nhạy cảm.
  - Sử dụng **Network ACLs** và **Security Groups** để kiểm soát lưu lượng.
- Cấu hình **Load Balancers** để xử lý lưu lượng bên ngoài một cách an toàn (ví dụ: HTTPS sử dụng chứng chỉ từ AWS Certificate Manager).
- Sử dụng **AWS WAF (Web Application Firewall)** để bảo vệ chống lại các khai thác web phổ biến như tiêm SQL hoặc XSS.

### **3. Bảo Vệ Dữ Liệu**

- **Mã Hóa**:
  - Sử dụng **KMS** để mã hóa dữ liệu khi lưu trữ.
  - Kích hoạt SSL/TLS cho dữ liệu trong quá trình truyền tải.
- Bảo vệ các biến môi trường nhạy cảm bằng **AWS Secrets Manager** hoặc **Parameter Store**.

### **4. Giám Sát và Ghi Log**

- Kích hoạt **CloudTrail** để kiểm toán các cuộc gọi API.
- Sử dụng **CloudWatch Logs** để giám sát nhật ký ứng dụng và hệ thống.
- Thiết lập cảnh báo cho các hoạt động đáng ngờ hoặc thay đổi cấu hình.

### **5. Thực Tiễn Phát Triển An Toàn**

- Thường xuyên quét các lỗ hổng trong hình ảnh container bằng cách sử dụng các công cụ như **Amazon Inspector**.
- Kích hoạt các pipeline CI/CD tự động để triển khai cập nhật với các bản vá bảo mật đã được xác thực.

---

## 2. Ví Dụ: Bảo Mật Dịch Vụ ECS Trên Đám Mây AWS

### **Thành Phần Kiến Trúc**

- **Amazon ECS (Fargate hoặc EC2)**: Chạy các tác vụ container hóa.
- **Application Load Balancer (ALB)**: Quản lý lưu lượng bên ngoài.
- **Security Groups**: Hạn chế lưu lượng vào/ra.
- **Secrets Manager**: Quản lý thông tin nhạy cảm.
- **CloudWatch Logs**: Tập trung thu thập nhật ký.
- **IAM Roles**: Cung cấp quyền hạn giới hạn cho các tác vụ và dịch vụ ECS.

### **Các Bước Để Bảo Mật Dịch Vụ ECS**

#### **1. Cấu Hình Mạng**

- Đặt các tác vụ ECS trong **subnet riêng tư** trong VPC.
- Sử dụng **ALB** trong subnet công cộng để xử lý lưu lượng HTTPS.
- Tạo **Security Groups**:
  - **Security Group của ALB**:
    - Cho phép lưu lượng vào trên cổng 443 (HTTPS) từ Internet.
    - Cho phép lưu lượng ra đến Security Group của ECS.
  - **Security Group của ECS**:
    - Chỉ cho phép lưu lượng vào từ Security Group của ALB.
    - Hạn chế lưu lượng ra dựa trên yêu cầu tài nguyên cụ thể (ví dụ: cơ sở dữ liệu hoặc API bên ngoài).

#### **2. Quyền Hạn IAM**

- Tạo **IAM Task Role**:
  - Chỉ cấp quyền cần thiết, chẳng hạn như truy cập các bucket S3 cụ thể hoặc khóa của Secrets Manager.
- Sử dụng **IAM Execution Role** cho dịch vụ ECS để kéo hình ảnh từ Amazon ECR.

#### **3. Quản Lý Bí Mật**

- Lưu dữ liệu nhạy cảm (ví dụ: thông tin đăng nhập cơ sở dữ liệu, khóa API) trong **AWS Secrets Manager**.
- Tham chiếu đến các bí mật này trong định nghĩa tác vụ ECS sử dụng tham số **Secrets**.

#### **4. An Toàn Hình Ảnh**

- Sử dụng **Amazon ECR** để lưu trữ hình ảnh container.
- Quét các hình ảnh để tìm lỗ hổng bằng **Amazon Inspector** hoặc công cụ bên thứ ba.
- Luôn sử dụng các thẻ hình ảnh cụ thể thay vì `latest` để tránh những thay đổi bất ngờ.

#### **5. Ghi Log và Giám Sát**

- Kích hoạt **CloudWatch Logs** cho các tác vụ ECS bằng cách thêm cấu hình ghi log trong định nghĩa tác vụ.
- Thiết lập **CloudTrail** để giám sát hoạt động API liên quan đến ECS và mạng lưới.
- Sử dụng **Amazon GuardDuty** để phát hiện các mối đe dọa bảo mật tiềm ẩn trong môi trường AWS của bạn.

### **Ví Dụ: Đoạn Mã Định Nghĩa Tác Vụ ECS**

```json
{
  "family": "example-service",
  "containerDefinitions": [
    {
      "name": "web-app",
      "image": "123456789012.dkr.ecr.us-east-1.amazonaws.com/web-app:1.0",
      "memory": 512,
      "cpu": 256,
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/example-service",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "secrets": [
        {
          "name": "DB_PASSWORD",
          "valueFrom": "arn:aws:secretsmanager:us-east-1:123456789012:secret:db-password"
        }
      ]
    }
  ]
}
```
