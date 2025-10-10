---
id: system-test
title: Kiểm Thử Hệ Thống
---

## Hướng Dẫn Kiểm Thử Hệ Thống Cho Dodo AI

### Giới Thiệu

Kiểm Thử Hệ Thống là một giai đoạn quan trọng trong vòng đời phát triển của dodo AI, đảm bảo rằng hệ thống hoạt động từ đầu đến cuối theo yêu cầu. Hướng dẫn này sẽ cung cấp cách tiếp cận có cấu trúc để thực hiện kiểm thử hệ thống cho dodo AI.

### Mục Tiêu

1. Xác nhận chức năng tổng thể của dodo AI.
2. Đảm bảo hệ thống đáp ứng các yêu cầu đã định rõ.
3. Xác định và giải quyết các lỗi trước khi triển khai.

### Lập Kế Hoạch Kiểm Thử

1. **Xác Định Phạm Vi**: Lên danh sách các tính năng và thành phần cần được kiểm thử.
2. **Xác Định Các Trường Hợp Kiểm Thử**: Viết các trường hợp kiểm thử chi tiết bao gồm tất cả các chức năng, kể cả các trường hợp tới hạn.

### Quy Trình Kiểm Thử

#### 1. **Kiểm Thử Chức Năng**

##### **Dựa Trên Danh Sách User Story**: Kiểm thử các kịch bản hội thoại khác nhau dựa trên user story

###### Ví Dụ

| Phân Loại               | #  | Tên Câu Chuyện                | Hành Động                                                     | Mục Đích                                                                      |
|-------------------------|----|-------------------------------|----------------------------------------------------------------|------------------------------------------------------------------------------|
| Quản Lý Mẫu             | 1  | Tìm Kiếm Nhiệm Vụ             | Chọn danh mục, nhập từ khóa, nhấp vào nút tìm kiếm             | Tìm kiếm các nhiệm vụ dựa trên danh mục hoặc từ khóa cụ thể                  |
| Quản Lý Mẫu             | 2  | Thêm Nhiệm Vụ                 | Nhấp vào nút "Thêm" trên màn hình danh sách nhiệm vụ           | Tạo nhiệm vụ mới                                                              |
| Quản Lý Mẫu             | 3  | Chỉnh Sửa Nhiệm Vụ            | Chọn nhiệm vụ muốn chỉnh sửa từ danh sách nhiệm vụ             | Chuyển đến màn hình chỉnh sửa nội dung nhiệm vụ                               |
| Quản Lý Mẫu             | 4  | Nhập Thông Tin Nhiệm Vụ       | Nhập tên nhiệm vụ, danh mục và dự án liên quan                 | Chỉnh sửa thông tin nhiệm vụ                                                  |
| Quản Lý Mẫu             | 5  | Thêm Mẫu                      | Nhấn nút [+] trên màn hình chỉnh sửa nhiệm vụ                   | Thêm mẫu liên kết với nhiệm vụ                                                |
| Quản Lý Mẫu             | 6  | Chỉnh Sửa Mẫu                 | Nhập tên mẫu và nội dung                                       | Chỉnh sửa nội dung mẫu liên kết với nhiệm vụ                                   |
| Quản Lý Mẫu             | 7  | Xóa Mẫu                       | Nhấn nút [×] trên màn hình chỉnh sửa nhiệm vụ                   | Xóa mẫu liên kết với nhiệm vụ                                                |
| Quản Lý Mẫu             | 8  | Thêm Tải Ảnh                  | Nhấn vào biểu tượng hình ảnh trên màn hình chỉnh sửa nhiệm vụ   | Thêm chức năng tải ảnh liên quan đến nhiệm vụ                                 |
| Quản Lý Mẫu             | 9  | Lưu Nhiệm Vụ                  | Nhấp vào nút "Lưu" trên màn hình chỉnh sửa nhiệm vụ             | Lưu thông tin nhiệm vụ và các mẫu liên kết                                    |
| Quản Lý Mẫu             | 10 | Xóa Nhiệm Vụ                  | Nhấp vào nút "Xóa" trên màn hình chỉnh sửa nhiệm vụ             | Xóa nhiệm vụ và mẫu liên kết                                                  |
| Quản Lý Dự Án           | 11 | Tìm Kiếm Dự Án                | Nhập tên dự án hoặc từ khóa và nhấp nút tìm kiếm                | Tìm dự án phù hợp với dự án hoặc tiêu chí tìm kiếm cụ thể                     |
| Quản Lý Dự Án           | 12 | Thêm Dự Án                    | Nhấp vào nút tạo dự án mới                                     | Thêm dự án mới vào hệ thống                                                  |
| Quản Lý Dự Án           | 13 | Chi Tiết Dự Án                | Chọn dự án muốn chỉnh sửa                                      | Kiểm tra chi tiết dự án                                                      |
| Quản Lý Dự Án           | 14 | Xóa Dự Án                     | Chọn dự án muốn và nhấp vào nút xóa                            | Xóa các dự án không còn cần thiết khỏi hệ thống                               |
| Quản Lý Dự Án           | 15 | Thêm Thành Viên Dự Án         | Nhấp vào nút Thêm và chọn thành viên muốn thêm                 | Thêm thành viên mới vào dự án                                                |
| Quản Lý Dự Án           | 16 | Xóa Thành Viên Dự Án          | Chọn danh sách thành viên và nhấp vào nút xóa                  | Loại bỏ thành viên khỏi một dự án                                            |
| Quản Lý Nhật Ký         | 17 | Xem Danh Sách Nhật Ký         | Nhấp vào nút Quản Lý Nhật Ký trong menu                        | Xem danh sách nhật ký                                                        |
| Quản Lý Nhật Ký         | 18 | Chọn Dự Án                    | Chọn một dự án                                                 | Xem nhật ký dựa trên dự án cụ thể                                            |
| Quản Lý Nhật Ký         | 19 | Lọc Nhật Ký                   | Chọn bộ lọc dự án và bộ lọc người dùng                         | Lọc nhật ký dựa trên người dùng cụ thể                                       |
| Quản Lý Nhật Ký         | 20 | Khôi Phục Nhật Ký             | Nhấn vào ID chuỗi cho một nhật ký cụ thể                       | Khôi phục nhật ký cụ thể trên màn hình                                      |
| Xác Thực                | 21 | Xác Thực Google               | Sử dụng chức năng đăng nhập                                    | Sử dụng Firebase Auth để đăng nhập với Google và bảo mật tính năng           |
| Lựa Chọn Dự Án          | 22 | Chọn Dự Án                    | Sử dụng chức năng lựa chọn dự án                               | Rõ ràng về các dự án bạn làm việc và sử dụng các nhiệm vụ chuyên dụng         |
| Lựa Chọn Danh Mục       | 23 | Chọn Danh Mục                 | Sử dụng chức năng lựa chọn danh mục                            | Chọn danh mục dựa trên nhiệm vụ để truy cập vào công cụ và mẫu               |
| Lựa Chọn Khung          | 24 | Chọn Khung                    | Sử dụng chức năng lựa chọn khung                               | Làm việc hiệu quả với khung phù hợp cho danh mục của bạn                     |
| Lựa Chọn Nhiệm Vụ       | 25 | Chọn Nhiệm Vụ                 | Sử dụng chức năng lựa chọn nhiệm vụ                            | Xác định các nhiệm vụ phù hợp với công việc và sử dụng mẫu                    |
| AI Sinh Mã Code         | 26 | Có Một Cuộc Trò Chuyện AI     | Sử dụng chức năng thực thi Trò Chuyện AI                       | Sử dụng AI để tạo ý tưởng và mã nhằm nâng cao chất lượng công việc           |
| AI Sinh Mã Code         | 27 | Trò Chuyện AI Với Văn Bản     | Sử dụng chức năng thực thi Trò Chuyện AI + hình ảnh            | Sử dụng văn bản và hình ảnh để có truy vấn trực quan và phức tạp hơn         |
| AI Sinh Mã Code         | 28 | Sao Chép Mã                   | Sử dụng chức năng sao chép                                     | Dễ dàng duy trì mã đã tạo, dẫn đến công việc hiệu quả hơn                   |
| AI Sinh Mã Code         | 29 | Lưu Mã Như Tệp Tin            | Sử dụng chức năng lưu trữ                                      | Mã đã tạo có thể được lưu dưới dạng tệp để sử dụng sau hoặc lưu trữ          |
| AI Sinh Mã Code         | 30 | Chạy Mã Code                  | Sử dụng chức năng thực thi                                     | Bạn có thể kiểm tra mã đã tạo để xem nó có hoạt động chính xác không         |
| Xem Nhật Ký             | 31 | Xem Danh Sách Nhật Ký         | Sử dụng chức năng xem lịch sử                                  | Bạn có thể xem lại công việc trước đây của mình thông qua lịch sử Trò Chuyện AI|
| Xem Nhật Ký             | 32 | Nhấn Để Khôi Phục Nhật Ký     | Sử dụng chức năng khôi phục nhật ký                            | Bạn có thể trở lại trạng thái trước đó của Trò Chuyện AI một cách hiệu quả  |
| Quản Lý Phản Hồi        | 33 | Nhập Phản Hồi Nhiệm Vụ        | Nhập phản hồi của bạn về chi tiết nhiệm vụ và nhấp vào nút Gửi | Đăng ký phản hồi liên quan đến nhiệm vụ trong hệ thống                      |
| Quản Lý Phản Hồi        | 34 | Nhập Phản Hồi Không Nhiệm Vụ  | Nhập phản hồi của bạn trên màn hình chính và nhấp vào nút Gửi  | Đăng ký phản hồi không liên quan đến nhiệm vụ trong hệ thống                |
| Quản Lý Phản Hồi        | 35 | Hiển Thị Phản Hồi             | Chọn "Phản Hồi" từ menu bên                                    | Hiển thị tất cả các phản hồi theo thứ tự giảm dần từ ngày giờ mới nhất      |
| Quản Lý Phản Hồi        | 36 | Phân Trang                    | Nhấp vào nút trang tiếp theo nếu có trên 50 phản hồi           | Hiển thị phản hồi trong quá khứ một cách liên tục                          |
| Quản Lý Người Dùng      | 37 | Hiển Thị Danh Sách            | Chọn "Quản Lý" từ menu                                         | Để xem và quản lý danh sách tất cả người dùng trong hệ thống               |
| Quản Lý Người Dùng      | 38 | Tìm Kiếm Người Dùng           | Nhập tên và địa chỉ email của bạn và nhấp vào nút tìm kiếm     | Để nhanh chóng tìm kiếm một người dùng cụ thể                              |
| Quản Lý Người Dùng      | 39 | Thêm Người Dùng               | Nhấp vào nút "Thêm"                                            | Để thêm người dùng mới vào hệ thống                                       |
| Quản Lý Người Dùng      | 40 | Chỉnh Sửa Người Dùng          | Chọn người dùng bạn muốn chỉnh sửa và nhấp vào nút chỉnh sửa   | Để cập nhật thông tin người dùng                                           |
| Quản Lý Người Dùng      | 41 | Nhập Thông Tin Người Dùng     | Nhập email, tên, dự án, vai trò                                | Để nhập thông tin người dùng một cách chính xác                           |
| Quản Lý Người Dùng      | 42 | Lưu Người Dùng                | Nhấp vào nút "Lưu" trên màn hình chỉnh sửa người dùng          | Để lưu thông tin người dùng đã chỉnh sửa hoặc mới tạo                       |
| Quản Lý Người Dùng      | 43 | Xóa Người Dùng                | Chọn người dùng bạn muốn xóa và nhấp vào nút "Xóa"             | Để xóa người dùng khỏi hệ thống khi không còn cần thiết                    |
| Quản Lý Người Dùng      | 44 | Xác Nhận Chi Tiết Người Dùng  | Nhấp vào người dùng mục tiêu từ danh sách người dùng           | Để kiểm tra thông tin chi tiết của người dùng cụ thể                        |
| Quản Lý Người Dùng      | 45 | Chỉnh Sửa Dự Án Của Người Dùng| Thêm hoặc xóa dự án                                           | Để cập nhật thông tin dự án mà người dùng đang tham gia                     |
| Quản Lý Người Dùng      | 46 | Chỉnh Sửa Vai Trò Người Dùng  | Thêm hoặc xóa vai trò                                         | Để cập nhật vai trò của người dùng                                         |
| Dịch Vụ Xác Thực        | 47 | Tạo Vai Trò Mới               | Tạo một vai trò với tên và mô tả duy nhất                      | Để định nghĩa hiệu quả vai trò trong hệ thống                              |
| Dịch Vụ Xác Thực        | 48 | Định Nghĩa Quyền              | Chỉ định quyền (đọc, viết, chỉnh sửa, xóa) cho vai trò         | Để kiểm soát hành động truy cập dựa trên vai trò                           |
| Dịch Vụ Xác Thực        | 49 | Quản Lý Quyền                 | Thiết lập và xem danh sách chi tiết các đặc quyền              | Để đảm bảo rằng tất cả các hành động phản ánh quyền và có thể được quản lý |
| Dịch Vụ Xác Thực        | 50 | Gán Vai Trò Cho Người Dùng    | Gán một hoặc nhiều vai trò cho một người dùng                  | Để xác định và quản lý quyền truy cập của người dùng dựa trên vai trò       |
| Dịch Vụ Xác Thực        | 51 | ACL                           | Triển khai để thực thi quyền vai trò trên tài nguyên           | Để thực thi kiểm soát truy cập dựa trên vai trò cho tài nguyên             |
| Dịch Vụ Xác Thực        | 52 | Xác Minh Truy Cập             | Xác nhận quyền truy cập tài nguyên của người dùng dựa trên ACL đã định nghĩa | Đảm bảo rằng kiểm soát truy cập phù hợp với các định nghĩa ACL           |
| Dịch Vụ Xác Thực        | 53 | Quản Lý Vai Trò               | Tạo, chỉnh sửa và xóa vai trò bằng giao diện trực quan        | Để đơn giản hóa quy trình quản lý vai trò                                 |
| Dịch Vụ Xác Thực        | 54 | Gán Vai Trò                   | Gán vai trò cho người dùng bằng giao diện quản trị            | Để tạo điều kiện thuận lợi cho việc gán vai trò hiệu quả                    |
| Dịch Vụ Xác Thực        | 55 | Thực Thi Đặc Quyền            | Giới hạn hành động của người dùng dựa trên đặc quyền vai trò được gán | Duy trì kiểm soát truy cập nghiêm ngặt trong hệ thống của chúng ta        |
| Dịch Vụ Xác Thực        | 56 | Lỗi Pháp Lý                   | Thông báo lỗi thích hợp khi thực hiện các hành động không hợp lệ  | Cung cấp phản hồi và ngăn chặn các hoạt động trái phép                  |
| Dịch Vụ Xác Thực        | 57 | Triển Khai Nhật Ký Kiểm Toán  | Ghi lại tất cả ID, các hành động đã thực hiện, thời gian, và tài nguyên | Kiểm tra thay đổi vai trò và quyền cho bảo mật và tuân thủ quy định      |
| Dịch Vụ Xác Thực        | 58 | Hỗ Trợ Phân Cấp               | Cho phép các vai trò cao hơn thừa hưởng quyền từ các vai trò thấp hơn | Tạo điều kiện cho quản lý vai trò phân cấp                               |
| Dịch Vụ Xác Thực        | 59 | Khả Năng Mở Rộng Của Hệ Thống | Cho phép hệ thống xử lý số lượng lớn vai trò và đặc quyền      | Duy trì hiệu suất và khả dụng khi vai trò và người dùng tăng             |
| Dịch Vụ Xác Thực        | 60 | Giới Hạn Tài Nguyên          | Thiết lập giới hạn phân bổ tài nguyên cho từng vai trò          | Ngăn chặn sự phát triển vượt mức của vai trò và kiểm soát phân bổ tài nguyên. |
| Không Gian Làm Việc Cục Bộ | 61 | Truy Cập Tệp                  | Truy cập không gian làm việc của máy tính khách để chỉnh sửa tệp và thư mục | Quản lý tệp và thư mục trong không gian làm việc                           |
| Không Gian Làm Việc Cục Bộ | 62 | Cài Đặt Không Gian Làm Việc   | Cấu hình và thay đổi không gian làm việc dựa vào yêu cầu         | Thiết lập thư mục phù hợp nhất với môi trường của họ                      |
| Không Gian Làm Việc Cục Bộ | 63 | Thực Thi Lệnh Kiểm Tra        | Chạy lệnh kiểm tra với giao diện dòng lệnh                       | Kiểm tra các lệnh bên trong không gian làm việc và hoạt động của hệ thống |
| Không Gian Làm Việc Cục Bộ | 64 | Xác Thực Lệnh                 | Xác nhận tính an toàn và chấp nhận của lệnh trước khi thực thi  | Đảm bảo rằng chỉ các lệnh an toàn và được phép được thực thi             |
| Không Gian Làm Việc Cục Bộ | 65 | Kết Quả Và Tệp                | Chọn kết quả của lệnh kiểm tra và tệp cụ thể                       | Liên kết kết quả kiểm tra và tệp liên quan với AI và cập nhật             |
| Không Gian Làm Việc Cục Bộ | 66 | Thông Báo Gửi Tệp             | Thông báo rằng một tệp đã được cập nhật bởi AI                   | Cho phép bạn kiểm tra tiến độ cập nhật tệp trong thời gian thực            |
| Không Gian Làm Việc Cục Bộ | 67 | Tệp Được Sửa Cẩu              | Nhận tệp được sửa từ AI                                          | Kiểm tra và áp dụng các sửa chỉnh tự động từ AI                          |
| Không Gian Làm Việc Cục Bộ | 68 | Áp Dụng Hoặc Từ Chối Tệp      | Kiểm tra nội dung của tệp đã sửa, gửi Áp Dụng hoặc Từ Chối        | Quyết định xem có cần phản ánh các sửa chữa từ AI hay không              |
| Không Gian Làm Việc Cục Bộ | 69 | Lựa Chọn Không Gian Làm Việc  | Chọn một không gian làm việc để làm việc                          | Làm rõ thư mục và dự án bạn đang làm việc với                               |
| Không Gian Làm Việc Cục Bộ | 70 | Áp Dụng Tệp Sửa | Nếu Chọn Áp Dụng, Tệp Đã Sửa Sẽ Bị Ghi Đè | Để Phản Ánh Nội Dung Đã Sửa Trong Tệp Và Duy Trì |
| Không Gian Làm Việc Cục Bộ | 71 | Truyền Dữ Liệu Bảo Mật | Đảm Bảo Chuyển Giao An Toàn Dữ Liệu Giữa Máy Tính Cục Bộ Và AI | Duy Trì Bảo Mật Dữ Liệu Và Đạt Được Giao Tiếp An Toàn |

##### **Dựa Trên Yêu Cầu Chức Năng**: Kiểm Thử Các Kịch Bản Hội Thoại Khác Nhau Dựa Trên Yêu Cầu Chức Năng

- **Quản Lý Người Dùng**

  - Tạo Người Dùng: Cho phép tạo người dùng mới và phản ánh sự bổ sung này trong Dịch Vụ Xác Thực.
  - Cập Nhật Thông Tin Người Dùng: Cho phép cập nhật thông tin người dùng hiện có và đồng bộ hóa các cập nhật này với Dịch Vụ Xác Thực.
  - Xóa Người Dùng: Cho phép xóa một người dùng và đảm bảo việc xóa này được phản ánh trong Dịch Vụ Xác Thực.
  - Tìm Kiếm Người Dùng: Cung cấp chức năng tìm kiếm và truy xuất thông tin người dùng.

- **Quản Lý Vai Trò**

  - Nhận Vai Trò Từ Dịch Vụ Xác Thực: Lấy thông tin vai trò từ Dịch Vụ Xác Thực.
  - Cập Nhật Vai Trò Trong Dịch Vụ Xác Thực: Cập nhật thông tin vai trò trong Dịch Vụ Xác Thực.

- **Đồng Bộ Hóa Dữ Liệu Với Dịch Vụ Xác Thực**

  - Phản Ánh Bổ Sung Người Dùng Vào Dịch Vụ Xác Thực: Đảm bảo rằng khi thông tin người dùng được bổ sung, những bổ sung này cũng được phản ánh trong Dịch Vụ Xác Thực.

#### 2. **Kiểm Thử Khả Dụng**

- **Trải Nghiệm**: Kiểm tra giao diện (nếu có) xem có dễ sử dụng không.
- **Khả Năng Truy Cập**: Đảm bảo hệ thống có thể truy cập cho người dùng khuyết tật.
- **Thông Báo Lỗi**: Kiểm tra xem thông báo lỗi có mang tính thông tin và hữu ích không.

#### 3. **Kiểm Thử Tích Hợp**

- **Điểm Cuối API**: Xác minh rằng tất cả các tích hợp API hoạt động liền mạch.
- **Cơ Sở Dữ Liệu**: Đảm bảo rằng các hoạt động cơ sở dữ liệu (chèn, cập nhật, xóa) hoạt động chính xác.
