---
id: pull-request-review
title: Yêu Cầu Kéo & Đánh Giá
---

## Tổng Quan

- `feature/{milestone_name}_{your_name}_{issue_number}` → `features/{milestone_name}`
- `features/{milestone_name}` → `feature/v{version_number}`
- `feature/v{version_number}` → develop → main

## Lưu Ý Khi Đánh Giá PR

- Đối với mỗi tệp đã chỉnh sửa trong PR, cần có một nhật ký yêu cầu dodoAI xem xét tệp đó.
- Quy Trình Đánh Giá:
  - Sử dụng tính năng *Code review* trong *ứng dụng dodoAI* để chọn tất cả các tệp đã chỉnh sửa trong PR để AI đánh giá. Sau đó, yêu cầu một đánh giá chi tiết cho từng tệp bằng cách thêm "Đánh giá chi tiết cho tệp xxxx.yyy" vào phần Thêm Gợi Ý. Tiếp tục quá trình này cho từng tệp cho đến khi tất cả đã được đánh giá.
  - Nếu sử dụng mẫu đánh giá trên web, hãy đánh giá từng tệp theo thứ tự cho đến khi tất cả các tệp đã chỉnh sửa trong PR đã được đánh giá.
- Xem xét ***mã đề xuất*** của AI, tích hợp các đề xuất cần thiết, hoặc cung cấp lý do cho việc không bao gồm một số đề xuất nếu bị người đánh giá đặt câu hỏi.

## Yêu Cầu Kéo (PR)

### Khi tạo PR, đảm bảo các điểm sau được bao gồm

- Điền Tiêu Đề và Mô Tả PR: Cung cấp tổng quan về các thay đổi và liên kết đến Vấn Đề liên quan (1 PR: 1 Vấn Đề).
- Khi tạo PR, nếu bạn thêm `Close #issue_id` trong Mô Tả, issue sẽ được đóng tự động sau khi hợp nhất.
- Ghi Chú (nếu cần): Ghi lại bất kỳ yêu cầu hoặc cấu hình cần thiết liên quan đến thứ tự hợp nhất PR.
- URL DodoAI:
  Bao gồm URL của nhật ký công cụ LLM đã sử dụng trong quá trình phát triển và tự đánh giá trong mô tả PR.
- Bằng Chứng (Bằng Chứng Ảnh Chụp Màn Hình):
  Đính kèm ảnh chụp màn hình hiển thị các thay đổi hoặc sửa lỗi.
- Thiết Lập Người Đánh Giá: Chỉ định người đánh giá cho PR.
- Tự Gán Bản Thân Là Người Thực Hiện:
  Thiết lập bản thân là người chịu trách nhiệm cho PR.

## Mẫu PR

```markdown
## Ghi Chú (nếu cần thiết)
- Ghi lại CÁC GHI CHÚ và yêu cầu liên quan đến thứ tự hợp nhất PR hoặc bất kỳ cấu hình cần thiết nào.

## Mô Tả
- Viết lại tóm tắt các nhiệm vụ đã thực hiện cho vấn đề này và mục tiêu của nó.

## Nhật Ký dodoAI
- Cung cấp nhật ký của dodoAI trong quá trình phát triển và tự xem trước.

## Bằng Chứng
- Bao gồm ảnh chụp màn hình hiển thị thay đổi hoặc sửa lỗi.
```

## Đánh Giá PR

### Quy Tắc Hợp Nhất

- PR không liên quan đến một Vấn Đề cụ thể không nên được người xem xét hợp nhất.
- Các vấn đề liên quan đến frontend hoặc backend sẽ được trưởng nhóm hợp nhất. `feature/{milestone_name}_{your_name}_{issue_number}` → `features/{milestone_name}`
- Quản lý (PdM/PM) sẽ hợp nhất `features/{milestone_name}` → `feature/v{version_number}`.
- Các vấn đề liên quan đến thiết kế và kiểm thử hệ thống sẽ được quản lý (Quản lý, PdM/PM) hợp nhất.
- Nếu hợp nhất một nhánh vào `features/{milestone_name}`, ít nhất 1 phê duyệt từ người đánh giá cần để thực hiện hợp nhất.
- Nếu hợp nhất vào `develop` hoặc `main`, cần ít nhất 2 phê duyệt từ người đánh giá để tiến hành hợp nhất.

#### Quy Trình Đánh Giá Và Hợp Nhất PR

- Sau khi phát triển hoàn tất, nhà phát triển sẽ tạo PR từ `feature/{milestone_name}_{your_name}_{issue_number}` → `features/{milestone_name}`.
  - Sau đó yêu cầu đánh giá chéo từ các nhà phát triển khác và trưởng nhóm.

#### Trưởng Nhóm

- Xem xét mã nguồn.
- Hợp nhất PR: `feature/{milestone_name}_{your_name}_{issue_number}` → `features/{milestone_name}`.

#### Kiểm Thử Viên

- Sau khi nhánh `features/{milestone_name}` được hợp nhất vào `feature/v{version_number}`, kiểm thử hệ thống sẽ được thực hiện theo các kịch bản kiểm thử đã được tạo và xem xét trước đó.
- Ghi lại lỗi vào bảng kịch bản kiểm thử, thảo luận với nhà phát triển và tạo vấn đề để giải quyết nếu cần.
- Sau đó báo cáo cho quản lý (PM và PdM), người sẽ kiểm tra lại.
- Nếu mọi thứ ổn, quản lý sẽ yêu cầu tạo một vấn đề yêu cầu đẩy `feature/v{version_number}` vào nhánh `main`.

#### Trưởng Nhóm

- Tạo một yêu cầu kéo để tải lên `features/{milestone_name}` đến nhánh `feature/v{version_number}`.

#### Quản Lý (PdM/PM)

- Xem xét và hợp nhất vào nhánh chính: `feature/v{version_number}` → develop → main.

#### Kiểm Tra Sau Triển Khai (Quản Lý)

- Xác Nhận Tính Năng: Đảm bảo tính năng mới đã được phản ánh.
- Độ Khả Dụng Của Hệ Thống: Đảm bảo hệ thống vẫn hoạt động bình thường.
