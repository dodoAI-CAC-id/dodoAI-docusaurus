import 'package:equatable/equatable.dart';

/// 失敗の抽象クラス
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// サーバーエラー
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// ネットワークエラー
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// キャッシュエラー
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// バリデーションエラー
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// 認証エラー
class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message);
}

/// 認可エラー
class AuthorizationFailure extends Failure {
  const AuthorizationFailure(super.message);
}

/// 未知のエラー
class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
