---
id: github-milestone-setup
title: Thiết Lập Cột Mốc Trên GitHub
---

## Đăng Ký Cột Mốc Trong GitHub

Liên kết các nhiệm vụ phát triển cấp 1 đã đăng ký trong Notion với các cột mốc trong GitHub. Đặt ngày kết thúc của cột mốc theo ngày kết thúc của nhiệm vụ phát triển cấp 1 trong Notion.

Mỗi nhiệm vụ cấp 1 nên liên kết trực tiếp với cột mốc tương ứng.
Các nhiệm vụ phát triển chi tiết hơn (cấp 2) được định nghĩa dưới dạng các vấn đề trong GitHub.

Tham khảo SDF để biết các nhiệm vụ cần được đăng ký.
[Miro SDF](https://miro.com/app/board/uXjVNhdn81M=/?moveToWidget=3458764589861350205&cot=14)

## Đăng Ký Vấn Đề Trong GitHub

Khi đăng ký các nhiệm vụ dựa trên SDF, hãy chắc chắn tuân theo những hướng dẫn sau đây:

- Nếu việc tạo vấn đề cho mỗi tính năng gây phiền phức, có sẵn một Công Cụ Đăng Ký Vấn Đề sử dụng Google App Script (Gas). [Trình Tạo Vấn Đề Trên GitHub](https://docs.google.com/spreadsheets/d/1tVnxJzJpan8ToeOxC2yEouGM6JQuWBAFohxTXu7Bxi0/edit?gid=912739404#gid=912739404)
- Nếu bạn muốn sử dụng công cụ đó, hãy hỏi kĩ sư dẫn dắt trong nhóm.

- Định Nghĩa Yêu Cầu và Nhiệm Vụ Thiết Kế
  - Một nhiệm vụ cho toàn bộ dự án là đủ.
- Nhiệm Vụ Phát Triển
  - Cần được đăng ký cho từng tính năng.

**Lưu Ý Quan Trọng Về Kích Thước Vấn Đề**

Tại 58, phát triển chủ yếu được thực hiện bằng AI. Để đảm bảo hiệu quả của Các Tác Nhân AI, tuân theo các điều sau:

- 1 Vấn Đề = 1 PR. Kích thước phát triển lớn hơn trong các vấn đề làm giảm hiệu quả đánh giá và cuối cùng giảm chất lượng.
- Số bước lý tưởng cho một tệp là dưới 100 dòng. Bằng cách luôn xuất mã hoàn chỉnh, tự động hóa AI bởi Các Tác Nhân AI trở nên khả thi. Luôn hướng tới việc tối ưu hóa kích thước tệp. Nếu số bước trở nên lớn, hãy xem xét liệu nó có thể được mô đun hóa và chia nhỏ tệp. Điều này cũng cải thiện khả năng duy trì.
