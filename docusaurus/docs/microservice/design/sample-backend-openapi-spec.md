---
id: sample-backend-openapi-spec
title: Sample Backend OpenAPI Specification
---

import SampleBackendSwaggerUIComponent from '@site/src/swagger/microservice/SampleBackendSwaggerUIComponent';

# Sample Backend OpenAPI 仕様書

このドキュメントは `sample-project/backend` の実装から生成されたOpenAPI仕様です。

## API仕様（Swagger UI）

<SampleBackendSwaggerUIComponent />

## メタ情報

- **ファイルパス**: `/swagger/microservice/sample-backend-openapi.yaml`
- **OpenAPIバージョン**: 3.0.3
- **生成元**: sample-project/backend の実装コード

## 実装ベース仕様との差分

以下は、`sample-project/backend` の実装コードから逆算したAPI仕様と、上記OpenAPI YAMLとの差分です。

| API (Method + Path) | 項目 | sample-backend-openapi.yaml | 実装ベース仕様 | コメント |
|---------------------|------|----------------------------|----------------|----------|
| `PATCH /incidents/{id}/alert` | isActive フィールド | `required: true`, `type: boolean` | 実装では `*bool` でnilチェックあり | YAMLと実装は整合（必須フィールド） |
| GET /incidents | status パラメータ | `enum: [open, in_progress, resolved, closed]` | 実装ではenum制約なし（任意文字列） | YAMLの方が厳密な仕様 |
| POST /incidents | type フィールド | `enum: [fall, leave_bed, enter_restricted_area, other]` | 実装ではenum制約なし（任意文字列） | YAMLの方が厳密な仕様 |
| 全API共通 | 認証・認可 | セキュリティ定義はあるが未適用（コメントアウト） | 実装では認証ミドルウェアなし | 両方とも認証未実装で一致 |
| 全API共通 | エラーレスポンス | `ErrorResponse` スキーマ定義あり | `utils.ErrorResponse` 関数で統一 | 形式は一致 |

### 詳細な差分分析

1. **Enum制約の差異**
   - OpenAPI YAMLでは `status` や `type` などにenum制約が定義されているが、実装側では文字列バリデーションが行われていない
   - これは実装の柔軟性を保つための意図的な設計の可能性がある

2. **必須フィールドの扱い**
   - 両者とも必須フィールドのバリデーションは一致している
   - `PATCH /incidents/{id}/alert` の `isActive` フィールドは、YAMLでも実装でも必須として扱われている

3. **日時フォーマット**
   - 両者ともRFC3339形式（`time.RFC3339`）を使用しており、完全に一致

4. **レスポンス構造**
   - 成功レスポンスは `{"data": ...}` 形式で統一
   - エラーレスポンスは `{"error": {"message": "..."}}` 形式で統一

※ 全体的に実装とOpenAPI仕様は高い整合性を保っており、重大な差分は確認されていません。

## 主な特徴

### エンドポイント定義
- 29個のAPIエンドポイントを完全定義
- 各エンドポイントにoperationId、tags、summary を付与
- パラメータの型、必須/任意、制約を明記

### スキーマ定義
- Request/Response の全スキーマを定義
- 型情報、nullable、enum値を含む
- 参照関係（$ref）による再利用可能な構造

### エラーハンドリング
- 共通エラーレスポンス形式（ErrorResponse）
- HTTPステータスコード別のレスポンス定義
- components/responses での再利用可能なエラー定義

### セキュリティ
- JWT Bearer認証の定義（将来実装用にコメントアウト）
- 現在は認証未実装のため適用なし

---

*生成日時: 2025/11/28*
*対象モジュール: sample-project/backend*
