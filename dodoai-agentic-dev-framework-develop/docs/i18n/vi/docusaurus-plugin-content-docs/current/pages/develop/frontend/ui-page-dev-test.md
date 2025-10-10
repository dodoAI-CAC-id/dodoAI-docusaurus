---
id: ui-page-dev-test
title: Phát Triển & Kiểm Thử Trang Giao Diện Người Dùng
---

## Hướng Dẫn

Viết mã cho các thành phần Trang kết hợp Thành Phần Giao Diện và Logic, và mã kiểm thử tương ứng.

## Tổng Quan

Xây dựng các thành phần giao diện người dùng cấp trang kết hợp thiết kế và chức năng thành các giao diện người dùng hoàn chỉnh.

## Mục Tiêu

Đồng bộ phát triển trang với thiết kế Figma và kế hoạch Thành Phần Giao Diện.

## Điểm Quan Trọng

- Tránh mô tả logic nghiệp vụ trong các kiểm thử trang.
- Tập trung kiểm thử vào các hành vi đặc thù của trang như hiển thị, điều hướng, chuyển đổi, và xử lý sự kiện.
- Cô lập giao tiếp API bên ngoài trong các thành phần logic.

### Các Trường Hợp Kiểm Thử Đặc Thù Cho Một Thành Phần Trang

1. **Hiển Thị Trang Ban Đầu**:
   - Xác nhận trang hiển thị đúng trạng thái ban đầu của nó, bao gồm cả tiêu đề và các phần tử mong đợi.

2. **Điều Hướng Trang**:
   - Xác minh chuyển sang các màn hình đúng khi các phần tử điều hướng như liên kết và nút được nhấp vào.

3. **Cập Nhật Giao Diện Dựa Trên Trạng Thái**:
   - Kiểm thử các thay đổi giao diện phù hợp khi trạng thái thay đổi do tương tác với thành phần.

4. **Tính Toàn Vẹn Bố Cục**:
   - Kiểm tra bố cục trang để đảm bảo áp dụng đúng các lớp CSS và kiểu dáng.

5. **Xử Lý Sự Kiện**:
   - Đảm bảo rằng các trình xử lý sự kiện đặc thù của trang như gửi biểu mẫu và nút bấm hoạt động như dự định.

## Mẫu

**Lưu Ý: Sử dụng các ví dụ sau như các mẫu cấu trúc cho phát triển và kiểm thử thành phần trang của bạn.**

### Mã Kiểm Thử Mẫu Cho Thành Phần Trang

```javascript
import { render, fireEvent } from '@testing-library/react';
import MyPage from './MyPage';

// Ví dụ kiểm thử đặc thù cho trang trong ứng dụng React
describe('MyPage', () => {
  test('renders MyPage with proper navigation and event handling', () => {
    const { getByText, getByTestId } = render(<MyPage />);
    const navBar = getByTestId('nav-bar');
    // Kiểm thử hiển thị trang
    expect(navBar).toBeInTheDocument();
    // Kiểm thử điều hướng trang
    fireEvent.click(getByText('Go to Settings'));
    // Xác nhận kết quả điều hướng
    expect(getByText('Settings Page')).toBeInTheDocument();
    // Kiểm thử xử lý sự kiện
    fireEvent.click(getByText('Submit'));
    // Xác nhận kết quả xử lý sự kiện
    expect(getByText('Form Submitted')).toBeInTheDocument();
  });

  // Các kiểm thử khác để bao phủ các kịch bản đặc thù trang khác...
});
```

```dart
// Ví dụ kiểm thử đặc thù cho trang sử dụng bộ khung kiểm thử Widget của Flutter.
void main() {
  testWidgets('MyPage has a title and responds to tap events', (WidgetTester tester) async {
    // Sắp xếp
    await tester.pumpWidget(MyPage());
    
    // Xác nhận trạng thái ban đầu.
    expect(find.text('My Page'), findsOneWidget);
    
    // Thực hiện
    await tester.tap(find.byType(FloatingActionButton));
    
    // Xác nhận trạng thái thay đổi sau sự kiện.
    expect(find.text('Button tapped'), findsOneWidget);
  });

  // Các kiểm thử Widget khác...
}
```
