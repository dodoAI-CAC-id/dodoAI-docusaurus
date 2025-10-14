---
id: system-requirement
title: System Requirement
---

# System Requirement

1. Cloud Environment / Hosting Region クラウド環境・ホスティング
- 要求概要：オンプレミスでの環境構成を選択（プライバシー配慮のため）
- 法的順守: 日本の個人情報保護法(医療情報)、及び厚労省ガイドライン（介護領域）

2. Software and Middleware ソフトウェア・ミドルウェア
- Python, ONNX, Golang, gRPC-Gateway, Google Flutter Dart, SQLite, Docker
- OS（推定）：Ubuntu LTSもしくはCentOSなど、安定稼働重視。
- その他: Nginx/Apache（推定, API Gateway用途）
- バージョンやサポート期間は、LTS(長期サポート)版を選定（推定）
- （推定）現場運用PC・モバイルではWindows10/11、AndroidOS

3. Programming Languages and Frameworks 言語・フレームワーク
- Python, Golang, Dart（Flutter）、ONNX
- AI推論部はPython+ONNXランタイム
- アプリ・UIはFlutter（クロスプラットフォーム）
- バージョンはLTSまたは最新安定版（具体的バージョンは決定次第記載）

4. Infrastructure Architecture インフラ構成
- オンプレミスサーバーで画像AI推論/データ管理（専用ラック・ラックマウントサーバー等）、ユーザー端末（PC、タブレット、スマホ）
- ネットワーク：施設内LAN（VLANでセグメント化、外部接続最小化）
- セキュリティ：FW/IDS（推定）、端末認証（MACアドレス制限等）
- Dockerによるアプリコンテナ化（AI系サーバー）

5. API & Interface Design Principles
- gRPC+RESTゲートウェイ。OpenAPI（Swagger）ドキュメント整備。
- エラーは統一JSON(推測)
- バージョニング: URIにv1など付与
- Idempotency保証（リトライ時の重複防止）

6. Batch Processing & Scheduling
- （推定）夜間にログ・バックアップ処理、定期的に古い履歴動画の自動削除ジョブ（要保持期間設定）。
- 失敗時アラート&リトライ処理追加。

7. Testing & QA Environments
- パフォーマンステスト(複数カメラ同時データ時)

8. Security, Authentication, and Authorization
- API認証：JWTまたはOAuth2（推定；BtoB内部利用ならAPIキーでも可）
- 暗号化保存（履歴データ）、モザイク処理（プライバシー保持）、通信経路のTLS化
- 監査ログ記録（誰がどのデータを閲覧/操作したか）

9. Monitoring, Logging and Alerting
- インフラ監視はZabbix/Nagios/Prometheus（推定）

10. Localization & Internationalization
- 日本語（初期）、将来英語/インドネシア語等対応（推定）
- UIはUTF-8、日付/時刻JST+ローカルタイム
- フィールド名の多言語管理、
- 履歴動画やアラートメッセージの多言語化（段階追加）

11. Reporting & Export Features
- 異常履歴検索・CSV/PDFエクスポート、履歴レポート閲覧、権限による出力制御

12. Email & Notification Delivery
- 異常通知、対応者情報通知を施設スタッフ端末にPUSH（専用アプリ）、及びメールも選択可能（推測）、多言語テンプレート

13. Processing Control (Transactions, Concurrency, Idempotency)
- 通知/履歴登録はトランザクション管理
- 冪等性保証（複数通知防止）

14. Manual Operations & Maintenance
- 障害時の現場メンテナンスは運用プロシージャ（runbook）で規定
- 月次リブート・ソフトアップデート手順（手動/自動）

15. Error Handling, Timeout, Notification Policies
- 例外はビジネス/システムエラー区別、APIはHTTP&gRPCで統一
- タイムアウト設定（画像AI処理: 数秒=超過時リトライ指示）
- エラーメッセージはユーザー向けに簡易+技術者向け詳細分割

16. Character Encoding
- システム全体でUTF-8を標準とする

17. Database and Data Retention
- SQLite（初期想定: スケール時はRDBMS移行を視野）
- 動画データは最大5分/件→ストレージ増大に注意
- GDPRは該当しないが、日本法対応/削除権利考慮

18. Security & Compliance
- 個人情報保護法(日本)

