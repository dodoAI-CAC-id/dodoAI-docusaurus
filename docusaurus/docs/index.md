---
id: index
title: mamoAI Documentation
---

## Overview
mamoAI Documentation は、本プロジェクトに関わる全メンバー（プロダクト責任者、デザイナー、フロントエンド/バックエンドエンジニア、SRE/インフラ、QA など）が、共通認識を持って設計・実装・運用を進めるためのドキュメントハブです。  
システムの非機能/セキュリティ要件、業務要件、UI/UX 設計、API/データモデル、マイクロサービス設計、インフラ/CI・CD、テスト計画まで、エンドツーエンドで参照できます。

本ドキュメントの特徴
- トレーサビリティ重視：仕様と実装（コード/Swagger/マイグレーション）を相互参照できる構造
- ロール別ナビゲーション：役割ごとに最短で必要情報に到達
- 実例ベース：サンプル（sample-project）やリバースエンジニアリング成果を用いた具体例
- 継続的運用：段階的な改善と lint による検出で、品質と最新性を維持

---

## What’s inside
このドキュメントは、以下の主要カテゴリで構成されています。各カテゴリ配下に詳細ページがあります。

- Specification（仕様）
  - [業務要件](./specification/business-requirement.md)
  - [非機能要件](./specification/non-functional-requirement.md)
  - [セキュリティアーキテクチャ](./specification/security-architecture.md)
  - [概念データ図](./specification/conceptual-data-diagram.md)
- Frontend
  - 画面設計/デザインルール: ./frontend/design/
  - 画面別ドキュメント（リバース含む）: ./frontend/screen-design/
    - 例: [異常検知一覧（未対応/対応中） 設計書](./frontend/screen-design/reversed/view-screen.md)
  - 実装/ガイド: ./frontend/develop/
- Microservice
  - サービス設計/API/データモデル: ./microservice/design/
    - 例: [OpenAPI 設計（サンプル）](./microservice/design/sample-backend-openapi-spec.md)
    - 例: [物理データモデル（サンプル）](./microservice/design/sample-backend-physical-data-model.md)
    - 例: [詳細機能設計（サンプル）](./microservice/design/sample-backend-detailed-functional-design.md)
  - サービス仕様: ./microservice/specification/
  - テスト方針/シナリオ: ./microservice/test/
  - 全体像: ./microservice/overview/
- Infrastructure / DevOps
  - インフラ設計: ./infrastructure/design/
  - IaC/運用ガイド: ./infrastructure/develop/
  - CI/CD・自動化: ./devops/
- Test / System Flows / Plan
  - システム/統合テスト: ./test/
  - 振る舞い図（シーケンスなど）: ./system-flows/
  - 実装計画・進捗・完了レポート: ./plan/

連携アセット
- Swagger（OpenAPI）: docusaurus/static/swagger/ 以下に配置し、関連ドキュメントから参照
- サンプル実装一式: `sample-project/`（バックエンド/フロントエンドの参照用コード）

---

## How to use this documentation
- 役割別の読み進め方
  - プロダクト責任者/PM: Specification → system-flows → microservice/design（影響範囲）を俯瞰
  - デザイナー/UX: frontend/design および frontend/screen-design を中心に、仕様との整合を確認
  - フロントエンド: frontend/develop と画面別設計を起点に、必要に応じて microservice/design の API 仕様を参照
  - バックエンド/アーキテクト: microservice/design・specification と security-architecture を横断
  - インフラ/SRE: infrastructure/design・develop、devops で CI/CD・運用前提を把握
  - QA: test、system-flows を起点に E2E 観点を整理
- 参照のコツ
  - サイドバーからカテゴリ → 個別ページの順で辿る
  - 仕様ページには可能な限り実装ソースや Swagger のリンクを併記（相互参照の手掛かりに）
  - サンプル（`sample-project/`）を併読すると設計意図が掴みやすい
- 貢献/更新の基本
  - 記述言語: 原則英語。ただしプロジェクト方針や明示的な依頼がある場合は日本語も可（本ページは日本語）
  - リンティング（検出のみ、オートフィックスなし）
    ```sh
    cd docusaurus && npx markdownlint "docs/**/*.{md,mdx}"
    ```
  - 新規ページは関連カテゴリ配下に作成し、必要に応じてサイドバーに追加
  - 仕様と実装が乖離しないよう、変更時は仕様/設計/テストのいずれかも併せて更新
