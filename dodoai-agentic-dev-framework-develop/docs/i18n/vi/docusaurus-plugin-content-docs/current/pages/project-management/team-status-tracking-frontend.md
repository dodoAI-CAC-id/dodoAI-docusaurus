---
id: team-status-tracking-frontend
title: Theo Dõi Trạng Thái Đội Nhóm (Frontend)
---

## Tổng Quan

Theo dõi trạng thái đội nhóm đối với front-end là quá trình giám sát, ghi lại, và đánh giá tiến độ và hiệu suất các hoạt động của cả đội và từng cá nhân. Điều này bao gồm việc theo dõi phân công nhiệm vụ, thời hạn hoàn thành, trạng thái công việc, và bất kỳ trở ngại nào mà đội nhóm có thể gặp phải.

## Mục Tiêu

Tạo một quy trình làm việc có cấu trúc và hiệu quả nơi đội phát triển front-end có thể phát triển tốt. Bằng cách theo dõi tiến độ, duy trì giao tiếp cởi mở, và ưu tiên các nhiệm vụ, đội nhóm có thể đảm bảo sự gắn kết với các mục tiêu của dự án và đạt được chất lượng cao đúng thời hạn. Những mục tiêu này cũng khuyến khích sự cải tiến liên tục và xây dựng văn hóa hợp tác trong đội ngũ.

## Mục Lục

- [Tổng Quan](#tổng-quan)
- [Mục Tiêu](#mục-tiêu)
- [Mục Lục](#mục-lục)
- [Giới Thiệu](#giới-thiệu)
- [Công Cụ Và Thiết Lập](#công-cụ-và-thiết-lập)
  - [GitHub Projects](#github-projects)
  - [Issues Có Thời Hạn](#issues-có-thời-hạn)
  - [TeamStatus](#teamstatus)
- [Quy Trình](#quy-trình)
  - [Tạo Và Quản Lý Issues](#tạo-và-quản-lý-issues)
  - [Theo Dõi Tiến Độ](#theo-dõi-tiến-độ)
  - [Xử Lý Pull Requests](#xử-lý-pull-requests)
  - [Cập Nhật Và Báo Cáo Định Kỳ](#cập-nhật-và-báo-cáo-định-kỳ)
- [Thực Hành Tốt Nhất](#thực-hành-tốt-nhất)

## Giới Thiệu

Tài liệu này trình bày quy trình và các thực hành tốt nhất để theo dõi trạng thái các nhiệm vụ phát triển front-end sử dụng GitHub Projects, thiết lập thời hạn cho issues, và quản lý trạng thái đội nhóm một cách hiệu quả. Phương pháp này đảm bảo sự gắn kết, cải thiện giao tiếp hiệu quả, và nâng cao năng suất tổng thể.

## Công Cụ Và Thiết Lập

### GitHub Projects

**GitHub Projects** là một công cụ mạnh mẽ để quản lý nhiệm vụ và quy trình làm việc. Công cụ này cho phép chúng ta tạo issues, đặt thời hạn hoàn thành, và phân loại nhiệm vụ bằng các labels để phản ánh trạng thái như: `Backlog`, `Ready`, `In Progress`, `In Review`, và `Done`.

### Issues Có Thời Hạn

**Issues** được sử dụng để theo dõi từng nhiệm vụ hoặc phần công việc riêng lẻ. Bằng cách gắn thời hạn cho issues, chúng ta có thể ưu tiên các công việc và đảm bảo hoàn thành đúng thời gian.

### TeamStatus

**TeamStatus** là công cụ được lựa chọn để thường xuyên cập nhật tiến độ đội nhóm. Công cụ này cho phép chúng ta thu thập và chia sẻ các cập nhật trạng thái, các vấn đề cản trở, và những thành tựu nổi bật.

## Quy Trình

### Tạo Và Quản Lý Issues

1. **Tạo Issue**: Xem hướng dẫn chi tiết về việc tạo và quản lý issues tại [Đăng Ký Issues](development-rules/issue-registration.md).

2. **Gắn Ngày Hạn**: Đặt thời hạn cho mỗi issue để ưu tiên và quản lý hoàn thành đúng hạn.
   - Điều hướng đến thanh bên phải của issue.
   - Nhấn vào `Due date` và chọn một ngày phù hợp.

### Theo Dõi Tiến Độ

1. **Cập Nhật Trạng Thái Issue**: Cập nhật trực tiếp trạng thái của issue bằng cách thay đổi label trên GitHub để phản ánh trạng thái hiện tại:
   - `Backlog`: Các issues mới chưa được bắt đầu.
   - `Ready`: Các issues sẵn sàng để xử lý.
   - `In Progress`: Các issues đang được thực hiện.
   - `In Review`: Các issues đang được xem xét.
   - `Done`: Các issues đã hoàn thành.

2. **Thêm Bình Luận Và Cập Nhật**: Thường xuyên thêm bình luận vào issue để cung cấp bối cảnh và cập nhật:
   - Nêu rõ tiến độ cụ thể.
   - Liệt kê các vấn đề cản trở hoặc yêu cầu.
   - Đánh dấu các nhiệm vụ đã hoàn thành trong issue.

### Xử Lý Pull Requests

Xem hướng dẫn chi tiết về xử lý pull requests tại [Pull Requests & Review](/pages/project-management/development-rules/pull-request-review).

### Cập Nhật Và Báo Cáo Định Kỳ

1. **Họp Nhanh Hằng Ngày (Daily Standups)**: Sử dụng TeamStatus để cung cấp các cập nhật hàng ngày.
   - Mỗi thành viên trong đội nên ghi lại cập nhật trạng thái, bao gồm những gì họ đã hoàn thành hôm qua, kế hoạch hôm nay, và bất kỳ vấn đề cản trở nào họ đang gặp phải.

2. **Họp Đội Hằng Tuần**:
   - Thực hiện họp đội hàng tuần để xem xét tiến độ, thảo luận các vấn đề quan trọng, và điều chỉnh các ưu tiên.
   - Xem lại GitHub Issues.
   - Phân tích thời hạn và các nhiệm vụ sắp tới.
   - Nêu bật những thành tựu quan trọng và giải quyết các cản trở hoặc trì hoãn.

## Thực Hành Tốt Nhất

- **Minh Bạch**: Đảm bảo tất cả các thành viên trong đội có quyền truy cập vào GitHub Issues và có thể xem trạng thái.
- **Ưu Tiên Giao Tiếp**: Các cập nhật thường xuyên và giao tiếp mở giúp giải quyết các vấn đề kịp thời và giữ cho tất cả thành viên đồng bộ.
- **Giữ Gọn Gàng**: Sử dụng labels và thời hạn một cách hiệu quả để tổ chức và ưu tiên nhiệm vụ.
- **Cập Nhật Thông Tin Thường Xuyên**: Đảm bảo rằng GitHub Issues và TeamStatus luôn được cập nhật để phản ánh trạng thái mới nhất của dự án.
- **Quy Trình Xem Xét Kỹ Lưỡng**: Đảm bảo rằng các Pull Requests được ít nhất hai thành viên đội nhóm xem xét kỹ lưỡng để duy trì chất lượng mã cũng như chia sẻ kiến thức.
- **Đặt Tên Thống Nhất**: Tuân thủ định dạng đặt tên PR (`feature/frontend_<tên-developer>_<tên-tính-năng>_<mã-issue>`) để duy trì tính nhất quán và dễ dàng theo dõi công việc.
