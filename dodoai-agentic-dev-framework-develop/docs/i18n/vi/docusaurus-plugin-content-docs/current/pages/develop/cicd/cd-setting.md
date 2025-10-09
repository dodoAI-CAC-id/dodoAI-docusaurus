---
id: cd-setting
title: Thiết Lập Triển Khai Liên Tục
---

## Tệp Thiết Lập Triển Khai Liên Tục

Để xem toàn bộ nội dung về thiết lập triển khai liên tục, vui lòng truy cập liên kết dưới đây:

https://github.com/58web3/llm/blob/develop/.github/workflows/auto-deploy-web-ecs.yaml

## Thiết Lập Triển Khai Liên Tục

Triển Khai Liên Tục (CD) Với GitHub Actions Và Amazon ECS

Tài liệu này bao gồm một loạt các bước để kích hoạt Triển khai liên tục (CD) cho ứng dụng sử dụng GitHub Actions và Dịch vụ Container Elastic của Amazon (ECS). Mỗi bước được giải thích chi tiết nhằm giúp bạn hiểu rõ quá trình tổng thể và thực hiện các cấu hình cần thiết.

### Điều Kiện Tiên Quyết

1. **Thiết Lập Amazon Web Services (AWS)**:
    - Một Cụm ECS của Amazon (`dev-llm`).
    - Một Dịch Vụ ECS (`dev-llm-api`).
    - Một Định Nghĩa Tác Vụ ECS (`dev-llm-api`).

2. **Kho Lưu Trữ GitHub**:
    - Một kho được cấu hình nơi bạn sẽ tạo workflow cho GitHub Actions.
    - Các bí mật được cấu hình cho thông tin xác thực AWS (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`) và các cấu hình cần thiết khác.

### Các Bước Workflow Của GitHub Actions

Dưới đây là sự phân tích các đoạn mã YAML cho workflow của GitHub Actions.

#### Bước 1: Lấy Định Nghĩa Tác Vụ ECS

```yaml
- name: Get task definition
  run: |
    aws ecs describe-task-definition --task-definition dev-llm-api --query taskDefinition > task-definition.json
```

##### Chi tiết

- **Tên**: Lấy định nghĩa tác vụ
- **Hành động**: Thực thi lệnh AWS CLI để lấy Định Nghĩa Tác Vụ ECS cho dịch vụ `dev-llm-api`.
- **Chi tiết**:
  - Sử dụng lệnh `aws ecs describe-task-definition` để lấy Định Nghĩa Tác Vụ ECS hiện tại.
  - Lọc phản hồi để chỉ trả về phần `taskDefinition` và lưu trữ nó trong một tệp có tên `task-definition.json`.

#### Bước 2: Cập Nhật Định Nghĩa Tác Vụ Với Hình Ảnh Mới

```yaml
- name: Fill in the new image ID in the Amazon ECS task definition
  id: task-def
  uses: aws-actions/amazon-ecs-render-task-definition@v1
  with:
    task-definition: task-definition.json
    container-name: api
    image: ${{ steps.build-image.outputs.image }}
```

##### Chi tiết

- **Tên**: Điền ID hình ảnh mới vào định nghĩa tác vụ Amazon ECS
- **ID**: task-def (id này được sử dụng sau để tham chiếu đến đầu ra của hành động này)
- **Hành động**: Sử dụng hành động `aws-actions/amazon-ecs-render-task-definition@v1` để cập nhật `task-definition.json` với hình ảnh container mới.
- **Đầu vào**:
  - `task-definition`: Đường dẫn đến tệp định nghĩa tác vụ (`task-definition.json`) đã lấy ở Bước 1.
  - `container-name`: Tên của container (`api`) trong định nghĩa tác vụ sẽ được cập nhật.
  - `image`: ID hình ảnh mới đã được xây dựng trước đó (`${{ steps.build-image.outputs.image }}`).

#### Bước 3: Triển Khai Định Nghĩa Tác Vụ Đã Cập Nhật

```yaml
- name: Deploy Amazon ECS task definition
  uses: aws-actions/amazon-ecs-deploy-task-definition@v1
  with:
    task-definition: ${{ steps.task-def.outputs.task-definition }}
    service: dev-llm-api
    cluster: dev-llm
    wait-for-service-stability: true
```

##### Chi tiết

- **Tên**: Triển khai định nghĩa tác vụ Amazon ECS
- **Hành động**: Sử dụng hành động `aws-actions/amazon-ecs-deploy-task-definition@v1` để triển khai Định Nghĩa Tác Vụ ECS đã cập nhật.
- **Đầu vào**:
  - `task-definition`: Định nghĩa tác vụ đã cập nhật từ Bước 2 (`${{ steps.task-def.outputs.task-definition }}`).
  - `service`: Tên của dịch vụ ECS (`dev-llm-api`) sẽ được cập nhật.
  - `cluster`: Tên của cụm ECS (`dev-llm`).
  - `wait-for-service-stability`: Đảm bảo rằng workflow chờ đợi cho đến khi dịch vụ ổn định trước khi tiếp tục (`true`).
