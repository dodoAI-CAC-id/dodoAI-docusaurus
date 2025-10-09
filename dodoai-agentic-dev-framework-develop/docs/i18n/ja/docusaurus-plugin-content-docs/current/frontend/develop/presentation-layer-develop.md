---
id: presentation-layer-develop
title: Presentation Layer開発
---

# Presentation Layer開発

## 概要

コンポーネント、ビューモデル、ユーザーインターフェースロジックを含む、プレゼンテーション層の実装ガイドライン。

## 開発ワークフロー

### コンポーネント開発
1. コンポーネントインターフェースを定義
2. レンダリングロジックを実装
3. イベントハンドリングを追加
4. 状態管理を実装
5. コンポーネントテストを作成

### 実装例
```typescript
// Reactコンポーネント例
interface UserProfileProps {
  userId: string;
  onUserUpdate: (user: User) => void;
}

export const UserProfile: React.FC<UserProfileProps> = ({ userId, onUserUpdate }) => {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const userService = useService<IUserService>('IUserService');

  useEffect(() => {
    loadUser();
  }, [userId]);

  const loadUser = async () => {
    try {
      setLoading(true);
      setError(null);
      const userData = await userService.getUserById(userId);
      setUser(userData);
    } catch (err) {
      setError('Failed to load user');
    } finally {
      setLoading(false);
    }
  };

  const handleEmailUpdate = async (newEmail: string) => {
    try {
      const updatedUser = await userService.updateUserEmail(userId, newEmail);
      setUser(updatedUser);
      onUserUpdate(updatedUser);
    } catch (err) {
      setError('Failed to update email');
    }
  };

  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorMessage message={error} />;
  if (!user) return <NotFound />;

  return (
    <div className="user-profile">
      <UserAvatar user={user} />
      <UserDetails user={user} onEmailUpdate={handleEmailUpdate} />
    </div>
  );
};
```

### ビューモデルパターン
```typescript
// 複雑な状態管理のためのビューモデル
export class UserProfileViewModel {
  private _user = signal<User | null>(null);
  private _loading = signal(false);
  private _error = signal<string | null>(null);

  constructor(private userService: IUserService) {}

  get user() { return this._user.asReadonly(); }
  get loading() { return this._loading.asReadonly(); }
  get error() { return this._error.asReadonly(); }

  async loadUser(userId: string): Promise<void> {
    this._loading.set(true);
    this._error.set(null);

    try {
      const user = await this.userService.getUserById(userId);
      this._user.set(user);
    } catch (error) {
      this._error.set('Failed to load user');
    } finally {
      this._loading.set(false);
    }
  }

  async updateEmail(newEmail: string): Promise<void> {
    const currentUser = this._user();
    if (!currentUser) return;

    try {
      const updatedUser = await this.userService.updateUserEmail(currentUser.id, newEmail);
      this._user.set(updatedUser);
    } catch (error) {
      this._error.set('Failed to update email');
    }
  }
}
```

## ベストプラクティス

### コンポーネント設計
- コンポーネントを集中的で小さく保つ
- 継承よりもコンポジションを使用
- 適切なプロパティ検証を実装
- ローディングとエラー状態を処理

### 状態管理
- コンポーネント固有のデータにはローカル状態を使用
- 共有データにはグローバル状態を実装
- 不変の状態更新を使用
- 再レンダリングを最適化

### イベントハンドリング
- 適切なイベント委譲を使用
- ユーザー入力にデバウンスを実装
- 非同期操作を適切に処理
- ユーザーフィードバックを提供

### テスト
- コンポーネントのユニットテストを作成
- ユーザーインタラクションをテスト
- 外部依存関係をモック
- ビジュアルリグレッションテストを使用
