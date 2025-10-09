---
id: model-dev-unittest
title: Phát Triển Mô Hình & Kiểm Thử Đơn Vị
---

## Hướng Dẫn

Viết chương trình cho Mô hình và Kiểm thử đơn vị của nó.

## Tổng Quan

Tập trung vào việc tạo các mô hình phản ánh chính xác dữ liệu và logic kinh doanh của hệ thống, cũng như phát triển các kiểm thử đơn vị đáng tin cậy.

## Mục Tiêu

- Phát triển mô hình phù hợp với các đặc tả trong Tài liệu thiết kế API và Swagger.
- Đảm bảo mô hình phản ánh mô hình dữ liệu vật lý, bao gồm cả sơ đồ cơ sở dữ liệu.
- Tạo các kiểm thử đơn vị tương ứng để xác thực chức năng và tính toàn vẹn của mô hình.

## Ví Dụ

**Lưu Ý: Sử dụng mã ví dụ dưới đây như một mẫu, điều chỉnh các chi tiết để phù hợp với thiết kế mô hình và nhu cầu kiểm thử của bạn.**

### Mã Ví Dụ Cho Sơ Đồ

```javascript
// ExampleSchema.js
const mongoose = require('mongoose');

const exampleSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
    trim: true
  },
  status: {
    type: String,
    required: true,
    enum: ['active', 'completed', 'archived']
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
  // Các trường bổ sung và quy tắc xác thực theo mô hình dữ liệu vật lý
});

module.exports = mongoose.model('Example', exampleSchema);
```

### Ví Dụ Mô Hình

```javascript
// ExampleModel.js (Giả sử môi trường Node.js)
const mongoose = require('mongoose');

const ExampleSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true
  },
  description: {
    type: String
  }
  // Định nghĩa các trường bổ sung dựa trên mô hình dữ liệu vật lý của bạn
});

const ExampleModel = mongoose.model('Example', ExampleSchema);

module.exports = ExampleModel;
```

### Kiểm Thử Đơn Vị Cho Mô Hình

```javascript
// ExampleModel.test.js
const chai = require('chai');
const expect = chai.expect;
const ExampleModel = require('../models/ExampleModel');

describe('ExampleModel', () => {
  it('nên không hợp lệ nếu tên trống', (done) => {
    const m = new ExampleModel();

    m.validate((err) => {
      expect(err.errors.name).to.exist;
      done();
    });
  });

  // Các kiểm thử đơn vị bổ sung để kiểm tra các kịch bản khác
});
```
