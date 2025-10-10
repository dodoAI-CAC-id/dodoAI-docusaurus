---
id: infrastructure-architecture
title: Kiến Trúc Hạ Tầng
---

## Cách Tạo Kiến Trúc Hạ Tầng

### 1. Hiểu Rõ Yêu Cầu

- **Thu Thập Yêu Cầu**: Xác định nhu cầu chức năng và phi chức năng của ứng dụng.  
  - Ví dụ: Khả năng mở rộng, khả dụng, bảo mật, hiệu quả chi phí.
- **Định Nghĩa Tài Nguyên**: Liệt kê các dịch vụ đám mây và tài nguyên cần thiết.  
  - Ví dụ: Tính toán (EC2), Lưu trữ (S3), Mạng (VPC, Bộ cân bằng tải).

### 2. Thiết Kế Kiến Trúc

- **Vẽ Sơ Đồ Kiến Trúc**: Sử dụng các công cụ như Lucidchart, Draw.io, hoặc AWS Architecture Diagrams.  
  - Định nghĩa các thành phần như:
    - Tính toán (EC2, ECS)
    - Cơ sở dữ liệu (RDS, DynamoDB)
    - Lưu trữ (S3, EBS)
    - Mạng (VPC, Subnets, Cổng, Nhóm bảo mật)
- **Lên Kế Hoạch Mở Rộng và Dự Phòng**:
  - Sử dụng Auto Scaling Groups để tăng tính linh hoạt.
  - Triển khai tài nguyên trên nhiều Khu vực sẵn sàng (AZs) để đảm bảo dung sai lỗi.

### 3. Định Nghĩa Các Biện Pháp Bảo Mật

- **Bảo Mật Mạng**:
  - Sử dụng Security Groups và Network ACLs để kiểm soát lưu lượng truy cập vào và ra.
  - Triển khai VPN hoặc Direct Connect để kết nối an toàn.

- **Chính Sách IAM**:
  - Sử dụng nguyên tắc quyền ít nhất có thể.
  - Tạo các vai trò cho các dịch vụ yêu cầu quyền cụ thể.

### 4. Tự Động Hóa Cung Cấp Hạ Tầng

- **Chọn Công Cụ IaC**: Sử dụng các công cụ như Terraform, AWS CloudFormation, hoặc Pulumi để tự động hóa.
- **Kiểm Soát Phiên Bản**: Lưu trữ các file IaC trong kho chứa (ví dụ: GitHub, GitLab).
- **Mô-đun Hóa Tài Nguyên**: Tạo các mô-đun tái sử dụng cho các thành phần thường dùng.

### 5. Giám Sát và Tối Ưu Hóa

- **Giám Sát**: Sử dụng các công cụ như CloudWatch, Prometheus, và Grafana để theo dõi tài nguyên.

- **Tối Ưu Hóa Chi Phí**:
  - Xem xét các báo cáo sử dụng.
  - Sử dụng Reserved Instances hoặc Kế Hoạch Tiết Kiệm cho các khối lượng công việc dự đoán được.

## Ví Dụ Về Kiến Trúc Hạ Tầng Sử Dụng Terraform

![image](https://github.com/user-attachments/assets/994fa46d-50ca-4d42-bc59-5a4ebd8bce7c)

## Các Thành Phần Kiến Trúc

### 1. Cụm ECS của Amazon Với Các Tác Vụ Ở Nhiều Khu Vực Sẵn Sàng

- **Định Nghĩa**:  
  Amazon Elastic Container Service (ECS) là dịch vụ điều phối container. Một cụm ECS là nhóm hợp lý của các tài nguyên (ví dụ, các instance EC2 hoặc các tác vụ Fargate) để chạy các ứng dụng container.

- **Mục Đích**:  
  - Triển khai các tác vụ (container) trên nhiều Khu vực sẵn sàng (AZs) để đảm bảo khả dụng cao và dung sai lỗi.
  - Cân bằng tải công việc để tránh quá tải cho bất kỳ AZ nào.

- **Tính Năng Chính**:  
  - Hỗ trợ Fargate (container không máy chủ) hoặc các cụm dựa trên EC2.
  - Cân bằng tải giữa các tác vụ.
  - Tự động điều chỉnh để xử lý các tải công việc khác nhau.

---

### 2. Bộ Cân Bằng Tải Ứng Dụng (ALB)

- **Định Nghĩa**:  
  ALB là bộ cân bằng tải được quản lý trong AWS phân phối lưu lượng ứng dụng đến nhiều mục tiêu, chẳng hạn như các tác vụ ECS, instance EC2 hoặc địa chỉ IP.

- **Mục Đích**:  
  - Định tuyến yêu cầu dựa trên nội dung (ví dụ, định tuyến theo đường dẫn hoặc tên máy chủ).
  - Tích hợp với ECS để tự động đăng ký và hủy đăng ký các tác vụ.
  - Cung cấp điểm vào duy nhất cho các tác vụ phân tán chạy ở nhiều AZs.

- **Tính Năng Chính**:  
  - Định tuyến Layer 7 cho lưu lượng HTTP/HTTPS.
  - Kiểm tra sức khỏe để đảm bảo chỉ các tác vụ hoạt động tốt mới nhận yêu cầu.
  - Hỗ trợ ngắt SSL với chứng chỉ từ AWS Certificate Manager (ACM).

---

### 3. Nhóm Bảo Mật (Security Group)

- **Định Nghĩa**:  
  Nhóm bảo mật hoạt động như tường lửa ảo cho các tài nguyên AWS, kiểm soát lưu lượng vào và ra.

- **Mục Đích**:  
  - Hạn chế truy cập đến các tác vụ ECS, ALBs và các thành phần khác dựa trên địa chỉ IP, giao thức và cổng.
  - Đảm bảo liên lạc an toàn giữa các tài nguyên trong kiến trúc.

- **Tính Năng Chính**:  
  - Quy tắc trạng thái (các phản hồi yêu cầu cho phép tự động được chấp nhận).
  - Kiểm soát chi tiết về lưu lượng mạng.
  - Quy tắc cho lưu lượng vào (ví dụ: lưu lượng HTTP/HTTPS) và lưu lượng ra (ví dụ: đến cơ sở dữ liệu hoặc API bên ngoài).

---

### 4. CloudWatch

- **Định Nghĩa**:  
  Amazon CloudWatch là dịch vụ giám sát và quan sát cho các tài nguyên AWS và các ứng dụng tùy chỉnh.

- **Mục Đích**:  
  - Thu thập số liệu (ví dụ: CPU, sử dụng bộ nhớ) và nhật ký từ các tác vụ ECS, ALBs và các thành phần khác.
  - Đặt báo động cho các điều kiện quan trọng (ví dụ: sử dụng CPU cao hoặc kiểm tra sức khỏe thất bại).

- **Tính Năng Chính**:  
  - Bảng điều khiển cho giám sát thời gian thực.
  - Tích hợp với các dịch vụ AWS để tự động phản hồi (ví dụ: mở rộng các tác vụ ECS).
  - Nhật ký tập trung cho việc gỡ lỗi và xử lý sự cố.

---

### 5. AWS Certificate Manager (ACM)

- **Định Nghĩa**:  
  ACM là dịch vụ quản lý chứng chỉ SSL/TLS để đảm bảo kết nối an toàn qua HTTPS.

- **Mục Đích**:  
  - Cung cấp kết nối an toàn cho ALB bằng các chứng chỉ SSL.
  - Tự động gia hạn chứng chỉ để tránh gián đoạn dịch vụ.

- **Tính Năng Chính**:  
  - Chứng chỉ SSL/TLS miễn phí cho tài nguyên AWS.
  - Dễ dàng tích hợp với ALBs, CloudFront, và API Gateway.
  - Quản lý tự động vòng đời của chứng chỉ (ví dụ: cấp phát, gia hạn, thu hồi).
