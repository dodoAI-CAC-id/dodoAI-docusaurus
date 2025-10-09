---
id: smart-contract-spec
title: Đặc Tả Hợp Đồng Thông Minh (Markdown)
---

## Tổng Quan

Đặc tả hợp đồng thông minh được tạo ra từ một danh sách các yêu cầu để đảm bảo rằng các hợp đồng thông minh được định nghĩa chính xác và hoạt động như mong đợi.

### Đầu Vào

- Hướng Dẫn
- Ví Dụ Đề Xuất: https://58llm.link/main/restore/2539d3aa-8c76-4332-9369-d8a85893bca4

### Đầu Ra

- Đặc Tả Hợp Đồng Thông Minh

## Mẫu

### Tài Liệu Thiết Kế StickerNFT.sol

#### Tổng Quan

Hợp đồng thông minh `StickerNFT.sol` là một token ERC721 được thiết kế để triển khai trên chuỗi khối Ethereum, cung cấp chức năng NFT với những tính năng đặc biệt cho một bộ sưu tập theo chủ đề nhãn dán. Sử dụng khuôn khổ hợp đồng nâng cấp của OpenZeppelin, hợp đồng này nhằm đảm bảo tính nâng cấp trong tương lai cùng với việc duy trì các biện pháp bảo mật mạnh mẽ.

#### Đặc Tả

##### Tính Nâng Cấp

- **Khung Công Tác**: Hợp đồng sẽ thực hiện tính năng nâng cấp sử dụng khuôn khổ hợp đồng nâng cấp của OpenZeppelin.
- **Mẫu Proxy**: Mẫu được chọn cho tính năng nâng cấp sẽ là Mẫu Proxy Trong Suốt hoặc Tiêu Chuẩn Proxy Nâng Cấp Phổ Quát (UUPS), tùy thuộc vào đánh giá thêm về hiệu quả và vấn đề bảo mật.

##### Giới Hạn Cung Cấp

- **Tổng Cung Tối Đa**: Hợp đồng sẽ xác định một biến để lưu trữ tổng cung tối đa của token có thể được đúc. Điều này đảm bảo sự khan hiếm và bảo vệ giá trị của NFT.
- **Ràng Buộc Đúc**: Việc đúc token mới sẽ tự động kiểm tra đối chiếu với giới hạn tổng cung tối đa để đảm bảo tuân thủ khan hiếm đã được xác định trước.

##### Quy Trình Đúc

- **Chức Năng**: Một hàm `mint` sẽ được thực hiện, yêu cầu hai tham số: `tokenId` (một định danh duy nhất cho NFT mới) và `tokenUri` (một chuỗi ký tự lưu trữ URI trỏ đến metadata của NFT).
- **Kiểm Soát Quyền Truy Cập**: Chỉ có chủ sở hữu hợp đồng mới có thẩm quyền gọi hàm mint, được thực thi bằng cách sử dụng hợp đồng `Ownable` của OpenZeppelin hoặc một mẫu kiểm soát quyền truy cập tương đương.
- **ID Token**: Mỗi NFT được đúc phải có một `tokenId` duy nhất để phân biệt với các token khác. Hợp đồng phải từ chối bất kỳ nỗ lực nào để đúc token với `tokenId` đã tồn tại.

##### Danh Sách Trắng

- **Cơ Chế Danh Sách Trắng**: Hợp đồng sẽ bao gồm một cơ chế để quản lý danh sách trắng của các địa chỉ được phép nhận token NFT.
- **Hạn Chế Chuyển Nhượng**: Tích hợp kiểm tra trong các hàm `transferFrom` và `safeTransferFrom` để đảm bảo rằng token chỉ có thể được chuyển nhượng đến các địa chỉ trong danh sách trắng.
- **Chức Năng Quản Lý**: Cung cấp các hàm chỉ dành cho chủ sở hữu để thêm hoặc xoá địa chỉ khỏi danh sách trắng, đảm bảo kiểm soát linh hoạt đối với khả năng chuyển nhượng.

#### Chức Năng

##### Các Yếu Tố Hợp Đồng Thông Minh

- **Hợp Đồng Cơ Sở**: Hợp đồng cơ sở sẽ là `ERC721Upgradeable` từ OpenZeppelin, cung cấp một triển khai tiêu chuẩn của token ERC721 với khả năng nâng cấp.
- **Kiểm Soát Quyền Truy Cập**: Sử dụng `OwnableUpgradeable` của OpenZeppelin hoặc hệ thống kiểm soát quyền truy cập tùy chỉnh cho các hoạt động bị giới hạn cho chủ sở hữu.
- **Metadata & Liệt Kê**: Tích hợp `ERC721URIStorageUpgradeable` và `ERC721EnumerableUpgradeable` từ OpenZeppelin để cho phép lưu trữ metadata duy nhất cho mỗi token và cung cấp cách liệt kê token.

##### Các Hàm Chính

- `initialize`: Thay thế hàm khởi tạo trong các hợp đồng có thể nâng cấp và thiết lập trạng thái ban đầu, chẳng hạn như chủ sở hữu hợp đồng và tổng cung tối đa.
- `mint`: Cho phép chủ sở hữu đúc các token mới, với điều kiện `tokenId` và `tokenUri` không vi phạm ràng buộc về tính duy nhất và tuân thủ giới hạn tổng cung tối đa.
- `addToWhitelist`: Cho phép chủ sở hữu thêm địa chỉ vào danh sách các tài khoản được phép nhận token.
- `removeFromWhitelist`: Cho phép chủ sở hữu xóa địa chỉ khỏi danh sách trắng.
- `transferFrom` và `safeTransferFrom`: Ghi đè các hàm ERC721 cơ sở để bao gồm các kiểm tra đảm bảo địa chỉ của người nhận có trong danh sách trắng.

##### Định Nghĩa Sự Kiện

- `Minted`: Được phát ra khi một token mới được đúc thành công, bao gồm chi tiết của `tokenId` và `tokenUri`.
- `WhitelistUpdated`: Được phát ra khi một địa chỉ được thêm vào hoặc bị xóa khỏi danh sách trắng, cung cấp sự minh bạch trong quản lý danh sách.

#### Các Cân Nhắc Về Bảo Mật

- **Kiểm Soát Quyền Truy Cập**: Sử dụng các hợp đồng kiểm soát quyền truy cập và sở hữu của OpenZeppelin, đã được kiểm tra để giảm thiểu rủi ro truy cập trái phép vào các hàm bị giới hạn cho chủ sở hữu.
- **An Toàn Nâng Cấp**: Sử dụng thử nghiệm kỹ lưỡng và chiến lược quản lý ví đa chữ ký cho các nâng cấp hợp đồng để giảm thiểu các rủi ro liên quan đến sửa đổi hợp đồng.
- **Tương Tác Hợp Đồng**: Đảm bảo tương tác hợp đồng an toàn bằng cách sử dụng `ReentrancyGuard` của OpenZeppelin khi cần thiết và tuân theo mô hình Kiểm Tra-Tác Động-Tương Tác.

#### Triển Khai Và Kiểm Thử

Việc triển khai hợp đồng thông minh `StickerNFT.sol` sẽ bao gồm các bước sau:

1. Triển khai hợp đồng logic chứa việc triển khai chức năng NFT.
2. Triển khai một hợp đồng proxy trỏ đến hợp đồng logic.
3. Gọi hàm `initialize` thông qua proxy để thiết lập trạng thái ban đầu của hợp đồng.

Kiểm thử sẽ được thực hiện trong nhiều môi trường, bao gồm các phiên bản blockchain địa phương như Ganache và các testnet như Rinkeby hoặc Ropsten, để xác thực tất cả các chức năng chi tiết như trên. Các bài kiểm thử tự động sẽ được viết bằng cách sử dụng các framework như Truffle hoặc Hardhat.

Sau khi thử nghiệm kỹ lưỡng, hợp đồng sẽ được triển khai lên mạng chính của Ethereum, và tính năng nâng cấp sẽ đảm bảo rằng các cải tiến và tính năng mới có thể được áp dụng khi cần mà không làm gián đoạn hệ sinh thái hiện tại.
