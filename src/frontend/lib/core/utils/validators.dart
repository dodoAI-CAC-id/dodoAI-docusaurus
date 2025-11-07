/// Input validation utilities
class Validators {
  /// Validate if string is not empty
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'この項目'}は必須です';
    }
    return null;
  }

  /// Validate email format
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Use required validator for non-empty check
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return '有効なメールアドレスを入力してください';
    }
    return null;
  }

  /// Validate minimum length
  static String? minLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null; // Use required validator for non-empty check
    }
    if (value.length < minLength) {
      return '${fieldName ?? 'この項目'}は${minLength}文字以上で入力してください';
    }
    return null;
  }

  /// Validate maximum length
  static String? maxLength(String? value, int maxLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length > maxLength) {
      return '${fieldName ?? 'この項目'}は${maxLength}文字以下で入力してください';
    }
    return null;
  }

  /// Validate numeric value
  static String? numeric(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null; // Use required validator for non-empty check
    }
    if (int.tryParse(value) == null && double.tryParse(value) == null) {
      return '${fieldName ?? 'この項目'}は数値で入力してください';
    }
    return null;
  }

  /// Validate integer value
  static String? integer(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null; // Use required validator for non-empty check
    }
    if (int.tryParse(value) == null) {
      return '${fieldName ?? 'この項目'}は整数で入力してください';
    }
    return null;
  }

  /// Validate minimum value
  static String? minValue(String? value, num minValue, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final numValue = num.tryParse(value);
    if (numValue == null) {
      return '${fieldName ?? 'この項目'}は数値で入力してください';
    }
    if (numValue < minValue) {
      return '${fieldName ?? 'この項目'}は$minValue以上の値を入力してください';
    }
    return null;
  }

  /// Validate maximum value
  static String? maxValue(String? value, num maxValue, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final numValue = num.tryParse(value);
    if (numValue == null) {
      return '${fieldName ?? 'この項目'}は数値で入力してください';
    }
    if (numValue > maxValue) {
      return '${fieldName ?? 'この項目'}は$maxValue以下の値を入力してください';
    }
    return null;
  }

  /// Validate date format (yyyy/MM/dd)
  static String? dateFormat(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Use required validator for non-empty check
    }
    final dateRegex = RegExp(r'^\d{4}/\d{2}/\d{2}$');
    if (!dateRegex.hasMatch(value)) {
      return '日付はyyyy/MM/dd形式で入力してください';
    }
    return null;
  }

  /// Validate phone number (Japanese format)
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Use required validator for non-empty check
    }
    final phoneRegex = RegExp(r'^0\d{9,10}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[-\s]'), ''))) {
      return '有効な電話番号を入力してください';
    }
    return null;
  }

  /// Combine multiple validators
  static String? combine(
    String? value,
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) {
        return error;
      }
    }
    return null;
  }
}
