---
id: project-management
title: Quản Lý Dự Án
---

## Quy Tắc Dự Án

### Điều Kiện Tiên Quyết

Áp dụng một phương pháp hiệu quả sau khi xem xét các thành viên hiện tại và các hạn chế về quyền truy cập.

### Quản Lý Dự Án

Sử dụng GitHub như một công cụ quản lý dự án.

#### Vấn Đề (Issue)

Khi làm việc, luôn tạo một vấn đề và quản lý công việc trên cơ sở từng vấn đề. Khi tạo một Yêu Cầu Kéo (PR), hãy chắc chắn liên kết nó với Vấn Đề.
Vấn đề bao gồm các thông tin sau.

Thường xuyên kiểm tra "ngày bắt đầu" / "ngày hết hạn" của các vấn đề, kết hợp với mức độ ưu tiên đã thiết lập trong cột "nhãn", để ưu tiên và lập lịch thời gian thực hiện cho các vấn đề.

- Đóng Vấn Đề
  Nếu vấn đề có Yêu Cầu Kéo, nó sẽ tự động đóng khi Yêu Cầu Kéo được hợp nhất.
  Nếu vấn đề không có Yêu Cầu Kéo: Sau khi hoàn thành công việc được giao, cập nhật trạng thái thành ĐÃ HOÀN THÀNH (DONE) và báo cáo cho người được giao qua một bình luận trong vấn đề hoặc Slack. Sau đó, người được giao sẽ ĐÓNG nó.

- Dự Án
  Do đặc điểm của GitHub, cần phải chọn dự án mà nó thuộc về.
- Mục Tiêu
  Mô tả mục đích của vấn đề
- Kết Quả Chính (KR)
  Xác định điều bạn có thể đạt được để đóng Vấn Đề. Trong trường hợp phát triển, mô tả mục tiêu của phát triển. Nếu là một yêu cầu, mô tả điều gì cần được làm rõ để yêu cầu có thể đóng lại.
- Người Được Giao
  Chỉ định một người chịu trách nhiệm giải quyết vấn đề. (Cơ bản nên chỉ định tối đa một người)
- Đề Xuất
  Mô tả cách giải quyết vấn đề
- Ngày Hết Hạn
  Nếu không thể nêu rõ tại thời điểm lập dự thảo, sẽ được nêu trước khi bắt đầu.
- Mốc
  Chọn Mốc. Các Mốc nên phù hợp với các Tính Năng.
- Bằng Chứng Kiểm Tra
  Đính kèm ảnh chụp màn hình cho công việc phát triển
  Ví dụ: Hình ảnh, bảng tính

#### Yêu Cầu Kéo (PR)

Bất cứ khi nào có sự thay đổi trong tài nguyên, tạo một PR.
PR nên được liên kết với một Vấn Đề. Các PR không được gắn với Vấn Đề không nên được hợp nhất bởi người đánh giá.

Khi tạo PR, bao gồm nội dung sau:

- Viết mô tả PR
- Thêm bằng chứng (video/ảnh)
- Đặt người đánh giá
- Đặt bạn là người được giao
- Liên kết với một vấn đề (1 PR : 1 Vấn Đề)
- Đính kèm URL nhật ký chạy công cụ SS, ví dụ: https://58llm.link/main/restore/5bd67ea1-ffe3-4e17-b6ba-d2366abee334

#### Tiêu Chí Hợp Nhất

Các điều kiện sau phải được đáp ứng trước khi hợp nhất:

- Luôn cần một phê duyệt bởi người đánh giá
  - 2 nhánh chính, 1 nhánh phát triển/tính năng
- Tất cả các phản hồi tại thời điểm đánh giá là "Giải quyết hội thoại"
- CI phải được thông qua
- Hoàn thành thử nghiệm và xem xét mã bởi AI Agent trên công cụ SS

#### Trạng Thái

GitHub cung cấp các trạng thái sau. Mỗi vấn đề được đặt vào trạng thái để mọi người có thể hiểu được trạng thái hiện tại của vấn đề.

- Mới, Tồn Đọng, Cần Làm, Đang Thực Hiện, Đang Xem Xét, Đã Xong

### Quản Lý Mã Nguồn

Quản lý mã nguồn với GitHub
Sử dụng "main" và "develop" làm nhánh chính.
Ngoài ra, sử dụng "feature", "release", "hotfix" và "prototype" làm các nhánh hỗ trợ.

#### Nhánh Chính

- main
  Nhánh chính của HEAD mã nguồn, luôn phản ánh trạng thái sẵn sàng xuất xưởng như một sản phẩm. Chỉ được hợp nhất từ nhánh release.
- develop
  Nhánh chính của HEAD mã nguồn luôn phản ánh thay đổi công việc phát triển mới nhất cho lần phát hành tiếp theo. Đặt đích hợp nhất PR bình thường vào nhánh phát triển (develop).

#### Nhánh Hỗ Trợ

- feature
  Sử dụng để phát triển các tính năng mới.
  Chia nhánh tính năng thành hai để phản ứng linh hoạt với thay đổi lịch trình phát hành
  - feature/feature_name
    - API: `feature/api_{function name}_#{issue_number}`
    - Frontend: `feature/frontend_{function name}_#{issue_number}`
    - Hợp Đồng Thông Minh: `feature/smartcontract_{function name}_#{issue_number}`
    - Hạ Tầng: `feature/infra_{function name}_#{issue_number}`
    - Tài Liệu: `feature/doc_{function name}_#{issue_number}`
  - Nếu đó là phát triển chức năng, nó khớp với tên Epic.
  - Chỉ tồn tại trong kho lưu trữ của nhà phát triển, không phải trong gốc. Đích hợp nhất là feature_name ở trên
- release *DỰ ÁN NÀY KHÔNG SỬ DỤNG*
  Nhánh release là một nhánh để chuẩn bị phát hành. Gắn thẻ nhánh phát hành. Nó thậm chí chuẩn bị dữ liệu meta (số phiên bản, ngày xây dựng, v.v.) cho phát hành.
- hotfix
  Sử dụng khi cần giải quyết ngay lập tức một lỗi nghiêm trọng. Tạo từ nhánh chính (master).
- prototype
  Sử dụng khi cam kết mã mẫu cho các nhiệm vụ nghiên cứu

### Quản Lý Tiến Độ

Quản lý tiến độ của bạn bằng cách sử dụng bảng dự án của GitHub & Notion.

### Quản Lý Nhiệm Vụ

Dưới đánh giá các nhiệm vụ phát triển. Khi bạn tạo một PR, hãy:

- Viết mô tả PR
- Thêm bằng chứng (video/hình ảnh)
- Đặt người đánh giá
- Đặt bạn là người được giao
- Liên kết tới một vấn đề (1 PR : 1 Vấn Đề)
- Đính kèm URL nhật ký công cụ SS, ví dụ: https://58llm.link/main/restore/5bd67ea1-ffe3-4e17-b6ba-d2366abee334

- Đang Chờ Triển Khai
  Đang chờ phản ánh trong môi trường sản xuất
- Đã Xong
  Đặt các Vấn Đề đã hoàn thành.

## Quản Lý Phiên Bản

### Phương Pháp Ký Hiệu

Sử dụng phương pháp ký hiệu sau `vX.Y.Z`
Ví dụ: v1.2.3

### Quản Lý Phiên Bản Tài Liệu

Quản lý phiên bản tài liệu chương trình như sau.

- X: Phiên Bản Chính
  Thay đổi lớn và thêm trang ảnh hưởng đến diện mạo và khả năng hoạt động
- Y: Phiên Bản Phụ
  Cải tiến chức năng chi tiết, bổ sung thông tin từng phần, sửa lỗi trên trang, v.v.
- Z: Phiên Bản Vá Lỗi
  Sửa lỗi, lỗi chính tả, v.v.

### Ghi Chú Phát Hành

Ghi chú phát hành được quản lý dưới đây

Bao gồm các mục sau trong ghi chú phát hành

- Các Cải Tiến
- Cải Thiện
- Tài Liệu

## Bài Học Rút Ra

- **Sự Phù Hợp**: Khi được yêu cầu thực hiện một nhiệm vụ, hãy đảm bảo bạn hiểu đầy đủ yêu cầu.
  (ví dụ: đặt câu hỏi như điểm đau / cái gì / tại sao / làm thế nào để hiểu đầy đủ bối cảnh của yêu cầu)
