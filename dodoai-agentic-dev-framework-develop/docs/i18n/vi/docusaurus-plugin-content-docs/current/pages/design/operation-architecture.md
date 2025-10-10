---
id: operation-architecture
title: Kiến Trúc Hoạt Động
---

## Tổng Quan

Kiến trúc hoạt động đảm bảo độ tin cậy, hiệu suất và bảo mật của hệ thống thông qua cơ chế giám sát, ghi log và cảnh báo hiệu quả. Tài liệu này phác thảo các thành phần và thực tiễn tốt nhất trong việc quản lý các khía cạnh hoạt động của hạ tầng.

## 1. Giám Sát

### **Mục Đích**

Giám sát cung cấp cái nhìn toàn diện theo thời gian thực về hiệu suất và tình trạng sức khỏe của hạ tầng và ứng dụng. Nó giúp phát hiện các hiện tượng bất thường, chẩn đoán vấn đề và tối ưu hóa tài nguyên.

### **Thành Phần**

1. **Amazon CloudWatch**:  
   - Theo dõi các chỉ số như sử dụng CPU, bộ nhớ, đĩa I/O, và lưu lượng mạng.
   - Cung cấp tích hợp sẵn với các tài nguyên AWS như ECS, EC2, RDS và ALB.

2. **Giám Sát Hiệu Suất Ứng Dụng (APM)**:
   - Công cụ như New Relic, Datadog, hoặc AppDynamics giúp phân tích sâu về hiệu suất ứng dụng.

### **Các Chỉ Số Quan Trọng Cần Giám Sát**

- **Hạ Tầng**:
  - Sử dụng CPU, Bộ nhớ, Đĩa
  - Độ trễ mạng và thông lượng
  - Tình trạng sức khỏe tác vụ và instance của ECS

- **Ứng Dụng**:
  - Độ trễ yêu cầu
  - Tỷ lệ lỗi (như lỗi HTTP 5xx)
  - Hiệu suất truy vấn cơ sở dữ liệu

## 2. Ghi Log

### **Mục Đích**

Ghi log tập trung thu thập nhật ký hệ thống và ứng dụng để đảm bảo việc hiển thị rõ ràng hành vi của các ứng dụng và hạ tầng.

### **Thành Phần**

1. **Amazon CloudWatch Logs**:  
   - Thu thập nhật ký từ các dịch vụ AWS như ECS, Lambda, và API Gateway.
   - Cho phép tìm kiếm và phân tích nhật ký thông qua Log Insights.

### **Thực Tiễn Tốt Nhất**

- **Ghi Log Có Cấu Trúc**: Sử dụng định dạng JSON cho nhật ký để dễ dàng phân tích.
- **Chính Sách Lưu Trữ**: Định nghĩa thời gian lưu trữ nhật ký để quản lý chi phí lưu trữ.
- **Gắn Thẻ và Tương Quan**: Bao gồm các ID yêu cầu hoặc ID giao dịch để theo dõi các nhật ký liên quan.

### **Nguồn Nhật Ký Chính**

- **Nhật Ký Hạ Tầng**:
  - Nhật ký tác vụ ECS
  - Nhật ký hệ thống EC2
  - Nhật ký luồng VPC

- **Nhật Ký Ứng Dụng**:
  - Nhật ký lỗi
  - Nhật ký truy cập API
  - Giao dịch kinh doanh

## 3. Cảnh Báo

### **Mục Đích**

Cảnh báo thông báo cho nhóm vận hành về các vấn đề quan trọng cần hành động ngay lập tức, giảm thiểu thời gian ngừng hoạt động và tác động đối với người dùng.

### **Thành Phần**

1. **Amazon CloudWatch Alarms**:  
   - Kích hoạt cảnh báo dựa trên các ngưỡng định nghĩa cho các chỉ số.
   - Hỗ trợ tích hợp với SNS để gửi email, SMS, hoặc chức năng Lambda.

2. **Công Cụ Bên Thứ Ba**:  
   - PagerDuty hoặc Opsgenie cho quản lý sự cố theo lịch trình.
   - Tích hợp Slack hoặc Teams để nhận thông báo thời gian thực.

## **Ví Dụ Mẫu**

- **Sử Dụng New Relic Cho Ghi Log Tập Trung**:  
  Sử dụng New Relic để hợp nhất các nhật ký từ các dịch vụ khác nhau và liên kết chúng với các chỉ số hiệu suất ứng dụng để tăng cường khả năng quan sát.

- **Ghi Log Có Cấu Trúc**: Sử dụng định dạng JSON cho nhật ký để dễ dàng phân tích.
- **Chính Sách Lưu Trữ**: Định nghĩa thời gian lưu trữ nhật ký để quản lý chi phí lưu trữ.
- **Gắn Thẻ và Tương Quan**: Bao gồm các ID yêu cầu hoặc ID giao dịch để theo dõi các nhật ký liên quan.
- **Giám Sát Khối Lượng Nhật Ký**: Thiết lập cảnh báo cho các đột biến bất ngờ trong khối lượng nhật ký có thể cho thấy vấn đề hệ thống hoặc hoạt động độc hại.

### **Ví Dụ Cảnh Báo Thông Thường**

- **Hạ Tầng**:
  - Sử dụng CPU > 80% trong 5 phút
  - Tác vụ ECS bị lỗi hoặc các instance không khỏe
  - Sử dụng đĩa > 90%

- **Ứng Dụng**:
  - Thời gian phản hồi API vượt quá 500ms
  - Tỷ lệ lỗi HTTP 5xx > 5% tổng số yêu cầu
  - Bão hòa kết nối cơ sở dữ liệu
