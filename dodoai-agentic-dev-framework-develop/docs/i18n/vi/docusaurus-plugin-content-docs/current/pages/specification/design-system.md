---
id: design-system
title: Hệ Thống Thiết Kế
---

## Tổng Quan Và Mục Đích Của Hệ Thống Thiết Kế

### Tổng Quan

Hệ Thống Thiết Kế dodoAI tồn tại để tránh việc "tái phát minh bánh xe" trong phát triển giao diện, đảm bảo rằng các thành phần tiêu chuẩn và thông dụng được sử dụng nhất quán. Điều này giúp giảm chi phí phát triển không cần thiết và nợ kỹ thuật, đồng thời nâng cao chất lượng sản phẩm và tính nhất quán của thương hiệu.

### Mục Đích

- **Đảm Bảo Tính Nhất Quán**: Đạt được thiết kế và trải nghiệm người dùng đồng nhất trên tất cả sản phẩm và nền tảng.
- **Phát Triển Hiệu Quả**: Tăng năng suất và giảm thời gian phát triển bằng cách tái sử dụng các thành phần tiêu chuẩn.
- **Giảm Nợ Kỹ Thuật**: Nền tảng phát triển hợp nhất giúp giảm chi phí bảo trì và gánh nặng kỹ thuật trong tương lai.

## Người Dùng Dự Kiến

Hệ Thống Thiết Kế dodoAI dành cho các đối tượng sau:

- **Nhà Thiết Kế**
- **Nhà Phát Triển (đặc biệt là kỹ sư giao diện)**
- **Người lập kế hoạch dịch vụ và kiến trúc sư thông tin**

## Cách Sử Dụng

Hệ Thống Thiết Kế dodoAI bao gồm ba yếu tố chính sau:

*Truy cập hệ thống thiết kế tại đây:*

[https://www.figma.com/design/8JwpYsftZbjYfJDKxSm5IZ/dodoAI-Design-System?node-id=753-2670&node-type=canvas&t=QT5ixNjWWNw3tGPG-0](https://www.figma.com/design/8JwpYsftZbjYfJDKxSm5IZ/dodoAI-Design-System?node-id=753-2670&node-type=canvas&t=QT5ixNjWWNw3tGPG-0)

#### 1. Hướng Dẫn Sử Dụng

- Cung cấp cái nhìn tổng quan về cách sử dụng và vận hành hệ thống thiết kế.

#### 2. Thiết Kế Thành Phần

- **Sử Dụng Các Thành Phần Hiện Có**: Trong phát triển giao diện, việc sử dụng một trong những thành phần UI được định nghĩa trong tài liệu thiết kế này là cần thiết, đảm bảo tính nhất quán về thiết kế và chức năng.

- **Sử Dụng Mã Nguồn Từ Widgetbook**: Mã nguồn cho các thành phần UI được sử dụng bởi nhà phát triển luôn từ Widgetbook, là một danh mục UI với các hướng dẫn phong cách được áp dụng, cung cấp mã nguồn tin cậy.

- **Thêm Thành Phần UI Mới**:
    1. **Thêm Vào Tài Liệu Thiết Kế**: Đầu tiên, thêm thiết kế mới vào tài liệu này.
    2. **Sử Dụng Figma Để Xuất Mã**: Xuất mã nguồn sử dụng Figma Để Xuất Mã.
    3. **Định Nghĩa Trong Widgetbook**: Định nghĩa mã nguồn đã xuất trong Widgetbook để nó có sẵn cho các nhà phát triển khác.

#### 3. Hướng Dẫn Phong Cách

- **Tuân Thủ Phong Cách**: Để duy trì chất lượng và thương hiệu của sản phẩm dodoAI nhất quán, tuân thủ các phong cách được định nghĩa trong hướng dẫn này, bao gồm các yếu tố như màu sắc, kiểu chữ, biểu tượng, và bố cục.

- **Hướng Dẫn Cho Thiết Kế Mới**: Khi thêm thiết kế mới, luôn tuân thủ theo hướng dẫn phong cách này để đảm bảo tính nhất quán thương hiệu trên các thành phần hoặc trang mới.

- **Vai Trò Của Nhà Phát Triển**: Các nhà phát triển giao diện thường tham khảo hướng dẫn phong cách này một cách gián tiếp bằng cách sử dụng các thành phần từ Widgetbook. Nhà phát triển nên tránh thực hiện tùy chỉnh UI và nếu cần một thành phần mới, họ nên yêu cầu nhà thiết kế tạo ra thiết kế.

#### 4. Thư Viện Tài Sản

- **Sử Dụng Đúng Cách**: Khi sử dụng logo, luôn xuất nó từ thư viện tài sản này với kích thước và định dạng thích hợp. Việc sử dụng không đúng cách có thể ảnh hưởng lớn đến chất lượng sản phẩm và hình ảnh thương hiệu.

- **Tuân Thủ Nghiêm Ngặt**: Hiểu và tuân thủ các quy định về xử lý logo và tài sản thương hiệu, bao gồm cấm thay đổi màu sắc hoặc tỷ lệ.

### Sử Dụng Theo Người Dùng Dự Kiến

Dựa trên người dùng dự kiến và vai trò của họ, việc sử dụng Hệ Thống Thiết Kế dodoAI có thể khác nhau. Dưới đây là các phương pháp sử dụng cơ bản:

| **Người Dùng Dự Kiến**                        | **Cách Sử Dụng**                                                                                                                                                                                                                          |
|----------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Nhà Thiết Kế**                             | <ul><li>Nhà thiết kế có thể đơn giản hóa thiết kế màn hình bằng cách chọn và chỉnh sửa các thành phần từ hệ thống thiết kế, thay vì tạo từng phần từ đầu.</li><li>Nhiều tài nguyên có thể được phân bổ cho việc lập kế hoạch thiết kế màn hình thay vì tạo từng phần.</li><li>Hướng dẫn truy cập có sẵn để tham khảo nhanh chóng trong quá trình thiết kế.</li></ul> |
| **Nhà Phát Triển**                            | <ul><li>Khi lập trình màn hình hoặc chuyển đổi màn hình, các thông số rõ ràng của thành phần giúp viết mã dễ dàng hơn.</li><li>Các mẫu, khi có sẵn, có thể được mã hóa trước để tăng cường hiệu quả công việc tiếp theo.</li><li>Các đoạn mã cho phép nhà phát triển chỉnh sửa mã hiện có thay vì tạo mã thành phần từ đầu.</li><li>Hướng dẫn truy cập có sẵn để tham khảo nhanh chóng trong quá trình phát triển.</li></ul> |
| **Người Lập Kế Hoạch Trang Web/Kiến Trúc Sư Thông Tin** | <ul><li>Các thành phần trong hệ thống thiết kế có thể được sử dụng khi tạo hình ảnh màn hình.</li><li>Sử dụng các mẫu có thể loại bỏ nhu cầu tạo hình ảnh màn hình từ đầu.</li><li>Hướng dẫn truy cập có sẵn, cho phép người lập kế hoạch cân nhắc về truy cập từ giai đoạn lập kế hoạch.</li></ul> |
| **Người Lập Kế Hoạch Đặc Tả Mua Sắm**     | <ul><li>Bằng cách đặt hệ thống thiết kế làm yêu cầu hoặc tiêu chí chấp nhận, có thể duy trì sự quản lý đối với các nhà thầu.</li><li>Hệ thống thiết kế bao gồm nhiều cân nhắc về truy cập, giúp đảm bảo tuân thủ truy cập.</li></ul> |

---

## Hướng Dẫn Vận Hành Hệ Thống Thiết Kế

- **Duy Trì Tính Nhất Quán**: Tuân thủ hướng dẫn phong cách, sử dụng các thành phần và phong cách hiện có bất cứ khi nào có thể để duy trì sự nhất quán trong thiết kế và phát triển.
- **Giao Tiếp**: Đảm bảo giao tiếp chặt chẽ giữa các nhà thiết kế và phát triển, chia sẻ yêu cầu và cập nhật rõ ràng.
- **Cập Nhật Widgetbook**: Khi hệ thống thiết kế được cập nhật, đảm bảo Widgetbook cũng được cập nhật.

#### Ghi Chú Cho Nhà Phát Triển

- **Tránh Thực Hiện Tùy Chỉnh**: Các nhà phát triển giao diện nên tránh tự thực hiện UI độc lập. Nếu không có thành phần nào tồn tại, hãy yêu cầu nhà thiết kế tạo thiết kế mới.
- **Duy Trì Tính Nhất Quán Thiết Kế**: Nhà phát triển nên sử dụng các thành phần từ Widgetbook trực tiếp, đảm bảo tính nhất quán với thiết kế.
- **Các Bước Thêm Thành Phần Bổ Sung**:
  - Xác nhận sự cần thiết: Kido-san, Ichikawa
  - Phê duyệt: Murakami-san
  - Ichikawa gán nhiệm vụ cho nhà thiết kế để ước tính và yêu cầu công việc
  - Khi thiết kế hoàn thành, thêm vào hệ thống thiết kế
  - Tạo vấn đề thành phần mới cho Widgetbook cho nhà phát triển
  - Ánh xạ thành phần mới dựa trên hệ thống thiết kế trong Widgetbook
  - Tạo một vấn đề cho nhà phát triển sử dụng thành phần mới trong Widgetbook
