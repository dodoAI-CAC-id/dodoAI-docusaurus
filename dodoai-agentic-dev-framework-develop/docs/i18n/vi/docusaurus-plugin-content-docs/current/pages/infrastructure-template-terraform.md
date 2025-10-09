---
id: infrastructure-template-terraform
title: Mẫu Cơ Sở Hạ Tầng (Terraform)
---

## Mã Terraform

Để có được Terraform, làm theo các bước dưới đây

```markdown
git clone git@github.com:58web3/llm.git
cd llm/infra
```

## Tài Liệu Mô Tả Tệp Terraform

Dưới đây là danh sách thư mục và giải thích về nội dung cũng như mục đích của mỗi tệp:

```markdown
├── be.tf
├── ecs-cluster.tf
├── fe.tf
├── locals.tf
├── main.tf
├── output.tf
├── service-roles.tf
├── variables.tf
└── vpc-alb.tf
```

### Mô Tả Tệp

#### 1. `be.tf`

**Mục Đích:**
'be' là viết tắt thường dùng cho "backend".
**Nội Dung:**

- Định nghĩa thông số kỹ thuật máy chủ phía sau, cấu hình, dịch vụ.

#### 2. `ecs-cluster.tf`

**Mục Đích:**
Tệp này định nghĩa và quản lý cấu hình đặc thù cho cụm AWS ECS (Elastic Container Service).
**Nội Dung:**

- Tạo và cấu hình cụm ECS.
- Có thể tích hợp với các định nghĩa và dịch vụ nhiệm vụ ECS.

#### 3. `fe.tf`

**Mục Đích:**
'fe' thường đại diện cho "front-end".
**Nội Dung:**

- Định nghĩa thông số kỹ thuật máy chủ phía trước, cấu hình, dịch vụ.

#### 4. `locals.tf`

**Mục Đích:**
Chứa các giá trị cục bộ đơn giản hóa định nghĩa tài nguyên và tra cứu dữ liệu trong dự án.
**Nội Dung:**

- Các giá trị cục bộ thường được tái sử dụng trong nhiều tài nguyên hoặc mô-đun.
- Giúp định nghĩa các giá trị có thể lặp lại và tái sử dụng như nhãn, tên và cấu hình chung.

#### 5. `main.tf`

**Mục Đích:**
Điểm nhập cho kế hoạch thực thi Terraform; nó thường điều phối thiết lập toàn bộ cơ sở hạ tầng.
**Nội Dung:**

- Bao gồm cấu hình chính để khai báo các cấu hình của nhà cung cấp.

#### 6. `output.tf`

**Mục Đích:**
Định nghĩa các kết quả đầu ra cho trạng thái Terraform.
**Nội Dung:**

- Các khối đầu ra tạo ra thông tin cụ thể về ALB, ECS.

#### 7. `service-roles.tf`

**Mục Đích:**
Định nghĩa các vai trò và quyền cho các dịch vụ khác nhau trong cơ sở hạ tầng.
**Nội Dung:**

- Vai trò IAM, chính sách cho dịch vụ ecs.

#### 8. `variables.tf`

**Mục Đích:**
Tệp này được sử dụng để khai báo và định nghĩa các biến đầu vào.
**Nội Dung:**

- Định nghĩa biến bao gồm các giới hạn kiểu, giá trị mặc định và mô tả.

#### 9. `vpc-alb.tf`

**Mục Đích:**
Định nghĩa các thành phần Đám Mây Riêng Ảo (VPC) và Bộ Cân Bằng Tải Ứng Dụng (ALB).
**Nội Dung:**

- Cấu hình và quản lý VPC, subnets, bảng điều hướng, và bất kỳ yêu cầu mạng nào.
- Định nghĩa ALB, bao gồm các nhóm mục tiêu, listeners, và quy tắc listener.
- Cài đặt nhóm bảo mật cụ thể cho mạng và cân bằng tải.
