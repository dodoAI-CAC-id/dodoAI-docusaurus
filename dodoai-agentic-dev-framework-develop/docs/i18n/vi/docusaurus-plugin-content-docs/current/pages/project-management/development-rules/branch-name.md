---
id: branch-name
title: Tên Nhánh
---

Vui lòng thực hiện phát triển theo SDF được sử dụng nội bộ tại 58

- **BƯỚC 1**: `feature/{milestone_name}_{your_name}_{issue_number}` -> `features/{milestone_name}`.  
  Ở giai đoạn này, chỉ thực hiện kiểm thử đơn vị CI.

- **BƯỚC 2**: `features/{milestone_name}` -> `feature/v{version_number}`.  
  Ở giai đoạn này, thiết lập Cucumber CI.

- **BƯỚC 3**: `feature/v{version_number}` -> `develop` -> `main`.  
  Ở giai đoạn này, chuẩn bị cho việc phát hành.

### Quản Lý Mã Nguồn

Quản lý mã nguồn với GitHub.  
Sử dụng "main" và "develop" như là nhánh chính.  
Cũng sử dụng "feature", "release", "hotfix", và "prototype" như các nhánh hỗ trợ.

### Nhánh Chính

- **main**  
    Nhánh chính của HEAD mã nguồn, luôn phản ánh trạng thái sẵn sàng xuất xưởng dưới dạng sản phẩm. Chỉ gộp từ nhánh phát hành.

- **develop**  
    Nhánh chính của HEAD mã nguồn luôn phản ánh các thay đổi công việc phát triển mới nhất cho bản phát hành tiếp theo. Đặt đích hợp nhất PR thông thường đến nhánh phát triển.

### Nhánh Hỗ Trợ

#### feature

- Được sử dụng để phát triển các tính năng mới.
- Chia nhánh tính năng thành hai để linh hoạt đáp ứng các thay đổi trong lịch phát hành:
  - **feature**: `feature/{milestone_name}_{your_name}_{issue_number}`
  - **Document**: `doc/{your_name}_{function_name}_{issue_number}`
- Đối với các tính năng cụ thể theo phiên bản, sử dụng: `feature/v{version_number}`.

#### hotfix

Sử dụng khi cần giải quyết ngay lỗi nghiêm trọng.

- **Backend**: `bugfix/api/{your_name}_{bug}_{issue_number}`
- **Frontend**: `bugfix/frontend/{your_name}_{bug}_{issue_number}`

#### prototype

Được sử dụng khi cam kết mã mẫu cho các nhiệm vụ nghiên cứu.

- `prototype/branch_name`
