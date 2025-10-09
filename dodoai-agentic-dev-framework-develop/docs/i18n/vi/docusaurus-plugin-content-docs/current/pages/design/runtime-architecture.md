---
id: runtime-architecture
title: Kiến Trúc Thời Gian Chạy
---

## Cách Tạo Môi Trường Thời Gian Chạy

### 1. Xác Định Nền Tảng

- **Xác Định Nền Tảng**: Chọn nền tảng cơ sở mà ứng dụng của bạn sẽ chạy.
  - Ví dụ: Các nhà cung cấp đám mây như AWS, Azure, Google Cloud, hoặc trung tâm dữ liệu tại chỗ.
- **Cân Nhắc**:
  - Đánh giá chi phí, hiệu suất và khả năng sẵn có theo địa lý.
  - Xem xét chiến lược đám mây lai hoặc đa đám mây nếu cần thiết.

### 2. Chỉ Định Chi Tiết Hạ Tầng

- **Thiết Kế Hạ Tầng**: Xác định các thành phần hạ tầng sẽ hỗ trợ ứng dụng của bạn.
  - Đối với các ứng dụng container hóa, xem xét Kubernetes cho điều phối.
  - Đối với các ứng dụng không máy chủ, sử dụng AWS Lambda, Azure Functions, hoặc Google Cloud Functions.
  - Đối với các ứng dụng truyền thống, chỉ định các phiên bản máy ảo và cấu hình của chúng (CPU, RAM, lưu trữ).

- **Cân Nhắc**:
  - Lên kế hoạch khả năng mở rộng với các giải pháp như nhóm tự động mở rộng trong môi trường đám mây.
  - Thiết kế cho khả năng khả dụng cao với các tài nguyên được phân phối qua nhiều Khu vực Sẵn sàng (AZs) hoặc các trung tâm dữ liệu.

### 3. Chọn Hệ Điều Hành và Phần Mềm Trung Gian

- **Chọn Hệ Điều Hành**: Xác định hệ điều hành đáp ứng nhu cầu của ứng dụng.
  - Các lựa chọn phổ biến bao gồm các bản phân phối Linux (ví dụ: Ubuntu, CentOS) hoặc Windows Server.
- **Xác Định Phần Mềm Trung Gian**: Chọn các thành phần phần mềm trung gian cần thiết cho hoạt động của ứng dụng.
  - Các runtime container như Docker, các thư viện runtime cho các ngôn ngữ như Java hoặc Python.

- **Cân Nhắc**:
  - Đảm bảo tính tương thích với phần mềm ứng dụng.
  - Thường xuyên cập nhật và vá lỗi để cải thiện bảo mật và hiệu suất.

## Ví Dụ: Môi Trường Thời Gian Chạy Ứng Dụng Web

### Môi Trường Thời Gian Chạy

#### 1. Nền Tảng

- **Nhà Cung Cấp Đám Mây**: AWS

#### 2. Chi Tiết Hạ Tầng

- **Hạ Tầng**:
  - **Cụm Kubernetes**:
    - Chạy trên Amazon EKS (Elastic Kubernetes Service)
    - Cụm triển khai qua nhiều Khu vực Sẵn sàng để đảm bảo khả dụng cao
  - **Amazon ECS**:
    - Sử dụng Fargate để quản lý container không máy chủ, cho phép chạy container mà không cần quản lý máy chủ hoặc cụm
    - Container được triển khai qua nhiều Khu vực Sẵn sàng để đảm bảo khả dụng cao
  - **Kiến Trúc Không Máy Chủ**:
    - AWS Lambda cho các tác vụ không đồng bộ và xử lý theo sự kiện
  - **Máy Ảo**:
    - Các phiên bản EC2 cho các công việc cụ thể, được cấu hình dưới dạng t3.medium để có hiệu suất cân bằng
  - **Cơ Sở Dữ Liệu**:
    - Amazon RDS với PostgreSQL để quản lý dữ liệu quan hệ
  - **Lưu Trữ Tệp**:
    - Amazon S3 để lưu trữ các tài sản tĩnh như hình ảnh, bản sao lưu, và các tệp khác

#### 3. Hệ Điều Hành và Phần Mềm Trung Gian

- **Hệ Điều Hành**:
  - Linux (Amazon Linux 2 cho các phiên bản EC2 và tác vụ ECS)
- **Phần Mềm Trung Gian**:
  - Động Cơ Container: Docker để chạy container trong cả Kubernetes và ECS
  - Thư Viện Runtime: Node.js runtime cho các chức năng Lambda

### Mô Hình Triển Khai

#### 1. Đơn Vị Triển Khai

- Container Docker cho các dịch vụ vi mô chạy trong EKS và ECS
- Các chức năng AWS Lambda cho xử lý theo sự kiện

#### 2. Chính Sách Mở Rộng

- **Tự Động Mở Rộng EC2**:
  - Kích hoạt dựa trên sử dụng CPU, mở rộng nếu sử dụng CPU trên 75% trong 5 phút
- **Tự Động Mở Rộng Kubernetes**:
  - Horizontal Pod Autoscaler mở rộng pods dựa trên sử dụng CPU và yêu cầu tài nguyên
- **Tự Động Mở Rộng ECS**:
  - Mở rộng dịch vụ ECS dựa trên các chỉ số CloudWatch tùy chỉnh (ví dụ: số lượng yêu cầu, sử dụng CPU)

#### 3. Dự Phòng và Khả Năng Chịu Lỗi

- Tài nguyên và dịch vụ được triển khai qua nhiều Khu vực Sẵn sàng
- Cân bằng tải với ELB (Elastic Load Balancer) để phân phối lưu lượng và đảm bảo khả năng chuyển đổi dự phòng

### Giao Thức Giao Tiếp và Luồng Dữ Liệu

#### 1. Giao Thức

- REST API cho giao tiếp dịch vụ web
- gRPC cho giao tiếp dịch vụ vi mô nội bộ

#### 2. Định Dạng Dữ Liệu

- JSON cho giao tiếp khách hàng bên ngoài
- Protobuf cho các cuộc gọi RPC nội bộ sử dụng gRPC

#### 3. Giao Tiếp Thời Gian Thực

- WebSockets được kích hoạt cho các tính năng thời gian thực như trò chuyện trực tiếp và thông báo

### Môi Trường Kiểm Thử vs. Môi Trường Sản Xuất

#### 1. Khác Biệt Cấu Hình

- **Cơ Sở Dữ Liệu**:
  - Môi trường kiểm thử sử dụng một phiên bản RDS có dung lượng nhỏ hơn (ví dụ: db.t3.micro) để tiết kiệm chi phí, trong khi môi trường sản xuất sử dụng một phiên bản lớn hơn (ví dụ: db.t3.large) để xử lý tải cao hơn và đảm bảo khả dụng cao.

- **Chính Sách Mở Rộng**:
  - Môi trường kiểm thử có các chính sách mở rộng đơn giản hơn với ngưỡng thấp hơn để tiết kiệm chi phí, trong khi sản xuất nhấn mạnh khả dụng cao và dự phòng.

#### 2. Biện Pháp Bảo Mật

- **Kiểm Soát Truy Cập (Môi Trường Kiểm Thử)**:
  - Thiết lập hạn chế IP để giới hạn truy cập vào các mạng đáng tin cậy
  - Sử dụng Xác Thực Cơ Bản cho thêm bảo mật trong các giai đoạn thử nghiệm

- **Tường Lửa Ứng Dụng Web (WAF)**:
  - Đảm bảo cả môi trường kiểm thử và sản xuất được bảo vệ với AWS WAF để ngăn chặn các mối đe dọa web thông thường như tiêm SQL và tấn công XSS
  - Tùy chỉnh các quy tắc WAF để phù hợp với yêu cầu cụ thể của ứng dụng

#### 3. Quá Trình Xác Thực Trước và Sau Triển Khai

- **Kiểm Tra**:
  - Pipeline kiểm tra tự động chạy các kiểm tra tích hợp và đơn vị trước khi triển khai

- **Xác Minh**:
  - Sau triển khai bao gồm một danh sách kiểm tra thủ công để xác minh chức năng, các chỉ số hiệu suất, và đảm bảo các cơ chế sao lưu hoạt động.

#### 4. Các Cân Nhắc Bổ Sung

- **Sao Lưu và Dự Phòng** (Sản Xuất):
  - Chụp nhanh và sao lưu thường xuyên các cơ sở dữ liệu RDS và nội dung S3 để đảm bảo các tùy chọn khôi phục dữ liệu
  - Cấu hình triển khai dự phòng để tối đa hóa thời gian hoạt động và độ bền của ứng dụng
