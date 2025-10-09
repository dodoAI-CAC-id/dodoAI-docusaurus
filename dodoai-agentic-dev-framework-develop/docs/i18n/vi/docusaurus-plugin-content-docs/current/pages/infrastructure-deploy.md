---
id: infrastructure-deploy
title: Triển Khai Cơ Sở Hạ Tầng
---

## Tổng Quan

Tài liệu này phác thảo quy trình triển khai một hệ thống dựa trên kịch bản đã cung cấp. Quá trình triển khai được chia thành hai phần chính: Yêu Cầu và Thực Hiện.

### Yêu Cầu

Trước khi bắt đầu quá trình triển khai, hãy đảm bảo bạn có các điều kiện tiên quyết sau:

1. **Thông Tin AWS IAM User**: Đảm bảo bạn có cặp AWS Access Key ID và Secret Access Key với đủ quyền để tạo và quản lý cơ sở hạ tầng trong AWS.

2. **Cấu Hình AWS**:
   - AWS_ACCESS_KEY_ID
   - AWS_SECRET_ACCESS_KEY
   - AWS_DEFAULT_REGION

3. **Git**: Đảm bảo rằng Git đã được cài đặt trên hệ thống của bạn và bạn đã thiết lập SSH key GitHub để sao chép kho lưu trữ.

4. **Terraform**: Đảm bảo Terraform đã được cài đặt trên hệ thống của bạn và cấu hình đúng cách.

5. **Truy Cập Kho Mã**: Đảm bảo truy cập vào kho GitHub `58web3/llm.git`.

6. **Trình Soạn Thảo Văn Bản**: Cài đặt trình soạn thảo văn bản (ví dụ: `vi`, `nano`, hoặc bất kỳ trình soạn thảo GUI nào) để sửa đổi `variables.tf`.

### Thực Hiện

Thực hiện theo các bước sau để triển khai hệ thống:

#### Bước 1: Thiết Lập Biến Môi Trường AWS

Thiết lập thông tin đăng nhập AWS và vùng mặc định bằng cách xuất các biến môi trường cần thiết:

```sh
# Thiết lập các biến môi trường AWS
export AWS_ACCESS_KEY_ID=xxxx
export AWS_SECRET_ACCESS_KEY=xxxx
export AWS_DEFAULT_REGION=ap-northeast-1
```

> *Lưu ý*: Thay `xxxx` bằng AWS Access Key và Secret Access Key thực tế của bạn.

#### Bước 2: Sao Chép Mã Cơ Sở Hạ Tầng

Sao chép kho GitHub chứa mã cơ sở hạ tầng:

```sh
# Sao chép mã infra
git clone git@github.com:58web3/llm.git
cd llm/infra
```

#### Bước 3: Cập Nhật Biến Terraform

Mở tệp `variables.tf` và cập nhật các biến cần thiết theo yêu cầu của bạn:

```sh
# Mở variables.tf để chỉnh sửa
vi variables.tf
```

#### Bước 4: Khởi Tạo Terraform

Khởi tạo thư mục làm việc Terraform để thiết lập các plugin và mô-đun cần thiết:

```sh
# Khởi tạo Terraform
terraform init
```

#### Bước 5: Tạo Và Chọn Workspace

Đảm bảo bạn đang làm việc trong workspace mong muốn. Nếu workspace không tồn tại, hãy tạo và chuyển sang nó:

```sh
# Tạo workspace mới nếu chưa tồn tại
terraform workspace new dev

# Chọn workspace
terraform workspace select dev
```

#### Bước 6: Lập Kế Hoạch Cơ Sở Hạ Tầng

Tạo một kế hoạch thực thi để xem trước các hành động mà Terraform sẽ thực hiện để khớp trạng thái mong muốn được chỉ định trong các tệp cấu hình:

```sh
# Tạo kế hoạch thực thi
terraform plan
```

#### Bước 7: Áp Dụng Kế Hoạch Terraform

Thực thi kế hoạch Terraform để tạo hoặc chỉnh sửa cơ sở hạ tầng:

```sh
# Áp dụng kế hoạch Terraform
terraform apply
```

Có thể cần xác nhận để tiến hành với bước áp dụng.
