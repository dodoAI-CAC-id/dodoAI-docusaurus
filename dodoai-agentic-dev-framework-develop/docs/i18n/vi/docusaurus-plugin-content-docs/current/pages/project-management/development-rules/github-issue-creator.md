---
id: github-issue-creator
title: Trình Tạo Issue Trên GitHub
---

## Tổng Quan

- Một công cụ mạnh mẽ để tạo các issue trên GitHub, được phát triển bởi Kasper và viết bằng Google Apps Script.
- Công cụ này cho phép bạn tạo nhiều issue cùng lúc dựa trên các mẫu đã được định nghĩa trước một cách nhanh chóng và dễ dàng.
- Với tính năng này, bạn có thể tiết kiệm thời gian và đảm bảo rằng các issue được tạo ra tuân thủ các quy định của SDF.

[Liên kết Trình Tạo Issue Trên GitHub](https://docs.google.com/spreadsheets/d/1riEJcvGzXSueyBU5tbjlH4DUKx2bpi4r/edit?usp=sharing&ouid=106885423561706431233&rtpof=true&sd=true)

## Tính Năng Chính

- **Tạo Nhiều Issue Cùng Lúc:** Tạo nhiều issue cùng lúc dựa trên các mẫu đã được định nghĩa trước.
- **Định Dạng Tiêu Chuẩn:** Đảm bảo rằng các issue được tạo ra tuân thủ các quy định của SDF.

## Cách Sử Dụng

Để sử dụng công cụ này, bạn cần tạo một token và thực hiện một số bước trên GitHub trước đó.

### Chuẩn Bị Trên GitHub

1. Tạo một token tại [GitHub Tokens](https://github.com/settings/tokens).

   - Nhấp vào **Generate new token**. Chọn **New personal access token (classic)**.
   - Đặt quyền.
   - Chọn **tất cả** dưới **repo**.
   - Chọn **tất cả** dưới **project**.
   - Nhấp vào **Generate token**.

2. Sao chép token đã tạo và lưu nó ở nơi an toàn.

### Các Bước Sử Dụng Công Cụ 

- Mở [Liên Kết Trình Tạo Issue Trên GitHub](https://docs.google.com/spreadsheets/d/1tVnxJzJpan8ToeOxC2yEouGM6JQuWBAFohxTXu7Bxi0/edit?gid=912739404#gid=912739404) và sao chép bảng tính này vào thư mục dự án của bạn.

1. Mở sheet "issues".
   - Nhập Tiêu Đề, Nội Dung, Nhãn, Cột Mốc (ID), và Người Được Giao Vào Trong Sheet.
   - Nhập ID Cột Mốc.
     - Đây là số ở cuối URL của cột mốc (ví dụ: `91` trong `https://github.com/58web3/dodoai/milestone/91`).

2. Chọn ô kiểm trong hàng của issue bạn muốn tạo.
   - Bạn có thể chọn tối đa 8 mục cùng lúc.
   - Chọn quá nhiều sẽ dẫn đến lỗi.

3. Nhấp vào `Scripts` -> `Create Issue` trong menu.
   - Lần đầu tiên bạn chạy điều này, sẽ xuất hiện cảnh báo nói rằng "Ứng dụng này chưa được Google xác minh." Nhấp vào "Chi tiết" để cấp quyền. Nhập AccessToken trong prompt bật lên.

4. Kiểm tra kết quả trên các issue của GitHub.

### Công cụ này giúp nhà quản lý giảm bớt công việc thủ công, tiết kiệm thời gian, và nâng cao hiệu quả trong việc quản lý dự án trên GitHub
