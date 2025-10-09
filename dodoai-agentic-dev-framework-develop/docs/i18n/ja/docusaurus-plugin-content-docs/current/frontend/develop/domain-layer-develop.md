---
id: domain-layer-develop
title: Domain Layer開発
---

# Domain Layer開発

## 概要

エンティティ、値オブジェクト、ドメインサービス、ビジネスロジックを含む、ドメイン層の実装ガイドライン。

## 開発ワークフロー

### エンティティ開発
1. エンティティのアイデンティティを定義
2. ビジネスメソッドを実装
3. バリデーションルールを追加
4. ドメインイベントを処理
5. ユニットテストを作成

### 実装例
```typescript
// エンティティ例
export class User {
  private constructor(
    private readonly _id: UserId,
    private _email: Email,
    private _profile: UserProfile,
    private _createdAt: Date
  ) {}

  static create(email: string, profileData: UserProfileData): User {
    const userId = UserId.generate();
    const userEmail = Email.create(email);
    const profile = UserProfile.create(profileData);
    
    const user = new User(userId, userEmail, profile, new Date());
    
    // ドメインイベントを発生
    DomainEvents.raise(new UserCreatedEvent(user.id, user.email));
    
    return user;
  }

  updateEmail(newEmail: string): void {
    const email = Email.create(newEmail);
    
    if (this._email.equals(email)) {
      return; // 変更不要
    }
    
    this._email = email;
    DomainEvents.raise(new UserEmailUpdatedEvent(this.id, email));
  }

  get id(): UserId { return this._id; }
  get email(): Email { return this._email; }
  get profile(): UserProfile { return this._profile; }
}
```

### 値オブジェクト開発
```typescript
// 値オブジェクト例
export class Email {
  private constructor(private readonly value: string) {}

  static create(email: string): Email {
    if (!this.isValid(email)) {
      throw new InvalidEmailError(email);
    }
    return new Email(email.toLowerCase());
  }

  private static isValid(email: string): boolean {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  equals(other: Email): boolean {
    return this.value === other.value;
  }

  toString(): string {
    return this.value;
  }
}
```

## ベストプラクティス

### ビジネスロジック
- ビジネスルールをドメインに保持
- 明示的なバリデーションを使用
- ドメインイベントを実装
- エンティティの不変条件を維持

### テスト
- すべてのビジネスロジックをユニットテスト
- ドメインイベントをテスト
- ビジネスルールを検証
- エッジケースをテスト

### 設計パターン
- 集約パターンを使用
- リポジトリインターフェースを実装
- 仕様パターンを適用
- 複雑なロジックにはドメインサービスを使用
