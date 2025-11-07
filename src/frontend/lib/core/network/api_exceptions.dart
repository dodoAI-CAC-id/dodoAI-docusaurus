/// カスタムAPI例外クラス
/// 
/// APIからのエラーレスポンスを表現する例外クラスの階層を定義します。
/// すべての例外は基底クラス [ApiException] を継承します。

/// API例外の基底クラス
abstract class ApiException implements Exception {
  /// エラーメッセージ
  final String message;
  
  /// HTTPステータスコード（オプション）
  final int? statusCode;
  
  /// 元の例外（オプション）
  final dynamic originalException;
  
  /// スタックトレース（オプション）
  final StackTrace? stackTrace;

  const ApiException({
    required this.message,
    this.statusCode,
    this.originalException,
    this.stackTrace,
  });

  @override
  String toString() {
    final buffer = StringBuffer('$runtimeType: $message');
    if (statusCode != null) {
      buffer.write(' (Status Code: $statusCode)');
    }
    if (originalException != null) {
      buffer.write('\nOriginal Exception: $originalException');
    }
    return buffer.toString();
  }
}

/// ネットワーク接続エラー
/// 
/// インターネット接続がない、タイムアウトなどのネットワークレベルのエラーを表します。
class NetworkException extends ApiException {
  const NetworkException({
    required super.message,
    super.originalException,
    super.stackTrace,
  });
}

/// サーバーエラー (5xx)
/// 
/// サーバー側で発生したエラーを表します。
class ServerException extends ApiException {
  const ServerException({
    required super.message,
    super.statusCode,
    super.originalException,
    super.stackTrace,
  });
}

/// 認証エラー (401)
/// 
/// 認証が必要または認証情報が無効な場合のエラーを表します。
class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    required super.message,
    super.originalException,
    super.stackTrace,
  }) : super(statusCode: 401);
}

/// 権限エラー (403)
/// 
/// 認証済みだが、リソースへのアクセス権限がない場合のエラーを表します。
class ForbiddenException extends ApiException {
  const ForbiddenException({
    required super.message,
    super.originalException,
    super.stackTrace,
  }) : super(statusCode: 403);
}

/// リソース未検出エラー (404)
/// 
/// 要求されたリソースが見つからない場合のエラーを表します。
class NotFoundException extends ApiException {
  const NotFoundException({
    required super.message,
    super.originalException,
    super.stackTrace,
  }) : super(statusCode: 404);
}

/// バリデーションエラー (400)
/// 
/// リクエストのバリデーションが失敗した場合のエラーを表します。
class ValidationException extends ApiException {
  /// バリデーションエラーの詳細（フィールド名とエラーメッセージのマップ）
  final Map<String, String>? errors;

  const ValidationException({
    required super.message,
    this.errors,
    super.originalException,
    super.stackTrace,
  }) : super(statusCode: 400);

  @override
  String toString() {
    final buffer = StringBuffer(super.toString());
    if (errors != null && errors!.isNotEmpty) {
      buffer.write('\nValidation Errors:');
      errors!.forEach((field, error) {
        buffer.write('\n  $field: $error');
      });
    }
    return buffer.toString();
  }
}

/// タイムアウトエラー
/// 
/// APIリクエストがタイムアウトした場合のエラーを表します。
class TimeoutException extends ApiException {
  const TimeoutException({
    required super.message,
    super.originalException,
    super.stackTrace,
  });
}

/// 不正なレスポンスエラー
/// 
/// APIのレスポンスが期待した形式でない場合のエラーを表します。
class InvalidResponseException extends ApiException {
  const InvalidResponseException({
    required super.message,
    super.statusCode,
    super.originalException,
    super.stackTrace,
  });
}
