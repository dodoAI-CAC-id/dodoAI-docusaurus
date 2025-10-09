---
id: application-architecture
title: Kiến Trúc Ứng Dụng
---

## Hướng Dẫn

Tạo Kiến Trúc Ứng Dụng bằng Markdown hoặc các công cụ khác như draw.io theo định dạng sau đây.

## Tổng Quan

Kiến trúc ứng dụng cung cấp mô tả về các thành phần cấu trúc của phần mềm, cách chúng tương tác và hợp tác để hỗ trợ các chức năng của ứng dụng.

## Mục Tiêu

Thiết kế một khung hệ thống có tổ chức để định nghĩa cách các phần khác nhau của ứng dụng hoạt động cùng nhau, đảm bảo sự nhất quán, khả năng mở rộng và dễ bảo trì.

## Các Điểm Chính Của Kiến Trúc Ứng Dụng

- Xây dựng các lớp với vai trò cụ thể, như lớp trình bày (presentation), lớp logic nghiệp vụ (business logic), và lớp truy cập dữ liệu (data access).
- Đảm bảo tính mô-đun để dễ dàng thực hiện các thay đổi và nâng cấp.
- Thiết kế hướng đến khả năng mở rộng thông qua việc phân tách trách nhiệm giữa các thành phần khác nhau.
- Duy trì sự rõ ràng để ứng dụng dễ hiểu, dễ kiểm thử và tích hợp.

## Ví Dụ Về Kiến Trúc Ứng Dụng

**Lưu Ý: Dưới đây là một ví dụ minh họa trực quan về kiến trúc ứng dụng. Ví dụ này chỉ mang tính tham khảo và cần được điều chỉnh theo yêu cầu cụ thể của ứng dụng của bạn. Việc sử dụng Mermaid hay một công cụ như Draw.io để tạo sơ đồ là tùy chọn của bạn.**

![Application Architecture](../../assets/app-arch.png)

```mermaid
flowchart TB
  subgraph ClientLayer [Lớp Khách Hàng]
    ClientApp1[Ứng Dụng Khách Hàng 1]
    ClientApp2[Ứng Dụng Khách Hàng 2]
    ClientAppN[Ứng Dụng Khách Hàng N]
  end

  subgraph RecommenderServer [Máy Chủ Gợi Ý]
    WebServiceAPI[Dịch Vụ API Web]
    OnlineRecommender[Dịch Vụ Gợi Ý Trực Tuyến]
    ActionService[Dịch Vụ Hành Động]
    OfflineRecommender[Dịch Vụ Gợi Ý Ngoại Tuyến]
    DBActions[Cơ Sở Dữ Liệu Hành Động]
    DBAssociationRules[Cơ Sở Dữ Liệu Quy Tắc Liên Kết]
  end

  subgraph AdministrationTool [Công Cụ Quản Trị]
    Management[Quản Lý]
    APIDocumentation[Tài Liệu API]
    AdminPanel[Bảng Quản Trị]
  end

  subgraph GeneratorServer [Máy Chủ Tạo Nội Dung]
    ActionBasedGenerators[Bộ Tạo Nội Dung Dựa Trên Hành Động]
    ContentBasedGenerators[Bộ Tạo Nội Dung Dựa Trên Nội Dung]
    ThirdPartyMetadata[Dữ Liệu Từ Bên Thứ Ba]
  end

  ClientApp1 --> WebServiceAPI
  ClientApp2 --> WebServiceAPI
  ClientAppN --> WebServiceAPI

  WebServiceAPI --> OnlineRecommender
  WebServiceAPI --> ActionService
  WebServiceAPI --> OfflineRecommender

  OnlineRecommender --> DBActions
  ActionService --> DBActions
  OfflineRecommender --> DBAssociationRules

  ActionBasedGenerators --> DBActions
  ContentBasedGenerators --> DBAssociationRules
  ThirdPartyMetadata --> DBAssociationRules

  Management -.-> AdminPanel
  APIDocumentation -.-> AdminPanel

  AdministrationTool -.-> RecommenderServer
  AdministrationTool -.-> GeneratorServer
```
