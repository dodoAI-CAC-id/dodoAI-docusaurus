---
id: infrastructure-layer-develop
title: Infrastructure Layer開発
---

# Infrastructure Layer開発

## 概要

リポジトリ実装、外部サービスアダプター、技術的関心事を含む、インフラストラクチャ層の実装ガイドライン。

## 開発ワークフロー

### リポジトリ実装
1. ドメインインターフェースを実装
2. データマッピングロジックを追加
3. データベース操作を処理
4. エラーハンドリングを実装
5. 統合テストを追加

### 実装例
```typescript
// リポジトリ実装
export class UserRepository implements IUserRepository {
  constructor(
    private database: IDatabase,
    private mapper: UserMapper
  ) {}

  async findById(id: UserId): Promise<User | null> {
    try {
      const userData = await this.database.query(
        'SELECT * FROM users WHERE id = ?',
        [id.value]
      );
      
      if (!userData) {
        return null;
      }
      
      return this.mapper.toDomain(userData);
    } catch (error) {
      throw new RepositoryError('Failed to find user', error);
    }
  }

  async save(user: User): Promise<void> {
    try {
      const userData = this.mapper.toPersistence(user);
      
      await this.database.transaction(async (tx) => {
        await tx.query(
          'INSERT INTO users (id, email, profile, created_at) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE email = ?, profile = ?',
          [userData.id, userData.email, userData.profile, userData.createdAt, userData.email, userData.profile]
        );
      });
    } catch (error) {
      throw new RepositoryError('Failed to save user', error);
    }
  }
}
```

### 外部サービスアダプター
```typescript
// 外部サービスアダプター
export class EmailService implements IEmailService {
  constructor(
    private httpClient: IHttpClient,
    private config: EmailConfig
  ) {}

  async sendWelcomeEmail(email: Email): Promise<void> {
    try {
      await this.httpClient.post('/send-email', {
        to: email.toString(),
        template: 'welcome',
        data: { email: email.toString() }
      });
    } catch (error) {
      throw new ExternalServiceError('Failed to send welcome email', error);
    }
  }
}
```

## ベストプラクティス

### データマッピング
- ドメインモデルと永続化モデルを分離
- 双方向マッピングを実装
- データ変換を処理
- データ整合性を検証

### エラーハンドリング
- 外部例外をラップ
- リトライメカニズムを実装
- サーキットブレーカーパターンを追加
- 詳細なエラー情報をログ

### パフォーマンス
- コネクションプーリングを実装
- クエリ最適化を使用
- キャッシング層を追加
- パフォーマンスメトリクスを監視

### テスト
- 統合テストを使用
- 外部依存関係をモック
- エラーシナリオをテスト
- データマッピングを検証
