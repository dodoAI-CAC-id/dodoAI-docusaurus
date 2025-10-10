---
id: system-test-scenario
title: Kịch Bản Kiểm Thử Hệ Thống
---

## Tổng Quan

Kịch bản kiểm thử hệ thống là các điều kiện cụ thể dưới đó chức năng của Công Cụ SS được kiểm tra để đảm bảo nó đáp ứng các yêu cầu và xử lý hiệu quả việc sử dụng thực tế. Hướng dẫn này sẽ giúp bạn tạo ra các kịch bản kiểm thử hệ thống toàn diện để xác nhận hiệu suất, độ tin cậy, và trải nghiệm người dùng của Công Cụ SS.

### Mục Tiêu

1. Xác định và tạo ra các kịch bản kiểm thử phù hợp cho Công Cụ SS.
2. Đảm bảo bao gồm cả các trường hợp phổ biến và cận biên.
3. Xác nhận hành vi hệ thống dưới các điều kiện khác nhau.
4. Tạo điều kiện thuận lợi cho việc xác định và giải quyết các lỗi.

### Điều Kiện Tiên Quyết

1. **Hiểu Rõ Yêu Cầu**: Nắm vững các yêu cầu chức năng và phi chức năng của Công Cụ SS.
2. **Môi Trường Kiểm Thử**: Thiết lập môi trường kiểm thử tương tự như môi trường sản xuất.
3. **Công Cụ Và Tài Nguyên**: Truy cập vào các công cụ kiểm thử, hệ thống quản lý phiên bản, tài liệu và hệ thống theo dõi.

### Các Bước Tạo Kịch Bản Kiểm Thử Hệ Thống

#### 1. **Tạo Bảng Tính Kiểm Thử Hệ Thống**

- Google Drive: [Link Tới Thư Mục](https://drive.google.com/drive/u/0/folders/1FpflrG5xnI45tUBSwmk4yGtHMeib63JW).
- Mẫu: [Link Tới Mẫu](https://docs.google.com/spreadsheets/d/1VAxdjk2Z78qCM5vyw3UUcol3pAhEfOE29ZivAdjeWfQ/edit#gid=0).

#### 2. **Tạo Kịch Bản Kiểm Thử Dựa Trên Tài Liệu**

- Tham Khảo Wireframe để làm rõ định nghĩa yêu cầu và thiết kế hệ thống: [Link Wireframe](https://miro.com/app/board/uXjVNhdn81M=/).
- Quan sát tất cả các yêu cầu chức năng chi tiết trong **Tài Liệu Script Sculptor (LLM)**: [Link Tài Liệu](https://docs.google.com/document/d/1RJWlEsyMTTdm4l5ja_uJN-xteCyY-aHPkPc-Pl-j7lY/edit#heading=h.3jtkuymjv6xi).
- Dựa trên danh sách user story, chi tiết luồng của mỗi chức năng: [Link Danh Sách](https://docs.google.com/spreadsheets/d/1kURKsfy2XeguJnUo4cXGgNYaTeWzJ2WsMLAO5uYoSJo/edit?gid=1310947896#gid=1310947896).
- Tham Khảo Thiết Kế Hệ Thống Giao Diện Người Dùng (Miro): [Link Thiết Kế](https://miro.com/app/board/uXjVKaNTLsQ=/) & [Link Khác](https://miro.com/app/board/uXjVMvA1mqE=).

#### 3. **Tạo Chi Tiết Các Kịch Bản Kiểm Thử**

- **Kịch Bản Thông Thường**: Các tương tác của người dùng phổ biến khi mọi thứ hoạt động như mong đợi.
- **Kịch Bản Thay Thế**: Các tình huống khi một đường dẫn không mong đợi hoặc hành động thay thế được thực hiện.
- **Trường Hợp Cận Biên**: Các điều kiện hiếm hoặc cực đoan có thể khiến hệ thống hành xử không thể đoán trước.
- **Kịch Bản Tiêu Cực**: Các tình huống kiểm thử khả năng của hệ thống để xử lý đầu vào hoặc hành động không hợp lệ một cách nhẹ nhàng.

### Mẫu Các Kịch Bản Kiểm Thử

#### Kỹ Năng Hội Thoại Cốt Lõi

1. **Gõ Tự Do Câu Lệnh Của Bạn**

   - **Kịch Bản**: Người dùng đặt câu hỏi trực tiếp (VD: "Thủ đô của Pháp là gì?")
   - **Kết Quả Mong Đợi**: Công Cụ SS trả lời chính xác ("Thủ đô của Pháp là Paris.")

2. **Đánh Giá Yêu Cầu Kéo**

   - **Kịch Bản**: Người dùng yêu cầu Công Cụ SS xem xét Yêu Cầu Kéo
   - **Kết Quả Mong Đợi**: Công Cụ SS sẽ xem xét chi tiết những gì sai cần sửa và những gì tốt cần duy trì, đánh giá sẽ xác định và phân loại một loạt các vấn đề bao gồm lỗi tiềm ẩn, điểm nghẽn hiệu suất, lỗ hổng bảo mật, tuân thủ các tiêu chuẩn mã hóa, và thực tiễn tốt nhất trong thiết kế phần mềm.

#### Tính Năng Đặc Biệt

1. **Đăng Ký Vấn Đề Với Hình Ảnh UI**

   - **Kịch Bản**: Đăng Vấn Đề trên Github. Cập nhật nội dung Mẫu Vấn Đề dựa trên các đầu vào và hình ảnh UI (nếu có)
   - **Kết Quả Mong Đợi**: Đầu ra phải tuân theo Mẫu Vấn Đề và được viết bằng markdown. Không cần đầu ra ngoại trừ thông tin trên tệp hoàn chỉnh.

...

*Vui lòng tiếp tục sử dụng mẫu này để hoàn thành các kịch bản và chi tiết khác như trong tài liệu gốc.*

### Tài Liệu Kịch Bản

- **Mã Kịch Bản**: Một mã định danh duy nhất cho mỗi kịch bản kiểm thử.
- **Điều Kiện Tiên Quyết**: Bất kỳ thiết lập nào cần thiết trước khi thực thi kịch bản.
- **Các Bước Kiểm Thử**: Các bước chi tiết thực hiện kịch bản.
- **Kết Quả Mong Đợi**: Kết quả mong đợi cho mỗi bước.
- **Kết Quả Thực Tế**: Kết quả thực tế khi kiểm thử.
- **Trạng Thái**: Trạng thái đạt hoặc không đạt sau khi kiểm thử.
- **Nhận Xét**: Bất kỳ quan sát hoặc ghi chú bổ sung nào.

### Thực Hành Tốt Nhất

1. **Ưu Tiên Kịch Bản**: Tập trung trước vào các trường hợp sử dụng có tác động cao và tần suất sử dụng cao.
2. **Cập Nhật Thường Xuyên**: Giữ kịch bản cập nhật khi các tính năng mới được thêm vào hoặc các tính năng hiện có bị sửa đổi.
3. **Tự Động Hóa**: Tự động hóa các kịch bản được thực thi thường xuyên hoặc phức tạp để tiết kiệm thời gian.
4. **Đánh Giá Đồng Nghiệp**: Có các kịch bản được đánh giá bởi các thành viên khác trong nhóm để đảm bảo tính đầy đủ và độ chính xác.

### Kết Luận

Tạo các kịch bản kiểm thử hệ thống toàn diện cho Công Cụ SS đảm bảo hệ thống được xác thực kỹ lưỡng để xử lý các điều kiện và tương tác người dùng thực tế khác nhau. Bằng cách theo dõi hướng dẫn này, bạn có thể bao phủ một cách hệ thống các khía cạnh khác nhau của chức năng, hiệu suất và bảo mật của Công Cụ SS, nhờ đó cung cấp một giải pháp AI mạnh mẽ và đáng tin cậy.
